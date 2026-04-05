using Core.Others;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace Core.Model
{
    public class User
    {
        private int id;
        private string username;
        private string firstName;
        private string lastName;
        private int age;
        private Sex sex;
        private string email;
        private string password;
        private City homeCity;

        // for creating a passenger
        public User(string firstName, string lastName, int age, Sex sex)
        {
            FirstName = firstName;
            LastName = lastName;
            Age = age;
            Sex = sex;
        }


        // control ctor
        public User() { }


        // admin user creation
        public User(int id, string username, string firstName, string lastName, string email,
           string password)
        {
            Id = id;
            Username = username;
            FirstName = firstName;
            LastName = lastName;
            Email = email;
            Password = password;
            Age = age;
            HomeCity = homeCity;
        }


        // main ctor
        public User(int id, string username, string firstName, string lastName, string email,
            string password, int age, Sex sex, City homeCity)
        {
            Id = id;
            Username = username;
            FirstName = firstName;
            LastName = lastName;
            Email = email;
            Password = password;
            Age = age;
            Sex = sex;
            HomeCity = homeCity;
        }

        public virtual int Id { get => id; set => id = value; }
        public string Username { get => username; set => username = value; }
        public string FirstName { get => firstName; set => firstName = value; }
        public string LastName { get => lastName; set => lastName = value; }
        public string Email { get => email; set => email = value; }
        public string Password { get => password; set => password = value; }
        public int Age { get => age; set => age = value; }
        public Sex Sex { get => sex; set => sex = value; }
        public City HomeCity { get => homeCity; set => homeCity = value; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.AppendLine($"Username: {Username}");
            stringBuilder.AppendLine($"First Name: {FirstName}");
            stringBuilder.AppendLine($"Last Name: {LastName}");
            stringBuilder.AppendLine($"Email: {Email}");
            stringBuilder.AppendLine($"Sex: {Sex.ToString()}");
            stringBuilder.AppendLine($"Age: {Age}");
            return stringBuilder.ToString();
        }
    }
}
