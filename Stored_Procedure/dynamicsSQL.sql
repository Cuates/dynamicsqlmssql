use [DatabaseName]
go

-- Set ansi nulls
set ansi_nulls on
go

-- Set quoted identifier
set quoted_identifier on
go

-- ========================
--        File: dynamicSQL
--     Created: 07/27/2020
--     Updated: 07/29/2020
--  Programmer: Cuates
--  Updated By: Cuates
--     Purpose: Dynamic SQL
-- ========================
create procedure [dbo].[dynamicSQL]
  -- Parameters
  @optionMode nvarchar(255),
  @startDate nvarchar(255) = null,
  @endDate nvarchar(255) = null,
  @columnOneString nvarchar(255) = null
as
begin
  -- Set nocount on added to prevent extra result sets from interfering with select statements
  set nocount on

  -- Dynamic select statement and where clause
  declare @dSQL as nvarchar(max)
  declare @dSQLWhere as nvarchar(max) = ''

  -- Omit characters
  set @optionMode = dbo.OmitCharacters(@optionMode, '65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122')

  -- Check if parameter is empty string
  if @optionMode = ''
    begin
      -- Set parameter to null if empty string
      set @optionMode = nullif(@optionMode, '')
    end

  -- Omit characters
  set @columnOneString = dbo.OmitCharacters(@columnOneString, '45,48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122')

  -- Check if parameter is empty string
  if @columnOneString = ''
    begin
      -- Set parameter to null if empty string
      set @columnOneString = nullif(@columnOneString, '')
    end

  -- Omit characters
  set @startDate = dbo.OmitCharacters(@startDate, '45,47,48,49,50,51,52,53,54,55,56,57')

  -- Check if parameter is date
  if isdate(@startDate) = 0
    begin
      -- Set parameter to empty string
      set @startDate = ''
    end

  -- Check if parameter is empty string
  if @startDate = ''
    begin
      -- Set parameter to null if empty string
      set @startDate = nullif(@startDate, '')
    end

  -- Omit characters
  set @endDate = dbo.OmitCharacters(@endDate, '45,47,48,49,50,51,52,53,54,55,56,57')

  -- Check if parameter is date
  if isdate(@endDate) = 0
    begin
      -- Set parameter to empty string
      set @endDate = ''
    end

  -- Check if parameter is empty string
  if @endDate = ''
    begin
      -- Set parameter to null if empty string
      set @endDate = nullif(@endDate, '')
    end

  -- Extract records
  if @optionMode = 'extractDataDynamicParameterized'
    begin
      -- Select records for processing using the dynamic sql builder containing parameters
      set @dSQL =
      'select
      distinct
      ltrim(rtrim(mtn.columnOne)) as [column One]
      from MainTableName mtn'

      -- Check if the two parameters are not null and dates not equal to each other
      if @startDate is not null and @endDate is not null and @startDate <> @endDate
        begin
          -- Check if start date is less than to end date
          if ltrim(rtrim(format(cast(@startDate as datetime2), 'yyyy-MM-dd', 'en-us'))) < ltrim(rtrim(format(cast(@endDate as datetime2), 'yyyy-MM-dd', 'en-us')))
            begin
              -- Check if parameter is not null
              if @columnOneString is not null
                begin
                  -- Build the dynamic where clause
                  set @dSQLWhere = @dSQLWhere + ' and ltrim(rtrim(mtn.columnOne)) = ltrim(rtrim(@_columnOneString)) and ltrim(rtrim(format(cast(mtn.create_date as datetime2), ''yyyy-MM-dd'', ''en-us''))) between ltrim(rtrim(format(cast(@_startDate as datetime2), ''yyyy-MM-dd'', ''en-us''))) and ltrim(rtrim(format(cast(@_endDate as datetime2), ''yyyy-MM-dd'', ''en-us'')))'
                end
              else
                begin
                  -- Build the dynamic where clause
                  set @dSQLWhere = @dSQLWhere + ' and ltrim(rtrim(format(cast(mtn.create_date as datetime2), ''yyyy-MM-dd'', ''en-us''))) between ltrim(rtrim(format(cast(@_startDate as datetime2), ''yyyy-MM-dd'', ''en-us''))) and ltrim(rtrim(format(cast(@_endDate as datetime2), ''yyyy-MM-dd'', ''en-us'')))'
                end
            end
          -- Else change the start date to the end date spot and vice versa for the end date to the start date
          else
            begin
              -- Check if parameter is not null
              if @columnOneString is not null
                begin
                  -- Build the dynamic where clause
                  set @dSQLWhere = @dSQLWhere + ' and ltrim(rtrim(mtn.columnOne)) = ltrim(rtrim(@_columnOneString)) and ltrim(rtrim(format(cast(mtn.create_date as datetime2), ''yyyy-MM-dd'', ''en-us''))) between ltrim(rtrim(format(cast(@_endDate as datetime2), ''yyyy-MM-dd'', ''en-us''))) and ltrim(rtrim(format(cast(@_startDate as datetime2), ''yyyy-MM-dd'', ''en-us'')))'
                end
              else
                begin
                  -- Build the dynamic where clause
                  set @dSQLWhere = @dSQLWhere + ' and ltrim(rtrim(format(cast(mtn.create_date as datetime2), ''yyyy-MM-dd'', ''en-us''))) between ltrim(rtrim(format(cast(@_endDate as datetime2), ''yyyy-MM-dd'', ''en-us''))) and ltrim(rtrim(format(cast(@_startDate as datetime2), ''yyyy-MM-dd'', ''en-us'')))'
                end
            end
        end

      -- Check if the two parameters are not null and dates equal to each other
      else if @startDate is not null and @endDate is not null and @startDate = @endDate
        begin
          -- Check if parameter is not null
          if @columnOneString is not null
            begin
              -- Build the dynamic where clause
              set @dSQLWhere = @dSQLWhere + ' and ltrim(rtrim(mtn.columnOne)) = ltrim(rtrim(@_columnOneString)) and ltrim(rtrim(format(cast(mtn.create_date as datetime2), ''yyyy-MM-dd'', ''en-us''))) = ltrim(rtrim(format(cast(@_startDate as datetime2), ''yyyy-MM-dd'', ''en-us'')))'
            end
          else
            begin
              -- Build the dynamic where clause
              set @dSQLWhere = @dSQLWhere + ' and ltrim(rtrim(format(cast(mtn.create_date as datetime2), ''yyyy-MM-dd'', ''en-us''))) = ltrim(rtrim(format(cast(@_startDate as datetime2), ''yyyy-MM-dd'', ''en-us'')))'
            end
        end

      -- Check if start date is not null
      else if @startDate is null and @endDate is not null
        begin
          -- Check if parameter is not null
          if @columnOneString is not null
            begin
              -- Build the dynamic where clause
              set @dSQLWhere = @dSQLWhere + ' and ltrim(rtrim(mtn.columnOne)) = ltrim(rtrim(@_columnOneString)) and ltrim(rtrim(format(cast(mtn.create_date as datetime2), ''yyyy-MM-dd'', ''en-us''))) <= ltrim(rtrim(format(cast(@_endDate as datetime2), ''yyyy-MM-dd'', ''en-us'')))'
            end
          else
            begin
              -- Build the dynamic where clause
              set @dSQLWhere = @dSQLWhere + ' and ltrim(rtrim(format(cast(mtn.create_date as datetime2), ''yyyy-MM-dd'', ''en-us''))) <= ltrim(rtrim(format(cast(@_endDate as datetime2), ''yyyy-MM-dd'', ''en-us'')))'
            end
        end

      -- Check if end date is not null
      else if @startDate is not null and @endDate is null
        begin
          -- Check if parameter is not null
          if @columnOneString is not null
            begin
              -- Build the dynamic where clause
              set @dSQLWhere = @dSQLWhere + ' and ltrim(rtrim(mtn.columnOne)) = ltrim(rtrim(@_columnOneString)) and ltrim(rtrim(format(cast(mtn.create_date as datetime2), ''yyyy-MM-dd'', ''en-us''))) >= ltrim(rtrim(format(cast(@_startDate as datetime2), ''yyyy-MM-dd'', ''en-us'')))'
            end
          else
            begin
              -- Build the dynamic where clause
              set @dSQLWhere = @dSQLWhere + ' and ltrim(rtrim(format(cast(mtn.create_date as datetime2), ''yyyy-MM-dd'', ''en-us''))) >= ltrim(rtrim(format(cast(@_startDate as datetime2), ''yyyy-MM-dd'', ''en-us'')))'
            end
        end

      -- Check if dynamic SQL is not empty
      if ltrim(rtrim(@dSQLWhere)) = ltrim(rtrim(''))
        begin
          -- Check if parameter is not null
          if @columnOneString is not null
            begin
              -- Build the dynamic where clause
              set @dSQLWhere = @dSQLWhere + ' and ltrim(rtrim(mtn.columnOne)) = ltrim(rtrim(@_columnOneString))'
            end
        end

      -- Combine both SQL and SQL Where clause into one statement
      set @dSQL = @dSQL + ' where mtn.[status] in (0)' + @dSQLWhere

      -- Execute dynamic statement with the parameterized values
      -- Important Note: Parameterizated values need to match the parameters they are matching at the top of the script
      exec sp_executesql @dSQL,
      N'@_columnOneString nvarchar(255), @_startDate nvarchar(255), @_endDate nvarchar(255)',
      @_columnOneString = @columnOneString, @_startDate = @startDate, @_endDate = @endDate
    end

  -- Extract all records when not completed or removed
  else if @optionMode = 'extractDataDynamic'
    begin
      -- Set dynamic query statement
      set @dSQL =
      'select
      distinct
      ltrim(rtrim(mtn.columnOne)) as [column One]
      from MainTableName mtn
      where
      mtn.[status] = 0'

      -- Check if parameter is not empty or is not null
      if(@columnOneString != '' or @columnOneString is not null)
        begin
          -- Append dynamic statement variable
          set @dSQL = @dSQL + ' and mtn.columnOne = ''' + @columnOneString + ''''
        end

      -- Execute dynamic statement
      exec(@dSQL)
    end
end