using Core.Others;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Core.Model
{
    public class Offer
    {
        private int id;
        private Vehicle vehicle;
        private DateTime departureTime;
        private City departureCity;
        private City destinationCity;
        private decimal pricePerSeat;
        //private int availableSeats;
        private DateTime createdAt;
        private DateTime expiresOn;
        private OfferStatus status;

        public Offer() { }

        public Offer(int id, Vehicle vehicle, DateTime departureTime, City departureCity,
            City destinationCity, decimal pricePerSeat, DateTime expiresOn)
        {
            Id = id;
            Vehicle = vehicle;
            DepartureTime = departureTime;
            DepartureCity = departureCity;
            DestinationCity = destinationCity;
            PricePerSeat = pricePerSeat;
            CreatedAt = DateTime.Now;
            ExpiresOn = CalculateExpirationTime();
            OfferStatus = OfferStatus.Active;
        }

        public virtual int Id { get => id; set => id = value; }
        public Vehicle Vehicle { get => vehicle; set => vehicle = value; }
        public DateTime DepartureTime { get => departureTime; set => departureTime = value; }
        public City DepartureCity { get => departureCity; set => departureCity = value; }
        public City DestinationCity { get => destinationCity; set => destinationCity = value; }
        //public int AvailableSeats { get => availableSeats; set => availableSeats = value; }

        public decimal PricePerSeat
        {
            get => pricePerSeat;
            set
            {
                if (value <= 0)
                    throw new ArgumentOutOfRangeException(nameof(PricePerSeat), "Price per seat must not be negative.");
                pricePerSeat = value;
            }
        }

        public DateTime CreatedAt { get => createdAt; set => createdAt = value; }
        public DateTime ExpiresOn { get => expiresOn; set => expiresOn = value; }
        public OfferStatus OfferStatus { get => status; set => status = value; }

        public DateTime CalculateExpirationTime()
        {
            Console.WriteLine("Calculating expiration time!");
            return DepartureTime.AddHours(-2);
        }

    }
}
