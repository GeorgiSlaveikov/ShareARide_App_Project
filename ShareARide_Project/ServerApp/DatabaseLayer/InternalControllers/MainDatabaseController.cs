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
                    if (!context.Users.Any(u => u.Username == "georgi.slaveykov"))
                    {
                        context.Add<DatabaseUser>(new DatabaseUser()
                        {
                            Username = "georgi.slaveykov",
                            FirstName = "Georgi",
                            LastName = "Slaveykov",
                            Email = "user@gmail.com",
                            Password = "0000"
                        });
                    }

                    context.SaveChanges();
                    var users = context.Users.ToList();
                    PrintUsers(users);
                }
                catch (Exception e)
                {
                    throw new Exception(e.Message);
                }
            }
        }

        private static void PrintUsers(List<DatabaseUser> users)
        {
            Console.ForegroundColor = ConsoleColor.Blue;
            Console.WriteLine("All users in the database");
            Console.ForegroundColor = ConsoleColor.White;
            foreach (var user in users)
            {
                Console.WriteLine(user.ToString());
            }
        }
    }
}
