System.Management.Automation.CommandInfo.get_CacheControl()
-----------------------------------------------------------

### Synopsis
Gets a Command's Cache Control

---

### Description

Gets a Command's Cache Control header (if present).

Any [Reflection.AssemblyMetaData] whose key is named `*Cache*Control*` will be counted as a cache-control value.

All values will be joined with commas and cached.

---

### Notes
Cache Control allows any script to easily specify how long it's results should be cached.

---
