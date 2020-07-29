# dynamicsqlmssql
> Microsoft SQL Server project which utilizes a stored procedure to extract data dynamically

## Table of Contents
* [Version](#version)
* [Important Note](#important-note)
* [Dependent MSSQL Function](#dependent-mssql-function)
* [Prerequisite Data Types](#prerequisite-data-types)
* [Prerequisite Functions](#prerequisite-functions)
* [Usage](#usage)

### Version
* 0.0.1

### **Important Note**
* This project was written with SQL Server 2012 methods

### Dependent MSSQL Function
* [Omit Characters](https://github.com/Cuates/omitcharactersmssql)

### Prerequisite Data Types
* bigint
* smallint
* nvarchar
* datetime2

### Prerequisite Functions
* nullif
* ltrim
* rtrim
* format
* isdate
* cast
* exec
* sp_executesql

### Usage
* `dbo.dynamicSQL @optionMode = 'extractDataDynamicParameterized', @columnOneString = 'SearchableColumnOne', @startDate = '2020-07-28 00:00:00, @endDate = '2020-07-29 00:00:00'`
* `dbo.dynamicSQL @optionMode = 'extractDataDynamic', @columnOneString = 'SearchableColumnOne'`
