Language.Templates.get_ByInputType()
------------------------------------

### Synopsis
Gets Language Templates by Input Type

---

### Description

Returns a dictionary of all unique language templates that accept a pipeline parameter.

The key will be the type of parameter accepted.
The value will be a list of commands that accept that parameter from the pipeline.

---

### Notes
Primitive parameter types and string types will be ignored.

---
