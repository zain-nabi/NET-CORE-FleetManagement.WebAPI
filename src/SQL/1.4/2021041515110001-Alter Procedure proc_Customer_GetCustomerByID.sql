USE TritonFleetManagement
GO

ALTER PROCEDURE proc_Customer_GetCustomerByID        
@CustomerID INT       
AS        
BEGIN        
    
SELECT     
   C.CustomerID,     
   C.AccountStatusTypeLCID,    
   C.CreatedByUserID,    
   C.CreatedOn,    
   C.CreditLimit,    
   C.CustomerTypeLCID,    
   C.DeletedByUserID,    
   C.DeletedOn,     
   C.LoyaltySpend,    
   C.LoyaltyStatusLCID,    
   C.Name,    
   C.PhysicalAddress1,    
   C.PhysicalAddress2,    
   C.PhysicalPostalCode,    
   C.PhysicalSuburb,    
   C.PostalAddress1,   
   C.PostalAddress2,  
   C.PhysicalAddress2,    
   C.PostalCode,    
   C.PostalSuburb,    
   C.VatRegistration,    
   CASE WHEN C.CompanyID IS NULL THEN 0 ELSE  C.CompanyID END [CompanyID],
   C.CompanyRegistration
    
FROM [TritonFleetManagement].[dbo].[Customer] C WITH(NOLOCK)    
WHERE C.CustomerID = @CustomerID    
    
END    
    