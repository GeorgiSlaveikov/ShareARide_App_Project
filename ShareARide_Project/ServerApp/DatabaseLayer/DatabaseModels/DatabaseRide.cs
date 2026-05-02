using Core.Model;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DatabaseLayer.DatabaseModels
{
    public class DatabaseRide : Ride
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public override int Id { get; set; }

        public int OfferId { get; set; }

        [ForeignKey("OfferId")]
        public virtual DatabaseOffer DatabaseOffer { get; set; }

        public virtual ICollection<DatabaseBooking> DatabaseBookings { get; set; } = new List<DatabaseBooking>();

        //public void AddBooking(DatabaseBooking booking)
        //{
        //    if (booking == null)
        //        throw new ArgumentNullException(nameof(booking));

        //    if (DatabaseOffer.AvailableSeats < 1)
        //        throw new InvalidOperationException("No available seats.");

        //    DatabaseBookings.Add(booking);
        //    PassengersCount = CalculatePassengersCount();
        //}

        //public void RemoveBooking(DatabaseBooking booking)
        //{
        //    if (booking == null)
        //        throw new ArgumentNullException(nameof(booking));

        //    DatabaseBookings.Remove(booking);
        //    PassengersCount = CalculatePassengersCount();
        //}

        public int CalculatePassengersCount()
        {
            return DatabaseBookings
                .Where(b => b.Status == Core.Others.BookingStatus.Accepted)
                .Sum(b => b.BookedSeats);
        }
    }
}
