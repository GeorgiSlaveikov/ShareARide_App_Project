using Core.Model;
using DatabaseLayer.DatabaseControllers;
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
        public DbSet<DatabaseVehicle> Vehicles { get; set; }
        public DbSet<DatabaseOffer> Offers { get; set; }
        public DbSet<DatabaseBooking> Bookings { get; set; }
        public DbSet<DatabaseRide> Rides { get; set; }
        public DbSet<DatabaseRating> Ratings { get; set; }
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            string solutionFolder = Environment.GetFolderPath(SpecialFolder.LocalApplicationData);
            string databaseFile = "ShareARideDB.db";
            string databasePath = Path.Combine(solutionFolder, databaseFile);
            optionsBuilder.UseSqlite($"Data Source={databasePath}");
        }

        protected override async void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<DatabaseUser>().Ignore(u => u.ProfilePicture);


            modelBuilder.Ignore<User>();
            modelBuilder.Ignore<Booking>();
            modelBuilder.Ignore<Offer>();
            modelBuilder.Ignore<City>();
            modelBuilder.Ignore<Ride>();
            modelBuilder.Ignore<Vehicle>();

            modelBuilder.Entity<DatabaseOffer>()
                .HasOne(o => o.DatabaseDepartureCity)
                .WithMany()
                .HasForeignKey(o => o.DepartureCityId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<DatabaseOffer>()
                .HasOne(o => o.DatabaseDestinationCity)
                .WithMany()
                .HasForeignKey(o => o.DestinationCityId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<DatabaseOffer>()
                .HasOne(o => o.DatabaseDriver)
                .WithMany()
                .HasForeignKey(o => o.DriverId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<DatabaseOffer>()
                .HasOne(o => o.DatabaseVehicle)
                .WithMany()
                .HasForeignKey(o => o.VehicleId)
                .OnDelete(DeleteBehavior.Restrict);


            modelBuilder.Entity<DatabaseBooking>()
                .HasOne(b => b.DatabaseRequester)
                .WithMany()
                .HasForeignKey(b => b.RequesterId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<DatabaseVehicle>()
                .HasOne(v => v.DatabaseOwner)
                .WithMany()
                .HasForeignKey(v => v.OwnerId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<DatabaseRating>()
    .HasIndex(r => new { r.RatedUserId, r.RatedByUserId, r.RideId })
    .IsUnique();

            modelBuilder.Entity<DatabaseRating>()
                .HasOne(r => r.RatedUser)
                .WithMany()
                .HasForeignKey(r => r.RatedUserId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<DatabaseRating>()
                .HasOne(r => r.RatedByUser)
                .WithMany()
                .HasForeignKey(r => r.RatedByUserId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<DatabaseRating>()
                .HasOne(r => r.Ride)
                .WithMany()
                .HasForeignKey(r => r.RideId)
                .OnDelete(DeleteBehavior.Cascade);


            modelBuilder.Entity<DatabaseUser>().ToTable("Users");

            var adminUser = new DatabaseUser()
            {
                Id = 1,
                Username = "admin",
                FirstName = "Admin",
                LastName = "Admin",
                Email = "admin@gmail.com",
                Password = DatabaseUserController.HashPassword("0000"),
                PhoneNumber = "0888888888"
            };

            modelBuilder.Entity<DatabaseUser>().HasData(adminUser);

            base.OnModelCreating(modelBuilder);
        }
    }
}
