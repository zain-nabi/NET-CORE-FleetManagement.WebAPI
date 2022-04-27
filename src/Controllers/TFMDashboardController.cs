using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Swashbuckle.AspNetCore.Annotations;
using Triton.FleetManagement.WebApi.Interface;
using Triton.Service.Model.TritonFleetManagement.Custom;

namespace Triton.FleetManagement.WebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TFMDashboardController : ControllerBase
    {
        private readonly IDashboard _dashboard;

        public TFMDashboardController(IDashboard dashboard)
        {
            _dashboard = dashboard;
        }

        [HttpGet("Dashboard/{startDate}/{endDate}")]
        [SwaggerOperation(Summary = "Returns Dashboard", Description = "Returns Dasboard")]
        public async Task<DashboardModel> Dashboard(string startDate, string endDate)
        {
            return await _dashboard.GetAllAsync(startDate, endDate);
        }
    }
}
