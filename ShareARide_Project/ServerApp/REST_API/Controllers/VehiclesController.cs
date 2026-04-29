using Core.Others;
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
    public class VehiclesController : ControllerBase
    {
        private readonly DatabaseContext _context;
        public VehiclesController(DatabaseContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<VehicleResponse>>> GetVehicles()
        {
            return await _context.Vehicles.AsNoTracking()
                .Select(v => new VehicleResponse
                {
                    Id = v.Id,
                    Make = v.Make,
                    Model = v.Model,
                    Year = v.Year,
                    MaxCapacity = v.MaxCapacity,
                    OwnerId = v.OwnerId,
                    OwnerName = v.DatabaseOwner.FirstName + " " + v.DatabaseOwner.LastName
                }).ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<DatabaseVehicle>> GetVehicle(int id)
        {
            var vehicle = await _context.Vehicles
                .AsNoTracking()
                .Where(v => v.Id == id)
                .Select(v => new VehicleResponse
                {
                    Id = v.Id,
                    Make = v.Make, 
                    Model = v.Model,
                    Year = v.Year,
                    MaxCapacity = v.MaxCapacity,
                    OwnerId = v.OwnerId,
                    OwnerName = v.DatabaseOwner.FirstName + " " + v.DatabaseOwner.LastName
                })
                .FirstOrDefaultAsync();

            if (vehicle == null)
            {
                return NotFound($"Vehicle with ID {id} not found.");
            }

            return Ok(vehicle);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteVehicle(int id)
        {   
            var vehicle = await _context.Vehicles.FindAsync(id);

            if (vehicle == null)
            {
                return NotFound();
            }

            _context.Vehicles.Remove(vehicle);
            await _context.SaveChangesAsync();
            return NoContent();
        }

        [HttpGet("my_vehicles/{id}")]
        public async Task<ActionResult<IEnumerable<VehicleResponse>>> GetMyVehicles(int id)
        {
            return await _context.Vehicles
                .AsNoTracking()
                .Where(vehicle => vehicle.OwnerId == id)
                .Select(v => new VehicleResponse
                {
                    Id = v.Id,
                    Make = v.Make,
                    Model = v.Model,
                    Year = v.Year,
                    MaxCapacity = v.MaxCapacity,
                    OwnerId = v.OwnerId,
                    OwnerName = v.DatabaseOwner.FirstName + " " + v.DatabaseOwner.LastName
                }).ToListAsync(); ;
        }

        [HttpPost("create")]
        public async Task<ActionResult<DatabaseVehicle>> CreateVehicle([FromBody] VehicleCreateRequest vehicleApiObject)
        {
            VehicleMake vehicleMake = VehicleMake.Unknown;
            if (Enum.TryParse<VehicleMake>(vehicleApiObject.Make, true, out var make))
            {
                vehicleMake = make;
            }
            else
            {
                Console.WriteLine("Invalid vehicle make.");
            }

            DatabaseVehicle newVehicle = new DatabaseVehicle()
            {
                Make = vehicleMake,
                Model = vehicleApiObject.Model,
                Year = vehicleApiObject.Year,
                MaxCapacity = vehicleApiObject.MaxCapacity,
                OwnerId = vehicleApiObject.OwnerId
            };

            _context.Vehicles.Add(newVehicle);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetVehicle), new { id = newVehicle.Id }, newVehicle);
        }
    }
}
