using Core.Model;
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

            //modelBuilder.Entity<DatabaseUser>()
            //    .HasOne(u => u.HomeCity)
            //    .WithMany()
            //    .HasForeignKey("HomeCityId");

            //modelBuilder.Entity<DatabaseUser>().ToTable("Users");

            //var adminUser = new DatabaseUser()
            //{
            //    Id = 1,
            //    Username = "admin",
            //    FirstName = "Admin",
            //    LastName = "Admin",
            //    Email = "admin@gmail.com",
            //    Password = "0000"
            //};

            //modelBuilder.Entity<DatabaseUser>().HasData(adminUser);

            modelBuilder.Ignore<User>();
            modelBuilder.Ignore<Booking>();
            modelBuilder.Ignore<Offer>();
            modelBuilder.Ignore<City>();
            modelBuilder.Ignore<Ride>();
            modelBuilder.Ignore<Vehicle>();

            // 1. DatabaseOffer -> DepartureCity & DestinationCity
            // We must disable cascade delete because there are two paths to the Cities table.
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

            // 2. DatabaseOffer -> Driver (User)
            modelBuilder.Entity<DatabaseOffer>()
                .HasOne(o => o.DatabaseDriver)
                .WithMany()
                .HasForeignKey(o => o.DriverId)
                .OnDelete(DeleteBehavior.Restrict);

            // 3. DatabaseBooking -> Passengers (Many-to-Many)
            // This creates a join table (e.g., BookingUser) automatically.
            modelBuilder.Entity<DatabaseBooking>()
                .HasMany(b => b.DatabasePassengers)
                .WithMany();

            // 4. DatabaseBooking -> Requester (User)
            modelBuilder.Entity<DatabaseBooking>()
                .HasOne(b => b.DatabaseRequester)
                .WithMany()
                .HasForeignKey(b => b.RequestorId)
                .OnDelete(DeleteBehavior.Restrict);

            // 5. DatabaseVehicle -> Owner (User)
            modelBuilder.Entity<DatabaseVehicle>()
                .HasOne(v => v.DatabaseOwner)
                .WithMany()
                .HasForeignKey(v => v.OwnerId)
                .OnDelete(DeleteBehavior.Cascade);

            // 6. DatabaseUser -> HomeCity (City)
            modelBuilder.Entity<DatabaseUser>()
                .HasOne(u => u.DatabaseHomeCity)
                .WithMany(c => c.Users)
                .HasForeignKey(u => u.HomeCityId)
                .OnDelete(DeleteBehavior.SetNull);



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

            base.OnModelCreating(modelBuilder);
        }
    }
}
