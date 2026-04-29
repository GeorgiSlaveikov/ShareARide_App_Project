namespace REST_API.Objects
{
    public class BookingCreateRequest
    {
        public int RequestedForId { get; set; }
        public int RequesterId { get; set; }
        public int OfferId { get; set; }
    }
}
