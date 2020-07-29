use [DatabaseName]
go

-- Set ansi nulls
set ansi_nulls on
go

-- Set quoted identifier
set quoted_identifier on
go

-- ===========================
--       File: MainTableName
--    Created: 07/29/2020
--    Updated: 07/29/2020
-- Programmer: Cuates
--  Update By: Cuates
--    Purpose: Main table name
-- ===========================
create table [dbo].[MainTableName](
  [mtnid] [bigint] identity (1, 1) not null,
  [columnOne] [nvarchar](255) not null,
  [status] [smallint] not null,
  [created_date] [datetime2](7) null,
  [modified_date] [datetime2](7) null,
  constraint [PK_MainTableName] primary key clustered
  (
    [columnone] asc
  )with (pad_index = off, statistics_norecompute = off, ignore_dup_key = off, allow_row_locks = on, allow_page_locks = on, fillfactor = 90) on [primary]
  ) on [primary]
go

alter table [dbo].[MainTableName] add  default (getdate()) for [created_date]
go

alter table [dbo].[MainTableName] add  default (getdate()) for [modified_date]
go

alter table [dbo].[MainTableName] add  default ((0)) for [status]
go