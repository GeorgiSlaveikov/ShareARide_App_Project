using REST_API.APIControllers;

namespace REST_API
{
    public class Program
    {
        public static void Main(string[] args)
        {
            //ApiMainController.InitializeApi(args);
            var builder = WebApplication.CreateBuilder(args);
            builder.Services.AddApiServices("ShareARideDB.db");
            var app = builder.Build();
            app.UseApiPipeline();
            app.Run("http://0.0.0.0:5205");
        }
    }
}
