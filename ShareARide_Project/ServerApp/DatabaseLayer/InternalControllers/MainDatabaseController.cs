using Core.Model;
using DatabaseLayer.Database;
using DatabaseLayer.DatabaseControllers;
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
                    DatabaseUser user1 = null;
                    if (!context.Users.Any(u => u.Username == "georgi"))
                    {
                        user1 = new DatabaseUser()
                        {
                            Username = "georgi",
                            FirstName = "Georgi",
                            LastName = "Slaveykov",
                            Email = "georgi.slaveykov@gmail.com",
                            BirthDate = new DateTime(2004, 5, 6),
                            Age = 21,
                            Sex = Core.Others.Sex.Male,
                            Password = DatabaseUserController.HashPassword("0000"),
                            PhoneNumber = "0886586117"

                        };
                        context.Add<DatabaseUser>(user1);
                    }

                    DatabaseUser user2 = null;
                    if (!context.Users.Any(u => u.Username == "rostislav"))
                    {
                        user2 = new DatabaseUser()
                        {
                            Username = "rostislav",
                            FirstName = "Rostislav",
                            LastName = "Stoyanov",
                            Email = "rostislav.stoyanov@gmail.com",
                            Password = DatabaseUserController.HashPassword("0000"),
                            BirthDate = new DateTime(2004, 3, 25),
                            Age = 22,
                            Sex = Core.Others.Sex.Male,
                            PhoneNumber = "0886586117"

                        };
                        context.Add<DatabaseUser>(user2);
                    }

                    context.Add<DatabaseVehicle>(new DatabaseVehicle() { 
                        Make = Core.Others.VehicleMake.Audi,
                        Model = "A7",
                        DatabaseOwner = user1,
                        Year = 2015,
                        MaxCapacity = 4
                    });

                    foreach (var c in DatabaseCityController.citiesBg)
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
                }
                catch (Exception e)
                {
                    throw new Exception(e.Message);
                }
            }
        }
    }
}
