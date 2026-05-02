namespace REST_API.RequestObjects
{
    public class OfferUpdateRequest
    {
        public int OfferId { get; set; }

        public int VehicleId { get; set; }

        public DateTime DepartureTime { get; set; }

        public int DepartureCityId { get; set; }

        public int DestinationCityId { get; set; }

        public decimal PricePerSeat { get; set; }

        public int AvailableSeats { get; set; }
    }
}
