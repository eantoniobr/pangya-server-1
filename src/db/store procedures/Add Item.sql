USE [Pangya]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		kitthanet
-- Create date: 2019-05-13
-- Description:	Add item
-- =============================================
CREATE PROCEDURE [dbo].[sys_add_item]
	@ACCOUNT_ID int, 
	@ITEM_TYPEID int,
	@AMOUNT int
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ITEM_GRP INT = 0
	DECLARE @ITEM_ID INT = 0
	-- FOR CADDIE
	DECLARE @DATETIME DATETIME

	SET @ITEM_GRP = [dbo].sys_parts_group(@ITEM_TYPEID)

	/********************
	* 1. CHARACTER
	********************/
	IF (@ITEM_GRP = 1) BEGIN
		SET @ITEM_ID = (SELECT char_id FROM [dbo].[char] WHERE account_id = @ACCOUNT_ID AND char_typeid = @ITEM_TYPEID)
		IF (@ITEM_ID <= 0) OR (@ITEM_ID IS NULL) BEGIN
			INSERT INTO [dbo].[char](account_id, char_typeid) VALUES (@ACCOUNT_ID, @ITEM_TYPEID)
			SET @ITEM_ID = SCOPE_IDENTITY()	
			IF (@ITEM_ID > 0) BEGIN
				DECLARE @NUM INT = 1;

				WHILE @NUM <= 24
				BEGIN
					INSERT INTO [dbo].[char_equip](account_id, char_id, num) VALUES (@ACCOUNT_ID, @ITEM_ID, @NUM)
					SET @NUM = @NUM + 1;
				END;
			END
		END
	END

	/********************
	* 2. PART
	********************/
	IF (@ITEM_GRP = 2) BEGIN -- PART ITEM
		INSERT INTO [dbo].[inventory](account_id, typeid, c0) VALUES(@ACCOUNT_ID, @ITEM_TYPEID, 0)
		SET @ITEM_ID = SCOPE_IDENTITY()
	END

	/********************
	* 4. CLUB SET
	********************/
	IF (@ITEM_GRP = 4) BEGIN -- Club Set
		INSERT INTO [dbo].[inventory](account_id, typeid) VALUES(@ACCOUNT_ID, @ITEM_TYPEID)
		SET @ITEM_ID = SCOPE_IDENTITY()
		INSERT INTO [dbo].[club_data](item_id) VALUES (@ITEM_ID)
	END

	/********************
	* 5,6. ITEM, BALL
	********************/
	IF (@ITEM_GRP = 6) OR (@ITEM_GRP = 5) BEGIN -- {NORMAL ITEM} AND {BALL}
		INSERT INTO [dbo].[inventory](account_id, typeid, c0) VALUES(@ACCOUNT_ID, @ITEM_TYPEID, @AMOUNT)
		SET @ITEM_ID = SCOPE_IDENTITY()
	END

	/********************
	* 14. SKIN
	********************/
	IF (@ITEM_GRP = 14) BEGIN -- SKIN
		-- TO CHECK
		--IF @ITEM_TYPE = 0 BEGIN
			SET @DATETIME = GETDATE()
		--END ELSE BEGIN
		--	SET @DATETIME = DATEADD(DAY, ISNULL(@DAY, 1), GETDATE())
		--END
		-- END CHECK
		INSERT INTO [dbo].[inventory](account_id, typeid, c0, end_date, flag) VALUES(@ACCOUNT_ID, @ITEM_TYPEID, 0, @DATETIME, 0)
		SET @ITEM_ID = SCOPE_IDENTITY()
	END

	/********************
	* 31. CARD
	********************/
	IF (@ITEM_GRP = 31) BEGIN -- CARD
		INSERT INTO [dbo].[card](account_id, typeid, amount) VALUES (@ACCOUNT_ID, @ITEM_TYPEID, @AMOUNT)
		SET @ITEM_ID = SCOPE_IDENTITY()
	END

	/*DECLARE @C0 SMALLINT = 0
	DECLARE @C1 SMALLINT = 0
	DECLARE @C2 SMALLINT = 0
	DECLARE @C3 SMALLINT = 0
	DECLARE @C4 SMALLINT = 0
	DECLARE @CREATE_DATE DATETIME
	DECLARE @END_DATE DATETIME
	DECLARE @TYPE TINYINT = 0
	DECLARE @FLAG TINYINT = 0
	DECLARE @UCC_STRING VARCHAR(50) = ''
	DECLARE @UCC_KEY VARCHAR(8) = ''
	DECLARE @UCC_STATE TINYINT = 0
	DECLARE @UCC_COPY_COUNT INT = 0
	DECLARE @UCC_DRAWER INT = 0
	DECLARE @HAIR_COLOR TINYINT = 0*/

	/*******************
	Send Result
	*******************/
	SELECT	@ITEM_ID		AS item_id/*, 
			@ITEM_TYPEID	AS item_typeid, 
			@C0		AS c0, 
			@C1		AS c1, 
			@C2		AS c2, 
			@C3		AS c3, 
			@C4		AS c4, 
			@CREATE_DATE	AS create_date,
			@END_DATE		AS end_date,
			@TYPE		AS type,
			@FLAG		AS flag,
			@UCC_STRING	AS ucc_string,
			@UCC_KEY	AS ucc_key,
			@UCC_STATE	AS ucc_state,
			@UCC_COPY_COUNT	AS ucc_copy_count,
			@UCC_DRAWER	AS ucc_drawer,
			@HAIR_COLOR	AS hair_colour*/
END
GO


