using Dapper;
using Dapper.Contrib.Extensions;
using Microsoft.Extensions.Configuration;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using Triton.Core;
using Triton.FleetManagement.WebApi.Interface;
using Triton.Model.TritonGroup.Tables;
using Triton.Service.Model.TritonFleetManagement.Custom;
using Triton.Service.Model.TritonFleetManagement.StoredProcs;
using Triton.Service.Model.TritonFleetManagement.Tables;

namespace Triton.FleetManagement.WebApi.Repository
{
    public class VehicleRepository : IVehicle
    {
        private readonly IConfiguration _config;

        public VehicleRepository(IConfiguration configuration)
        {
            _config = configuration;
        }
        public async Task<List<Customer>> GetAllCustomers()
        {
            string sql = @"SELECT * FROM [TritonFleetManagement].[dbo].[Customer]";
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));
            return connection.Query<Customer>(sql, "").ToList();
        }

        public async Task<List<proc_Vehicle_License_Customer_TailLift_Select>> GetVehicles()
        {
            const string sql = "proc_Vehicle_Select";
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));
            return connection.Query<proc_Vehicle_License_Customer_TailLift_Select>(sql, commandType: CommandType.StoredProcedure).ToList();
        }

        public async Task<proc_Vehicle_License_Customer_TailLift_Select> GetVehicleDetailsByID(int VehicleID)
        {
            const string sql = "proc_VehicleByID_Select";
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));
            return connection.Query<proc_Vehicle_License_Customer_TailLift_Select>(sql, new { VehicleID }, commandType: CommandType.StoredProcedure).FirstOrDefault();
        }

        public async Task<List<proc_Vehicle_License_Customer_TailLift_Select>> GetVehiclesPerCustomer(int? CustomerID, string RegistrationNumber)
        {
            if(CustomerID == 0)
            {
                CustomerID = null;
            }
            const string sql = "proc_VehiclePerCustomer_Select";
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));
            return connection.Query<proc_Vehicle_License_Customer_TailLift_Select>(sql, new { CustomerID, RegistrationNumber }, commandType: CommandType.StoredProcedure).ToList();

        }

        public async Task<Vehicle> CheckIfRegistrationExists(string RegistrationNumber)
        {
            const string sql = "proc_Vehicles_CheckIfRegistrationExist";
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));
            return connection.Query<Vehicle>(sql, new { RegistrationNumber }, commandType: CommandType.StoredProcedure).FirstOrDefault();

        }

        public async Task<List<LookUpCodes>> GetLookUpCodesPerCategory(int LookupcodeCategoryID)
        {
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));
            return connection.Query<LookUpCodes>("proc_LookUpCodes_Select", new { LookupcodeCategoryID }, commandType: CommandType.StoredProcedure).ToList();
        }

        public async Task<bool> InsertVehicleAsync(VehicleModel model)
        {
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));
            DBConnection.GetContextInformationFromConnection(connection, model.Vehicles.CreatedByUserID);
            return connection.Query<bool>("[TritonFleetManagement].[dbo].[proc_Vehicle_Insert]",
                new
                {
                    model.Vehicles.CustomerID,
                    model.Vehicles.RegistrationNumber,
                    model.Vehicles.FleetNumber,
                    model.Vehicles.VinNumber,
                    model.Vehicles.EngineNumber,
                    model.Vehicles.VehicleYear,
                    model.Vehicles.GVM,
                    model.Vehicles.ServiceIntervalLCID,
                    model.Vehicles.TailLift,
                    model.Vehicles.TailLiftTypeLCID,
                    model.Vehicles.VehicleClassLCID,
                    model.Vehicles.VehicleBrandLCID,
                    model.Vehicles.CreatedByUserID,
                    model.Vehicles.CreatedOn,
                    model.Vehicles.DeletedByUserID,
                    model.Vehicles.DeletedOn,
                    model.TailLiftServices.Description,
                    model.TailLiftServices.ServiceDate,
                    model.Licenses.LicenseNumber,
                    model.Licenses.Expiry
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();
        }

        public async Task<bool> UpdateVehicleAsync(proc_Vehicle_Update model)
        {
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));
            var details = GetVehicleDetailsByID(model.VehicleID);
            DBConnection.GetContextInformationFromConnection(connection, details.Result.CreatedByUserID);
            return connection.Query<bool>("[TritonFleetManagement].[dbo].[proc_Vehicle_Update]",
                new
                {
                    model.VehicleID,
                    model.CustomerID,
                    model.RegistrationNumber,
                    model.FleetNumber,
                    model.VinNumber,
                    model.EngineNumber,
                    model.VehicleYear,
                    model.GVM,
                    model.ServiceIntervalLCID,
                    model.TailLift,
                    model.TailLiftTypeLCID,
                    model.VehicleClassLCID,
                    model.VehicleBrandLCID,
                    model.Description,
                    model.ServiceDate,
                    model.LicenseNumber,
                    model.Expiry
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();
        }

        public async Task<bool> DeActivateVehicleAsync(proc_Vehicle_License_Customer_TailLift_Select model)
        {
            try
            {
                await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));
                DBConnection.GetContextInformationFromConnection(connection, model.DeletedByUserID);
                _ = connection.Query<bool>("proc_Vehicle_Delete", new { model.VehicleID, model.DeletedByUserID }, commandType: CommandType.StoredProcedure).FirstOrDefault();

                return true;
            }
            catch
            {
                return false;
            }
        }

        public async Task<bool> ActivateVehicleAsync(proc_Vehicle_License_Customer_TailLift_Select model)
        {
            try
            {
                await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));
                var details = GetVehicleDetailsByID(model.VehicleID);
                DBConnection.GetContextInformationFromConnection(connection, details.Result.CreatedByUserID);
                _ = connection.Query<bool>("proc_Vehicle_ReActivate", new { model.VehicleID }, commandType: CommandType.StoredProcedure).FirstOrDefault();

                return true;
            }
            catch
            {
                return false;
            }
        }

        public async Task<List<VehiclesModel>> GetVehiclesByCustomerIDAsyn(int customerID)
        {
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));

            return connection.Query<VehiclesModel>("proc_Vehicle_GetVehicleByCustomerID", new { @CustomerID = customerID }, commandType: CommandType.StoredProcedure).ToList();
        }

        public async Task<List<VehicleAuditModel>> GetVehicleAuditAsync(int VehicleID)
        {
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));

            return connection.Query<VehicleAuditModel>("proc_VehicleAudit_Select", new { vehicleID = VehicleID }, commandType: CommandType.StoredProcedure).ToList();
        }
    }
}
