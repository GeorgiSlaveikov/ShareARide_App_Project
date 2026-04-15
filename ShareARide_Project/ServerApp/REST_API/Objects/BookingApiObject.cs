namespace REST_API.Objects
{
    public class BookingApiObject
    {
        public int RequestedForId { get; set; }
        public int RequestorId { get; set; }
        public int OfferId { get; set; }
        public List<String> passengers { get; set; }
    }
}
