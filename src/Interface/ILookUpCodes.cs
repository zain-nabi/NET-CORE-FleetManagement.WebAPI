using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Triton.Model.TritonGroup.Custom;
using Triton.Model.TritonGroup.Tables;
using Triton.Service.Model.TritonGroup.Custom;

namespace Triton.FleetManagement.WebApi.Interface
{
    public interface ILookUpCodes
    {
        Task<LookUpCodes> GetLookUpCodeByID(int LookupcodeID);
        Task<bool> UpdateLookUpCodeAsync(LookUpCodes model);
        Task<bool> DeleteLookUpCodeAsync(LookUpCodes model);
        Task<bool> InsertLookUpCodeAsync(LookUpCodes model);
        public Task<List<LookupCodeCategoriesModel>> GetAllLookUpCodes(int systemId);
        public Task<List<LookupCodeCategoriesModel>> GetLookUpCodesPerCategory(int LookupcodeCategoryID, int systemId);
        Task<LookupCodeCategoriesModel> GetInventoryByLookUpCodeID(int CustomerID);
    }
}
