using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace ServerApp.Model
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
        private string passwordHash;
        private City homeCity;

        public User(string firstName, string lastName, int age, Sex sex)
        {
            FirstName = firstName;
            LastName = lastName;
            Age = age;
            Sex = sex;
        }

        public User() { }

        public User(int id, string username, string firstName, string lastName, string email,
            string passwordHash, int age, Sex sex, object cryptographicOperations, City homeCity)
        {
            Id = id;
            Username = username;
            FirstName = firstName;
            LastName = lastName;
            Email = email;
            PasswordHash = passwordHash;
            Age = age;
            Sex = sex;
            CryptographicOperations = cryptographicOperations;
            HomeCity = homeCity;
        }

        public virtual int Id { get => id; set => id = value; }
        public string Username { get => username; set => username = value; }
        public string FirstName { get => firstName; set => firstName = value; }
        public string LastName { get => lastName; set => lastName = value; }
        public string Email { get => email; set => email = value; }
        public string PasswordHash { get => passwordHash; set => passwordHash = value; }
        public int Age { get => age; set => age = value; }
        public Sex Sex { get => sex; set => sex = value; }
        public object CryptographicOperations { get; private set; }
        public City HomeCity { get => homeCity; set => homeCity = value; }


        // Hash password
        public void SetPassword(string password)
        {
            PasswordHash = HashPassword(password);
        }

        // Verify password during login
        public bool VerifyPassword(string password)
        {
            return VerifyHashedPassword(PasswordHash, password);
        }

        private string HashPassword(string password)
        {
            byte[] salt = new byte[32];

            using (var rng = new RNGCryptoServiceProvider())
            {
                rng.GetBytes(salt);
            }

            using (var pbkdf2 = new Rfc2898DeriveBytes(
                password,
                salt,
                100000))
            {
                byte[] hash = pbkdf2.GetBytes(32);
                return Convert.ToBase64String(salt) + "." + Convert.ToBase64String(hash);
            }
        }

        private bool VerifyHashedPassword(string storedHash, string password)
        {
            var parts = storedHash.Split('.');
            byte[] salt = Convert.FromBase64String(parts[0]);
            byte[] storedPasswordHash = Convert.FromBase64String(parts[1]);

            using (var pbkdf2 = new Rfc2898DeriveBytes(
                password,
                salt,
                100000))
            {
                byte[] computedHash = pbkdf2.GetBytes(32);

                return SlowEquals(storedPasswordHash, computedHash);
            }
        }

        private bool SlowEquals(byte[] a, byte[] b)
        {
            uint diff = (uint)a.Length ^ (uint)b.Length;

            for (int i = 0; i < a.Length && i < b.Length; i++)
            {
                diff |= (uint)(a[i] ^ b[i]);
            }

            return diff == 0;
        }

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
