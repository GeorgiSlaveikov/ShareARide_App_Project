namespace REST_API.ResponseObjects
{
    public class RatingResponse
    {
        public int Id { get; set; }

        public int RatedUserId { get; set; }

        public string RatedUserName { get; set; } = string.Empty;

        public int RatedByUserId { get; set; }

        public string RatedByUserName { get; set; } = string.Empty;

        public int RideId { get; set; }

        public int Score { get; set; }

        public string? Comment { get; set; }

        public DateTime CreatedAt { get; set; }
    }
}
