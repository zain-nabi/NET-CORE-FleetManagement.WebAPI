using Dapper;
using Dapper.Contrib.Extensions;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using System.Transactions;
using Triton.Core;
using Triton.FleetManagement.WebApi.Interface;
using Triton.Service.Model.TritonFleetManagement.Custom;
using Triton.Service.Model.TritonFleetManagement.Tables;

namespace Triton.FleetManagement.WebApi.Repository
{
    public class ScaleHourRepository : IScaleHour
    {
        private readonly IConfiguration _config;

        public ScaleHourRepository(IConfiguration configuration)
        {
            _config = configuration;
        }

        public async Task<bool> InsertScaleHour(ScaleHours model)
        {
            try
            {
                await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));
                DBConnection.GetContextInformationFromConnection(connection, model.CreatedByUserID);
                _ = connection.Query<bool>("[TritonFleetManagement].[dbo].[proc_ScaleHours_Insert_RemoveDuplicateEmployee]",
                    new
                    {
                        model.EmployeeID,
                        model.CostScaleHour,
                        model.CreatedOn,
                        model.CreatedByUserID
                    },
                    commandType: CommandType.StoredProcedure).FirstOrDefault();

                return true;
            }
            catch //(Exception e)
            {
                // Log error
                return false;
            }
        }

        public async Task<bool> UpdateScaleHour(ScaleHours model)
        {
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));
            var details = GetEmployeesAndScaleHours();
            DBConnection.GetContextInformationFromConnection(connection, details.Result.ToList().Where(x => x.ScaleHourID == model.ScaleHourID).Select(x=> x.CreatedByUserID).FirstOrDefault());
            return connection.Query<bool>("[TritonFleetManagement].[dbo].[proc_ScaleHours_Update]",
                new
                {
                    model.ScaleHourID,
                    model.CostScaleHour
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();
        }

        public async Task<List<CostScaleUsersModel>> GetEmployees()
        {
            const string sql = "proc_ScaleHour_Users_Select";
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));
            return connection.Query<CostScaleUsersModel>(sql, commandType: CommandType.StoredProcedure).ToList();
        }

        public async Task<List<ScaleHoursModel>> GetEmployeesAndScaleHours()
        {
            const string sql = "proc_ScaleHour_UsersandScaleHour_Select";
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));
            return connection.Query<ScaleHoursModel>(sql, commandType: CommandType.StoredProcedure).ToList();
        }

        public async Task<List<ScaleHoursModel>> GetEmployeesAndScaleHoursByCostScale(int costScale)
        {
            const string sql = "proc_ScaleHour_ScaleHoursByCostScale_Select";
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));
            return connection.Query<ScaleHoursModel>(sql, new { costScale }, commandType: CommandType.StoredProcedure).ToList();
        }

        public async Task<bool> DeleteScaleHour(ScaleHoursModel model)
        {
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));
            DBConnection.GetContextInformationFromConnection(connection, model.CreatedByUserID);
            return connection.Query<bool>("[TritonFleetManagement].[dbo].[proc_ScaleHour_Delete]",
                new
                {
                    model.ScaleHourID,
                    model.EmployeeID,
                    model.CostScaleHour,
                    model.CreatedOn,
                    model.CreatedByUserID,
                    model.DeletedByUserID
                },
                commandType: CommandType.StoredProcedure).FirstOrDefault();
        }

        public async Task<ScaleHoursModel> GetEmployeeDetailsByID(int employeeID)
        {
            const string sql = "proc_ScaleHour_ScaleHoursbyEmployeeID_Select";
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));
            return connection.Query<ScaleHoursModel>(sql, new { employeeID }, commandType: CommandType.StoredProcedure).FirstOrDefault();
        }

        public async Task<ScaleHours> CheckIfEmployeeScaleHourExists(int employeeID, int scaleHour)
        {
            const string sql = "[TritonFleetManagement].[dbo].[proc_ScaleHour_CheckIfEmployeeScaleHourExists]";
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));
            return connection.Query<ScaleHours>(sql, new { employeeID, scaleHour }, commandType: CommandType.StoredProcedure).FirstOrDefault();
        }

        public async Task<List<ScaleHourAuditModel>> GetScaleHourAuditAsync(int EmployeeID)
        {
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));

            return connection.Query<ScaleHourAuditModel>("proc_ScaleHourAudit_Select", new { employeeID = EmployeeID }, commandType: CommandType.StoredProcedure).ToList();
        }
    }
}
