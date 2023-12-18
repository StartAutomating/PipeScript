System.Management.Automation.PSModuleInfo.get_Export()
------------------------------------------------------

### Synopsis
Gets a module's exports

---

### Description

Gets everything a module exports or intends to export.

This combines the various `.Exported*` properties already present on a module.

It also adds anything found in a manifest's `.PrivateData.Export(s)` properties,
as well as anything in a manifest's  `.PrivateData.PSData.Export(s)`.

---

### Notes
This property serves two major purposes:

1. Interacting with all of the exports from any module in a consistent way
2. Facilitating exporting additional content from modules, such as classes.

---
