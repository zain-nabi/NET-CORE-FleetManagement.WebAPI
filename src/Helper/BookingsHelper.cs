using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Triton.Service.Model.TritonFleetManagement.Custom;
using Triton.Service.Model.TritonFleetManagement.Tables;

namespace Triton.FleetManagement.WebApi.Helper
{
    public class BookingsHelper
    {

        public PartReasonViewModel GetPartsByCategory(PartReasonViewModel InventoryCustoModelList)
        {
            var PartReasonViewModel = new PartReasonViewModel();
            var partModel = new PartReasonViewModel();
            var outWorksCommission = new OutworksCommission();

            partModel.InventoryCustoModelList = InventoryCustoModelList.InventoryCustoModelList;

            foreach (var item in InventoryCustoModelList.InventoryCustoModelList)
            {
                if (item.CategoryLCID == 701)
                {
                    PartReasonViewModel.PartReasonsList = partModel.InventoryCustoModelList.Where(x => x.CategoryLCID == 701).ToList();
                }
                if (item.CategoryLCID == 703)
                {
                    PartReasonViewModel.LabourReasonList = partModel.InventoryCustoModelList.Where(x => x.CategoryLCID == 703).ToList();
                }
                if (item.CategoryLCID == 705)
                {
                    PartReasonViewModel.ConsumableReasonList = partModel.InventoryCustoModelList.Where(x => x.CategoryLCID == 705).ToList();
                }
                if (item.CategoryLCID == 704)
                {
                    PartReasonViewModel.TyreReasonList = partModel.InventoryCustoModelList.Where(x => x.CategoryLCID == 704).ToList();
                }
            }
            PartReasonViewModel.OutworksCommission = InventoryCustoModelList.OutworksCommission;
            return PartReasonViewModel;
        }
    }
}
