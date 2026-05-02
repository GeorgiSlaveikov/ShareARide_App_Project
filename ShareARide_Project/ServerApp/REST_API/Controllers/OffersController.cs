using DatabaseLayer.Database;
using DatabaseLayer.DatabaseModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using REST_API.Objects;
using REST_API.RequestObjects;
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
                  VehicleId = o.VehicleId,
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
                  CreatedAt = o.CreatedAt,
                  ExpiresOn = o.ExpiresOn,
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
                    VehicleId = o.VehicleId,
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
                    CreatedAt = o.CreatedAt,
                    ExpiresOn = o.ExpiresOn,
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
            VehicleId = o.VehicleId,
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
            CreatedAt = o.CreatedAt,
            ExpiresOn = o.ExpiresOn,
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
            VehicleId = o.VehicleId,
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
            CreatedAt = o.CreatedAt,
            ExpiresOn = o.ExpiresOn,
            Status = o.OfferStatus
        })
        .ToListAsync();
        }

        [HttpPost("create")]
        public async Task<ActionResult<OfferResponse>> CreateOffer([FromBody] OfferCreateRequest request)
        {
            var driver = await _context.Users.FirstOrDefaultAsync(u => u.Id == request.DriverId);
            if (driver == null)
            {
                return BadRequest("Driver does not exist.");
            }

            var vehicle = await _context.Vehicles.FirstOrDefaultAsync(v => v.Id == request.VehicleId);
            if (vehicle == null)
            {
                return BadRequest("Vehicle does not exist.");
            }

            var departureCity = await _context.Cities.FirstOrDefaultAsync(c => c.Id == request.DepartureCityId);
            if (departureCity == null)
            {
                return BadRequest("Departure city does not exist.");
            }

            var destinationCity = await _context.Cities.FirstOrDefaultAsync(c => c.Id == request.DestinationCityId);
            if (destinationCity == null)
            {
                return BadRequest("Destination city does not exist.");
            }

            var newOffer = new DatabaseOffer
            {
                DriverId = request.DriverId,
                VehicleId = request.VehicleId,
                DepartureTime = request.DepartureTime,
                DepartureCityId = request.DepartureCityId,
                DestinationCityId = request.DestinationCityId,
                PricePerSeat = request.PricePerSeat,
                AvailableSeats = request.AvailableSeats,
                CreatedAt = DateTime.Now,
                ExpiresOn = request.DepartureTime.AddHours(-2),
                OfferStatus = Core.Others.OfferStatus.Active
            };

            _context.Offers.Add(newOffer);
            await _context.SaveChangesAsync();

            var response = new OfferResponse
            {
                Id = newOffer.Id,
                DriverId = newOffer.DriverId,
                DriverName = driver.FirstName + " " + driver.LastName,
                DriverAge = driver.Age,

                VehicleId = newOffer.VehicleId,
                VehicleMake = vehicle.Make.ToString(),
                VehicleModel = vehicle.Model,
                VehicleYear = vehicle.Year,

                DepartureTime = newOffer.DepartureTime,

                DepartureCityName = departureCity.Name,
                DestinationCityName = destinationCity.Name,

                DepartureCity = new CityResponse
                {
                    Id = departureCity.Id,
                    Name = departureCity.Name,
                    Latitude = departureCity.Latitude,
                    Longitude = departureCity.Longitude
                },

                DestinationCity = new CityResponse
                {
                    Id = destinationCity.Id,
                    Name = destinationCity.Name,
                    Latitude = destinationCity.Latitude,
                    Longitude = destinationCity.Longitude
                },

                PricePerSeat = newOffer.PricePerSeat,
                AvailableSeats = newOffer.AvailableSeats,
                CreatedAt = newOffer.CreatedAt,
                ExpiresOn = newOffer.ExpiresOn,
                Status = newOffer.OfferStatus
            };

            return CreatedAtAction(nameof(GetOffer), new { id = newOffer.Id }, response);
        }

        [HttpPut("update_vehicle")]
        public async Task<IActionResult> UpdateVehicle([FromBody] OfferVehicleUpdateRequest request)
        {
            var offer = await _context.Offers.FindAsync(request.OfferId);

            if (offer == null)
            {
                return NotFound("Offer not found.");
            }

            var vehicleExists = await _context.Vehicles.AnyAsync(v => v.Id == request.VehicleId);
            if (!vehicleExists)
            {
                return BadRequest("The selected vehicle does not exist.");
            }

            offer.VehicleId = request.VehicleId;

            try
            {
                await _context.SaveChangesAsync();
                return Ok(); 
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        [HttpPut("update")]
        public async Task<IActionResult> UpdateOffer([FromBody] OfferUpdateRequest request)
        {
            var offer = await _context.Offers.FirstOrDefaultAsync(o => o.Id == request.OfferId);

            if (offer == null)
                return NotFound("Offer not found.");

            var vehicle = await _context.Vehicles.FirstOrDefaultAsync(v => v.Id == request.VehicleId);

            if (vehicle == null)
                return BadRequest("Selected vehicle does not exist.");

            var departureCity = await _context.Cities.FirstOrDefaultAsync(c => c.Id == request.DepartureCityId);

            if (departureCity == null)
                return BadRequest("Departure city does not exist.");

            var destinationCity = await _context.Cities.FirstOrDefaultAsync(c => c.Id == request.DestinationCityId);

            if (destinationCity == null)
                return BadRequest("Destination city does not exist.");

            if (request.DepartureCityId == request.DestinationCityId)
                return BadRequest("Departure city and destination city cannot be the same.");

            if (request.PricePerSeat <= 0)
                return BadRequest("Price per seat must be greater than zero.");

            if (request.AvailableSeats <= 0)
                return BadRequest("Available seats must be greater than zero.");

            if (request.AvailableSeats > vehicle.MaxCapacity)
                return BadRequest("Available seats cannot be greater than vehicle capacity.");

            offer.VehicleId = request.VehicleId;
            offer.DepartureTime = request.DepartureTime;
            offer.DepartureCityId = request.DepartureCityId;
            offer.DestinationCityId = request.DestinationCityId;
            offer.PricePerSeat = request.PricePerSeat;
            offer.AvailableSeats = request.AvailableSeats;

            offer.ExpiresOn = request.DepartureTime.AddHours(-2);

            await _context.SaveChangesAsync();

            return Ok();
        }
    }
}
