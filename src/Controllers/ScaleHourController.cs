using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Swashbuckle.AspNetCore.Annotations;
using Triton.FleetManagement.WebApi.Interface;
using Triton.Service.Model.TritonFleetManagement.Custom;
using Triton.Service.Model.TritonFleetManagement.Tables;

namespace Triton.FleetManagement.WebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ScaleHourController : ControllerBase
    {
        private readonly IScaleHour _scaleHour;

        public ScaleHourController(IScaleHour scaleHour)
        {
            _scaleHour = scaleHour;
        }

        [Route("GetEmployeesAndScaleHours")]
        [HttpGet]
        [SwaggerOperation(Summary = "GetEmployeesAndScaleHours - Returns employees and cost scale", Description = "Returns an employee if successful ")]
        public async Task<ActionResult<List<ScaleHoursModel>>> GetEmployeesAndScaleHours()
        {
            return await _scaleHour.GetEmployeesAndScaleHours();
        }

        [Route("GetEmployees")]
        [HttpGet]
        [SwaggerOperation(Summary = "GetEmployees - Returns employees", Description = "Returns employees if successful ")]
        public async Task<ActionResult<List<CostScaleUsersModel>>> GetEmployees()
        {
            return await _scaleHour.GetEmployees();
        }

        [Route("GetEmployeesAndScaleHoursByCostScale/{costScale}")]
        [HttpGet]
        [SwaggerOperation(Summary = "GetEmployees - Returns employees by cost scale", Description = "Returns employees if successful ")]
        public async Task<ActionResult<List<ScaleHoursModel>>> GetEmployeesAndScaleHoursByCostScale(int costScale)
        {
            return await _scaleHour.GetEmployeesAndScaleHoursByCostScale(costScale);
        }

        [Route("GetEmployeeDetailsByID/{employeeID}")]
        [HttpGet]
        [SwaggerOperation(Summary = "GetEmployees - Returns employees by ID", Description = "Returns employees if successful ")]
        public async Task<ActionResult<ScaleHoursModel>> GetEmployeeDetailsByID(int employeeID)
        {
            return await _scaleHour.GetEmployeeDetailsByID(employeeID);
        }

        [HttpPost("InsertScaleHour/{Model}")]
        [SwaggerOperation(Summary = "InsertScaleHour - Inserts a cost scale record into the system", Description = "Returns true/false")]
        public async Task<ActionResult<bool>> InsertScaleHour(ScaleHours model)
        {
            return await _scaleHour.InsertScaleHour(model);
        }

        [HttpPut("UpdateScaleHour/{Model}")]
        [SwaggerOperation(Summary = "UpdateScaleHour - Updates a cost scale record into the system", Description = "Returns true/false")]
        public async Task<ActionResult<bool>> UpdateScaleHour(ScaleHours model)
        {
            return await _scaleHour.UpdateScaleHour(model);
        }

        [HttpPut("DeleteScaleHour/{Model}")]
        [SwaggerOperation(Summary = "DeleteScaleHour - Delete a cost scale record into the system", Description = "Returns true/false")]
        public async Task<ActionResult<bool>> DeleteScaleHour(ScaleHoursModel model)
        {
            return await _scaleHour.DeleteScaleHour(model);
        }

        [Route("CheckIfEmployeeScaleHourExists/{employeeID}/{scaleHour}")]
        [HttpGet]
        [SwaggerOperation(Summary = "CheckIfEmployeeScaleHourExists - Checks employees scale hours per ID", Description = "Returns true/false if successful ")]
        public async Task<ActionResult<ScaleHours>> CheckIfEmployeeScaleHourExists(int employeeID, int scaleHour)
        {
            return await _scaleHour.CheckIfEmployeeScaleHourExists(employeeID, scaleHour);
        }

        [HttpGet("ScaleHourAudit/{EmployeeID}")]
        [SwaggerOperation(Summary = "Returns audit trail", Description = "Get a list of the audit trail")]
        public async Task<List<ScaleHourAuditModel>> ScaleHourAudit(int EmployeeID)
        {
            return await _scaleHour.GetScaleHourAuditAsync(EmployeeID);
        }
    }
}
