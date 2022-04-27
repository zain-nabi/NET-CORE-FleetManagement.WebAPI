using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Triton.Model.LeaveManagement.Tables;
using Triton.Service.Model.TritonFleetManagement.Custom;
using Triton.Service.Model.TritonFleetManagement.StoredProcs;
using Triton.Service.Model.TritonFleetManagement.Tables;

namespace Triton.FleetManagement.WebApi.Interface
{
    public interface IBookings
    {
        Task<BookingsModel> LookUpCodesAsync(int customerID);
        Task<List<BookingsModel>> GetAllAsync();
        Task<BookingsModel> GetByIdAsync(int bookingsID);
        Task<bool> DeleteAsync(Bookings bookings);
        Task<bool> InsertAsync(BookingsModel bookingsModel);
        Task<bool> UpdateAsync(BookingsModel bookingsModel);
        Task<List<BookingsModel>> GetBookingsByEstimatedDateAsync(DateTime estimatedArrivalDateFrom, DateTime estimatedArrivalDateTo);
        Task<List<proc_VendorCodes_String_Agg>> GetVendorCodesPerCustomer();
        Task<List<CustomersModels>> GetAllCustomersAsync();
        Task<List<Employees>> GetAllMechanics();
        Task<List<proc_Bookings_BookingReasons_Customers_Select>> GetBookingsPerCustomer(int CustomerID, DateTime startDate, DateTime endDate);
        Task<proc_Bookings_BookingReasons_Customers_Select> GetBookingReasonsPerJobCard(int bookingsID);
        Task<proc_BookingDetails_GetByID> GetBookingDetailsByID(int BookingsID);
        Task<bool> DeleteBooking(proc_BookingDetails_GetByID model);
        Task<proc_BookingDetails_GetByID> CheckIfBookingExist(int CustomerID, int VehicleID, string EstimatedArrivalDate);
        Task<bool> InsertDocumentRepositoryAsync(DocumentRepository documentRepository,int bookingId);
        Task<List<DocumentVehicleModel>> GetAllDocuments(int bookingId);
        Task<bool> DeleteDocument(int vehicleDocumentID, int deletedByUserID);
        Task<List<BookingAuditModel>> GetBookingAuditAsync(int BookingID);
        Task<bool> UpdatePartReasons(BookingsModel model);
        Task<List<PartReason>> GetPartsPerBooking(int BookingID);
        Task<bool> InsertPartsBookingReasonAndOutworksCommissionAsync(BookingsModel bookingsModel);

        Task<bool>  UpdatePartsBookingReasonAndOutworksCommissionAsync(BookingsModel bookingsModel);
        Task<proc_BookingDetails_GetByID> GetBookingDetailsByCustomerID(int BookingsID);
        Task<PartReasonViewModel> GetInventoryByBookingID(int BookingsID);
    }
}
