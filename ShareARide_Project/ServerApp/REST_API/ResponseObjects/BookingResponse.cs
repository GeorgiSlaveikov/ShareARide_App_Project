using Core.Others;

namespace REST_API.ResponseObjects
{
    public class BookingResponse
    {
        public int Id { get; set; }
        public int OfferId { get; set; }
        public string DepartureCityName { get; set; }
        public string DestinationCityName { get; set; }
        public DateTime DepartureTime { get; set; }
        public string DriverName { get; set; }
        public int RequesterId { get; set; }
        public string RequesterName { get; set; }
        public int RequestedForId { get; set; }
        public string RequestedForName { get; set; }
        public int BookedSeats { get; set; }
        public decimal PricePerSeat { get; set; }
        public decimal TotalPrice { get; set; }
        public BookingStatus Status { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
