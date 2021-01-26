USE [EMS.Common]
GO
/****** Object:  UserDefinedFunction [dbo].[removeTrailingZeros]    Script Date: 2021-01-04 11:32:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author, Sesugh Hulugh>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
ALTER FUNCTION [dbo].[removeTrailingZeros](@input NVARCHAR(MAX))

RETURNS NVARCHAR(MAX)
AS
BEGIN
	--(1)
IF (CHARINDEX('.', @input) > 0)
		--(2)
        IF (SUBSTRING(@input, LEN(@input), LEN(@input)) = '0')
			SET @input = dbo.removeTrailingZeros(SUBSTRING(@input, 1,LEN(@input) -1)) --recursion
		--(3)
		ELSE IF (SUBSTRING(@input, LEN(@input), LEN(@input)) = '.')
			SET @input = SUBSTRING(@input, 1,LEN(@input) -1)
		
ELSE
		SET @input = @input
--(4)
RETURN @input

--PSEUDOCODE
--(1) If input contains '.' GOTO (2) ELSE GOTO (4)
--(2) If last character is '0' THEN remove '0' AND GOTO (1) ELSE GOTO (3)
--(3) If lastCharacter is '.' THEN remove '.' AND GOTO (4)
--(4) RETURN input
	
END