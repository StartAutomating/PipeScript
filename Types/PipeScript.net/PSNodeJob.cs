namespace PipeScript.Net
{
    using System;
    using System.ComponentModel;
    using System.Collections;
    using System.Collections.Generic;
    using System.Collections.ObjectModel;
    using System.IO;
    using System.Text;
    using System.Text.RegularExpressions;    
    using System.Timers;   
    using System.Threading;
    using System.Management.Automation;
    using System.Management.Automation.Runspaces;
    using System.Net;
    #if Windows
    using Microsoft.Win32;
    using System.Security.Principal;
    #endif
    using System.Web;
    
    
    public class PSNodeJob : Job
    {
        static RunspacePool runspacePool;
        PowerShell powerShellCommand;
        int bufferSize = 262144;
        uint poolSize = 3;
        TimeSpan sessionTimeout = TimeSpan.FromMinutes(15);
        Dictionary<string, string> MimeTypes = new Dictionary<string, string>();        
        RunspacePool _PSNodePool;        
        ScriptBlock _PSNodeAction;
        ScriptBlock _FullPSNodeAction;        
        PSNodeJob parentJob = null;        
        AuthenticationSchemes authenticationType = AuthenticationSchemes.Anonymous;
        private string PSNodeScriptPreface = @"
<#ScriptPreface#>
";
                       
        static PSNodeJob() 
        {
            InitialSessionState iss = InitialSessionState.CreateDefault();
            //#StartWindowsOnly
            iss.ThreadOptions = PSThreadOptions.UseNewThread;
            iss.ApartmentState = ApartmentState.STA;                        
            //#EndWindowsOnly
            runspacePool =  RunspaceFactory.CreateRunspacePool(iss);        
            runspacePool.Open();
            AppDomain.CurrentDomain.ProcessExit += PooledJob_Exiting;
        }

        RunspacePool PSNodePool
        {
            get
            {
                if (_PSNodePool == null || _PSNodePool.RunspacePoolStateInfo.State != RunspacePoolState.Opened)
                {
                    InitialSessionState iss = InitialSessionState.CreateDefault();
                    if (this.ImportModule != null) {
                        iss.ImportPSModule(this.ImportModule);
                    }
                    if (this.DeclareFunction != null) {
                        foreach (FunctionInfo df in this.DeclareFunction) {
                            iss.Commands.Add(new SessionStateFunctionEntry(df.Name, df.Definition));
                        }                        
                    }
                    if (this.DeclareAlias != null) {
                        foreach (AliasInfo af in this.DeclareAlias) {
                            iss.Commands.Add(new SessionStateAliasEntry(af.Name, af.Definition));
                        }
                    }

                    if (this.ImportTypeFile != null) {
                        foreach (string typeFile in this.ImportTypeFile) {
                            iss.Types.Add(new SessionStateTypeEntry(typeFile));
                        }
                    }

                    if (this.ImportFormatFile != null) {
                        foreach (string formatFile in this.ImportFormatFile) {
                            iss.Formats.Add(new SessionStateFormatEntry(formatFile));
                        }
                    }

                    _PSNodePool = RunspaceFactory.CreateRunspacePool(iss);
                    //#StartWindowsOnly
                    _PSNodePool.ThreadOptions = PSThreadOptions.UseNewThread;
                    _PSNodePool.ApartmentState = System.Threading.ApartmentState.STA;
                    //#EndWindowsOnly
		            _PSNodePool.SetMaxRunspaces((int)PoolSize);                
                    _PSNodePool.Open();
                }
                return _PSNodePool;
            }
        }

        public HttpListener Listener { get; set; }
        public bool AllowBrowseDirectory { get; set; } 
        public bool AllowScriptExecution { get; set; }
        public string CORS { get; set;}
        public AuthenticationSchemes AuthenticationType {
            get {
                return authenticationType;
            }
            
            set {
                authenticationType = value;
            }
        }
        public FunctionInfo[] DeclareFunction { get; set; }
        public AliasInfo[] DeclareAlias { get; set; } 
        public string[] ImportTypeFile { get; set; }
        public string[] ImportFormatFile { get; set; }
        public string[] FileBlacklist { get; set; }
        public int BufferSize {  
            get { return bufferSize; }         
            set { bufferSize = value; } 
        }
        public string[] ImportModule { get; set; }        
        public string[] ListenerLocation { get; set; }
        public uint PoolSize { 
            get {
                return poolSize;
            } set {
                poolSize = value;
            }
        }
        public string RootPath { get; set; }
        public TimeSpan SessionTimeout { get { return sessionTimeout; }  set { sessionTimeout = value; }   }
        public ScriptBlock PSNodeAction {
            get {
                return _PSNodeAction;
            }
            
            set {
                _PSNodeAction = value;
                _FullPSNodeAction = ScriptBlock.Create(this.PSNodeScriptPreface + _PSNodeAction.ToString());
            } 
        }

        public AsyncCallback Callback {
            get {
                return new AsyncCallback(this.ListenerCallback);
            }
        }

        

        static void PooledJob_Exiting(object sender, EventArgs e) {
            runspacePool.Close();
            runspacePool.Dispose();
            runspacePool = null;
        }

        public PSNodeJob(string name, string command, ScriptBlock scriptBlock)
            : base(command, name)
        {}

        private PSNodeJob(ScriptBlock scriptBlock)
        {}
        
        
        public PSNodeJob(string name, string command, ScriptBlock scriptBlock, Hashtable parameters)
            : base(command, name)
        {}

        public PSNodeJob(string name, string command, ScriptBlock scriptBlock, Hashtable parameters, PSObject[] argumentList)
            : base(command, name)
        {}

        private PSNodeJob(string name, string command, ScriptBlock scriptBlock, Hashtable parameters, PSObject[] argumentList, bool isChildJob)
            : base(command, name)
        {            
            if (! isChildJob) {
                PSNodeJob childJob = new PSNodeJob(name, command, scriptBlock, parameters, argumentList, true);
                childJob.StateChanged += new EventHandler<JobStateEventArgs>(childJob_StateChanged);
                this.ChildJobs.Add(childJob);
            }
        }


        void childJob_StateChanged(object sender, JobStateEventArgs e)
        {
            this.SetJobState(e.JobStateInfo.State);            
        }

        /// <summary>
        /// Synchronizes Job State with Background Runspace
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        void powerShellCommand_InvocationStateChanged(object sender, PSInvocationStateChangedEventArgs e)
        {
            try
            {                
                if (e.InvocationStateInfo.State == PSInvocationState.Failed)
                {
                    ErrorRecord err = new ErrorRecord(e.InvocationStateInfo.Reason, "JobFailed", ErrorCategory.OperationStopped, this);
                    Error.Add(err);                    
                }
                JobState js = (JobState)Enum.Parse(typeof(JobState), e.InvocationStateInfo.State.ToString(), true);
                this.SetJobState(js);
            }
            catch (Exception ex) {
                this.Error.Add(new ErrorRecord(ex, "PSNode.Unknown.Error", ErrorCategory.NotSpecified, this));
            }
        }

        public void ServeFile(string fullPath, HttpListenerRequest request, HttpListenerResponse response) {
            if (File.Exists(fullPath)) {
                FileInfo fileInfo = new FileInfo(fullPath);
                if (FileBlacklist != null ){
                    foreach (string f in FileBlacklist) {
                        WildcardPattern wp = new WildcardPattern(f, WildcardOptions.IgnoreCase);
                        if (wp.IsMatch(fileInfo.FullName)) {
                            return;
                        }
                    }
                }
                if (MimeTypes.ContainsKey(fileInfo.Extension.ToLower())) {
                    response.ContentType = MimeTypes[fileInfo.Extension.ToLower()];
                }
                int read = 0;
                if (request.HttpMethod.ToUpper() == "HEAD") {
                    response.ContentLength64 = fileInfo.Length;
                    response.OutputStream.Close();
                    return;
                }
                response.Headers["Accept-Ranges"] = "bytes";
                long start = 0;
                long end = fileInfo.Length;
                if (!String.IsNullOrEmpty(request.Headers["Range"])) {
                    
                    var RangeMatch = Regex.Match(request.Headers["Range"], "bytes=(?<Start>\\d{1,})(-(?<End>\\d{1,})){0,1}");
                    if (RangeMatch != null && 
                        RangeMatch.Groups["Start"].Success &&
                        RangeMatch.Groups["End"].Success) {
                        start  = long.Parse(RangeMatch.Groups["Start"].ToString());
                        end = long.Parse(RangeMatch.Groups["End"].ToString());
                    }
                }

                
                using ( var fs = File.OpenRead(fullPath)) {
                    if (start > 0 && end > 0) {
                        byte[] buffer = new byte[this.BufferSize];
                        fs.Seek(start, SeekOrigin.Begin);
                        read = fs.Read(buffer, 0, this.BufferSize);
                        string contentRange = start.ToString() + "-" + (start + read - 1).ToString() + 
                            "/" + fs.Length.ToString();
                        response.StatusCode = 206;
                        response.ContentLength64 = read;
                        response.Headers.Add("Content-Range", contentRange);
                        response.OutputStream.Write(buffer, 0, read);
                        response.OutputStream.Close();
                    } else {
                        response.ContentLength64 = fs.Length;
                        fs.CopyTo(response.OutputStream);
                        response.OutputStream.Close();
                    }
                    
                }                                 

                response.Close();                 
                return;
            }
        }

        Dictionary<string, PSObject> UserSessions = new Dictionary<string, PSObject>();

        Dictionary<string, string> ContentTypeCommands = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);        
        
        System.Timers.Timer SessionTimer = null;        
        Dictionary<string, Object> Application = new Dictionary<string, Object>();

        public Cookie NewSessionCookie() {
            string sessionGuid = Guid.NewGuid().ToString();
            Cookie sessionKey = new Cookie("SessionKey", sessionGuid);
            sessionKey.Expires = DateTime.UtcNow.AddMinutes(15);                
            UserSessions[sessionGuid] = new PSObject();
            UserSessions[sessionGuid].Properties.Add(new PSNoteProperty("Expires", sessionKey.Expires), true);
            UserSessions[sessionGuid].Properties.Add(new PSNoteProperty("SessionKey", sessionKey.Value), true);            
            return sessionKey;
        }

        public void ServeScript(string powerShellScript,  HttpListenerContext context) {
            HttpListenerRequest request = context.Request;                
            HttpListenerResponse response = context.Response;

            PSObject session = null;
            
            // If we're serving a script, we'll want a SessionKey, so we can have _some_ sense of Web Session State.
            if (request.Cookies["SessionKey"] == null) {
                Cookie sessionCookie = NewSessionCookie();
                response.AppendCookie(sessionCookie);
                session = UserSessions[sessionCookie.Value];
            } else {
                string sessionKey = request.Cookies["SessionKey"].Value.ToString();
                if (UserSessions.ContainsKey(sessionKey)) {
                    session = UserSessions[sessionKey];
                    ((PSNoteProperty)UserSessions[sessionKey].Properties["Expires"]).Value = DateTime.UtcNow;
                } else {
                    Cookie sessionCookie = NewSessionCookie();
                    response.AppendCookie(sessionCookie);
                    session = UserSessions[sessionCookie.Value];
                }
            }
            
            string contentType = request.ContentType;
            if (contentType != null) {
                contentType = contentType.ToLower();
            }            
           
            using (
                PowerShell command = PowerShell.Create()
                    .AddScript(powerShellScript, false)
                    .AddArgument(request)
                    .AddArgument(response)
                    .AddArgument(context)
                    //#StartWindowsOnly
                    .AddArgument(context.User)
                    //#EndWindowsOnly
                    .AddArgument(session)
                    .AddArgument(this.Application)
                    .AddArgument(this))
            {
                if (String.IsNullOrEmpty(contentType) || contentType.ToLower() == "text/html") {
                    command.AddCommand("Out-Html");
                } else if (request.ContentType != null && (contentType == "application/json" || contentType == "text/json")) {
                    command.AddCommand("ConvertTo-Json").AddParameter("Compress", true);                    
                } else if (request.ContentType != null && contentType == "text/plain") {
                    command.AddCommand("Out-String");
                } else if (request.ContentType != null && contentType == "application/clixml") {
                    command.AddScript("process { [Management.Automation.PSSerializer]::Serialize($_) }");
                }
                
                command.RunspacePool = PSNodePool;
                if (! string.IsNullOrEmpty(this.CORS)) {
                    response.Headers["Access-Control-Allow-Origin"] = this.CORS;
                }
                
                int offset = 0;

                try
                {
                    foreach (PSObject psObject in command.Invoke<PSObject>())
                    {
                        if (psObject.BaseObject == null) { continue; }                        
                        byte[] buffer = null;
                        string stringified = psObject.ToString();                                            
                        buffer = System.Text.Encoding.UTF8.GetBytes(stringified);
                        if (response.OutputStream.CanWrite) {
                            response.OutputStream.Write(buffer, 0, buffer.Length);
                        }                        
                        offset += buffer.Length;
                        buffer = null;
                    }
                    
                    foreach (ErrorRecord err in command.Streams.Error) {
                        string errorString = err.Exception.ToString() + ' ' + err.InvocationInfo.PositionMessage;
                        byte[] buffer = System.Text.Encoding.UTF8.GetBytes(errorString);
                        if (response.OutputStream.CanWrite) {
                            response.OutputStream.Write(buffer, 0, buffer.Length);
                        }
                        offset += buffer.Length;
                        buffer = null;
                    }                    
                }
                catch (Exception ex)
                {
                    byte[] buffer = System.Text.Encoding.UTF8.GetBytes(ex.Message);
                    response.StatusCode = 500;
                    if (response.OutputStream.CanWrite) {
                        response.OutputStream.Write(buffer, 0, buffer.Length);
                    }
                    offset += buffer.Length;
                    buffer = null;
                }
                finally
                {
                    try {                    
                        response.Close();
                    } catch (Exception ex) {
                        this.Error.Add(new ErrorRecord(ex, "PSNode.Unknown.Error", ErrorCategory.NotSpecified, this));
                    }
                }
            }
        }

        public void ListenerCallback(IAsyncResult result)
        {
            try
            {
                HttpListener listener = (HttpListener)result.AsyncState;

                // Call EndGetContext to complete the asynchronous operation.        
                HttpListenerContext context = listener.EndGetContext(result);
                HttpListenerRequest request = context.Request;
                // Obtain a response object.
                HttpListenerResponse response = context.Response;
                
                if (request.Url.Segments.Length > 2 && request.Url.Segments[1].ToLower() == "favicon.ico") {
                    response.StatusCode = 200;
                    response.Close();
                    return;
                }

                if (! String.IsNullOrEmpty(this.RootPath)) {
                    string url = request.RawUrl.ToString();
                    url = url.Replace('/', System.IO.Path.DirectorySeparatorChar); 
                    url = HttpUtility.UrlDecode(url, Encoding.UTF8); 
                    url = url.Substring(1);
                    string fullPath = string.IsNullOrEmpty(url) ? this.RootPath : Path.Combine(this.RootPath, url);
                    
                    if (Directory.Exists(fullPath) && AllowBrowseDirectory && fullPath != this.RootPath) {
                        context.Response.ContentType = "text/html"; 
                        context.Response.ContentEncoding = Encoding.UTF8; 
                        using (var sw = new StreamWriter(context.Response.OutputStream)) { 
                            sw.WriteLine("<html>"); 
                            sw.WriteLine("<head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"></head>"); 
                            sw.WriteLine("<body><ul>");                                 
                            foreach (string d in Directory.GetDirectories(fullPath)) { 
                                string link = d.Replace(this.RootPath, "").Replace(System.IO.Path.DirectorySeparatorChar, '/'); 
                                sw.WriteLine("<li>&lt;DIR&gt; <a href=\"" + link + "\">" + Path.GetFileName(d) + "</a></li>"); 
                            }                                  
                            foreach (string f in Directory.GetFiles(fullPath)) { 
                                string link = f.Replace(this.RootPath, "").Replace(System.IO.Path.DirectorySeparatorChar, '/'); 
                                sw.WriteLine("<li><a href=\"" + link + "\">" + Path.GetFileName(f) + "</a></li>"); 
                            }  
                            sw.WriteLine("</ul></body></html>"); 
                        } 
                        context.Response.OutputStream.Close(); 
                        return;
                    }
    
                    if (request.Url.Segments[request.Url.Segments.Length - 1].Contains(".")) {                        
                        if (File.Exists(fullPath)) {
                            FileInfo fileInfo = new FileInfo(fullPath);    
                            if (this.AllowScriptExecution && fileInfo.Extension.ToLower() == ".ps1") {
                                this.ServeScript(File.ReadAllText(fullPath), context);                                                                
                            } else {
                                this.ServeFile(fullPath, request, response);
                            }
                            
                            return;
                        }                        
                    }
                                        
                }

                this.ServeScript(_FullPSNodeAction.ToString(), context);                                                
            }
            catch (Exception e)
            {   
                this.Error.Add(new ErrorRecord(e, e.Message, ErrorCategory.NotSpecified, e));
            }
        }
        
        public void WriteOutput(PSObject item) {
            this.Output.Add(item);
        }

        private ElapsedEventHandler elapsedEventHandler = null;
        
        public void Start()
        {
            #if Windows
            WindowsIdentity current = System.Security.Principal.WindowsIdentity.GetCurrent();
            WindowsPrincipal principal = new WindowsPrincipal(current);
            if (!principal.IsInRole(WindowsBuiltInRole.Administrator))
            {
                throw new UnauthorizedAccessException();
            }
            #endif
            if (SessionTimer != null) {
                SessionTimer.Stop();
                SessionTimer.Elapsed -= elapsedEventHandler;
            }
            SessionTimer = new System.Timers.Timer();
            SessionTimer.Interval = 5119;
            elapsedEventHandler = new ElapsedEventHandler(SessionTimerElapsed);
            SessionTimer.Elapsed += elapsedEventHandler;
            SessionTimer.Start();
            
            if (! String.IsNullOrEmpty(this.RootPath)) {
                #if Windows
                RegistryKey hkcr = Microsoft.Win32.Registry.ClassesRoot;
                RegistryKey ctKey = hkcr.OpenSubKey("MIME\\Database\\Content Type");
                foreach (string ctName in ctKey.GetSubKeyNames()) {
                    object extension = ctKey.OpenSubKey(ctName).GetValue("Extension");
                    if (extension != null) {
                        MimeTypes[extension.ToString().ToLower()]= ctName;
                    }
                }
                #endif
                // Defaulting several MIME types:
                // See https://developer.mozilla.org/en-US/docs/Learn/Server-side/Configuring_server_MIME_types
                if (! MimeTypes.ContainsKey(".md")) {
                    MimeTypes[".md"] = "text/markdown";
                }
                if (! MimeTypes.ContainsKey(".html")) {
                    MimeTypes[".html"] = "text/html";
                }
                if (! MimeTypes.ContainsKey(".htm")) {
                    MimeTypes[".htm"] = "text/html";
                }
                if (! MimeTypes.ContainsKey(".js")) {
                    MimeTypes[".js"] = "text/javascript";
                }
                if (! MimeTypes.ContainsKey(".css")) {
                    MimeTypes[".css"] = "text/css";
                }
            }

            Listener = new HttpListener();

            //this.ListenerLocation = listenerLocation;
            //this.PSNodeAction = scriptblock;
            //this.AuthenticationType = authenticationType;
                

            int max = runspacePool.GetMaxRunspaces();
            runspacePool.SetMaxRunspaces(max + 1);
            powerShellCommand = PowerShell.Create();
            powerShellCommand.RunspacePool = runspacePool;

            powerShellCommand.Streams.Error = this.Error;
            powerShellCommand.Streams.Warning = this.Warning;
            powerShellCommand.Streams.Verbose = this.Verbose;
            powerShellCommand.Streams.Debug = this.Debug;
            //powerShellCommand.Streams.Progress = this.Progress;
            //this.Progress.DataAdded += new EventHandler<DataAddedEventArgs>(Progress_DataAdded);
            PSNodeJob nodeJob = this;
            if (this.parentJob != null) {
                nodeJob = this.parentJob;
            }
            powerShellCommand.AddScript(@"
param($PSNodeJob, $listener)
:ResetPSNode while (1) {        
    $AuthenticationType = $PSNodeJob.AuthenticationType
    $ListenerLocation = $PSNodeJob.ListenerLocation    
    if ($AuthenticationType) {
        $listener.AuthenticationSchemes =$AuthenticationType
    }
    foreach ($ll in $ListenerLocation) {
        $listener.Prefixes.Add($ListenerLocation);
    }

    # Start the listener to begin listening for requests.    
    $listener.IgnoreWriteExceptions = $true;

    try {
        $listener.Start();
    } catch {
        Write-Error -ErrorRecord $_
        return
    }    
    
    :NodeIsRunning while (1) {          
        $result = $listener.BeginGetContext($PSNodeJob.Callback, $listener);
        if (-not $result) { return } 
        $null = $result.AsyncWaitHandle.WaitOne(1kb);       
        if (""$($PSNodeJob.ListenerLocation)"" -ne ""$ListenerLocation"" -or 
            $PSNodeJob.AuthenticationType -ne $AuthenticationType) {

            if ($listener) {
                $listener.Stop()
                $listener.Close();                
                $listener.Prefixes.Clear();
                [GC]::Collect()
            }
            continue ResetPSNode
        }             
    }

    $listener.Stop()
    $listener.Close()
    [GC]::Collect()    
}", false).AddArgument(nodeJob).AddArgument(this.Listener);
                        
            powerShellCommand.InvocationStateChanged += new EventHandler<PSInvocationStateChangedEventArgs>(powerShellCommand_InvocationStateChanged);
            powerShellCommand.BeginInvoke<Object, PSObject>(null, this.Output);
        }        

        
        void SessionTimerElapsed(object sender, ElapsedEventArgs e) {
            try {
                List<string> toRemove = new List<string>();
                foreach (PSObject sessionObject in UserSessions.Values) {
                    try {
                        DateTime sessionExpiresAt = (DateTime)sessionObject.Properties["Expires"].Value;
                        if (sessionExpiresAt != null && sessionExpiresAt >= DateTime.UtcNow ) {
                            string sessionKey = sessionObject.Properties["SessionKey"].Value as string;
                            toRemove.Add(sessionKey);
                        }
                    }
                    catch (Exception ex) {
                        this.Error.Add(new ErrorRecord(ex, "PSNode.Unknown.Error", ErrorCategory.NotSpecified, this));
                    }
                }

                foreach (string tr in toRemove) {                    
                    UserSessions.Remove(tr);
                }
            } catch (Exception ex) {
                this.Error.Add(new ErrorRecord(ex, "PSNode.Unknown.Error", ErrorCategory.NotSpecified, this));
            }
        }
        

        /// <summary>
        /// If the comamnd is running, the job indicates it has more data
        /// </summary>
        public override bool HasMoreData
        {
            get
            {
                if (powerShellCommand.InvocationStateInfo.State == PSInvocationState.Running)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }

        public override string Location
        {
            get
            {
                if (this.JobStateInfo.State == JobState.Running)
                {
                    if (this.ListenerLocation == null) {
                        return " ";
                    } else {
                        return this.ListenerLocation[0];
                    }
                }
                else
                {
                    return " ";
                }
            }
        }


        public override string StatusMessage
        {
            get { return string.Empty; }
        }

        public override void StopJob()
        {                           
            try {                
                powerShellCommand.BeginStop(null, null);                                
                if (Listener != null) {
                    Listener.Stop();
                    Listener.Close();                    
                }

            } catch (Exception ex) {
                this.Error.Add(new ErrorRecord(ex, "PSNode.StopJob.Error", ErrorCategory.CloseError, this));
            }            
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                powerShellCommand.Dispose();
                runspacePool.Close();
                runspacePool.Dispose();
            }
            base.Dispose(disposing);
        }        
    }
}