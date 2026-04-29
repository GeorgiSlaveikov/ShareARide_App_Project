using DatabaseLayer.Database;
using DatabaseLayer.DatabaseModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using REST_API.Objects;
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
                    RequesterId = b.RequestorId,
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
                    RequesterName = b.DatabaseRequester.FirstName + " " + b.DatabaseRequester.LastName,
                    BookedSeats = b.BookedSeats,
                    PricePerSeat = b.DatabaseOffer.PricePerSeat,
                    TotalPrice = b.TotalPrice,
                    Status = b.Status,
                    CreatedAt = b.CreatedAt
                }).FirstOrDefaultAsync();

            if (booking == null) return NotFound();
            return Ok(booking);
        }


        [HttpPost("create")]
        public async Task<ActionResult<DatabaseOffer>> CreateBooking([FromBody] BookingCreateRequest request)
        {
            DatabaseBooking newBooking = new DatabaseBooking()
            {
                RequestedForId = request.RequestedForId,
                DatabaseRequestedFor = _context.Users.FirstOrDefault(u => u.Id == request.RequestedForId),
                RequestorId = request.RequesterId,
                DatabaseRequester = _context.Users.FirstOrDefault(u => u.Id == request.RequesterId),
                OfferId = request.OfferId,
                DatabaseOffer = _context.Offers.FirstOrDefault(o => o.Id == request.OfferId),
                CreatedAt = DateTime.Now

            };

            _context.Bookings.Add(newBooking);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetBooking), new { id = newBooking.Id }, request);
        }
    }
}
