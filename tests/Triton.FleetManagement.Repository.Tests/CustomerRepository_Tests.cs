using System;
using System.Diagnostics.CodeAnalysis;
using System.Threading.Tasks;
using System.Transactions;
using Triton.FleetManagement.WebApi.Repository;
using Microsoft.Extensions.Configuration;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Triton.Service.Model.TritonFleetManagement.Tables;
using Triton.Service.Model.TritonFleetManagement.Custom;
using System.Collections.Generic;

namespace CRM.Rates.Repository.Tests
{
    [ExcludeFromCodeCoverage]
    [TestClass]
    public class CustomerRepository_Tests
    {
        private static IConfiguration GetConfig()
        {
            return new ConfigurationBuilder()
                .AddJsonFile("appsettings.json")
                .Build();
        }

        private static CustomerModel GetCustomerSuccessObject()
        {

            return new CustomerModel
            {
                Customer = new Customer
                {
                    CustomerID = 1,
                    AccountStatusTypeLCID = 1,
                    CreatedByUserID = 15555,
                    CreatedOn = DateTime.Now,
                    CreditLimit = 122,
                    CustomerTypeLCID = 1,
                    LoyaltyStatusLCID = 1,
                    VatRegistration = "Addd",
                    DeletedByUserID = null,
                    DeletedOn = null,
                    LoyaltySpend = 13444,
                    PhysicalAddress1 = "1213 A",
                    PhysicalAddress2 = "dddd",
                    PhysicalPostalCode = "12133",
                    PhysicalSuburb = "sdsff",
                    PostalAddress1 = "asddfdsfd",
                    PostalAddress2 = "1233",
                    PostalCode = "1222",
                    PostalSuburb = "12133"

                }
            };

        }


        [TestMethod]
        public async Task PostAsync_Success()
        {
            var customer = new CustomerRepository(GetConfig());

            using (var tx = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                var result = await customer.InsertAsync(GetCustomerSuccessObject());

                Assert.IsNotNull(result);
                Assert.IsFalse(result, "false");
                Assert.IsInstanceOfType(result, typeof(bool));
                //tx.Complete();
            }
        }

        [TestMethod]
        public async Task GetByIdAsync_Success()
        {
            var customer = new CustomerRepository(GetConfig());
            var result = await customer.GetByIdAsync(10);
            Assert.IsInstanceOfType(result, typeof(CustomerModel));
            Assert.IsInstanceOfType(result.AccountStatusType, typeof(List<LookupCodeModel>));

        }


    }
}
