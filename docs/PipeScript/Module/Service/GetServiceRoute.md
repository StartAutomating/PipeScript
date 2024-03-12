PipeScript.Module.Service.GetServiceRoute()
-------------------------------------------

### Synopsis
Gets the service's route.

---

### Description

Any service can define a route, in a property named `.Route`, `.Routes`, `.Router`, or `.Routers`.

If the service does not define a route, the function will look for a `ValidatePattern` attribute in the service's command.

If the attribute is found, the function will return a regular expression describing the route.

---
