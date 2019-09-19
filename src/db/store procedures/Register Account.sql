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
CREATE PROCEDURE [dbo].[register_account]
	@USERNAME varchar(16), 
	@PASSWORD varchar(16),
	@SEX int,
	@EMAIL varchar(MAX),
	@BIRTHDATE date
AS
BEGIN
	SET NOCOUNT ON;

	--DECLARE @MD5_PASSWORD varchar(32)

	--SELECT @MD5_PASSWORD = CONVERT(VARCHAR(32), HashBytes('MD5', @PASSWORD), 2)

    INSERT INTO account (username, password, sex, email, birthdate) VALUES (@USERNAME, @PASSWORD, @SEX, @EMAIL, @BIRTHDATE)
END
GO


