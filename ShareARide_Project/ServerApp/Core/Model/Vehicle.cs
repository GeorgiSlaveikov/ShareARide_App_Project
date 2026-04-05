using Core.Others;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Core.Model
{
    public class Vehicle
    {
        private int id;
        private VehicleMake make;
        private string model;
        private int year;
        private int maxCapacity;
        private User owner;

        public Vehicle(int id, VehicleMake make, string model, int year, int maxCapacity, User owner)
        {
            Id = id;
            Make = make;
            Model = model;
            Year = year;
            MaxCapacity = maxCapacity;
            Owner = owner;
        }

        public virtual int Id { get => id; set => id = value; }
        public VehicleMake Make { get => make; set => make = value; }
        public string Model { get => model; set => model = value; }
        public int Year
        {
            get => year;
            set
            {
                if (value > 2026 || value < 1900)
                    throw new ArgumentOutOfRangeException(nameof(Year), "Year is not valid.");
                year = value;
            }
        }
        public int MaxCapacity
        {
            get => maxCapacity;
            set
            {
                if (value <= 0)
                    throw new ArgumentOutOfRangeException(nameof(MaxCapacity), "Max capacity must be positive.");
                maxCapacity = value;
            }
        }
        public User Owner { get => owner; set => owner = value; }
    }
}
