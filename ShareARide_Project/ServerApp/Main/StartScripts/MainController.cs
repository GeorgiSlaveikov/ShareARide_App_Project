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
        }
    }
}
