USE TritonFleetManagement
GO

  
CREATE PROCEDURE [dbo].[proc_Customer_IsCustomerNameExists]   
@CustomerName  VARCHAR(350)   
  
AS   
  BEGIN   
      DECLARE @IsCustomerNameExists BIT = 0   
  
      IF EXISTS (SELECT TOP 1 *   
                 FROM   [TritonFleetManagement].[dbo].[Customer] C WITH(nolock)   
                 WHERE  LOWER(LTRIM(RTRIM(C.Name))) = LOWER(LTRIM(RTRIM(@CustomerName)))   
                 )   
        BEGIN   
            SET @IsCustomerNameExists = 1   
        END   
  
      SELECT @IsCustomerNameExists   
  END   
  