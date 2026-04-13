using DatabaseLayer.Database;
using DatabaseLayer.DatabaseModels;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DatabaseLayer.DatabaseControllers
{ 
    public static class DatabaseUserController
    {
        public static async Task<DatabaseUser> LogIn(string username, string password)
        {
            using (var context = new DatabaseContext())
            {
                var users = context.Users;

                var user = await context.Users
                .SingleOrDefaultAsync(u => u.Username == username && u.Password == password);

                return user;
            }
        }

        public static async Task<DatabaseUser> GetUser(DatabaseContext context, int id) {
            using (context)
            {
                var users = context.Users;

                var user = await context.Users
                .SingleOrDefaultAsync(u => u.Id == id);

                return user;
            }
        }
    }
}
