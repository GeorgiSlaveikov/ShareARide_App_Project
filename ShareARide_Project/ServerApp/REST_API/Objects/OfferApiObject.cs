namespace REST_API.Objects
{
    public class OfferApiObject
    {
        public int DriverId { get; set; }
        public int VehicleId { get; set; }
        public int DepartureCityId { get; set; }
        public int DestinationCityId { get; set; }
        public double PricePerSeat { get; set; }
        public DateTime DepartureTime { get; set; }
    }
}
