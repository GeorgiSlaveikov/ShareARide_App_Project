namespace REST_API.Objects
{
    public class OfferCreateRequest
    {
        public int DriverId { get; set; }
        public int VehicleId { get; set; }
        public int DepartureCityId { get; set; }
        public int DestinationCityId { get; set; }
        public decimal PricePerSeat { get; set; }
        public int AvailableSeats { get; set; }
        public DateTime DepartureTime { get; set; }
    }
}
