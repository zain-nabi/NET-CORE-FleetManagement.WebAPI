using System.Collections.Generic;
using System.Threading.Tasks;
using Triton.Model.TritonGroup.Custom;
using Triton.Model.TritonGroup.Tables;
using Triton.Service.Model.TritonGroup.Custom;

namespace Triton.FleetManagement.WebApi.Interface
{
    public interface ILookUpCodeCategories
    {
        public Task<List<LookupCodeCategoriesModel>> GetLookUpCodeCategories(int systemId);
        Task<bool> UpdateLookUpCodeCategoryAsync(LookupCodeCategories model);
        Task<LookupCodeCategories> GetLookUpCodeCategoryByID(int LookupcodeCategoryID);
    }
}
