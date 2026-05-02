using DatabaseLayer.Database;
using DatabaseLayer.DatabaseModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using REST_API.RequestObjects;
using REST_API.ResponseObjects;

namespace REST_API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class RatingsController : ControllerBase
    {
        private readonly DatabaseContext _context;

        public RatingsController(DatabaseContext context)
        {
            _context = context;
        }

        [HttpGet("for_user/{userId}")]
        public async Task<ActionResult<IEnumerable<RatingResponse>>> GetRatingsForUser(int userId)
        {
            var ratings = await _context.Ratings
                .AsNoTracking()
                .Where(r => r.RatedUserId == userId)
                .Select(r => new RatingResponse
                {
                    Id = r.Id,
                    RatedUserId = r.RatedUserId,
                    RatedUserName = r.RatedUser.FirstName + " " + r.RatedUser.LastName,
                    RatedByUserId = r.RatedByUserId,
                    RatedByUserName = r.RatedByUser.FirstName + " " + r.RatedByUser.LastName,
                    RideId = r.RideId,
                    Score = r.Score,
                    Comment = r.Comment,
                    CreatedAt = r.CreatedAt
                })
                .ToListAsync();

            return Ok(ratings);
        }

        [HttpGet("summary/{userId}")]
        public async Task<IActionResult> GetRatingSummary(int userId)
        {
            var userExists = await _context.Users.AnyAsync(u => u.Id == userId);

            if (!userExists)
                return NotFound("User not found.");

            var ratingsQuery = _context.Ratings
                .AsNoTracking()
                .Where(r => r.RatedUserId == userId);

            var ratingsCount = await ratingsQuery.CountAsync();

            var averageRating = ratingsCount == 0
                ? 0
                : await ratingsQuery.AverageAsync(r => r.Score);

            return Ok(new
            {
                userId,
                rating = Math.Round(averageRating, 2),
                ratingsCount
            });
        }

        [HttpGet("by_user_for_ride/{rideId}/{ratedByUserId}")]
        public async Task<IActionResult> GetRatingByUserForRide(int rideId, int ratedByUserId)
        {
            var rating = await _context.Ratings
                .AsNoTracking()
                .Where(r => r.RideId == rideId && r.RatedByUserId == ratedByUserId)
                .Select(r => new RatingResponse
                {
                    Id = r.Id,
                    RatedUserId = r.RatedUserId,
                    RatedUserName = r.RatedUser.FirstName + " " + r.RatedUser.LastName,
                    RatedByUserId = r.RatedByUserId,
                    RatedByUserName = r.RatedByUser.FirstName + " " + r.RatedByUser.LastName,
                    RideId = r.RideId,
                    Score = r.Score,
                    Comment = r.Comment,
                    CreatedAt = r.CreatedAt
                })
                .FirstOrDefaultAsync();

            if (rating == null)
                return NotFound();

            return Ok(rating);
        }

        [HttpPost("create")]
        public async Task<IActionResult> CreateRating([FromBody] RatingCreateRequest request)
        {
            if (request.Score < 1 || request.Score > 5)
                return BadRequest("Rating must be between 1 and 5.");

            if (request.RatedUserId == request.RatedByUserId)
                return BadRequest("You cannot rate yourself.");

            var ride = await _context.Rides
                .Include(r => r.DatabaseOffer)
                .FirstOrDefaultAsync(r => r.Id == request.RideId);

            if (ride == null)
                return BadRequest("Ride does not exist.");

            if (ride.Status != Core.Others.RideStatus.Finished)
                return BadRequest("You can rate only finished rides.");

            if (ride.DatabaseOffer.DriverId != request.RatedUserId)
                return BadRequest("Only the driver of this ride can be rated.");

            var wasPassenger = await _context.Bookings
                .AnyAsync(b =>
                    b.RideId == request.RideId &&
                    b.Status == Core.Others.BookingStatus.Accepted &&
                    (
                        b.RequesterId == request.RatedByUserId ||
                        b.RequestedForId == request.RatedByUserId
                    )
                );

            if (!wasPassenger)
                return BadRequest("Only accepted passengers can rate this driver.");

            var alreadyRated = await _context.Ratings
                .AnyAsync(r =>
                    r.RideId == request.RideId &&
                    r.RatedUserId == request.RatedUserId &&
                    r.RatedByUserId == request.RatedByUserId
                );

            if (alreadyRated)
                return BadRequest("You already rated this driver for this ride.");

            var rating = new DatabaseRating
            {
                RatedUserId = request.RatedUserId,
                RatedByUserId = request.RatedByUserId,
                RideId = request.RideId,
                Score = request.Score,
                Comment = request.Comment,
                CreatedAt = DateTime.Now
            };

            _context.Ratings.Add(rating);

            var driver = await _context.Users.FirstOrDefaultAsync(u => u.Id == request.RatedUserId);

            await _context.SaveChangesAsync();

            if (driver != null)
            {
                var averageRating = await _context.Ratings
                    .Where(r => r.RatedUserId == request.RatedUserId)
                    .AverageAsync(r => r.Score);

                driver.Rating = Math.Round((decimal)averageRating, 2);

                await _context.SaveChangesAsync();
            }

            return Ok(new
            {
                message = "Rating submitted successfully.",
                score = request.Score
            });
        }
    }
}