using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Swashbuckle.AspNetCore.Annotations;
using Triton.FleetManagement.WebApi.Interface;
using Triton.Model.LeaveManagement.Tables;
using Triton.Service.Model.TritonFleetManagement.Custom;
using Triton.Service.Model.TritonFleetManagement.StoredProcs;
using Triton.Service.Model.TritonFleetManagement.Tables;

namespace Triton.FleetManagement.WebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BookingsController : ControllerBase
    {
        private readonly IBookings _bookings;
        public BookingsController(IBookings bookings)
        {
            _bookings = bookings;
        }

        [HttpGet("Bookings/LookUpCodes")]
        [SwaggerOperation(Summary = "Get List of LookUpCodes", Description = "Get List of LookUpCodes")]
        public async Task<BookingsModel> LookUpCodes(int customerID = 0)
        {
            return await _bookings.LookUpCodesAsync(customerID);
        }

        [HttpGet("Bookings")]
        [SwaggerOperation(Summary = "Get List of BookingsModel", Description = "Get List of BookingsModel")]
        public async Task<List<BookingsModel>> GetAsync()
        {
            return await _bookings.GetAllAsync();
        }

        [HttpGet("Bookings{bookingsID:int}")]
        [SwaggerOperation(Summary = "GetBookingsID - Gets a single Bookings by BookingsID", Description = "Returns the Bookings object")]
        public async Task<ActionResult<BookingsModel>> GetByIdAsync(int bookingsID)
        {
            return await _bookings.GetByIdAsync(bookingsID);
        }

        [HttpPost("Bookings")]
        [SwaggerOperation(Summary = "Post - Inserts the Bookings table", Description = "Returns a new Entry")]
        public async Task<ActionResult<bool>> InsertAsync(BookingsModel bookingsModel)
        {
            return await _bookings.InsertAsync(bookingsModel);
        }

        [HttpPut("Bookings")]
        [SwaggerOperation(Summary = "Put - Updates the Bookings table", Description = "Returns a bool")]
        public async Task<ActionResult<bool>> UpdateAsync(BookingsModel bookingsModel)
        {
            return await _bookings.UpdateAsync(bookingsModel);
        }

        [HttpPut("Bookings/Delete")]
        [SwaggerOperation(Summary = "Put - Delete the Bookings table", Description = "Returns a bool")]
        public async Task<ActionResult<bool>> DeleteAsync(Bookings customer)
        {
            return await _bookings.DeleteAsync(customer);
        }

        [HttpGet("Bookings/GetBookingsByEstimatedDateAsync")]
        [SwaggerOperation(Summary = "Get List of BookingsModel By Date", Description = "Get List of BookingsModel By Date")]
        public async Task<List<BookingsModel>> GetBookingsByEstimatedDateAsync(DateTime estimatedArrivalDateFrom, DateTime estimatedArrivalDateTo)
        {
            return await _bookings.GetBookingsByEstimatedDateAsync(estimatedArrivalDateFrom, estimatedArrivalDateTo);
        }

        [Route("VendorCodesPerCustomer")]
        [HttpGet]
        [SwaggerOperation(Summary = "VendorCodesPerCustomer - Returns vendor codes per customer", Description = "Returns true if successful ")]
        public async Task<ActionResult<List<proc_VendorCodes_String_Agg>>> VendorCodesPerCustomer()
        {
            return await _bookings.GetVendorCodesPerCustomer();
        }

        [Route("GetAllCustomersAsync")]
        [HttpGet]
        [SwaggerOperation(Summary = "GetAllCustomersAsync - Returns customers who has vehicles", Description = "Returns true if successful ")]
        public async Task<ActionResult<List<CustomersModels>>> GetAllCustomersAsync()
        {
            return await _bookings.GetAllCustomersAsync();
        }

        [Route("GetAllMechanics")]
        [HttpGet]
        [SwaggerOperation(Summary = "GetAllMechanics - Returns employees who are mechanics", Description = "Returns true if successful ")]
        public async Task<ActionResult<List<Employees>>> GetAllMechanics()
        {
            return await _bookings.GetAllMechanics();
        }

        [Route("GetBookingReasonsPerJobCard/{bookingsID}")]
        [HttpGet]
        [SwaggerOperation(Summary = "GetBookingReasonsPerJobCard - Returns bookings per customer", Description = "Returns true if successful ")]
        public async Task<ActionResult<proc_Bookings_BookingReasons_Customers_Select>> GetBookingReasonsPerJobCard(int bookingsID)
        {
            return await _bookings.GetBookingReasonsPerJobCard(bookingsID);
        }

        [Route("GetBookingsPerCustomer/{CustomerID}/{startDate}/{endDate}")]
        [HttpGet]
        [SwaggerOperation(Summary = "GetBookingsPerCustomer - Returns bookings per customer", Description = "Returns true if successful ")]
        public async Task<ActionResult<List<proc_Bookings_BookingReasons_Customers_Select>>> GetBookingsPerCustomer(int CustomerID, DateTime startDate, DateTime endDate)
        {
            return await _bookings.GetBookingsPerCustomer(CustomerID, startDate, endDate);
        }

        [Route("GetBookingDetailsByCustomerID/{CustomerID}")]
        [HttpGet]
        [SwaggerOperation(Summary = "GetBookingDetailsByID - Returns bookings per ID", Description = "Returns true if successful ")]
        public async Task<ActionResult<proc_BookingDetails_GetByID>> GetBookingDetailsByCustomerID(int CustomerID)
        {
            return await _bookings.GetBookingDetailsByCustomerID(CustomerID);
        }

        [Route("GetBookingDetailsByID/{BookingsID}")]
        [HttpGet]
        [SwaggerOperation(Summary = "GetBookingDetailsByID - Returns bookings per ID", Description = "Returns true if successful ")]
        public async Task<ActionResult<proc_BookingDetails_GetByID>> GetBookingDetailsByID(int BookingsID)
        {
            return await _bookings.GetBookingDetailsByID(BookingsID);
        }

        [Route("CheckIfBookingExist/{CustomerID}/{VehicleID}/{EstimatedArrivalDate}")]
        [HttpGet]
        [SwaggerOperation(Summary = "CheckIfBookingExist - Checks bookings per ID", Description = "Returns true/false if successful ")]
        public async Task<ActionResult<proc_BookingDetails_GetByID>> CheckIfBookingExist(int CustomerID, int VehicleID, string EstimatedArrivalDate)
        {
            return await _bookings.CheckIfBookingExist(CustomerID, VehicleID, EstimatedArrivalDate);
        }

        [HttpPut("DeleteBooking/{Model}")]
        [SwaggerOperation(Summary = "DeleteBooking - Update a booking record", Description = "Returns true if successful ")]
        public async Task<ActionResult<bool>> DeleteBooking(proc_BookingDetails_GetByID model)
        {
            return await _bookings.DeleteBooking(model);
        }

        [HttpPost("Bookings/InsertDocumentRepositoryAsync")]
        [SwaggerOperation(Summary = "Post - Inserts the DocumentRepository table", Description = "Returns a new Entry")]
        public async Task<bool> InsertDocumentRepositoryAsync(DocumentRepository documentRepository, int bookingId)
        {
            return await _bookings.InsertDocumentRepositoryAsync(documentRepository, bookingId);
        }

        [HttpGet("Bookings/GetAllDocuments")]
        [SwaggerOperation(Summary = "Get List of Document Repository", Description = "Get List of Repository")]
        public async Task<List<DocumentVehicleModel>> GetAllDocuments(int bookingId)
        {
            return await _bookings.GetAllDocuments(bookingId);
        }

        [HttpPut("Bookings/DeleteDocument")]
        [SwaggerOperation(Summary = "Put - Delete the Document Repository table", Description = "Returns a bool")]
        public async Task<ActionResult<bool>> DeleteDocumentAsync(DocumentVehicleModel documentVehicleModel)
        {
            return await _bookings.DeleteDocument(documentVehicleModel.VehicleDocumentID,1);
        }

        [HttpGet("BookingAudit/{BookingID}")]
        [SwaggerOperation(Summary = "Returns audit trail", Description = "Get a list of the audit trail")]
        public async Task<List<BookingAuditModel>> BookingAudit(int BookingID)
        {
            return await _bookings.GetBookingAuditAsync(BookingID);
        }

        [HttpPost("InsertPartReasons/{Model}")]
        [SwaggerOperation(Summary = "Post - Inserts the Part Reason table", Description = "Returns a new Entry")]
        public async Task<bool> UpdatePartReasons(BookingsModel model)
        {
            return await _bookings.UpdatePartReasons(model);
        }

        [HttpPost("InsertPartsBookingReasonAndOutworksCommissionAsync")]
        [SwaggerOperation(Summary = "Post - Inserts the Bookings table", Description = "Returns a new Entry")]
        public async Task<ActionResult<bool>> InsertPartsBookingReasonAndOutworksCommissionAsync(BookingsModel bookingsModel)
        {
            return await _bookings.InsertPartsBookingReasonAndOutworksCommissionAsync(bookingsModel);
        }

        [HttpPut("UpdatePartsBookingReasonAndOutworksCommissionAsync")]
        [SwaggerOperation(Summary = "Put - Updates the Bookings table", Description = "Returns a bool")]
        public async Task<ActionResult<bool>> UpdatePartsBookingReasonAndOutworksCommissionAsync(BookingsModel bookingsModel)
        {
            return await _bookings.UpdatePartsBookingReasonAndOutworksCommissionAsync(bookingsModel);
        }

        [HttpGet("GetInventoryByBookingID/{BookingsID}")]
        [SwaggerOperation(Summary = "GetInventoryByBookingID - Gets a single inventory by BookingsID", Description = "Returns the inventory object")]
        public async Task<ActionResult<PartReasonViewModel>> GetInventoryByBookingID(int BookingsID)
        {
            return await _bookings.GetInventoryByBookingID(BookingsID);
        }
    }
}
