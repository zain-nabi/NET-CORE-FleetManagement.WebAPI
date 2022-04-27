USE [TritonFleetManagement]
GO

CREATE PROCEDURE  proc_Customer_Update_CustomerModel
(
	/*Customer Parameters*/
	@CustomerID               INT,
    @Name                     VARCHAR(255),
	@AccountNumber            VARCHAR(255),
	@VatRegistration		  VARCHAR(255),
	@TelephoneNumber		  VARCHAR(20),
	@CellphoneNumber		  VARCHAR(20),
	@Email				      VARCHAR(350),
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
	@CreatedOn                DATETIME,
	
	

	/*ContactType Parameters Management Operations Accounts*/ 
	@ContactTypeIDManagement    INT,
	@ContactTypeLCIDManagement  INT,
	@NameManagement             VARCHAR(50),
	@TelephoneNumberManagement  VARCHAR(50),
	@EmailManagement            VARCHAR(250),

	@ContactTypeIDOperations    INT,
	@ContactTypeLCIDOperations  INT,
	@NameOperations             VARCHAR(50),
	@TelephoneNumberOperations  VARCHAR(50),
	@EmailOperations            VARCHAR(250),

	@ContactTypeIDAccounts      INT,
	@ContactTypeLCIDAccounts    INT,
	@NameAccounts               VARCHAR(50),
	@TelephoneNumberAccounts    VARCHAR(50),
	@EmailAccounts              VARCHAR(250),

	/*VendorCode*/
	/*VendorCode*/
	@VendorCodeTFM              VARCHAR(10),
	@VendorCodeTTM              VARCHAR(10),
	@VendorCodeIDTMF            INT,
	@VendorCodeIDTTM            INT

)
AS

DECLARE     @IsUpdateCompletedSuccessfully BIT = 0

BEGIN TRAN
BEGIN TRY

   UPDATE Customer 
	SET 
	    Name = @Name, AccountNumber = @AccountNumber, AccountStatusTypeLCID = @AccountStatusTypeLCID,CompanyID = @CompanyID,CellphoneNumber = @CellphoneNumber,
		CreatedByUserID = @CreatedByUserID, CreatedOn = @CreatedOn, CreditLimit = @CreditLimit, CustomerTypeLCID = @CustomerTypeLCID, LoyaltyStatusLCID =@LoyaltyStatusLCID,
		PhysicalAddress1 = @PhysicalAddress1, PhysicalAddress2 = @PhysicalAddress2, PhysicalPostalCode = @PhysicalPostalCode,
		PhysicalSuburb = @PhysicalSuburb, PostalCode = @PostalCode, PostalAddress1 = @PostalAddress1, PostalAddress2 = @PostalAddress2, LoyaltySpend = @LoyaltySpend,
		VatRegistration = @VatRegistration,TelephoneNumber = @TelephoneNumber, Email = @Email, PostalSuburb = @PostalSuburb
	WHERE CustomerID = @CustomerID

  IF (@ContactTypeIDManagement = 0)
  BEGIN
  INSERT INTO [dbo].[ContactType]([CustomerID],[ContactTypeLCID],[Name],[TelephoneNumber],[Email])
     VALUES
           (@CustomerID,@ContactTypeLCIDManagement,@NameManagement,@TelephoneNumberManagement,@EmailManagement)
		   

  END
  IF (@ContactTypeIDOperations = 0)
  BEGIN
  INSERT INTO [dbo].[ContactType]([CustomerID],[ContactTypeLCID],[Name],[TelephoneNumber],[Email])
     VALUES
           
		   (@CustomerID,@ContactTypeLCIDOperations,@NameOperations,@TelephoneNumberOperations,@EmailOperations)
		 

  END
  IF (@ContactTypeIDAccounts = 0 )
  BEGIN
  INSERT INTO [dbo].[ContactType]([CustomerID],[ContactTypeLCID],[Name],[TelephoneNumber],[Email])
     VALUES
           (@CustomerID,@ContactTypeLCIDAccounts,@NameAccounts,@TelephoneNumberAccounts,@EmailAccounts)

  END
  ELSE
  BEGIN
     UPDATE ContactType
	  SET Name = @NameAccounts, TelephoneNumber = @TelephoneNumberAccounts, Email = @EmailAccounts
	 WHERE ContactTypeID = @ContactTypeIDAccounts

	 UPDATE ContactType
	  SET Name = @NameOperations, TelephoneNumber = @TelephoneNumberOperations, Email = @EmailOperations
	 WHERE ContactTypeID = @ContactTypeIDOperations

	 UPDATE ContactType
	  SET Name = @NameManagement, TelephoneNumber = @TelephoneNumberManagement, Email = @EmailManagement
	 WHERE ContactTypeID = @ContactTypeIDManagement

  END

   IF (@VendorCodeIDTMF = 0 AND @VendorCodeIDTTM = 0)
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

IF (@VendorCodeTFM IS NOT NULL)
   PRINT '@VendorCodeIDTMF'
    BEGIN
       UPDATE VendorCode
	   SET VendorCodeTFM = @VendorCodeTFM
	   WHERE VendorCodeID = @VendorCodeIDTMF
	   
    END

  IF (@VendorCodeTTM IS NOT NULL)
   PRINT '@VendorCodeIDTTM'
    BEGIN
       UPDATE VendorCode
	   SET VendorCodeTTM = @VendorCodeTTM
	   WHERE VendorCodeID = @VendorCodeIDTTM
	   
    END
  SET @IsUpdateCompletedSuccessfully = 1
  COMMIT 
  SELECT @IsUpdateCompletedSuccessfully
END TRY

BEGIN CATCH
           IF(@IsUpdateCompletedSuccessfully = 0)
		   BEGIN
		    ROLLBACK TRANSACTION

		   END
     SELECT @IsUpdateCompletedSuccessfully       
END CATCH



