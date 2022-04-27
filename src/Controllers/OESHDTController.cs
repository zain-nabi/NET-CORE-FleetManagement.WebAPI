using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Swashbuckle.AspNetCore.Annotations;
using Triton.FleetManagement.WebApi.Interface;
using Triton.Service.Model.TFFDAT.Tables;

namespace Triton.FleetManagement.WebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class OESHDTController : ControllerBase
    {
        private readonly IOESHDT _ioeshdt;
        public OESHDTController(IOESHDT ioeshdt)
        {
            _ioeshdt = ioeshdt;
        }

        [HttpGet("GetAsync")]
        [SwaggerOperation(Summary = "Gets a list of OESHDT", Description = "Returns a  list of OESHDT")]
        public async Task<List<OESHDT>> GetAsync()
        {
            return await _ioeshdt.GetAsync();
        }
    }
}
