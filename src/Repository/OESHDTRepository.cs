using Dapper;
using Microsoft.Extensions.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Triton.Core;
using Triton.FleetManagement.WebApi.Interface;
using Triton.Service.Model.TFFDAT.Tables;

namespace Triton.FleetManagement.WebApi.Repository
{
    public class OESHDTRepository : IOESHDT
    {
        private readonly IConfiguration _config;
        public OESHDTRepository(IConfiguration configuration)
        {
            _config = configuration;
        }

        public async Task<List<OESHDT>> GetAsync()
        {
            const string sql = "SELECT DISTINCT YR FROM OESHDT ORDER BY YR DESC";
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TFFDAT));
            return connection.Query<OESHDT>(sql).ToList();
        }
    }
}
