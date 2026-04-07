using DatabaseLayer.Database;
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


                    var hskCity = context.Cities.FirstOrDefault(u => u.Name == "Haskovo");
                    if (hskCity == null)
                    {
                        hskCity = new DatabaseCity()
                        {
                            Name = "Haskovo"
                        };
                        context.Cities.Add(hskCity);
                        context.SaveChanges();
                    }

                    DatabaseUser user = null;
                    if (!context.Users.Any(u => u.Username == "georgi.slaveykov"))
                    {
                        user = new DatabaseUser()
                        {
                            Username = "georgi.slaveykov",
                            FirstName = "Georgi",
                            LastName = "Slaveykov",
                            Email = "user@gmail.com",
                            DatabaseHomeCity = hskCity,
                            Password = "0000"
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
