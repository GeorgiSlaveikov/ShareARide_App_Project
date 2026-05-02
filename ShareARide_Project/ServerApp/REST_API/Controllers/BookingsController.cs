using DatabaseLayer.Database;
using DatabaseLayer.DatabaseModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using REST_API.Objects;
using REST_API.RequestObjects;
using REST_API.ResponseObjects;
using System.Linq;

namespace REST_API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class BookingsController : ControllerBase
    {
        private readonly DatabaseContext _context;
        public BookingsController(DatabaseContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<BookingResponse>>> GetBookings()
        {
            return await _context.Bookings
                .AsNoTracking() 
                .Select(b => new BookingResponse
                {
                    Id = b.Id,
                    OfferId = b.OfferId,
                    DepartureCityName = b.DatabaseOffer.DatabaseDepartureCity.Name,
                    DestinationCityName = b.DatabaseOffer.DatabaseDestinationCity.Name,
                    DepartureTime = b.DatabaseOffer.DepartureTime,
                    DriverName = b.DatabaseOffer.DatabaseDriver.FirstName + " " + b.DatabaseOffer.DatabaseDriver.LastName,
                    RequesterId = b.RequesterId,
                    RequesterName = b.DatabaseRequester.FirstName + " " + b.DatabaseRequester.LastName,
                    RequestedForId = b.RequestedForId,
                    RequestedForName = b.DatabaseRequestedFor.FirstName + " " + b.DatabaseRequestedFor.LastName,
                    BookedSeats = b.BookedSeats,
                    PricePerSeat = b.DatabaseOffer.PricePerSeat,
                    TotalPrice = b.TotalPrice,
                    Status = b.Status,
                    CreatedAt = b.CreatedAt
                })
                .ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<DatabaseBooking>> GetBooking(int id)
        {
            var booking = await _context.Bookings
                .AsNoTracking()
                .Where(b => b.Id == id)
                .Select(b => new BookingResponse
            {
                Id = b.Id,
                OfferId = b.OfferId,
                DepartureCityName = b.DatabaseOffer.DatabaseDepartureCity.Name,
                DestinationCityName = b.DatabaseOffer.DatabaseDestinationCity.Name,
                DepartureTime = b.DatabaseOffer.DepartureTime,
                DriverName = b.DatabaseOffer.DatabaseDriver.FirstName + " " + b.DatabaseOffer.DatabaseDriver.LastName,
                RequesterId = b.RequesterId,
                RequesterName = b.DatabaseRequester.FirstName + " " + b.DatabaseRequester.LastName,
                RequestedForId = b.RequestedForId,
                RequestedForName = b.DatabaseRequestedFor.FirstName + " " + b.DatabaseRequestedFor.LastName,
                BookedSeats = b.BookedSeats,
                PricePerSeat = b.DatabaseOffer.PricePerSeat,
                TotalPrice = b.TotalPrice,
                Status = b.Status,
                CreatedAt = b.CreatedAt
            }).FirstOrDefaultAsync();
           
            if (booking == null) return NotFound();
            return Ok(booking);
        }

        [HttpGet("requests_for_user/{id}")]
        public async Task<ActionResult<IEnumerable<BookingResponse>>> GetBookingsForMe(int id)
        {
            return await _context.Bookings
                .AsNoTracking()
                .Where(b => b.DatabaseOffer.DriverId == id && b.Status == Core.Others.BookingStatus.Pending)
                .Select(b => new BookingResponse
                {
                    Id = b.Id,
                    OfferId = b.OfferId,
                    DepartureCityName = b.DatabaseOffer.DatabaseDepartureCity.Name,
                    DestinationCityName = b.DatabaseOffer.DatabaseDestinationCity.Name,
                    DepartureTime = b.DatabaseOffer.DepartureTime,
                    DriverName = b.DatabaseOffer.DatabaseDriver.FirstName + " " + b.DatabaseOffer.DatabaseDriver.LastName,
                    RequesterId = b.RequesterId,
                    RequesterName = b.DatabaseRequester.FirstName + " " + b.DatabaseRequester.LastName,
                    RequestedForId = b.RequestedForId,
                    RequestedForName = b.DatabaseRequestedFor.FirstName + " " + b.DatabaseRequestedFor.LastName,
                    BookedSeats = b.BookedSeats,
                    PricePerSeat = b.DatabaseOffer.PricePerSeat,
                    TotalPrice = b.TotalPrice,
                    Status = b.Status,
                    CreatedAt = b.CreatedAt
                })
                .ToListAsync();
        }

        [HttpGet("requests_from_user/{id}")]
        public async Task<ActionResult<IEnumerable<BookingResponse>>> GetBookingsFromMe(int id)
        {
            return await _context.Bookings
               .AsNoTracking()
               .Where(b => b.RequesterId == id)
               .Select(b => new BookingResponse
               {
                   Id = b.Id,
                   OfferId = b.OfferId,
                   DepartureCityName = b.DatabaseOffer.DatabaseDepartureCity.Name,
                   DestinationCityName = b.DatabaseOffer.DatabaseDestinationCity.Name,
                   DepartureTime = b.DatabaseOffer.DepartureTime,
                   DriverName = b.DatabaseOffer.DatabaseDriver.FirstName + " " + b.DatabaseOffer.DatabaseDriver.LastName,
                   RequesterId = b.RequesterId,
                   RequesterName = b.DatabaseRequester.FirstName + " " + b.DatabaseRequester.LastName,
                   RequestedForId = b.RequestedForId,
                   RequestedForName = b.DatabaseRequestedFor.FirstName + " " + b.DatabaseRequestedFor.LastName,
                   BookedSeats = b.BookedSeats,
                   PricePerSeat = b.DatabaseOffer.PricePerSeat,
                   TotalPrice = b.TotalPrice,
                   Status = b.Status,
                   CreatedAt = b.CreatedAt
               })
               .ToListAsync();
        }

        [HttpPost("create")]
        public async Task<ActionResult<DatabaseOffer>> CreateBooking([FromBody] BookingCreateRequest request)
        {   
            Console.WriteLine("Requester Id: " + request.RequesterId);

            var offer = await _context.Offers
                .FirstOrDefaultAsync(o => o.Id == request.OfferId);

            if (offer == null)
            {
                return NotFound("Booking not found.");
            }

            DatabaseBooking newBooking = new DatabaseBooking()
            {
                RequestedForId = request.RequestedForId,
                DatabaseRequestedFor = _context.Users.FirstOrDefault(u => u.Id == request.RequestedForId),
                RequesterId = request.RequesterId,
                DatabaseRequester = _context.Users.FirstOrDefault(u => u.Id == request.RequesterId),
                OfferId = request.OfferId,
                DatabaseOffer = _context.Offers.FirstOrDefault(o => o.Id == request.OfferId),
                BookedSeats = request.BookedSeats,
                TotalPrice = request.BookedSeats * offer.PricePerSeat,
                CreatedAt = DateTime.Now
            };

            _context.Bookings.Add(newBooking);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetBooking), new { id = newBooking.Id }, request);
        }

        [HttpPut("accept")]
        public async Task<IActionResult> AcceptBooking([FromBody] BookingDecisionRequest request)
        {
            var booking = await _context.Bookings
                .Include(b => b.DatabaseOffer)
                .FirstOrDefaultAsync(b => b.Id == request.BookingId);

            if (booking == null)
            {
                return NotFound("Booking not found.");
            }

            if (booking.Status == Core.Others.BookingStatus.Accepted)
            {
                return BadRequest("Booking is already accepted.");
            }

            if (booking.Status == Core.Others.BookingStatus.Rejected)
            {
                return BadRequest("Rejected booking cannot be accepted.");
            }

            var ride = await _context.Rides
                .Include(r => r.DatabaseOffer)
                .FirstOrDefaultAsync(r => r.OfferId == booking.OfferId);

            if (ride == null)
            {
                ride = new DatabaseRide
                {
                    OfferId = booking.OfferId,
                    PassengersCount = 0,
                    Status = Core.Others.RideStatus.Open
                };

                _context.Rides.Add(ride);
                await _context.SaveChangesAsync();
            }

            if (ride.DatabaseOffer.AvailableSeats < booking.BookedSeats)
            {
                return BadRequest("Not enough available seats.");
            }

            booking.Accept();
            booking.RideId = ride.Id;

            ride.DatabaseOffer.AvailableSeats -= booking.BookedSeats;

            if (ride.DatabaseOffer.AvailableSeats <= 0)
            {
                ride.DatabaseOffer.AvailableSeats = 0;
                ride.DatabaseOffer.OfferStatus = Core.Others.OfferStatus.Full;
                //ride.Status = Core.Others.RideStatus.Full;
                ride.DatabaseOffer.OfferStatus = Core.Others.OfferStatus.Full;
            }

            await _context.SaveChangesAsync();

            ride.PassengersCount = await _context.Bookings
                .Where(b =>
                    b.RideId == ride.Id &&
                    b.Status == Core.Others.BookingStatus.Accepted
                )
                .SumAsync(b => b.BookedSeats);

            await _context.SaveChangesAsync();

            return Ok();
        }

        [HttpPut("reject")]
        public async Task<IActionResult> RejectBooking([FromBody] BookingDecisionRequest request)
        {
            var booking = await _context.Bookings
                .FirstOrDefaultAsync(b => b.Id == request.BookingId);

            if (booking == null)
            {
                return NotFound("Booking not found.");
            }

            if (booking.Status == Core.Others.BookingStatus.Accepted)
            {
                return BadRequest("Accepted booking cannot be rejected.");
            }

            if (booking.Status == Core.Others.BookingStatus.Rejected)
            {
                return BadRequest("Booking is already rejected.");
            }

            booking.Reject();

            await _context.SaveChangesAsync();

            return Ok();
        }
    }
}
