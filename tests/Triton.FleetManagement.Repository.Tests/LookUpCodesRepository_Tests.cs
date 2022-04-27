using Microsoft.Extensions.Configuration;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;
using Triton.FleetManagement.WebApi.Repository;
using Triton.Model.TritonGroup.Tables;

namespace Triton.FleetManagement.Repository.Tests
{
    [ExcludeFromCodeCoverage]
    [TestClass]
    public class LookUpCodesRepository_Tests
    {
        private static IConfiguration GetConfig()
        {
            return new ConfigurationBuilder()
                .AddJsonFile("appsettings.json")
                .Build();
        }

        //private static LookUpCodes LookUpCodesSuccessObject()
        //{

        //    return new LookUpCodes
        //    {
        //        Name = "H300",
        //        Detail = "H300",
        //        LookupcodeCategoryID = 96,
        //        Sequence = 1,
        //        CreatedByUserID = 88425,
        //        CreatedOn = System.DateTime.Now,
        //        DeletedByUserID = null,
        //        DeletedOn = null,
        //        FAIconString = "",
        //        AdditionalField1Name = "",
        //        AdditionalField1Value = ""

        //    };

        //}


        //[TestMethod]
        //public async Task PostAsync_Success()
        //{
        //    var lookUpCode = new LookUpCodeRepository(GetConfig());

        //    using (var tx = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
        //    {
        //        var result = await lookUpCode.InsertLookUpCodeAsync(LookUpCodesSuccessObject());

        //        Assert.IsNotNull(result);
        //        Assert.AreEqual(result, true);
        //        Assert.IsInstanceOfType(result, typeof(bool));
        //        tx.Complete();
        //    }
            
        //}
    }
}
