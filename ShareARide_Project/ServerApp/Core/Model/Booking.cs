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
        //private Offer offer;
        //private List<User> passengers;
        //private List<string> passengersNames;
        private decimal pricePerSeat;
        private int bookedSeats;
        private decimal totalPrice;
        private BookingStatus status;
        private DateTime createdAt;

        public Booking() { }

        public Booking(decimal price, int seats)
        {
            //Offer = offer;
            //passengers = new List<User>();
            //passengersNames = new List<string>();
            pricePerSeat = price;
            bookedSeats = seats;
            status = BookingStatus.Pending;
            createdAt = DateTime.Now;
            totalPrice = CalculateTotalPrice();
        }

        public virtual int Id { get => id; set => id = value; }

        //[NotMapped]
        //public Offer Offer
        //{
        //    get => offer;
        //    set
        //    {
        //        if (value == null)
        //            throw new ArgumentNullException(nameof(offer));
        //        offer = value;
        //    }
        //}

        //public List<string> PassengersNames { get => passengersNames; set => passengersNames = value; }
        //public List<User> Passengers { get => passengers; set => passengers = value; }
        public int BookedSeats { get => bookedSeats; set => bookedSeats = value; }
        //public User Requester
        //{
        //    get => requester;
        //    set
        //    {
        //        if (value == null)
        //            throw new ArgumentNullException(nameof(requester));
        //        requester = value;
        //    }
        //}
        public decimal TotalPrice { get => totalPrice; set => totalPrice = value; }
        public BookingStatus Status { get => status; set => status = value; }
        public DateTime CreatedAt { get => createdAt; set => createdAt = value; }

        private decimal CalculateTotalPrice()
        {
            return Math.Round(this.pricePerSeat * this.bookedSeats, 2);
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
