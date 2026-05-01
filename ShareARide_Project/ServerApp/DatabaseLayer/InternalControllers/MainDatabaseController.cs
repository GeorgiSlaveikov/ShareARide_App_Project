using Core.Model;
using DatabaseLayer.Database;
using DatabaseLayer.DatabaseModelControllers;
using DatabaseLayer.DatabaseModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace DatabaseLayer.InternalControllers
{
    public static class MainDatabaseController
    {
        public static void DropDatabase()
        {
            using (var context = new DatabaseContext())
            {
                try
                {
                    context.Database.EnsureDeleted();
                }
                catch (Exception e)
                {
                    throw new Exception(e.Message);
                }
            }
        }
        public static void InitializeDatabase()
        {
            using (var context = new DatabaseContext())
            {
                try
                {
                    context.Database.EnsureCreated();
                    DatabaseUser user = null;
                    if (!context.Users.Any(u => u.Username == "georgi.slaveykov"))
                    {
                        user = new DatabaseUser()
                        {
                            Username = "georgi.slaveykov",
                            FirstName = "Georgi",
                            LastName = "Slaveykov",
                            Email = "georgi.slaveykov@gmail.com",
                            Password = "0000",
                            PhoneNumber = "0886586117"

                        };
                        context.Add<DatabaseUser>(user);
                    }

                    context.Add<DatabaseVehicle>(new DatabaseVehicle() { 
                        Make = Core.Others.VehicleMake.Audi,
                        Model = "A7",
                        DatabaseOwner = user,
                        Year = 2015,
                        MaxCapacity = 4
                    });

                    foreach (var c in DatabaseCityController.cities)
                        {
                            var coordinates = DatabaseCityController.GetCoordinates(c);
                        
                            context.Add<DatabaseCity>(new DatabaseCity()
                            {
                                Name = c,
                                Latitude = coordinates.Latitude,
                                Longitude = coordinates.Longitude
                            });
                        }

                    context.SaveChanges();
                    //var users = context.Users.ToList();
                }
                catch (Exception e)
                {
                    throw new Exception(e.Message);
                }
            }
        }
    }
}
