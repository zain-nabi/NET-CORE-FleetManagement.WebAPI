USE [TritonFleetManagement]
GO

ALTER PROCEDURE  proc_Customer_Insert_CustomerModel
(
	/*Customer Parameters*/
    @Name                     VARCHAR(255),
	@VatRegistration		  VARCHAR(255),
	@CreditLimit			  DECIMAL,
	@LoyaltySpend		      DECIMAL,
	@LoyaltyStatusLCID	      INT,
	@AccountStatusTypeLCID    INT,
	@CustomerTypeLCID	      INT,
	@PhysicalAddress1	      VARCHAR(500),
	@PhysicalAddress2	      VARCHAR(500),
	@PhysicalSuburb		      VARCHAR(500),
	@PhysicalPostalCode	      VARCHAR(10),
	@PostalAddress1		      VARCHAR(500),
	@PostalAddress2		      VARCHAR(500),
	@PostalSuburb		      VARCHAR(500),
	@PostalCode			      VARCHAR(10),
	@CreatedByUserID	      INT,
	@CompanyID			      INT,
	@CompanyRegistration      VARCHAR(255),
	
	

	/*ContactType Parameters Management Operations Accounts*/ 
	
	@ContactTypeLCIDManagement  INT,
	@NameManagement             VARCHAR(50),
	@TelephoneNumberManagement  VARCHAR(50),
	@EmailManagement            VARCHAR(250),

	@ContactTypeLCIDOperations  INT,
	@NameOperations             VARCHAR(50),
	@TelephoneNumberOperations  VARCHAR(50),
	@EmailOperations            VARCHAR(250),

	@ContactTypeLCIDAccounts    INT,
	@NameAccounts               VARCHAR(50),
	@TelephoneNumberAccounts    VARCHAR(50),
	@EmailAccounts              VARCHAR(250),

	/*VendorCode*/
	@VendorCodeTFM              VARCHAR(10),
	@VendorCodeTTM              VARCHAR(10)
)
AS
DECLARE		@CustomerID	INT
DECLARE     @IsInsertCompletedSuccessfully BIT = 0

BEGIN TRAN
BEGIN TRY

	INSERT INTO [dbo].[Customer]
           ([Name],[VatRegistration],[CreditLimit],[LoyaltySpend],[LoyaltyStatusLCID]
           ,[AccountStatusTypeLCID],[CustomerTypeLCID],[PhysicalAddress1],[PhysicalAddress2],[PhysicalSuburb],[PhysicalPostalCode],[PostalAddress1],[PostalAddress2]
           ,[PostalSuburb],[PostalCode],[CreatedOn],[CreatedByUserID] ,[DeletedOn],[DeletedByUserID],[CompanyID],[CompanyRegistration])
     VALUES
           (@Name,@VatRegistration,@CreditLimit,@LoyaltySpend,@LoyaltyStatusLCID
           ,@AccountStatusTypeLCID,@CustomerTypeLCID,@PhysicalAddress1,@PhysicalAddress2,@PhysicalSuburb,@PhysicalPostalCode,@PhysicalAddress1,@PostalAddress2
           ,@PostalSuburb,@PostalCode,GETDATE(),@CreatedByUserID,NULL,NULL,@CompanyID,@CompanyRegistration)

    SET    @CustomerID = SCOPE_IDENTITY()

  INSERT INTO [dbo].[ContactType]([CustomerID],[ContactTypeLCID],[Name],[TelephoneNumber],[Email])
     VALUES
           (@CustomerID,@ContactTypeLCIDManagement,@NameManagement,@TelephoneNumberManagement,@EmailManagement),
		   (@CustomerID,@ContactTypeLCIDOperations,@NameOperations,@TelephoneNumberOperations,@EmailOperations),
		   (@CustomerID,@ContactTypeLCIDAccounts,@NameAccounts,@TelephoneNumberAccounts,@EmailAccounts)

  IF (@CompanyID IS NULL)
  BEGIN
  DECLARE @CompanyIDTFM INT
  DECLARE @CompanyIDTTM INT

      SELECT @CompanyIDTFM = C.CompanyID FROM [TritonSecurity].[dbo].[Companys] C WITH(NOLOCK)    WHERE C.Description ='Triton Express (Pty) Ltd'    
      SELECT @CompanyIDTTM = C.CompanyID FROM [TritonSecurity].[dbo].[Companys] C WITH(NOLOCK)    WHERE C.Description ='Truck and Trailer Mbombela' 
    INSERT INTO [dbo].[VendorCode]([CustomerID],[CompanyID],[VendorCodeTFM],[VendorCodeTTM])
      VALUES

      (@CustomerID,@CompanyIDTFM,@VendorCodeTFM,@VendorCodeTTM ),
      (@CustomerID,@CompanyIDTTM,@VendorCodeTFM,@VendorCodeTTM )
  END
  ELSE 
    BEGIN
       INSERT INTO [dbo].[VendorCode]([CustomerID],[CompanyID],[VendorCodeTFM],[VendorCodeTTM])
       VALUES
	   (@CustomerID,@CompanyID,@VendorCodeTFM,@VendorCodeTTM )
    END


 SET @IsInsertCompletedSuccessfully = 1
 COMMIT 

END TRY

BEGIN CATCH
           IF(@IsInsertCompletedSuccessfully = 0)
		   BEGIN
		    ROLLBACK TRANSACTION
		   END
     SELECT @IsInsertCompletedSuccessfully       
END CATCH
