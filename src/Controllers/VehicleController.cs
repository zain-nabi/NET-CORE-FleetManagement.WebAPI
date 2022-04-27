using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Swashbuckle.AspNetCore.Annotations;
using Triton.FleetManagement.WebApi.Interface;
using Triton.Model.TritonGroup.Tables;
using Triton.Service.Model.TritonFleetManagement.Custom;
using Triton.Service.Model.TritonFleetManagement.StoredProcs;
using Triton.Service.Model.TritonFleetManagement.Tables;
using Triton.Service.Model.TritonGroup.Custom;

namespace Triton.FleetManagement.WebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class VehicleController : ControllerBase
    {
        private readonly IVehicle _vehicles;

        public VehicleController(IVehicle vehicles)
        {
            _vehicles = vehicles;
        }

        [Route("Customers")]
        [HttpGet]
        [SwaggerOperation(Summary = "Customers - Returns a customer", Description = "Returns a customer if successful ")]
        public async Task<ActionResult<List<Customer>>> Customers()
        {
            return await _vehicles.GetAllCustomers();
        }

        [Route("Vehicles")]
        [HttpGet]
        [SwaggerOperation(Summary = "Vehicles - Returns a vehicle", Description = "Returns a vehicle if successful ")]
        public async Task<ActionResult<List<proc_Vehicle_License_Customer_TailLift_Select>>> Vehicles()
        {
            return await _vehicles.GetVehicles();
        }

        [Route("VehicleDetails/{VehicleID}")]
        [HttpGet]
        [SwaggerOperation(Summary = "Vehicles - Returns a vehicle", Description = "Returns a vehicle if successful ")]
        public async Task<ActionResult<proc_Vehicle_License_Customer_TailLift_Select>> VehicleDetails(int VehicleID)
        {
            return await _vehicles.GetVehicleDetailsByID(VehicleID);
        }

        [Route("CheckIfRegistrationExists/{RegistrationNumber}")]
        [HttpGet]
        [SwaggerOperation(Summary = "Vehicles - Returns a vehicle", Description = "Returns a vehicle if successful ")]
        public async Task<ActionResult<Vehicle>> CheckIfRegistrationExists(string RegistrationNumber)
        {
            return await _vehicles.CheckIfRegistrationExists(RegistrationNumber);
        }

        [Route("VehiclePerCustomer/{CustomerID}/{RegistrationNumber}")]
        [HttpGet]
        [SwaggerOperation(Summary = "Vehicles - Returns a customer vehicle", Description = "Returns a customer vehicle if successful ")]
        public async Task<ActionResult<List<proc_Vehicle_License_Customer_TailLift_Select>>> VehiclePerCustomer(int? CustomerID, string RegistrationNumber)
        {
            return await _vehicles.GetVehiclesPerCustomer(CustomerID, RegistrationNumber);
        }

        [Route("LookUpCodesPerCategory/{LookupcodeCategoryID}")]
        [HttpGet]
        [SwaggerOperation(Summary = "Users - Returns Look Up Codes Per Category", Description = "Returns Look Up Codes per category if successful ")]
        public async Task<ActionResult<List<LookUpCodes>>> LookUpCodesPerCategory(int LookupcodeCategoryID)
        {
            return await _vehicles.GetLookUpCodesPerCategory(LookupcodeCategoryID);
        }


        [HttpPost("InsertVehicleAsync/{Model}")]
        [SwaggerOperation(Summary = "InsertVehicleAsync - Inserts a vehicle record into the system", Description = "Returns false if successful ")]
        public async Task<ActionResult<bool>> InsertVehicleAsync(VehicleModel model)
        {
            return await _vehicles.InsertVehicleAsync(model);
        }

        [HttpPut("UpdateVehicleAsync/{Model}")]
        [SwaggerOperation(Summary = "UpdateVehicleAsync - Update a vehicle record into the system", Description = "Returns true if successful ")]
        public async Task<ActionResult<bool>> UpdateVehicleAsync(proc_Vehicle_Update model)
        {
            return await _vehicles.UpdateVehicleAsync(model);
        }

        [HttpPut("DeActivateVehicleAsync/{Model}")]
        [SwaggerOperation(Summary = "DeActivateVehicleAsync - Deactivate a vehicle record into the system", Description = "Returns true if successful ")]
        public async Task<ActionResult<bool>> DeActivateVehicleAsync(proc_Vehicle_License_Customer_TailLift_Select model)
        {
            return await _vehicles.DeActivateVehicleAsync(model);
        }

        [HttpPut("ActivateVehicleAsync/{Model}")]
        [SwaggerOperation(Summary = "ActivateVehicleAsync - Activate a vehicle record into the system", Description = "Returns true if successful ")]
        public async Task<ActionResult<bool>> ActivateVehicleAsync(proc_Vehicle_License_Customer_TailLift_Select model)
        {
            return await _vehicles.ActivateVehicleAsync(model);
        }

        [Route("GetVehiclesByCustomerID/{customerID}")]
        [HttpGet]
        [SwaggerOperation(Summary = "GetVehiclesByCustomerID - Returns a vehicle", Description = "Returns a List of Vehicle ")]
        public async Task<ActionResult<List<VehiclesModel>>> GetVehiclesByCustomerID(int customerID)
        {
            return await _vehicles.GetVehiclesByCustomerIDAsyn(customerID);
        }

        [HttpGet("VehicleAudit/{VehicleID}")]
        [SwaggerOperation(Summary = "Returns audit trail", Description = "Get a list of the audit trail")]
        public async Task<List<VehicleAuditModel>> VehicleAudit(int VehicleID)
        {
            return await _vehicles.GetVehicleAuditAsync(VehicleID);
        }
    }
}
