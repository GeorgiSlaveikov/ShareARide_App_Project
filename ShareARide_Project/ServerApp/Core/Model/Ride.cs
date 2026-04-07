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
        private Offer offer;
        private List<Booking> bookings;
        private int passengersCount;
        private RideStatus status;

        public Ride() { }

        public Ride(int id, Offer offer, List<Booking> bookings, int passengersCount)
        {
            Id = id;
            Offer = offer;
            Bookings = bookings ?? new List<Booking>();
            PassengersCount = CalculatePassengersCount();
            Status = RideStatus.Open;
        }

        public virtual int Id { get => id; set => id = value; }
        public Offer Offer { get => offer; set => offer = value; }
        public List<Booking> Bookings { get => bookings; set => bookings = value; }
        public int PassengersCount { get => passengersCount; set => passengersCount = value; }
        public RideStatus Status { get => status; set => status = value; }
        public int AvailableSeats => Offer.Vehicle.MaxCapacity - PassengersCount;


        public void AddBooking(Booking booking)
        {
            if (booking == null)
                throw new ArgumentNullException(nameof(booking));

            if (AvailableSeats < 1)
                throw new InvalidOperationException("No available seats.");

            Bookings.Add(booking);
            PassengersCount = CalculatePassengersCount();
        }

        public void RemoveBooking(Booking booking)
        {
            if (booking == null)
                throw new ArgumentNullException(nameof(booking));

            Bookings.Remove(booking);
            PassengersCount = CalculatePassengersCount();
        }
        private int CalculatePassengersCount()
        {
            int count = 0;

            foreach (var booking in Bookings)
            {
                if (booking != null)
                {
                    count += booking.Passengers.Count;
                }
            }
            return count;
        }

        private void UpdateStatus()
        {

        }
    }
}
