using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Swashbuckle.AspNetCore.Annotations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Triton.FleetManagement.WebApi.Interface;
using Triton.Service.Model.TFFDAT.Tables;

namespace Triton.FleetManagement.WebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ICLOCController : ControllerBase
    {
        private readonly IICLOC _icloc;
        public ICLOCController(IICLOC icloc)
        {
            _icloc = icloc;
        }

        [HttpGet("GetAsync")]
        [SwaggerOperation(Summary = "Gets a list of Locations", Description = "Returns a  list of ICLOC")]
        public async Task<List<ICLOC>> GetAsync()
        {
            return await _icloc.GetAsync();
        }
    }
}
