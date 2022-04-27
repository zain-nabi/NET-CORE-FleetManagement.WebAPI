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
    public class ARCUSRepository : IARCUS
    {
        private readonly IConfiguration _config;
        public ARCUSRepository(IConfiguration configuration)
        {
            _config = configuration;
        }

        public async Task<List<ARCUS>> GetAsync()
        {
            const string sql = "SELECT * FROM ARCUS WHERE SWACTV = 1 ORDER BY NAMECUST";
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TFFDAT));
            return connection.Query<ARCUS>(sql).ToList();
        }
    }
}
