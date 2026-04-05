using DatabaseLayer.DatabaseModels;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using static System.Environment;

namespace DatabaseLayer.Database
{
    public class DatabaseContext : DbContext
    {
        public DatabaseContext() { }
        public DatabaseContext(DbContextOptions<DatabaseContext> options) : base(options)
        {
        }
        public DbSet<DatabaseUser> Users { get; set; }
        public DbSet<DatabaseCity> Cities { get; set; }
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            string solutionFolder = Environment.GetFolderPath(SpecialFolder.LocalApplicationData);
            string databaseFile = "ShareARideDB.db";
            string databasePath = Path.Combine(solutionFolder, databaseFile);
            optionsBuilder.UseSqlite($"Data Source={databasePath}");
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            //modelBuilder.Entity<DatabaseUser>().Property(e => e.Id).ValueGeneratedOnAdd();

            modelBuilder.Entity<DatabaseUser>()
                .HasOne(u => u.HomeCity)
                .WithMany()
                .HasForeignKey("HomeCityId");

            modelBuilder.Entity<DatabaseUser>().ToTable("Users");

            var adminUser = new DatabaseUser()
            {
                Id = 1,
                Username = "admin",
                FirstName = "Admin",
                LastName = "Admin",
                Email = "admin@gmail.com",
                Password = "0000"
            };

            modelBuilder.Entity<DatabaseUser>().HasData(adminUser);
        }
    }
}
