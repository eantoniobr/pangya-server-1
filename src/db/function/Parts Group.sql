USE [Pangya]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		kitthanet
-- Create date: 2019-05-13
-- Description:	Parts group
-- =============================================
CREATE FUNCTION [dbo].[sys_parts_group]
(
	@TYPEID INT
)
RETURNS INT
AS
BEGIN
	RETURN (@TYPEID & (0xfc000000)) / POWER(2, 26)
END
GO

