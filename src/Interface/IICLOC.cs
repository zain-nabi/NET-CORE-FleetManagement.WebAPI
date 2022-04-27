using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Triton.Service.Model.TFFDAT.Tables;

namespace Triton.FleetManagement.WebApi.Interface
{
    public interface IICLOC
    {
        Task<List<ICLOC>> GetAsync();
    }
}
