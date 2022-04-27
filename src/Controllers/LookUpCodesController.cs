using System.Collections.Generic;
using System.Threading.Tasks;
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
    public class LookUpcodesController : ControllerBase
    {
        private readonly ILookUpCodes _lookupcodes;

        public LookUpcodesController(ILookUpCodes lookupcodes)
        {
            _lookupcodes = lookupcodes;
        }

        [HttpPut("UpdateLookUpCodeAsync/{Model}")]
        [SwaggerOperation(Summary = "UpdateLookUpCodeAsync - Updates a LookUpCode record into the system", Description = "Returns true if successful ")]
        public async Task<ActionResult<bool>> UpdateLookUpCodeAsync(LookUpCodes model)
        {
            return await _lookupcodes.UpdateLookUpCodeAsync(model);
        }

        [HttpPost("InsertLookUpCodeAsync/{Model}")]
        [SwaggerOperation(Summary = "InsertLookUpCodeAsync - Inserts a LookUpCode record into the system", Description = "Returns true if successful ")]
        public async Task<ActionResult<bool>> InsertLookUpCodeAsync(LookUpCodes model)
        {
            return await _lookupcodes.InsertLookUpCodeAsync(model);
        }

        [Route("GetLookUpCodeByID/{LookupcodeID}")]
        [HttpGet]
        [SwaggerOperation(Summary = "GetLookUpCodeByID - Returns a LookUpCode", Description = "Returns a LookUpCode if successful ")]
        public async Task<ActionResult<LookUpCodes>> GetLookUpCodeByID(int LookupcodeID)
        {
            return await _lookupcodes.GetLookUpCodeByID(LookupcodeID);
        }

        [HttpPut("DeleteLookUpCodeAsync/{Model}")]
        [SwaggerOperation(Summary = "DeleteLookUpCodeAsync - Updates a LookUpCode record into the system", Description = "Returns true if successful ")]
        public async Task<ActionResult<bool>> DeleteLookUpCodeAsync(LookUpCodes model)
        {
            return await _lookupcodes.DeleteLookUpCodeAsync(model);
        }

        [Route("LookUpCodes")]
        [HttpGet]
        [SwaggerOperation(Summary = "Users - Returns Look Up Codes", Description = "Returns Look Up Codes if successful ")]
        public async Task<ActionResult<List<LookupCodeCategoriesModel>>> LookUpCodes(int systemId)
        {
            return await _lookupcodes.GetAllLookUpCodes(systemId);
        }

        [Route("LookUpCodesPerCategory")]
        [HttpGet]
        [SwaggerOperation(Summary = "Users - Returns Look Up Codes Per Category", Description = "Returns Look Up Codes per category if successful ")]
        public async Task<ActionResult<List<LookupCodeCategoriesModel>>> LookUpCodesPerCategory(int LookupcodeCategoryID, int systemId)
        {
            return await _lookupcodes.GetLookUpCodesPerCategory(LookupcodeCategoryID, systemId);
        }

        [Route("GetInventoryByLookUpCodeID/{CustomerID}")]
        [HttpGet]
        [SwaggerOperation(Summary = "Users - Returns Look Up Codes Per Category", Description = "Returns Look Up Codes per category if successful ")]
        public async Task<LookupCodeCategoriesModel> GetInventoryByLookUpCodeID(int CustomerID)
        {
            return await _lookupcodes.GetInventoryByLookUpCodeID(CustomerID);
        }
    }
}
