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
        

        //public void AddBooking(Booking booking)
        //{
        //    if (booking == null)
        //        throw new ArgumentNullException(nameof(booking));

        //    if (AvailableSeats < 1)
        //        throw new InvalidOperationException("No available seats.");

        //    Bookings.Add(booking);
        //    PassengersCount = CalculatePassengersCount();
        //}

        //public void RemoveBooking(Booking booking)
        //{
        //    if (booking == null)
        //        throw new ArgumentNullException(nameof(booking));

        //    Bookings.Remove(booking);
        //    PassengersCount = CalculatePassengersCount();
        //}
        //private int CalculatePassengersCount()
        //{
        //    int count = 0;

        //    foreach (var booking in Bookings)
        //    {
        //        if (booking != null)
        //        {
        //            count += booking.BookedSeats;
        //        }
        //    }
        //    return count;
        //}
    }
}
