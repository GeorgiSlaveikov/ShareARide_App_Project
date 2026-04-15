using DatabaseLayer.Database;
using DatabaseLayer.DatabaseModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using REST_API.Objects;
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
        public async Task<ActionResult<IEnumerable<DatabaseBooking>>> GetBookings()
        {
            return await _context.Bookings.ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<DatabaseBooking>> GetBooking(int id)
        {
            var booking = await _context.Bookings.FindAsync(id);
            if (booking == null) return NotFound();
            return Ok(booking);
        }

        [HttpGet("requests_for_me/{id}")]
        public async Task<ActionResult<IEnumerable<DatabaseBooking>>> GetBookingsForMe(int id)
        {
            return await _context.Bookings.Where(booking => booking.RequestedForId == id).ToListAsync();
        }


        [HttpPost("create")]
        public async Task<ActionResult<DatabaseOffer>> CreateBooking([FromBody] BookingApiObject bookingApiObject)
        {
            DatabaseBooking newBooking = new DatabaseBooking()
            {
                RequestedForId = bookingApiObject.RequestedForId,
                RequestorId = bookingApiObject.RequestorId,
                OfferId = bookingApiObject.OfferId,
                PassengersNames = bookingApiObject.passengers,
                CreatedAt = DateTime.Now,
                Passengers = new List<Core.Model.User>(),
                TotalPrice = 12,
                Status = Core.Others.BookingStatus.Pending,

            };

            _context.Bookings.Add(newBooking);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetBooking), new { id = newBooking.Id }, bookingApiObject);
        }
    }
}
