using DatabaseLayer.InternalControllers;
using Microsoft.AspNetCore.Builder;
using REST_API.APIControllers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Main.StartScripts
{
    public static class MainController
    {
        public static void StartServer(string[] args) {
            MainDatabaseController.InitializeDatabase();
            //ApiMainController.InitializeApi(args);
            //var builder = WebApplication.CreateBuilder(args);
            //builder.Services.AddApiServices("ShareARideDB.db");
            //var app = builder.Build();
            //app.UseApiPipeline();
            //app.Run("http://0.0.0.0:5205");
        }
    }
}
