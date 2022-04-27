using System.Net.Mail;
using System.Reflection;
using DbUp;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using SmtpClient = System.Net.Mail.SmtpClient;


namespace Triton.FleetManagement.WebApi
{
    public class Program
    {
        public static void Main(string[] args)
        {
#if DEBUG
            const string connectionString = "Server=texzadcdev01;Database=TritonFleetManagement;User Id=tritonit;Password=tritonexpressit;";
            var config = new ConfigurationBuilder()
                .AddJsonFile("appsettings.Development.json")
                .Build();
#else
            const string connectionString = "Server=TIGER;Database=TritonFleetManagement;User Id=tritonit;Password=tritonexpressit;";
            var config = new ConfigurationBuilder()
                .AddJsonFile("appsettings.json")
                .Build();
#endif

            var upgrader =
                DeployChanges.To
                    .SqlDatabase(connectionString)
                    .WithScriptsEmbeddedInAssembly(Assembly.GetExecutingAssembly())
                    .LogToConsole()
                    .Build();

            var result = upgrader.PerformUpgrade();

            if (!result.Successful)
            {
                var mailMessage = new MailMessage
                {
                    From = new MailAddress("administrator@tritonexpress.co.za"),
                    Subject = "Triton.FleetManagement.WebApi DB update failed",
                    Body = $"Error Message:  {result.Error.Message}",
                    IsBodyHtml = true
                };
                mailMessage.To.Add("Developers@tritonexpress.co.za");

                var s = new SmtpClient {Host = config.GetSection("SMTP").GetSection("ip").Value ?? "192.168.85.235", Port = int.Parse(config.GetSection("SMTP").GetSection("port").Value)};
                s.Send(mailMessage);
            }

            CreateHostBuilder(args).Build().Run();
        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>();
                });
    }
}
