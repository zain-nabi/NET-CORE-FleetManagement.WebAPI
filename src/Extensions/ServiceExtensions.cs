using Microsoft.AspNetCore.Mvc.Formatters;
using Microsoft.Extensions.DependencyInjection;
using Triton.FleetManagement.WebApi.Interface;
using Triton.FleetManagement.WebApi.Repository;

namespace Applications.Claims.WebApi
{
    public static class ServiceExtensions
    {
        public static void ConfigureCors(this IServiceCollection services)
        {
            services.AddCors(options =>
            {
                options.AddPolicy("CorsPolicy",
                    builder => builder.AllowAnyOrigin()
                    .AllowAnyMethod()
                    .AllowAnyHeader());
            });
        }

        public static void ConfigureTransient(this IServiceCollection services)
        {
            services.AddTransient<ILookUpCodeCategories, LookUpCodeCategoriesRepository>();
            services.AddTransient<ILookUpCodes, LookUpCodeRepository>();
            services.AddTransient<ICustomer, CustomerRepository>();
            services.AddTransient<IVehicle, VehicleRepository>();
            services.AddTransient<IBookings, BookingsRepository>();
            services.AddTransient<IScaleHour, ScaleHourRepository>();
            services.AddTransient<IDashboard, DashboardRepository>();
            services.AddTransient<IICCATG, ICCATGRepository>();
            services.AddTransient<IARCUS, ARCUSRepository>();
            services.AddTransient<IICLOC, ICLOCRepository>();
            services.AddTransient<IOESHDT, OESHDTRepository>();
        }

        public static void ConfigureOutputFormatters(this IServiceCollection services)
        {
            services.AddControllers(opt => // or AddMvc()
            {
                // remove formatter that turns nulls into 204 - No Content responses
                // this formatter breaks Angular's Http response JSON parsing
                opt.OutputFormatters.RemoveType<HttpNoContentOutputFormatter>();
            });
        }
    }
}
