using DatabaseLayer.DatabaseControllers;
using DatabaseLayer.DatabaseModels;
using DatabaseLayer.InternalControllers;
using System.Threading.Tasks;

namespace DatabaseLayer
{
    internal class Program
    {
        static async Task Main(string[] args)
        {
            MainDatabaseController mdbc = new MainDatabaseController();


            mdbc.InitializeDatabase();

            DatabaseUser user = null;

            while (user == null)
            {

                Console.WriteLine("Username: ");
                string username = Console.ReadLine();
                Console.WriteLine("Password: ");
                string password = Console.ReadLine();
                user = await DatabaseUserController.LogIn(username, password);
                if (user != null)
                {
                    Console.WriteLine(user);
                }
                else
                {
                    Console.WriteLine("Sorry! Wrong credentials!");
                }
            }
        }
    }
}
