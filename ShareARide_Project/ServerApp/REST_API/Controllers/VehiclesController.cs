using Core.Others;
using DatabaseLayer.Database;
using DatabaseLayer.DatabaseModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using REST_API.Objects;

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
        public async Task<ActionResult<IEnumerable<DatabaseVehicle>>> GetVehicles()
        {
            return await _context.Vehicles.ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<DatabaseVehicle>> GetVehicle(int id)
        {
            var user = await _context.Vehicles.FindAsync(id);
            if (user == null) return NotFound();
            return Ok(user);
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
        public async Task<ActionResult<IEnumerable<DatabaseVehicle>>> GetMyVehicles(int id)
        {
            return await _context.Vehicles.Where(vehicle => vehicle.OwnerId == id).ToListAsync();
        }

        [HttpPost("create")]
        public async Task<ActionResult<DatabaseVehicle>> CreateVehicle([FromBody] VehicleApiObject vehicleApiObject)
        {
            VehicleMake vehicleMake = VehicleMake.BMW;
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
