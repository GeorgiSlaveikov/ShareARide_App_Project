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
    }
}
