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
    public class OffersController : ControllerBase
    {
        private readonly DatabaseContext _context;
        public OffersController(DatabaseContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<OfferResponse>>> GetOffers()
        {
            return await _context.Offers
              .AsNoTracking()
              .Select(o => new OfferResponse
              {
                  Id = o.Id,
                  DriverId = o.DriverId,
                  DriverName = o.DatabaseDriver.FirstName + " " + o.DatabaseDriver.LastName,
                  DriverAge = o.DatabaseDriver.Age,
                  VehicleMake = o.DatabaseVehicle.Make.ToString(),
                  VehicleModel = o.DatabaseVehicle.Model,
                  VehicleYear = o.DatabaseVehicle.Year,
                  DepartureTime = o.DepartureTime,
                  DepartureCityName = o.DatabaseDepartureCity.Name,
                  DestinationCityName = o.DatabaseDestinationCity.Name,
                  DepartureCity = new CityResponse
                  {
                      Id = o.DatabaseDepartureCity.Id,
                      Name = o.DatabaseDepartureCity.Name,
                      Latitude = o.DatabaseDepartureCity.Latitude,
                      Longitude = o.DatabaseDepartureCity.Longitude
                  },
                  DestinationCity = new CityResponse
                  {
                      Id = o.DatabaseDestinationCity.Id,
                      Name = o.DatabaseDestinationCity.Name,
                      Latitude = o.DatabaseDestinationCity.Latitude,
                      Longitude = o.DatabaseDestinationCity.Longitude
                  },
                  PricePerSeat = o.PricePerSeat,
                  AvailableSeats = o.AvailableSeats,
                  Status = o.OfferStatus
              }).ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<OfferResponse>> GetOffer(int id)
        {
            var offer = await _context.Offers
                .AsNoTracking()
                .Where(o => o.Id == id)
                .Select(o => new OfferResponse
                {
                    Id = o.Id,
                    DriverId = o.DriverId,
                    DriverName = o.DatabaseDriver.FirstName + " " + o.DatabaseDriver.LastName,
                    DriverAge = o.DatabaseDriver.Age,
                    VehicleMake = o.DatabaseVehicle.Make.ToString(),
                    VehicleModel = o.DatabaseVehicle.Model,
                    VehicleYear = o.DatabaseVehicle.Year,
                    DepartureTime = o.DepartureTime,
                    DepartureCityName = o.DatabaseDepartureCity.Name,
                    DestinationCityName = o.DatabaseDestinationCity.Name,
                    DepartureCity = new CityResponse
                    {
                        Id = o.DatabaseDepartureCity.Id,
                        Name = o.DatabaseDepartureCity.Name,
                        Latitude = o.DatabaseDepartureCity.Latitude,
                        Longitude = o.DatabaseDepartureCity.Longitude
                    },
                    DestinationCity = new CityResponse
                    {
                        Id = o.DatabaseDestinationCity.Id,
                        Name = o.DatabaseDestinationCity.Name,
                        Latitude = o.DatabaseDestinationCity.Latitude,
                        Longitude = o.DatabaseDestinationCity.Longitude
                    },
                    PricePerSeat = o.PricePerSeat,
                    AvailableSeats = o.AvailableSeats,
                    Status = o.OfferStatus
                }).FirstOrDefaultAsync();

            if (offer == null)
            {
                return NotFound($"Offer with ID {id} not found.");
            }

            return Ok(offer);
        }


        [HttpGet("other_offers/{id}")]
        public async Task<ActionResult<IEnumerable<OfferResponse>>> GetOtherOffers(int id)
        {
            return await _context.Offers
        .AsNoTracking()
        .Where(offer => offer.DriverId != id)
        .Select(o => new OfferResponse
        {
            Id = o.Id,
            DriverId = o.DriverId,
            DriverName = o.DatabaseDriver.FirstName + " " + o.DatabaseDriver.LastName,
            DriverAge = o.DatabaseDriver.Age,
            VehicleMake = o.DatabaseVehicle.Make.ToString(),
            VehicleModel = o.DatabaseVehicle.Model,
            VehicleYear = o.DatabaseVehicle.Year,
            DepartureTime = o.DepartureTime,
            DepartureCityName = o.DatabaseDepartureCity.Name,
            DestinationCityName = o.DatabaseDestinationCity.Name,
            DepartureCity = new CityResponse
            {
                Id = o.DatabaseDepartureCity.Id,
                Name = o.DatabaseDepartureCity.Name,
                Latitude = o.DatabaseDepartureCity.Latitude,
                Longitude = o.DatabaseDepartureCity.Longitude
            },
            DestinationCity = new CityResponse
            {
                Id = o.DatabaseDestinationCity.Id,
                Name = o.DatabaseDestinationCity.Name,
                Latitude = o.DatabaseDestinationCity.Latitude,
                Longitude = o.DatabaseDestinationCity.Longitude
            },
            PricePerSeat = o.PricePerSeat,
            AvailableSeats = o.AvailableSeats,
            Status = o.OfferStatus
        })
        .ToListAsync();
        }

        [HttpGet("my_offers/{id}")]
        public async Task<ActionResult<IEnumerable<OfferResponse>>> GetMyOffers(int id)
        {
            return await _context.Offers
        .AsNoTracking()
        .Where(offer => offer.DriverId == id)
        .Select(o => new OfferResponse
        {
            Id = o.Id,
            DriverId = o.DriverId,
            DriverName = o.DatabaseDriver.FirstName + " " + o.DatabaseDriver.LastName,
            DriverAge = o.DatabaseDriver.Age,
            VehicleMake = o.DatabaseVehicle.Make.ToString(),
            VehicleModel = o.DatabaseVehicle.Model,
            VehicleYear = o.DatabaseVehicle.Year,
            DepartureTime = o.DepartureTime,
            DepartureCityName = o.DatabaseDepartureCity.Name,
            DestinationCityName = o.DatabaseDestinationCity.Name,
            DepartureCity = new CityResponse
            {
                Id = o.DatabaseDepartureCity.Id,
                Name = o.DatabaseDepartureCity.Name,
                Latitude = o.DatabaseDepartureCity.Latitude,
                Longitude = o.DatabaseDepartureCity.Longitude
            },
            DestinationCity = new CityResponse
            {
                Id = o.DatabaseDestinationCity.Id,
                Name = o.DatabaseDestinationCity.Name,
                Latitude = o.DatabaseDestinationCity.Latitude,
                Longitude = o.DatabaseDestinationCity.Longitude
            },
            PricePerSeat = o.PricePerSeat,
            AvailableSeats = o.AvailableSeats,
            Status = o.OfferStatus
        })
        .ToListAsync();
        }

        [HttpPost("create")]
        public async Task<ActionResult<DatabaseOffer>> CreateOffer([FromBody] OfferCreateRequest request)
        {
            DatabaseOffer newOffer = new DatabaseOffer()
            {
                DriverId = request.DriverId,
                DatabaseDriver = _context.Users.FirstOrDefault(u => u.Id == request.DriverId) ?? new DatabaseUser(),
                VehicleId = request.VehicleId,
                DatabaseVehicle = _context.Vehicles.FirstOrDefault(v => v.Id == request.VehicleId) ?? new DatabaseVehicle(),
                DepartureTime = request.DepartureTime,
                DepartureCityId = request.DepartureCityId,
                DatabaseDestinationCity = _context.Cities.FirstOrDefault(c => c.Id == request.DestinationCityId) ?? new DatabaseCity(),
                DestinationCityId = request.DestinationCityId,
                DatabaseDepartureCity = _context.Cities.FirstOrDefault(c => c.Id == request.DepartureCityId) ?? new DatabaseCity(),
                PricePerSeat = request.PricePerSeat,
                AvailableSeats = request.AvailableSeats,
                CreatedAt = DateTime.Now,
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
