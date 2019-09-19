USE [Pangya]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		kitthanet
-- Create date: 2019-05-12
-- Description:	Register account
-- =============================================
CREATE PROCEDURE [dbo].[sys_firstset]
	@ACCOUNT_ID int, 
	@NAME varchar(16),
	@CHAR_TYPEID int,
	@HAIR_COLOR tinyint
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ERROR_CODE TINYINT = 0

	DECLARE @CLUB_ID INT = 0
	DECLARE @CHAR_ID INT = 0

	IF EXISTS (SELECT 1 FROM [dbo].[account] WHERE account_id = @ACCOUNT_ID AND first_set = 0) BEGIN
		-- Pangya Equip
		INSERT INTO [dbo].equipment(account_id) VALUES (@ACCOUNT_ID)

		-- Insert Default Item
		EXEC [dbo].sys_add_item @ACCOUNT_ID, 436207622, 1 -- Lucky Necklace
		EXEC [dbo].sys_add_item @ACCOUNT_ID, 402653188, 1
		EXEC [dbo].sys_add_item @ACCOUNT_ID, 402653189, 1
		EXEC [dbo].sys_add_item @ACCOUNT_ID, 402653195, 1
		EXEC [dbo].sys_add_item @ACCOUNT_ID, 402653185, 1
		EXEC [dbo].sys_add_item @ACCOUNT_ID, 402653184, 1
		EXEC [dbo].sys_add_item @ACCOUNT_ID, 402653190, 1
		EXEC [dbo].sys_add_item @ACCOUNT_ID, 402653193, 1
		EXEC [dbo].sys_add_item @ACCOUNT_ID, 467664918, 1 -- Assist

		-- Insert Ball
		EXEC [dbo].sys_add_item @ACCOUNT_ID, 335544320, 1

		-- Insert Club
		SELECT @CLUB_ID EXEC [dbo].sys_add_item @ACCOUNT_ID, 268435456, 1
		
		-- Insert Character
		SELECT @CHAR_ID EXEC [dbo].sys_add_item @ACCOUNT_ID, @CHAR_TYPEID, 1
		UPDATE [dbo].[char] SET hair_color = @HAIR_COLOR WHERE char_id = @CHAR_ID

		-- Update Equip
		UPDATE [dbo].[equipment] SET 
		ball_typeid = 335544320, 
		club_id = @CLUB_ID, 
		character_id = @CHAR_ID 
		WHERE account_id = @ACCOUNT_ID
		
		-- Insert User Statistic
		INSERT INTO [dbo].[statistic](account_id, pang) VALUES (@ACCOUNT_ID, 3000000)
		
		-- Acievement
		--EXEC DBO.ProcCreateAchievement @UID

		-- Insert Into Macro
		INSERT INTO [dbo].[hotkey](account_id) VALUES (@ACCOUNT_ID)

	END ELSE BEGIN
		SET @ERROR_CODE = 1;
	END

	SELECT @ERROR_CODE AS ERROR_CODE
END
GO


