PipeScript.Module.Container.get_DockerFileContent()
---------------------------------------------------

### Synopsis
Gets the content of a module's Dockerfile

---

### Description

A module may define a .Container(s) section in its manifest. 

This section may be docker file content.

It can also be a hashtable containing a .DockerFile property
(this can be the module-relative path to the .Dockerfile, or it's contents)

If neither of these is present, a default docker file will be generated for this module.

---
