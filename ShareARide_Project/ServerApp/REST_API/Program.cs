using REST_API.APIControllers;
using DatabaseLayer.InternalControllers;

namespace REST_API
{
    public class Program
    {
        public static void Main(string[] args)
        {
            //ApiMainController.InitializeApi(args);
            MainDatabaseController.DropDatabase();
            MainDatabaseController.InitializeDatabase();
            var builder = WebApplication.CreateBuilder(args);
            builder.Services.AddApiServices("ShareARideDB.db");
            var app = builder.Build();
            app.UseStaticFiles();
            app.UseApiPipeline();
            app.Run("http://0.0.0.0:5205");
        }
    }
}
