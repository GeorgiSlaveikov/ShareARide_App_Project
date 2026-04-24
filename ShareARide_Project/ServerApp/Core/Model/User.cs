using Core.Others;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
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
        private String phoneNumber;
        private DateTime birthDate;
        private int age;
        private Sex sex;
        private string email;
        private string password;
        private City homeCity;
        private double rating;

        [NotMapped]
        public IFormFile? ProfilePicture { get; set; }

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
           string password, string phoneNumber)
        {
            Id = id;
            Username = username;
            FirstName = firstName;
            LastName = lastName;
            Email = email;
            Password = password;
            Age = CalculateAge();
            HomeCity = homeCity;
            PhoneNumber = phoneNumber;
        }


        // main ctor
        public User(int id, string username, string firstName, string lastName, string email,
            string password, DateTime birthDate, Sex sex, City homeCity, string phoneNumber, double rating)
        {
            Id = id;
            Username = username;
            FirstName = firstName;
            LastName = lastName;
            Email = email;
            Password = password;
            BirthDate = birthDate;
            Age = age;
            Sex = sex;
            HomeCity = homeCity;
            PhoneNumber = phoneNumber;
            Rating = rating;
        }

        public virtual int Id { get => id; set => id = value; }
        public string Username { get => username; set => username = value; }
        public string FirstName { get => firstName; set => firstName = value; }
        public string LastName { get => lastName; set => lastName = value; }
        public string PhoneNumber { get => phoneNumber; set => phoneNumber = value; }
        public string Email { get => email; set => email = value; }
        public string Password { get => password; set => password = value; }
        public int Age { get => age; set => age = value; }
        public DateTime BirthDate { get => birthDate; set => birthDate = value; }
        public Sex Sex { get => sex; set => sex = value; }
        public City HomeCity { get => homeCity; set => homeCity = value; }
        public double Rating { get => rating; set => rating = value; }

        public int CalculateAge() {
            return (DateTime.Now.Year - BirthDate.Year);
        }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.AppendLine($"Username: {Username}");
            stringBuilder.AppendLine($"First Name: {FirstName}");
            stringBuilder.AppendLine($"Last Name: {LastName}");
            stringBuilder.AppendLine($"Email: {Email}");
            stringBuilder.AppendLine($"Phone Number: {PhoneNumber}");
            stringBuilder.AppendLine($"Sex: {Sex.ToString()}");
            stringBuilder.AppendLine($"Age: {Age}");
            stringBuilder.AppendLine($"Rating: {Rating}");
            return stringBuilder.ToString();
        }
    }
}
