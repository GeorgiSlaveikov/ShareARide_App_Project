using Core.Model;
using DatabaseLayer.Database;
using DatabaseLayer.DatabaseModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using REST_API.Objects;

using DatabaseLayer.DatabaseControllers;

namespace REST_API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class OffersController : ControllerBase
    {
        private readonly DatabaseContext _context;
        public OffersController(DatabaseContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<DatabaseOffer>>> GetOffers()
        {
            return await _context.Offers.ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<DatabaseOffer>> GetOffer(int id)
        {
            var user = await _context.Offers.FindAsync(id);
            if (user == null) return NotFound();
            return Ok(user);
        }


        [HttpGet("other_offers/{id}")]
        public async Task<ActionResult<IEnumerable<DatabaseOffer>>> GetOtherOffers(int id)
        {
            return await _context.Offers.Where(offer => offer.DriverId != id).ToListAsync();
        }

        [HttpGet("my_offers/{id}")]
        public async Task<ActionResult<IEnumerable<DatabaseOffer>>> GetMyOffers(int id)
        {
            return await _context.Offers.Where(offer => offer.DriverId == id).ToListAsync();
        }

        [HttpPost("create")]
        public async Task<ActionResult<DatabaseOffer>> CreateOffer([FromBody] OfferApiObject offerApiObject)
        {
            DatabaseOffer newOffer = new DatabaseOffer()
            {
                DriverId = offerApiObject.DriverId,
                VehicleId = offerApiObject.VehicleId,
                DepartureTime = offerApiObject.DepartureTime,
                DepartureCityId = offerApiObject.DepartureCityId,
                DestinationCityId = offerApiObject.DestinationCityId,
                PricePerSeat = offerApiObject.PricePerSeat,
                CreatedAt = DateTime.Now,
                ExpiresOn = DateTime.Now,
                OfferStatus = Core.Others.OfferStatus.Active
            };

            _context.Offers.Add(newOffer);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetOffer), new { id = newOffer.Id }, newOffer);
        }

        [HttpPut("update_vehicle")]
        public async Task<IActionResult> UpdateVehicle([FromBody] OfferVehicleApiObject offerVehicleApiObject)
        {
            // 1. Find the offer in the database
            var offer = await _context.Offers.FindAsync(offerVehicleApiObject.OfferId);

            if (offer == null)
            {
                return NotFound("Offer not found.");
            }

            // 2. Validate that the new vehicle exists (Optional but recommended)
            var vehicleExists = await _context.Vehicles.AnyAsync(v => v.Id == offerVehicleApiObject.VehicleId);
            if (!vehicleExists)
            {
                return BadRequest("The selected vehicle does not exist.");
            }

            // 3. Update the vehicle ID
            offer.VehicleId = offerVehicleApiObject.VehicleId;

            try
            {
                await _context.SaveChangesAsync();
                return Ok(); // Returns HTTP 200 as expected by your Flutter code
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
    }
}
