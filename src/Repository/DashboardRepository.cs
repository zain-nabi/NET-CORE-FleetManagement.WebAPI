using Dapper;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Triton.Core;
using Triton.FleetManagement.WebApi.Interface;
using Triton.Service.Model.TritonFleetManagement.Custom;

namespace Triton.FleetManagement.WebApi.Repository
{
    public class DashboardRepository : IDashboard
    {
        private readonly IConfiguration _config;

        public DashboardRepository(IConfiguration configuration)
        {
            _config = configuration;
        }

        public async Task<DashboardModel> GetAllAsync(string startDate, string endDate)
        {
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TritonFleetManagement));

            const string sql = "EXEC TritonFleetManagement.dbo.proc_BookingReasons_VehicleRepairsSelect "  +
                               "EXEC TritonFleetManagement.dbo.proc_Bookings_Total_Yesterday_Weekly_Monthly_Select " +
                               "EXEC TritonFleetManagement.dbo.proc_Bookings_GetBarGraphData @startDate, @endDate ";
            var dashboardModel = new DashboardModel();

            using (var multi = connection.QueryMultiple(sql, new { StartDate = startDate, EndDate = endDate }))
            {
                dashboardModel.GeneralRepairsModelList = multi.Read<GeneralRepairsModel>().ToList();
                dashboardModel.BookingsStatisticsModel = multi.Read<BookingsStatisticsModel>().FirstOrDefault();
                dashboardModel.BookingsBarGraphModelList = multi.Read<BookingsBarGraphModel>().ToList();
            }

            return dashboardModel;
        }
    }
}
