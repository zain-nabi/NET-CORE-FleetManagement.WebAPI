using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Triton.Service.Model.TritonFleetManagement.Custom;
using Triton.Service.Model.TritonFleetManagement.Tables;

namespace Triton.FleetManagement.WebApi.Interface
{
    public interface ICustomer
    {
        Task<List<CustomerModel>> GetAllAsync();
        Task<CustomerModel> LookUpCodesAsync();
        Task<CustomerModel> GetByIdAsync(int customerID);
        Task<bool> DeleteAsync(Customer customer);
        Task<bool> InsertAsync(CustomerModel customerModel);
        Task<bool> UpdateAsync(CustomerModel customerModel);
        Task<bool> IsCustomerExistsAsync(string customerName);
        Task<bool> InsertDocumentRepositoryAsync(CustomerDocumentRepositoryModel documentRepository);
        Task<DocumentRepository> GetAllDocuments(int DocumentRepositoryID);
        Task<Customer> GetCustomerID(string customerName);
        Task<bool> DeleteFile(CustomerDocumentRepositoryModel customerDocumentRepository);
        Task<List<CustomerAuditModel>> GetCustomerAuditAsync(int CustomerID);
    }
}
