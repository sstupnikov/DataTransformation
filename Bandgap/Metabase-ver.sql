CREATE DATABASE [Metabase]

CREATE TABLE [dbo].[SystemInfo](
	[DBID] [int] NOT NULL,
	[SystemID] [int] NOT NULL,
	[ElemNumber] [int] NOT NULL,
	[UpdateStatus] [int] NOT NULL,
	[_date] [datetime] NOT NULL,
	[Elements] [varchar](32) NOT NULL,
	[SystemInfo] [varchar](256) NOT NULL,
	[Description] [varchar](256) NULL,
 CONSTRAINT [PK_SystemInfo] PRIMARY KEY ([DBID],[SystemID])
)
 
CREATE TABLE [dbo].[PropertiesInfo](
	[DBID] [int] NOT NULL,
	[PropID] [int] NOT NULL,
	[Name] [varchar](256) NOT NULL,
	[Description] [text] NOT NULL,
	[WWWTemplatePage] [varchar](256) NOT NULL,
	[UpdateStatus] [int] NOT NULL,
 CONSTRAINT [PK_PropertiesInfo] PRIMARY KEY ([DBID],[PropID])
)
 
 CREATE TABLE [dbo].[DBContent](
	[DBID] [int] NOT NULL,
	[SystemID] [int] NOT NULL,
	[PropID] [int] NOT NULL,
	[UpdateStatus] [int] NOT NULL,
 CONSTRAINT [PK_Content] PRIMARY KEY ([DBID],[SystemID],[PropID])
)

CREATE PROCEDURE [dbo].[UpdateSystemInfo]
@DBID int,
@SystemID int OUTPUT,
@Elements varchar(32),
@ElemNumber int,
@SystemInfo varchar(256),
@Description text,
@UpdateStatus int
AS 
	IF @UpdateStatus=2		-- удалить запись
	BEGIN
		DELETE FROM dbo.SystemInfo WHERE [DBID]=@DBID AND SystemID=@SystemID
	END
	ELSE	-- добавить/изменить запись
	BEGIN		
		if @Elements IS NULL OR LEN(@Elements)<3 OR @ElemNumber<1
			RETURN 1
		IF @SystemID=0 -- надо добавлять новую систему 
		BEGIN -- определим номер системы
			SET @SystemID = ISNULL((SELECT MAX(SystemID)+1 FROM dbo.SystemInfo WHERE [DBID]=@DBID), 1)
		END

		IF EXISTS (SELECT TOP 1 [DBID] FROM dbo.SystemInfo WHERE [DBID]=@DBID AND SystemID=@SystemID)
			UPDATE dbo.SystemInfo SET [Elements]=@Elements, ElemNumber=@ElemNumber, SystemInfo=@SystemInfo,
				[Description]=@Description, UpdateStatus=1
				WHERE [DBID]=@DBID AND SystemID=@SystemID
		ELSE	-- запись найдена, обновить ее
			INSERT INTO dbo.SystemInfo ([DBID], SystemID, [Elements], ElemNumber, SystemInfo, [Description], UpdateStatus)
			VALUES (@DBID, @SystemID, @Elements, @ElemNumber, @SystemInfo, @Description, 1)
	END
	RETURN 0

CREATE PROCEDURE [dbo].[UpdatePropertiesInfo]
@DBID int,
@PropID int,
@Name varchar(256),
@Description text,
@WWWTemplatePage varchar(256),
@UpdateStatus int
AS
		IF @UpdateStatus=2		-- удалить запись
		BEGIN
			DELETE FROM PropertiesInfo WHERE DBID=@DBID AND PropID=@PropID
		END
		ELSE	-- добавить/изменить запись
		BEGIN			
			IF EXISTS (SELECT DBID FROM PropertiesInfo WHERE DBID=@DBID AND PropID=@PropID)	-- запись найдена, обновить ее
				UPDATE PropertiesInfo SET [Name]=@Name, [Description]=@Description, WWWTemplatePage=@WWWTemplatePage,
					UpdateStatus=1
				WHERE DBID=@DBID AND PropID=@PropID
			ELSE	-- запись не найдена, добавить ее
				INSERT INTO PropertiesInfo (DBID, PropID, [Name], [Description], WWWTemplatePage, UpdateStatus)
				VALUES (@DBID, @PropID, @Name, @Description, @WWWTemplatePage, 1)
		END
	RETURN 0
	
CREATE PROCEDURE [dbo].[UpdateDBContent]
	@DBID int,
	@SystemID int,
	@PropID int,
	@UpdateStatus int
AS
		IF @UpdateStatus=2		-- удалить запись
		BEGIN
			DELETE FROM DBContent WHERE DBID=@DBID AND SystemID=@SystemID AND PropID=@PropID
		END
		ELSE	-- добавить/изменить запись
		BEGIN
			IF EXISTS (SELECT DBID FROM DBContent WHERE DBID=@DBID AND SystemID=@SystemID AND PropID=@PropID)	-- запись найдена, обновить ее
				UPDATE DBContent SET UpdateStatus=1
				WHERE DBID=@DBID AND SystemID=@SystemID AND PropID=@PropID
			ELSE	-- запись не найдена, добавить ее
				INSERT INTO DBContent (DBID, SystemID, PropID, UpdateStatus)
				VALUES (@DBID, @SystemID, @PropID, 1)
		END
	RETURN 0	
		