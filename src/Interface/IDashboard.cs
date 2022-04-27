using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Triton.Service.Model.TritonFleetManagement.Custom;

namespace Triton.FleetManagement.WebApi.Interface
{
    public interface IDashboard
    {
        Task<DashboardModel> GetAllAsync(string startDate, string endDate);
    }
}
