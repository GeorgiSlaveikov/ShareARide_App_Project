namespace REST_API.RequestObjects
{
    public class RatingCreateRequest
    {
        public int RatedUserId { get; set; }

        public int RatedByUserId { get; set; }

        public int RideId { get; set; }

        public int Score { get; set; }

        public string? Comment { get; set; }
    }
}
