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
                    OwnerName = v.DatabaseOwner.FirstName + " " + v.DatabaseOwner.LastName,
                    VehiclePicturePath = v.VehiclePicturePath,
                    IsDeleted = v.IsDeleted
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
                    OwnerName = v.DatabaseOwner.FirstName + " " + v.DatabaseOwner.LastName,
                    VehiclePicturePath = v.VehiclePicturePath,
                    IsDeleted = v.IsDeleted
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
            var vehicle = await _context.Vehicles
                .FirstOrDefaultAsync(v => v.Id == id);

            if (vehicle == null)
            {
                return NotFound("Vehicle not found.");
            }

            if (vehicle.IsDeleted)
            {
                return BadRequest("Vehicle is already archived.");
            }

            bool wasEverUsed = await _context.Offers
                .AnyAsync(o => o.VehicleId == id);

            if (wasEverUsed)
            {
                vehicle.IsDeleted = true;
                await _context.SaveChangesAsync();

                return Ok(new
                {
                    message = "Vehicle was used before, so it was archived instead of deleted.",
                    archived = true
                });
            }

            _context.Vehicles.Remove(vehicle);
            await _context.SaveChangesAsync();

            return Ok(new
            {
                message = "Vehicle deleted successfully.",
                archived = false
            });
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
                    OwnerName = v.DatabaseOwner.FirstName + " " + v.DatabaseOwner.LastName,
                    VehiclePicturePath = v.VehiclePicturePath,
                    IsDeleted = v.IsDeleted
                }).ToListAsync(); ;
        }

        [HttpPost("create")]
        public async Task<ActionResult<DatabaseVehicle>> CreateVehicle([FromForm] VehicleCreateRequest request)
        {
            VehicleMake vehicleMake = VehicleMake.Unknown;
            if (Enum.TryParse<VehicleMake>(request.Make, true, out var make))
            {
                vehicleMake = make;
            }
            else
            {
                Console.WriteLine("Invalid vehicle make.");
            }

            string? imagePath = null;

            if (request.VehiclePicture != null && request.VehiclePicture.Length > 0)
            {
                var uploadsFolder = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/uploads/vehicles");
                if (!Directory.Exists(uploadsFolder)) Directory.CreateDirectory(uploadsFolder);

                var fileName = $"{Guid.NewGuid()}_{request.VehiclePicture.FileName}";
                var fullPath = Path.Combine(uploadsFolder, fileName);

                using (var stream = new FileStream(fullPath, FileMode.Create))
                {
                    await request.VehiclePicture.CopyToAsync(stream);
                }

                imagePath = $"/uploads/vehicles/{fileName}";
            }

            DatabaseVehicle newVehicle = new DatabaseVehicle()
            {
                Make = vehicleMake,
                Model = request.Model,
                Year = request.Year,
                MaxCapacity = request.MaxCapacity,
                OwnerId = request.OwnerId,
                VehiclePicturePath = imagePath,
                IsDeleted = false
            };

            _context.Vehicles.Add(newVehicle);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetVehicle), new { id = newVehicle.Id }, newVehicle);
        }
    }
}
