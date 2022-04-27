using System.Collections.Generic;
using System.Threading.Tasks;
using Triton.Service.Model.TFFDAT.Tables;

namespace Triton.FleetManagement.WebApi.Interface
{
    public interface IICCATG
    {
        Task<List<ICCATG>> GetAsync();
    }
}
