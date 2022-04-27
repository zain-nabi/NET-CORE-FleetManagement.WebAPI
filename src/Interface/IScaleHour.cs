using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Triton.Service.Model.TritonFleetManagement.Custom;
using Triton.Service.Model.TritonFleetManagement.Tables;

namespace Triton.FleetManagement.WebApi.Interface
{
    public interface IScaleHour
    {
        Task<bool> InsertScaleHour(ScaleHours model);
        Task<bool> UpdateScaleHour(ScaleHours model);
        Task<List<CostScaleUsersModel>> GetEmployees();
        Task<List<ScaleHoursModel>> GetEmployeesAndScaleHours();
        Task<List<ScaleHoursModel>> GetEmployeesAndScaleHoursByCostScale(int costScale);
        Task<bool> DeleteScaleHour(ScaleHoursModel model);
        Task<ScaleHoursModel> GetEmployeeDetailsByID(int employeeID);
        Task<ScaleHours> CheckIfEmployeeScaleHourExists(int employeeID, int scaleHour);
        Task<List<ScaleHourAuditModel>> GetScaleHourAuditAsync(int EmployeeID);
    }
}
