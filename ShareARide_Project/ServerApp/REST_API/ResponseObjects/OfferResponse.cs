using Core.Others;

namespace REST_API.ResponseObjects
{
    public class OfferResponse
    {
        public int Id { get; set; }
        public int DriverId { get; set; }
        public string DriverName { get; set; }
        public string DriverPhoneNumber { get; set; }
        public int DriverAge { get; set; }
        public int VehicleId { get; set; }
        public string VehicleMake { get; set; }
        public string VehicleModel { get; set; }
        public int VehicleYear { get; set; }
        public DateTime DepartureTime { get; set; }
        public string DepartureCityName { get; set; }
        public string DestinationCityName { get; set; }
        public CityResponse DepartureCity { get; set; }
        public CityResponse DestinationCity { get; set; }
        public decimal PricePerSeat { get; set; }
        public int AvailableSeats { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime ExpiresOn { get; set; }
        public OfferStatus Status { get; set; }
    }
}
