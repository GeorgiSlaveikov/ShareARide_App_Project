using DatabaseLayer.Database;
using DatabaseLayer.DatabaseModels;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using BCrypt.Net;

namespace DatabaseLayer.DatabaseControllers
{ 
    public static class DatabaseUserController
    {
        public static async Task<DatabaseUser> LogIn(string username, string password)
        {
            using (var context = new DatabaseContext())
            {
                var user = await context.Users
             .SingleOrDefaultAsync(u => u.Username == username);

               
                if (user == null)
                {
                    return null;
                }

                bool isValid = VerifyPassword(password, user.Password);

                return isValid ? user : null;
            }
        }

        public static async Task<DatabaseUser> GetUser(int id) {
            using (var context = new DatabaseContext())
            {
                var users = context.Users;

                var user = await context.Users
                .SingleOrDefaultAsync(u => u.Id == id);

                return user;
            }
        }

        public static async Task<bool> IsUsernameFree(string username) {
            using (var context = new DatabaseContext())
            {
                var users = context.Users;

                var user = await context.Users
                .SingleOrDefaultAsync(u => u.Username == username);

                if (user == null)
                {
                    return true;
                }
                else return false;
            }
        }

        public static async Task<bool> IsEmailValid(string email)
        {
            if (string.IsNullOrWhiteSpace(email))
                return false;

            string regexPattern = @"^[^@\s]+@[^@\s]+\.[^@\s]+$";

            bool isValid = Regex.IsMatch(email, regexPattern, RegexOptions.IgnoreCase);

            return await Task.FromResult(isValid);
        }

        public static async Task<bool> IsPasswordValid(string password)
        {
            if (string.IsNullOrWhiteSpace(password))
                return false;

            bool hasUpper = password.Any(char.IsUpper);
            bool hasLower = password.Any(char.IsLower);
            bool hasDigit = password.Any(char.IsDigit);

            return await Task.FromResult(hasUpper && hasLower && hasDigit);
        }

        public static async Task<bool> IsPhoneNumberValid(string phoneNumber)
        {
            if (string.IsNullOrWhiteSpace(phoneNumber))
                return false;

            bool isValid = Regex.IsMatch(phoneNumber, @"^0\d{9}$");

            return await Task.FromResult(isValid);
        }


        public static string HashPassword(string password)
        {
            return BCrypt.Net.BCrypt.HashPassword(password);
        }

        public static bool VerifyPassword(string password, string hashedPassword)
        {
            if (string.IsNullOrWhiteSpace(password) || string.IsNullOrWhiteSpace(hashedPassword))
                return false;

            try
            {
                return BCrypt.Net.BCrypt.Verify(password, hashedPassword);
            }
            catch (BCrypt.Net.SaltParseException)
            {
                return false;
            }
        }

        public static int CalculateAge(DateTime birthDate)
        {
            var today = DateTime.Today;
            var age = today.Year - birthDate.Year;

            if (birthDate.Date > today.AddYears(-age))
            {
                age--;
            }

            return age;
        }
    }
}
