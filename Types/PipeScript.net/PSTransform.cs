namespace PipeScript.Net
{
    using System;
    using System.ComponentModel;
    using System.Collections;
    using System.Collections.Generic;
    using System.Collections.ObjectModel;
    using System.Management.Automation;
    /// <summary>    
    /// Transforms objects with PowerShell.
    /// </summary>    
    public class PSTransformAttribute : ArgumentTransformationAttribute
    {
        /// <summary>
        /// Creates a Argument Transform from an expression.
        /// </summary>
        /// <param name="transformExpression">
        /// An expression to use for the transform.
        /// This will be converted into a ScriptBlock.</param>
        public PSTransformAttribute(string transformExpression) {
            this.TransformScript = ScriptBlock.Create(transformExpression);
        }

        /// <summary>
        /// Creates a Argument Transform from a ScriptBlock
        /// </summary>
        /// <param name="transformScript">A ScriptBlock to transform the value</param>
        public PSTransformAttribute(ScriptBlock transformScript) {
            this.TransformScript = transformScript;            
        }                        

        /// <summary>
        /// A ScriptBlock to transform the value.
        /// The output of this script block will become the argument.
        /// </summary>
        public ScriptBlock TransformScript {
            get;
            set;
        }        

        /// <summary>
        /// If a transform is disabled, nothing will happen.
        /// </summary>
        public bool Disabled {
            get;
            set;
        }

        /// <summary>
        /// The name of the transform.
        /// This is not required. It is present in order to disambiguate multiple transforms.
        /// </summary>
        public string TransformName {
            get;
            set;
        }

        /// <summary>
        /// Determines if the script uses a new scope to execute.
        /// </summary>
        public bool UseNewScope {
            get;
            set;
        }

        /// <summary>
        /// Transforms arguments.        
        /// If the attribute is disabled, no transformation will take place.        
        /// If the attribute has a .TransformScript, this argument will be transformed by invoking the script. 
        /// </summary>
        /// <param name="engineIntrinsics"></param>
        /// <param name="inputData"></param>
        /// <returns></returns>
        public override object Transform(EngineIntrinsics engineIntrinsics, object inputData) {
            // If disabled, do nothing
            if (this.Disabled) { return inputData; }
            // If there is no transform script, return the input data.
            if (this.TransformScript == null) { return inputData; }                      

            // By getting the value of InvocationInfo now, we know what command is trying to perform the transform.
            InvocationInfo myInvocation = engineIntrinsics.SessionState.PSVariable.Get("MyInvocation").Value as InvocationInfo;

            engineIntrinsics.SessionState.PSVariable.Set("thisTransform", this);
            engineIntrinsics.SessionState.PSVariable.Set("_", inputData);    

            // The transform script will be passed the following arguments:
            // The input data, invocation info,  command, and this attribute.
            object[] arguments        = new object[] { inputData, myInvocation, myInvocation.MyCommand, this };
            object[] transformInput   = new object[] inputData; 

            // Invoke it in place.
            // ($_ will be the current transformed value)            
            Collection<PSObject> invokeResults = engineIntrinsics.SessionState.InvokeCommand.InvokeScript(this.UseNewScope, this.TransformScript, transformInput, arguments);
            
            if (invokeResults != null && invokeResults.Count == 1) {
                return invokeResults[0];
            } else if (invokeResults != null)  {
                return invokeResults;
            } else {
                return inputData;
            }
        }
    }
}