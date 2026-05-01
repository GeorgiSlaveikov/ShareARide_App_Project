using DatabaseLayer.Database;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Mvc;

namespace REST_API.APIControllers
{
    public static class ApiMainController
    {
        //public static void InitializeApi(string[] args) {
        //    var builder = WebApplication.CreateBuilder(args);

        //    string databasePath = "ShareARideDB.db";
        //    builder.Services.AddDbContext<DatabaseContext>(options =>
        //        options.UseSqlite($"Data Source={databasePath}"));

        //    builder.Services.AddCors(options => options.AddPolicy("AllowAll", policy => policy.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader()));


        //    builder.Services.AddControllers();
        //    builder.Services.AddEndpointsApiExplorer();
        //    builder.Services.AddSwaggerGen();

        //    var app = builder.Build();

        //    if (app.Environment.IsDevelopment())
        //    {
        //        app.UseSwagger();
        //        app.UseSwaggerUI(c =>
        //        {
        //            c.SwaggerEndpoint("/swagger/v1/swagger.json", "My API V1");
        //        });
        //    }

        //    app.UseCors("AllowAll");
        //    app.UseAuthorization();
        //    app.MapControllers();
        //    app.Run("http://0.0.0.0:5205");
        //}

        public static void AddApiServices(this IServiceCollection services, string databasePath)
        {
            //services.AddDbContext<DatabaseContext>(options =>
            //    options.UseSqlite($"Data Source={databasePath}"));

            //services.AddCors(options => options.AddPolicy("AllowAll",
            //    policy => policy.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader()));

            //// CRITICAL: Since controllers are in this project, we must tell 
            //// the runner project where to find them.
            ////services.AddControllers();
            //services.AddControllers()
            //.AddApplicationPart(typeof(ApiServiceExtensions).Assembly);

            //services.AddEndpointsApiExplorer();
            //services.AddSwaggerGen();

            services.AddDbContext<DatabaseContext>(options =>
        options.UseSqlite($"Data Source={databasePath}"));

            services.AddCors(options => options.AddPolicy("AllowAll",
                policy => policy.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader()));

            // Alternative way to register controllers from the current project
            services.AddControllers()
                .AddApplicationPart(System.Reflection.Assembly.GetExecutingAssembly());

            services.AddEndpointsApiExplorer();
            services.AddSwaggerGen();
        }

        // 2. Configure Middleware (The Pipeline)
        public static void UseApiPipeline(this WebApplication app)
        {
            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI(c =>
                {
                    c.SwaggerEndpoint("/swagger/v1/swagger.json", "My API V1");
                });
            }

            app.UseCors("AllowAll");
            app.UseAuthorization();
            app.MapControllers();
        }
    }
}
