using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Swashbuckle.AspNetCore.Annotations;
using Triton.FleetManagement.WebApi.Interface;
using Triton.Service.Model.TritonFleetManagement.Custom;
using Triton.Service.Model.TritonFleetManagement.Tables;

namespace Triton.FleetManagement.WebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CustomerController : ControllerBase
    {
        private readonly ICustomer _customer;
        public CustomerController(ICustomer customer)
        {
            _customer = customer;
        }

        [HttpGet("Customer/LookUpCodes")]
        [SwaggerOperation(Summary = "Get List of LookUpCodes", Description = "Get List of LookUpCodes")]
        public async Task<CustomerModel> LookUpCodes()
        {
            return await _customer.LookUpCodesAsync();
        }

        [HttpGet("Customer")]
        [SwaggerOperation(Summary = "Get List of CustomerModel", Description = "Get List of CustomerModel")]
        public async Task<List<CustomerModel>> GetAsync()
        {
            return await _customer.GetAllAsync();
        }

        [HttpGet("Customer{customerID:int}")]
        [SwaggerOperation(Summary = "GetcustomerID - Gets a single Custoner by customerID", Description = "Returns the Customer object")]
        public async Task<ActionResult<CustomerModel>> GetByIdAsync(int customerID)
        {
            return await _customer.GetByIdAsync(customerID);
        }

        [HttpPost("Customer")]
        [SwaggerOperation(Summary = "Post - Inserts the Customer table", Description = "Returns a new Entry")]
        public async Task<ActionResult<bool>> InsertAsync(CustomerModel customerModel)
        {
            return await _customer.InsertAsync(customerModel);
        }

        [HttpPut("Customer")]
        [SwaggerOperation(Summary = "Put - Updates the Customer table", Description = "Returns a bool")]
        public async Task<ActionResult<bool>> UpdateAsync(CustomerModel customerModel)
        {
            return await _customer.UpdateAsync(customerModel);
        }

        [HttpPut("DeleteAsync/{Model}")]
        [SwaggerOperation(Summary = "Put - Delete the Customer table", Description = "Returns a bool")]
        public async Task<ActionResult<bool>> DeleteAsync(Customer customer)
        {
            return await _customer.DeleteAsync(customer);
        }

        [HttpGet("IsCustomerNameExists")]
        [SwaggerOperation(Summary = "IsCustomerNameExists", Description = "return bool")]
        public async Task<bool> IsCustomerNameExists(string customerName)
        {
            return await _customer.IsCustomerExistsAsync(customerName);
        }


        [HttpPost("InsertDocumentRepositoryAsync/{Model}")]
        [SwaggerOperation(Summary = "InsertDocumentRepositoryAsync - inserts a document", Description = "return bool")]
        public async Task<bool> InsertDocumentRepositoryAsync(CustomerDocumentRepositoryModel documentRepository)
        {
            return await _customer.InsertDocumentRepositoryAsync(documentRepository);
        }

        [HttpGet("GetAllDocuments/{DocumentRepositoryID}")]
        [SwaggerOperation(Summary = "GetAllDocuments - returns customers documents", Description = "return documents")]
        public async Task<DocumentRepository> GetAllDocuments(int DocumentRepositoryID)
        {
            return await _customer.GetAllDocuments(DocumentRepositoryID);
        }

        [HttpGet("GetCustomerID/{customerName}")]
        [SwaggerOperation(Summary = "GetCustomerID - returns customer ID", Description = "return a customerID")]
        public async Task<Customer> GetCustomerID(string customerName)
        {
            return await _customer.GetCustomerID(customerName);
        }

        [HttpPut("DeleteFile/Update")]
        [SwaggerOperation(Summary = "Put - Update the customer document and document repository table", Description = "Returns a bool")]
        public async Task<ActionResult<bool>> DeleteFile(CustomerDocumentRepositoryModel customerDocumentRepository)
        {
            return await _customer.DeleteFile(customerDocumentRepository);
        }

        [HttpGet("CustomerAudit/{CustomerID}")]
        [SwaggerOperation(Summary = "Returns audit trail", Description = "Get a list of the audit trail")]
        public async Task<List<CustomerAuditModel>> CustomerAudit(int CustomerID)
        {
            return await _customer.GetCustomerAuditAsync(CustomerID);
        }
    }
}
