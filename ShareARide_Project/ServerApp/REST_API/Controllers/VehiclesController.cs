using DatabaseLayer.Database;
using DatabaseLayer.DatabaseModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

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
        public async Task<ActionResult<IEnumerable<DatabaseVehicle>>> GetUsers()
        {
            return await _context.Vehicles.ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<DatabaseVehicle>> GetUser(int id)
        {
            var user = await _context.Cities.FindAsync(id);
            if (user == null) return NotFound();
            return Ok(user);
        }
    }
}
