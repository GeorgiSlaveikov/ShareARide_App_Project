using Core.Others;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Core.Model
{
    public class Ride
    {
        private int id;
        private int passengersCount;
        private RideStatus status;

        public Ride() { }

        public Ride(int id, int passengersCount)
        {
            Id = id;
            PassengersCount = 0;
            Status = RideStatus.Open;
        }

        public virtual int Id { get => id; set => id = value; }
        public int PassengersCount { get => passengersCount; set => passengersCount = value; }
        public RideStatus Status { get => status; set => status = value; }
    }
}
