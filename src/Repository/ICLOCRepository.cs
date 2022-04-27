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
    public class ICLOCRepository : IICLOC
    {
        private readonly IConfiguration _config;
        public ICLOCRepository(IConfiguration configuration)
        {
            _config = configuration;
        }
        public async Task<List<ICLOC>> GetAsync()
        {
            const string sql = "SELECT * FROM ICLOC ORDER BY [LOCATION]";
            await using var connection = DBConnection.GetOpenConnection(_config.GetConnectionString(StringHelpers.Database.TFFDAT));
            return connection.Query<ICLOC>(sql).ToList();
        }
    }
}
