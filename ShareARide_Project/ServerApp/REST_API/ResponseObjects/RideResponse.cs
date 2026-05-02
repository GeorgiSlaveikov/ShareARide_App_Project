using Core.Others;
using DatabaseLayer.DatabaseModels;

namespace REST_API.ResponseObjects
{
    public class RideResponse
    {
        public int Id { get; set; }
        public int OfferId { get; set; }
        public int PassengersCount { get; set; }
        public RideStatus Status { get; set; }
        public int AvailableSeats { get; set; }
        public decimal PricePerSeat { get; set; }
        public int DriverId { get; set; }
        public string DriverName { get; set; } = string.Empty;
        public DateTime DepartureTime { get; set; }
        public string DepartureCityName { get; set; } = string.Empty;
        public string DestinationCityName { get; set; } = string.Empty;
        public int VehicleId { get; set; }
        public string VehicleMake { get; set; } = string.Empty;
        public string VehicleModel { get; set; } = string.Empty;
        public int VehicleYear { get; set; }
        public ICollection<DatabaseBooking> DatabaseBookings { get; set; } = [];
    }
}
