using Dapper;
using Dapper.Contrib.Extensions;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Triton.Core;
using Triton.FleetManagement.WebApi.Interface;
using Triton.Model.TritonGroup.Custom;
using Triton.Model.TritonGroup.Tables;
using Triton.Service.Model.TritonGroup.Custom;

namespace Triton.FleetManagement.WebApi.Repository
{
    public class LookUpCodeCategoriesRepository : ILookUpCodeCategories
    {
        private readonly IConfiguration _config;
        
        public LookUpCodeCategoriesRepository(IConfiguration configuration)
        {
            _config = configuration;
        }


        public async Task<List<LookupCodeCategoriesModel>> GetLookUpCodeCategories(int systemId)
        {

            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonGroup));
            string sql = @"proc_LookupcodeCategory_GetBySystemID @SystemID ";

            var LookupCodeCategoriesModel = new List<LookupCodeCategoriesModel>();

            var data = connection.Query<LookupCodeCategories, Model.TritonSecurity.Tables.Users, List<LookupCodeCategoriesModel>>(
                 sql, (LookupCodeCategories, Users) =>
                 {
                     var model = new LookupCodeCategoriesModel
                     {
                         LookUpCodeCategories = LookupCodeCategories,
                         Users = Users,
                     };

                     LookupCodeCategoriesModel.Add(model);
                     return LookupCodeCategoriesModel;
                 },
                  new { SystemID = systemId },
                 splitOn: "LookupcodeCategoryID, UserID").FirstOrDefault();

            return data == null ? new List<LookupCodeCategoriesModel>() : data;

        }

        public async Task<bool> UpdateLookUpCodeCategoryAsync(LookupCodeCategories model)
        {
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonGroup));
            return await connection.UpdateAsync(model);
        }

        public async Task<LookupCodeCategories> GetLookUpCodeCategoryByID(int LookupcodeCategoryID)
        {
            string sql = @"SELECT * FROM [TritonGroup].[dbo].[LookupcodeCategories]
                                WHERE [TritonGroup].[dbo].[LookupcodeCategories].[LookupcodeCategoryID] = @LookupcodeCategoryID";

            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonGroup));

            return connection.Query<LookupCodeCategories>(sql, new { LookupcodeCategoryID }).FirstOrDefault();
        }
    }
}
