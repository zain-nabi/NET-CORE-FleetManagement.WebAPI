using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Swashbuckle.AspNetCore.Annotations;
using Triton.FleetManagement.WebApi.Interface;
using Triton.Model.TritonGroup.Custom;
using Triton.Model.TritonGroup.Tables;
using Triton.Service.Model.TritonGroup.Custom;

namespace Triton.FleetManagement.WebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LookUpCodeCategoriesController : ControllerBase
    {
        private readonly ILookUpCodeCategories _lookupcodecategories;

        public LookUpCodeCategoriesController(ILookUpCodeCategories lookupcodecategories)
        {
            _lookupcodecategories = lookupcodecategories;
        }

        [Route("LookUpCodeCategories")]
        [HttpGet]
        [SwaggerOperation(Summary = "Look up code categories - Returns LookUpCodeCategories", Description = "Returns look up code categories if successful ")]
        public async Task<ActionResult<List<LookupCodeCategoriesModel>>> Lookupcodecategories(int systemId)
        {
            return await _lookupcodecategories.GetLookUpCodeCategories(systemId);
        }

        [HttpPut("UpdateLookUpCodeCategoryAsync/{Model}")]
        [SwaggerOperation(Summary = "UpdateLookUpCodeAsync - Updates a LookUpCodeCategory record into the system", Description = "Returns true if successful ")]
        public async Task<ActionResult<bool>> UpdateLookUpCodeCategoryAsync(LookupCodeCategories model)
        {
            return await _lookupcodecategories.UpdateLookUpCodeCategoryAsync(model);
        }

        [Route("GetLookUpCodeCategoryByID/{LookupcodeCategoryID}")]
        [HttpGet]
        [SwaggerOperation(Summary = "GetLookUpCodeByID - Returns a LookUpCodeCategory", Description = "Returns a LookUpCodeCategory if successful ")]
        public async Task<ActionResult<LookupCodeCategories>> GetLookUpCodeCategoryByID(int LookupcodeCategoryID)
        {
            return await _lookupcodecategories.GetLookUpCodeCategoryByID(LookupcodeCategoryID);
        }
    }
}
