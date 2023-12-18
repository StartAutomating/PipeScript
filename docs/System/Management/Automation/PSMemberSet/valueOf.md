System.Management.Automation.PSMemberSet.valueOf()
--------------------------------------------------

### Synopsis
Returns the Value Of an object

---

### Description

valueOf allows you to override the returned value (in _some_ circumstances).

Defining a member named `valueOf` will make .PSObject.valueOf return that member's value or result.

Otherwise, `.valueOf()` will return the .ImmediateBaseObject.

---

### Notes
This makes .PSObject more similar to a JavaScript prototype.

---
