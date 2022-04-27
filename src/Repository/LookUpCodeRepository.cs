using Dapper;
using Dapper.Contrib.Extensions;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Transactions;
using Triton.Core;
using Triton.FleetManagement.WebApi.Interface;
using Triton.Model.TritonGroup.Custom;
using Triton.Model.TritonGroup.Tables;
using Triton.Service.Model.TritonFleetManagement.Custom;
using Triton.Service.Model.TritonGroup.Custom;

namespace Triton.FleetManagement.WebApi.Repository
{
    public class LookUpCodeRepository : ILookUpCodes
    {
        private readonly IConfiguration _config;

        public LookUpCodeRepository(IConfiguration configuration)
        {
            _config = configuration;
        }

        public async Task<LookUpCodes> GetLookUpCodeByID(int LookupcodeID)
        {
            string sql = @"SELECT * FROM [TritonGroup].[dbo].[LookUpCodes]
                                WHERE [TritonGroup].[dbo].[LookUpCodes].[LookupcodeID] = @LookupcodeID";

            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonGroup));

            return connection.Query<LookUpCodes>(sql, new { LookupcodeID }).FirstOrDefault();
        }

        public async Task<bool> UpdateLookUpCodeAsync(LookUpCodes model)
        {
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonGroup));
            return await connection.UpdateAsync(model);
        }

        public async Task<bool> InsertLookUpCodeAsync(LookUpCodes model)
        {
            //await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonGroup));
            //return await connection.InsertAsync(model);

            try
            {
                // Scope transaction
                using var scope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
                // Set the connection
                await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonGroup));
                _ = await connection.InsertAsync(model);

                // Save the record
                scope.Complete();

                // Return success
                return true;
            }
            catch //(Exception e)
            {
                // Log error
                return false;
            }
        }

        public async Task<bool> DeleteLookUpCodeAsync(LookUpCodes model)
        {
            try
            {
                await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonGroup));
                var LookUpCode = await GetLookUpCodeByID(Convert.ToInt32(model.LookUpCodeID));
                LookUpCode.DeletedByUserID = model.CreatedByUserID;
                LookUpCode.DeletedOn = System.DateTime.Now;

                _ = await connection.UpdateAsync(LookUpCode);
                return true;
            }
            catch// (Exception)
            {
                return false;
            }
        }

        public async Task<List<LookupCodeCategoriesModel>> GetAllLookUpCodes(int systemId)
        {
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonGroup));
            string sql = @"proc_LookupcodeCategory_GetAllLookUpCodes @SystemID";

            var LookupCodeCategoriesModel = new List<LookupCodeCategoriesModel>();

            var data = connection.Query<LookUpCodes, LookupCodeCategories, Model.TritonSecurity.Tables.Users, List<LookupCodeCategoriesModel>>(
                 sql, (LookUpCodes, LookupCodeCategories, Users) =>
                 {
                     var model = new LookupCodeCategoriesModel
                     {
                         LookUpCodes = LookUpCodes,
                         LookUpCodeCategories = LookupCodeCategories,
                         Users = Users,
                     };

                     LookupCodeCategoriesModel.Add(model);
                     return LookupCodeCategoriesModel;
                 },
                 new { SystemID = systemId },
                 splitOn: "LookupcodeID, LookupcodeCategoryID, UserID").FirstOrDefault();

            return data == null ? new List<LookupCodeCategoriesModel>() : data;

        }

        public async Task<List<LookupCodeCategoriesModel>> GetLookUpCodesPerCategory(int LookupcodeCategoryID, int systemId)
        {
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonGroup));
            string sql = "proc_LookupcodeCategory_GetLookUpCodesPerCategory @SystemID, @LookupcodeCategoryID";

            var LookupCodeCategoriesModel = new List<LookupCodeCategoriesModel>();

            var data = connection.Query<LookUpCodes, LookupCodeCategories, Model.TritonSecurity.Tables.Users, List<LookupCodeCategoriesModel>>(
                 sql, (LookUpCodes, LookupCodeCategories, Users) =>
                 {
                     var model = new LookupCodeCategoriesModel
                     {
                         LookUpCodes = LookUpCodes,
                         LookUpCodeCategories = LookupCodeCategories,
                         Users = Users,
                     };

                     LookupCodeCategoriesModel.Add(model);
                     return LookupCodeCategoriesModel;
                 },
                 new { SystemID = systemId, LookupcodeCategoryID = LookupcodeCategoryID },
                 splitOn: "LookupcodeID, LookupcodeCategoryID, UserID").FirstOrDefault();

            return data == null ? new List<LookupCodeCategoriesModel>() : data;

        }


        public async Task<LookupCodeCategoriesModel> GetInventoryByLookUpCodeID(int CustomerID)
        {
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));
            var bookingModel = new LookupCodeCategoriesModel();

            var query = string.Format(@" 
                                        EXEC [TritonFleetManagement].[dbo].[proc_InventoryByLookUpCode_Select] @CustomerID
                                        "
                                     );
            using (var multi = connection.QueryMultiple(query, new { CustomerID }))
            {
                bookingModel.PartsConsumablesLaboutLookUpCodes = multi.Read<LookUpCodes>().ToList();

            }
            return bookingModel;
        }

    }
}
