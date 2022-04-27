using System.Collections.Generic;
using System.Threading.Tasks;
using Triton.Model.TritonGroup.Tables;
using Triton.Service.Model.TritonFleetManagement.Custom;
using Triton.Service.Model.TritonFleetManagement.StoredProcs;
using Triton.Service.Model.TritonFleetManagement.Tables;

namespace Triton.FleetManagement.WebApi.Interface
{
    public interface IVehicle
    {
        Task<List<Customer>> GetAllCustomers();
        Task<List<proc_Vehicle_License_Customer_TailLift_Select>> GetVehicles();
        Task<List<proc_Vehicle_License_Customer_TailLift_Select>> GetVehiclesPerCustomer(int? CustomerID, string RegistrationNumber);
        Task<proc_Vehicle_License_Customer_TailLift_Select> GetVehicleDetailsByID(int VehicleID);
        Task<Vehicle> CheckIfRegistrationExists(string RegistrationNumber);
        Task<List<LookUpCodes>> GetLookUpCodesPerCategory(int LookupcodeCategoryID);
        Task<bool> InsertVehicleAsync(VehicleModel model);
        Task<bool> UpdateVehicleAsync(proc_Vehicle_Update model);
        Task<bool> DeActivateVehicleAsync(proc_Vehicle_License_Customer_TailLift_Select model);
        Task<bool> ActivateVehicleAsync(proc_Vehicle_License_Customer_TailLift_Select model);
        Task<List<VehiclesModel>> GetVehiclesByCustomerIDAsyn(int customerID);
        Task<List<VehicleAuditModel>> GetVehicleAuditAsync(int VehicleID);
    }
}
