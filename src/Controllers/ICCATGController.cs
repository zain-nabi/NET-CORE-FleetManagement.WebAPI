using Microsoft.AspNetCore.Mvc;
using Swashbuckle.AspNetCore.Annotations;
using System.Collections.Generic;
using System.Threading.Tasks;
using Triton.FleetManagement.WebApi.Interface;
using Triton.Service.Model.TFFDAT.Tables;

namespace Triton.FleetManagement.WebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ICCATGController : ControllerBase
    {
        private readonly IICCATG _iccatg;
        public ICCATGController(IICCATG iccatg)
        {
            _iccatg = iccatg;
        }

        [HttpGet("GetAsync")]
        [SwaggerOperation(Summary = "Gets a list of Categories", Description = "Returns a  list of ICCATG")]
        public async Task<List<ICCATG>> GetAsync()
        {
            return await _iccatg.GetAsync();
        }
    }
}
