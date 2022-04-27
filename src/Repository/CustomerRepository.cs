using Dapper;
using Dapper.Contrib.Extensions;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using Triton.Core;
using Triton.FleetManagement.WebApi.Interface;
using Triton.Service.Model.TritonFleetManagement.Custom;
using Triton.Service.Model.TritonFleetManagement.Tables;

namespace Triton.FleetManagement.WebApi.Repository
{
    public class CustomerRepository : ICustomer
    {
        private readonly IConfiguration _config;
        public CustomerRepository(IConfiguration configuration)
        {
            _config = configuration;
        }
        public async Task<bool> DeleteAsync(Customer customer)
        {
            try
            {

                await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));
                int deletedByUserID = (int)customer.DeletedByUserID;
                DBConnection.GetContextInformationFromConnection(connection, deletedByUserID);
                customer.DeletedOn = DateTime.Now;

                _ = await connection.UpdateAsync(customer);
                // Return success
                return true;
            }
            catch //(Exception exc)
            {
                return false;
            }
        }

        public async Task<List<CustomerModel>> GetAllAsync()
        {
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));
            var query = string.Format(@"SELECT
                                        C.CustomerID[CustomerID],C.*,
                                        L.LookupcodeID[LookupcodeID], L.*,
                                        
                                        CASE WHEN CP.CompanyID IS NULL THEN 0 ELSE CP.CompanyID  END [CompanyID],
                                        CASE WHEN CP.CompanyID IS NULL THEN 0 ELSE CP.CompanyID  END [CompanyID],
                                        CP.Description [Description],
                                        CP.VatNo,
                                        CP.Contact,
                                        CP.ContacNumber,
                                        CP.RegNo,
                                        CASE WHEN CP.ShortCompanyName IS NULL THEN 'ALL' ELSE CP.ShortCompanyName  END [ShortCompanyName]
                                        
                                        FROM[TritonFleetManagement].[dbo].[Customer] C WITH(NOLOCK)
                                        INNER JOIN TritonGroup.dbo.Lookupcodes L WITH(NOLOCK) ON L.[LookupcodeID] = C.AccountStatusTypeLCID
                                        LEFT JOIN  [TritonSecurity].[dbo].[Companys] CP WITH(NOLOCK) ON CP.companyID = C.CompanyID 
                                        ORDER BY C.CustomerID DESC"
                                       );


            var customerModel = new List<CustomerModel>();

            var data = connection.Query<Customer, LookupCodeModel, CompanyModel, List<CustomerModel>>(
                 query, (Customer, LookupCodeModel, CompanyModel) =>
                 {
                     var model = new CustomerModel
                     {
                         Customer = Customer,
                         AccountStatusTypes = LookupCodeModel,
                         Company = CompanyModel
                     };

                     customerModel.Add(model);
                     return customerModel;
                 },

                 splitOn: "CustomerID,LookupcodeID,CompanyID").FirstOrDefault();

            return data == null ? new List<CustomerModel>() : data;
        }


        public async Task<CustomerModel> GetByIdAsync(int customerID)
        {

            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));

            const string sql = "EXEC [TritonFleetManagement].[dbo].[proc_Customer_GetCustomerByID] @CustomerID " +
                               "EXEC [TritonSecurity].[dbo].[proc_Company_GetAll] " +
                               "EXEC [TritonGroup].[dbo].[proc_LookUpCodes_ByCategoryID_Select] 71 " +
                               "EXEC [TritonGroup].[dbo].[proc_LookUpCodes_ByCategoryID_Select] 75 " +
                               "EXEC [TritonGroup].[dbo].[proc_LookUpCodes_ByCategoryID_Select] 76 " +
                               "EXEC [TritonGroup].[dbo].[proc_LookUpCodes_ByCategoryID_Select] 84 " +
                               "EXEC [TritonFleetManagement].[dbo].[proc_ContactType_GetByCustomerID] @CustomerID " +
                               "EXEC [TritonFleetManagement].[dbo].[proc_VendorCode_GetByCustomerID] @CustomerID " +
                               "EXEC [TritonFleetManagement].[dbo].[proc_DocumentRepository_CustomerDocument_Select] @CustomerID " +
                               "EXEC [TritonGroup].[dbo].[proc_LookUpCodes_ByCategoryID_Select] 87 " +
                               "EXEC [TritonFleetManagement].[dbo].[proc_CustomerDocument_CountFiles_Select] @CustomerID"
                               ;
            var customerModel = new CustomerModel();

            using (var multi = connection.QueryMultiple(sql, new { CustomerID = customerID }))
            {
                customerModel.Customer = multi.Read<Customer>().FirstOrDefault();
                customerModel.CompanyModel = multi.Read<CompanyModel>().ToList();
                customerModel.AccountStatusType = multi.Read<LookupCodeModel>().ToList();
                customerModel.CategoryType = multi.Read<LookupCodeModel>().ToList();
                customerModel.LoyaltyStatus = multi.Read<LookupCodeModel>().ToList();
                customerModel.ContactTypeDetails = multi.Read<LookupCodeModel>().ToList();
                customerModel.ContactType = multi.Read<ContactType>().ToList();
                customerModel.VendorCodes = multi.Read<VendorCode>().ToList();
                customerModel.CustomerDocumentRepositoryList = multi.Read<CustomerDocumentRepositoryModel>().ToList();
                customerModel.ITCType = multi.Read<LookupCodeModel>().ToList();
                customerModel.CountFiles = multi.Read<CustomerDocumentRepositoryModel>().FirstOrDefault();
                customerModel.SelectedAccountStatusType = customerModel.Customer.AccountStatusTypeLCID;
                customerModel.SelectedCategoryType = customerModel.Customer.CustomerTypeLCID;
                customerModel.SelectedLoyaltyStatus = customerModel.Customer.LoyaltyStatusLCID;
                customerModel.SelectedCompany = customerModel.Customer.CompanyID.Value;

                var vendorModel = new VendorCodeModel();
                if (customerModel.VendorCodes.Count == 0)
                {
                    vendorModel.VendorCodeIDTMF = 0;
                    vendorModel.VendorCodeIDTTM = 0;
                    vendorModel.VendorCodeTFM = null;
                    vendorModel.VendorCodeTTM = null;
                }
                else if (customerModel.VendorCodes.Count == 1)
                {
                    vendorModel.VendorCodeIDTMF = customerModel.VendorCodes[0].VendorCodeID;
                    vendorModel.VendorCodeIDTTM = 0;
                    vendorModel.VendorCodeTFM = customerModel.VendorCodes[0].VendorCodes;
                    vendorModel.VendorCodeTTM = null;
                }
                else if (customerModel.VendorCodes.Count == 2)
                {
                    vendorModel.VendorCodeIDTMF = customerModel.VendorCodes[0].VendorCodeID;
                    vendorModel.VendorCodeIDTTM = customerModel.VendorCodes[1].VendorCodeID;
                    vendorModel.VendorCodeTFM = customerModel.VendorCodes[0].VendorCodes;
                    vendorModel.VendorCodeTTM = customerModel.VendorCodes[1].VendorCodes;
                }

                customerModel.VendorCodeModel = vendorModel;

                customerModel.ContactTypes = new ContactTypeModel
                {
                    ContactTypeIDAccounts = customerModel.ContactType.Count == 0 ? 0 : customerModel.ContactType[2].ContactTypeID,
                    CustomerIDAccounts = customerModel.ContactType.Count == 0 ? 0 : customerModel.ContactType[2].CustomerID,
                    ContactTypeLCIDAccounts = Convert.ToInt32(customerModel.ContactType[2].ContactTypeLCID),
                    NameAccounts = customerModel.ContactType.Count == 0 ? null : customerModel.ContactType[2].Name,
                    TelephoneNumberAccounts = customerModel.ContactType.Count == 0 ? null : customerModel.ContactType[2].TelephoneNumber,
                    EmailAccounts = customerModel.ContactType.Count == 0 ? null : customerModel.ContactType[2].Email,

                    ContactTypeIDOperations = customerModel.ContactType.Count == 0 ? 0 : customerModel.ContactType[1].ContactTypeID,
                    CustomerIDOperations = customerModel.ContactType.Count == 0 ? 0 : customerModel.ContactType[1].CustomerID,
                    ContactTypeLCIDOperations = Convert.ToInt32(customerModel.ContactType[1].ContactTypeLCID),
                    NameOperations = customerModel.ContactType.Count == 0 ? null : customerModel.ContactType[1].Name,
                    TelephoneNumberOperations = customerModel.ContactType.Count == 0 ? null : customerModel.ContactType[1].TelephoneNumber,
                    EmailOperations = customerModel.ContactType.Count == 0 ? null : customerModel.ContactType[1].Email,

                    ContactTypeIDManagement = customerModel.ContactType.Count == 0 ? 0 : customerModel.ContactType[0].ContactTypeID,
                    CustomerIDManagement = customerModel.ContactType.Count == 0 ? 0 : customerModel.ContactType[0].CustomerID,
                    ContactTypeLCIDManagement = Convert.ToInt32(customerModel.ContactType[0].ContactTypeLCID),
                    NameManagement = customerModel.ContactType.Count == 0 ? null : customerModel.ContactType[0].Name,
                    TelephoneNumberManagement = customerModel.ContactType.Count == 0 ? null : customerModel.ContactType[0].TelephoneNumber,
                    EmailManagement = customerModel.ContactType.Count == 0 ? null : customerModel.ContactType[0].Email
                };

            }

            return customerModel;
        }



        public async Task<CustomerModel> LookUpCodesAsync()
        {
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));
            var customerModel = new CustomerModel();

            var query = string.Format(@" 
                                        EXEC [TritonSecurity].[dbo].[proc_Company_GetAll]" +
                                        "EXEC [TritonGroup].[dbo].[proc_LookUpCodes_ByCategoryID_Select] 71 " +
                                        "EXEC [TritonGroup].[dbo].[proc_LookUpCodes_ByCategoryID_Select] 75 " +
                                        "EXEC [TritonGroup].[dbo].[proc_LookUpCodes_ByCategoryID_Select] 76 " +
                                        "EXEC [TritonGroup].[dbo].[proc_LookUpCodes_ByCategoryID_Select] 84 " +
                                        "EXEC [TritonGroup].[dbo].[proc_LookUpCodes_ByCategoryID_Select] 87 "
                                     );
            using (var multi = connection.QueryMultiple(query))
            {
                customerModel.CompanyModel = multi.Read<CompanyModel>().ToList();
                customerModel.AccountStatusType = multi.Read<LookupCodeModel>().ToList();
                customerModel.CategoryType = multi.Read<LookupCodeModel>().ToList();
                customerModel.LoyaltyStatus = multi.Read<LookupCodeModel>().ToList();
                customerModel.ContactTypeDetails = multi.Read<LookupCodeModel>().ToList();
                customerModel.ITCType = multi.Read<LookupCodeModel>().ToList();
                customerModel.Customer = new Customer();
                customerModel.ContactTypes = new ContactTypeModel();

            }
            return customerModel;
        }


        public async Task<bool> InsertAsync(CustomerModel customerModel)
        {
            try
            {
                await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));
                DBConnection.GetContextInformationFromConnection(connection, customerModel.Customer.CreatedByUserID);
                customerModel.Customer.CompanyID = (customerModel.Customer.CompanyID == 0 ? null : customerModel.Customer.CompanyID);
                return connection.Query<bool>("[TritonFleetManagement].[dbo].[proc_Customer_Insert_CustomerModel]",
                new
                {
                    customerModel.Customer.Name,
                    customerModel.Customer.VatRegistration,
                    customerModel.Customer.CreditLimit,
                    customerModel.Customer.LoyaltySpend,
                    customerModel.Customer.LoyaltyStatusLCID,
                    customerModel.Customer.AccountStatusTypeLCID,
                    customerModel.Customer.CustomerTypeLCID,
                    customerModel.Customer.PhysicalAddress1,
                    customerModel.Customer.PhysicalAddress2,
                    customerModel.Customer.PhysicalSuburb,
                    customerModel.Customer.PhysicalPostalCode,
                    customerModel.Customer.PostalAddress1,
                    customerModel.Customer.PostalAddress2,
                    customerModel.Customer.PostalSuburb,
                    customerModel.Customer.PostalCode,
                    customerModel.Customer.CreatedByUserID,
                    customerModel.Customer.CompanyID,
                    customerModel.Customer.CompanyRegistration,

                    customerModel.ContactTypes.ContactTypeLCIDManagement,
                    customerModel.ContactTypes.NameManagement,
                    customerModel.ContactTypes.TelephoneNumberManagement,
                    customerModel.ContactTypes.EmailManagement,

                    customerModel.ContactTypes.ContactTypeLCIDOperations,
                    customerModel.ContactTypes.NameOperations,
                    customerModel.ContactTypes.TelephoneNumberOperations,
                    customerModel.ContactTypes.EmailOperations,

                    customerModel.ContactTypes.ContactTypeLCIDAccounts,
                    customerModel.ContactTypes.NameAccounts,
                    customerModel.ContactTypes.TelephoneNumberAccounts,
                    customerModel.ContactTypes.EmailAccounts,

                    customerModel.VendorCodeModel.VendorCodeTFM,
                    customerModel.VendorCodeModel.VendorCodeTTM

                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
            catch //(Exception e)
            {
                // Log error
                return false;
            }
        }

        public async Task<bool> UpdateAsync(CustomerModel customerModel)
        {
            try
            {
                await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));
                DBConnection.GetContextInformationFromConnection(connection, customerModel.Customer.CreatedByUserID);
                customerModel.Customer.CompanyID = (customerModel.Customer.CompanyID == 0 ? null : customerModel.Customer.CompanyID);
                return connection.Query<bool>("[TritonFleetManagement].[dbo].[proc_Customer_Update_CustomerModel]",
                new
                {
                    customerModel.Customer.CustomerID,
                    customerModel.Customer.Name,
                    customerModel.Customer.VatRegistration,
                    customerModel.Customer.CreditLimit,
                    customerModel.Customer.LoyaltySpend,
                    customerModel.Customer.LoyaltyStatusLCID,
                    customerModel.Customer.AccountStatusTypeLCID,
                    customerModel.Customer.CustomerTypeLCID,
                    customerModel.Customer.PhysicalAddress1,
                    customerModel.Customer.PhysicalAddress2,
                    customerModel.Customer.PhysicalSuburb,
                    customerModel.Customer.PhysicalPostalCode,
                    customerModel.Customer.PostalAddress1,
                    customerModel.Customer.PostalAddress2,
                    customerModel.Customer.PostalSuburb,
                    customerModel.Customer.PostalCode,
                    customerModel.Customer.CreatedByUserID,
                    customerModel.Customer.CompanyID,
                    customerModel.Customer.CreatedOn,
                    customerModel.Customer.CompanyRegistration,

                    customerModel.ContactTypes.ContactTypeIDManagement,
                    customerModel.ContactTypes.ContactTypeLCIDManagement,
                    customerModel.ContactTypes.NameManagement,
                    customerModel.ContactTypes.TelephoneNumberManagement,
                    customerModel.ContactTypes.EmailManagement,

                    customerModel.ContactTypes.ContactTypeIDOperations,
                    customerModel.ContactTypes.ContactTypeLCIDOperations,
                    customerModel.ContactTypes.NameOperations,
                    customerModel.ContactTypes.TelephoneNumberOperations,
                    customerModel.ContactTypes.EmailOperations,

                    customerModel.ContactTypes.ContactTypeIDAccounts,
                    customerModel.ContactTypes.ContactTypeLCIDAccounts,
                    customerModel.ContactTypes.NameAccounts,
                    customerModel.ContactTypes.TelephoneNumberAccounts,
                    customerModel.ContactTypes.EmailAccounts,

                    customerModel.VendorCodeModel.VendorCodeTFM,
                    customerModel.VendorCodeModel.VendorCodeTTM,
                    customerModel.VendorCodeModel.VendorCodeIDTMF,
                    customerModel.VendorCodeModel.VendorCodeIDTTM


                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            }
            catch //(Exception exc)
            {
                return false;
            }
        }

        public async Task<bool> IsCustomerExistsAsync(string customerName)
        {
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));
            return connection.Query<bool>("proc_Customer_IsCustomerNameExists", new { CustomerName = customerName }, commandType: CommandType.StoredProcedure).First();
        }

        public async Task<bool> InsertDocumentRepositoryAsync(CustomerDocumentRepositoryModel documentRepository)
        {
            try
            {
                await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));
                _ = connection.Query<bool>("[TritonFleetManagement].[dbo].[proc_Bookings_CustomerDocument_DocumentRepository_Insert]",
                new
                {
                    documentRepository.ImgName,
                    documentRepository.ImgData,
                    documentRepository.ImgContentType,
                    documentRepository.ImgLength,
                    documentRepository.CreatedByUserID,
                    documentRepository.customerID,
                    documentRepository.DocumentCategoryLCID

                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();

                return true;
            }
            catch //(Exception e)
            {
                // Log error
                return false;
            }
        }

        public async Task<DocumentRepository> GetAllDocuments(int DocumentRepositoryID)
        {
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));
            var query = string.Format(@"
                                        SELECT 
	                                        DR.ImgName, 
	                                        DR.ImgData, 
	                                        DR.ImgContentType, 
	                                        DR.ImgLength
                                        FROM DocumentRepository DR
                                        INNER JOIN CustomerDocument CD ON CD.DocumentRepositoryID = DR.DocumentRepositoryID
                                        WHERE CD.DocumentRepositoryID = @DocumentRepositoryID
                                        ORDER BY DR.DocumentRepositoryID DESC"
                                     );

            return connection.Query<DocumentRepository>(query, new { DocumentRepositoryID }).FirstOrDefault();
        }

        public async Task<Customer> GetCustomerID(string customerName)
        {
            string sql = @" SELECT 
	                            C.CustomerID
                            FROM Customer C
                            WHERE C.Name = @customerName";
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));
            return connection.Query<Customer>(sql, new { customerName }).FirstOrDefault();
        }

        public async Task<bool> DeleteFile(CustomerDocumentRepositoryModel customerDocumentRepository)
        {
            try
            {
                await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));
                _ = connection.Query<bool>("[TritonFleetManagement].[dbo].[proc_CustomerDocument_DocumentRepository_Delete]",
                new
                {
                    customerDocumentRepository.DocumentRepositoryID,
                    customerDocumentRepository.customerID,
                    customerDocumentRepository.DeletedByUserID
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();

                return true;
            }
            catch //(Exception e)
            {
                // Log error
                return false;
            }
        }

        public async Task<List<CustomerAuditModel>> GetCustomerAuditAsync(int CustomerID)
        {
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));

            return connection.Query<CustomerAuditModel>("proc_CustomerAudit_Select", new { customerID = CustomerID }, commandType: CommandType.StoredProcedure).ToList();
        }
    }
}
