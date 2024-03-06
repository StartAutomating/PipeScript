Template.Docker.HealthCheck
---------------------------

### Synopsis
Template for a health check in a Dockerfile.

---

### Description

A Template for a health check in a Dockerfile.

---

### Related Links
* [https://docs.docker.com/engine/reference/builder/#healthcheck](https://docs.docker.com/engine/reference/builder/#healthcheck)

---

### Parameters
#### **Command**
The command to run.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|

#### **Interval**
The interval between checks.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[TimeSpan]`|false   |2       |true (ByPropertyName)|

#### **Timeout**
The timeout for a check.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[TimeSpan]`|false   |3       |true (ByPropertyName)|

#### **StartPeriod**
The start period for the check.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[TimeSpan]`|false   |4       |true (ByPropertyName)|

#### **StartInterval**
The start interval for the check.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[TimeSpan]`|false   |5       |true (ByPropertyName)|

#### **RetryCount**
The number of retries.

|Type     |Required|Position|PipelineInput        |Aliases          |
|---------|--------|--------|---------------------|-----------------|
|`[Int32]`|false   |6       |true (ByPropertyName)|Retries<br/>Retry|

---

### Syntax
```PowerShell
Template.Docker.HealthCheck [[-Command] <String>] [[-Interval] <TimeSpan>] [[-Timeout] <TimeSpan>] [[-StartPeriod] <TimeSpan>] [[-StartInterval] <TimeSpan>] [[-RetryCount] <Int32>] [<CommonParameters>]
```
