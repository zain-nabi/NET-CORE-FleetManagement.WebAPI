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
    public class ARCUSController : ControllerBase
    {
        private readonly IARCUS _iarcus;
        public ARCUSController(IARCUS iarcus)
        {
            _iarcus = iarcus;
        }

        [HttpGet("GetAsync")]
        [SwaggerOperation(Summary = "Gets a list of Customers", Description = "Returns a  list of ARCUS")]
        public async Task<List<ARCUS>> GetAsync()
        {
            return await _iarcus.GetAsync();
        }
    }
}
