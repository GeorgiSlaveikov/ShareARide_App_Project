using Core.Others;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Core.Model
{
    public class Booking
    {
        private int id;
        private Offer offer;
        private List<User> passengers;
        private List<string> passengersNames;
        private int bookedSeats;
        private User requester;
        private double totalPrice;
        private BookingStatus status;
        private DateTime createdAt;

        public Booking() { }

        public Booking(Offer offer, User requester)
        {
            Offer = offer;
            Requester = requester;
            passengers = new List<User>();
            passengersNames = new List<string>();
            bookedSeats = 0;
            status = BookingStatus.Pending;
            createdAt = DateTime.Now;
            totalPrice = 0;
        }

        public virtual int Id { get => id; set => id = value; }

        [NotMapped]
        public Offer Offer
        {
            get => offer;
            set
            {
                if (value == null)
                    throw new ArgumentNullException(nameof(offer));
                offer = value;
            }
        }

        public List<string> PassengersNames { get => passengersNames; set => passengersNames = value; }
        public List<User> Passengers { get => passengers; set => passengers = value; }
        public int BookedSeats { get => bookedSeats; set => bookedSeats = value; }
        public User Requester
        {
            get => requester;
            set
            {
                if (value == null)
                    throw new ArgumentNullException(nameof(requester));
                requester = value;
            }
        }
        public double TotalPrice { get => totalPrice; set => totalPrice = value; }
        public BookingStatus Status { get => status; set => status = value; }
        public DateTime CreatedAt { get => createdAt; set => createdAt = value; }

        private double CalculateTotalPrice()
        {
            return Math.Round(this.offer.PricePerSeat * this.bookedSeats, 2);
        }

        public void AddPassenger(User passenger)
        {
            if (passenger == null)
                throw new ArgumentNullException(nameof(passenger));

            if (passengers.Count + 1 > Offer.Vehicle.MaxCapacity)
                throw new InvalidOperationException("No available seats.");

            this.passengers.Add(passenger);
            BookedSeats++;
            TotalPrice = CalculateTotalPrice();
        }

        public void RemovePassenger(User passenger)
        {
            if (passenger == null)
                throw new ArgumentNullException(nameof(passenger));

            if (passengers.Remove(passenger))
            {
                BookedSeats--;
                TotalPrice = CalculateTotalPrice();
            }
            else
            {
                throw new InvalidOperationException("Passenger not found in booking.");
            }
        }

        public void ClearPassengers()
        {
            passengers.Clear();
            BookedSeats = 0;
            TotalPrice = 0;
        }

        public void ResetStatus()
        {
            Status = BookingStatus.Pending;
        }

        public void Accept()
        {
            Status = BookingStatus.Accepted;
        }

        public void Reject()
        {
            Status = BookingStatus.Rejected;
        }
    }
}
