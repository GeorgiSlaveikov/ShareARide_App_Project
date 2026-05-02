using Core.Model;
using DatabaseLayer.Database;
using DatabaseLayer.DatabaseModels;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using REST_API.Objects;
using REST_API.RequestObjects;
using REST_API.ResponseObjects;

namespace REST_API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class RidesController : ControllerBase
    {
        private readonly DatabaseContext _context;
        public RidesController(DatabaseContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<RideResponse>>> GetRides()
        {
            var rides = await _context.Rides
                .AsNoTracking()
                .Select(r => new RideResponse
                {
                    Id = r.Id,
                    OfferId = r.OfferId,

                    DepartureCityName = r.DatabaseOffer.DatabaseDepartureCity.Name,
                    DestinationCityName = r.DatabaseOffer.DatabaseDestinationCity.Name,
                    DepartureTime = r.DatabaseOffer.DepartureTime,

                    DriverId = r.DatabaseOffer.DriverId,
                    DriverName = r.DatabaseOffer.DatabaseDriver.FirstName + " " + r.DatabaseOffer.DatabaseDriver.LastName,

                    Status = r.Status,
                    AvailableSeats = r.DatabaseOffer.AvailableSeats,
                    PassengersCount = r.PassengersCount,

                    VehicleId = r.DatabaseOffer.VehicleId,
                    VehicleMake = r.DatabaseOffer.DatabaseVehicle.Make.ToString(),
                    VehicleModel = r.DatabaseOffer.DatabaseVehicle.Model,
                    VehicleYear = r.DatabaseOffer.DatabaseVehicle.Year,
                    DatabaseBookings = r.DatabaseBookings
                })
                .ToListAsync();

            return Ok(rides);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<DatabaseRide>> GetRide(int id)
        {
            var booking = await _context.Rides
                .AsNoTracking()
                .Where(r => r.Id == id)
                .Select(r => new RideResponse
                {
                    Id = r.Id,
                    OfferId = r.OfferId,
                    DepartureCityName = r.DatabaseOffer.DatabaseDepartureCity.Name,
                    DestinationCityName = r.DatabaseOffer.DatabaseDestinationCity.Name,
                    DepartureTime = r.DatabaseOffer.DepartureTime,
                    DriverId = r.DatabaseOffer.DriverId,
                    DriverName = r.DatabaseOffer.DatabaseDriver.FirstName + " " + r.DatabaseOffer.DatabaseDriver.LastName,
                    Status = r.Status,
                    PricePerSeat = r.DatabaseOffer.PricePerSeat,
                    AvailableSeats = r.DatabaseOffer.AvailableSeats,
                    PassengersCount = r.PassengersCount,
                    VehicleId = r.DatabaseOffer.VehicleId,
                    VehicleMake = r.DatabaseOffer.DatabaseVehicle.Make.ToString(),
                    VehicleModel = r.DatabaseOffer.DatabaseVehicle.Model,
                    VehicleYear = r.DatabaseOffer.DatabaseVehicle.Year,
                    DatabaseBookings = r.DatabaseBookings
                    
                }).FirstOrDefaultAsync();

            if (booking == null) return NotFound();
            return Ok(booking);
        }

        [HttpPost("create")]
        public async Task<ActionResult<RideResponse>> CreateRide([FromBody] RideCreateRequest request)
        {
            var offer = await _context.Offers
                .Include(o => o.DatabaseDriver)
                .Include(o => o.DatabaseVehicle)
                .Include(o => o.DatabaseDepartureCity)
                .Include(o => o.DatabaseDestinationCity)
                .FirstOrDefaultAsync(o => o.Id == request.OfferId);

            if (offer == null)
                return BadRequest("Offer does not exist.");

            var ride = new DatabaseRide
            {
                OfferId = request.OfferId,
                PassengersCount = 0,
                Status = Core.Others.RideStatus.Open,
                DatabaseOffer = offer
            };

            _context.Rides.Add(ride);
            await _context.SaveChangesAsync();

            var response = new RideResponse
            {
                Id = ride.Id,
                OfferId = ride.OfferId,
                PassengersCount = ride.PassengersCount,
                Status = ride.Status,
                PricePerSeat = offer.PricePerSeat,
                AvailableSeats = offer.AvailableSeats,
                DriverId = offer.DriverId,
                DriverName = offer.DatabaseDriver.FirstName + " " + offer.DatabaseDriver.LastName,
                DepartureTime = offer.DepartureTime,
                DepartureCityName = offer.DatabaseDepartureCity.Name,
                DestinationCityName = offer.DatabaseDestinationCity.Name,
                VehicleMake = offer.DatabaseVehicle.Make.ToString(),
                VehicleModel = offer.DatabaseVehicle.Model,
                VehicleYear = offer.DatabaseVehicle.Year,
                DatabaseBookings = []
            };

            return CreatedAtAction(nameof(GetRide), new { id = ride.Id }, response);
        }

        [HttpGet("related_to_user/{userId}")]
        public async Task<ActionResult<IEnumerable<RideResponse>>> GetRidesRelatedToUser(int userId)
        {
            var rides = await _context.Rides
                .AsNoTracking()
                .Where(r =>
                    r.DatabaseOffer.DriverId == userId ||
                    r.DatabaseBookings.Any(b =>
                        b.RequesterId == userId ||
                        b.RequestedForId == userId
                    )
                )
                .Select(r => new RideResponse
                {
                    Id = r.Id,
                    OfferId = r.OfferId,

                    DepartureCityName = r.DatabaseOffer.DatabaseDepartureCity.Name,
                    DestinationCityName = r.DatabaseOffer.DatabaseDestinationCity.Name,
                    DepartureTime = r.DatabaseOffer.DepartureTime,

                    DriverId = r.DatabaseOffer.DriverId,
                    DriverName = r.DatabaseOffer.DatabaseDriver.FirstName + " " + r.DatabaseOffer.DatabaseDriver.LastName,

                    Status = r.Status,
                    AvailableSeats = r.DatabaseOffer.AvailableSeats,
                    PassengersCount = r.PassengersCount,
                    PricePerSeat = r.DatabaseOffer.PricePerSeat,

                    VehicleId = r.DatabaseOffer.VehicleId,
                    VehicleMake = r.DatabaseOffer.DatabaseVehicle.Make.ToString(),
                    VehicleModel = r.DatabaseOffer.DatabaseVehicle.Model,
                    VehicleYear = r.DatabaseOffer.DatabaseVehicle.Year,

                    DatabaseBookings = r.DatabaseBookings
                        .Where(b => b.Status == Core.Others.BookingStatus.Accepted)
                        .ToList()
                })
                .ToListAsync();

            return Ok(rides);
        }

        [HttpPut("{id}/cancel")]
        public async Task<IActionResult> CancelRide(int id)
        {
            var ride = await _context.Rides
                .Include(r => r.DatabaseOffer)
                .FirstOrDefaultAsync(r => r.Id == id);

            if (ride == null)
            {
                return NotFound("Ride not found.");
            }

            if (ride.Status == Core.Others.RideStatus.Finished)
            {
                return BadRequest("Completed ride cannot be cancelled.");
            }

            ride.Status = Core.Others.RideStatus.Cancelled;

            if (ride.DatabaseOffer != null)
            {
                ride.DatabaseOffer.OfferStatus = Core.Others.OfferStatus.Cancelled;
            }

            await _context.SaveChangesAsync();

            return Ok();
        }

        [HttpPut("{id}/finish")]
        public async Task<IActionResult> FinishRide(int id)
        {
            var ride = await _context.Rides
                .Include(r => r.DatabaseOffer)
                .FirstOrDefaultAsync(r => r.Id == id);

            if (ride == null)
            {
                return NotFound("Ride not found.");
            }

            if (ride.Status == Core.Others.RideStatus.Cancelled)
            {
                return BadRequest("Cancelled ride cannot be finished.");
            }

            ride.Status = Core.Others.RideStatus.Finished;

            //if (ride.DatabaseOffer != null)
            //{
            //    ride.DatabaseOffer.OfferStatus = Core.Others.OfferStatus.;
            //}

            await _context.SaveChangesAsync();

            return Ok();
        }
    }
}
