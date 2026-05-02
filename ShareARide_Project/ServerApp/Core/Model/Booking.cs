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
        private decimal pricePerSeat;
        private int bookedSeats;
        private decimal totalPrice;
        private BookingStatus status;
        private DateTime createdAt;

        public Booking() { }

        public Booking(decimal price, int seats)
        {
            pricePerSeat = price;
            bookedSeats = seats;
            status = BookingStatus.Pending;
            createdAt = DateTime.Now;
            totalPrice = CalculateTotalPrice();
        }

        public virtual int Id { get => id; set => id = value; }
        public int BookedSeats { get => bookedSeats; set => bookedSeats = value; }
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
