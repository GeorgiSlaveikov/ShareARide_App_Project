using DatabaseLayer.Database;
using DatabaseLayer.DatabaseModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

using DatabaseLayer.DatabaseControllers;

using System.Linq;
using REST_API.Objects;

namespace REST_API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CitiesController : ControllerBase
    {
        private readonly DatabaseContext _context;
        public CitiesController(DatabaseContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<DatabaseCity>>> GetUsers()
        {
            return await _context.Cities.ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<DatabaseCity>> GetUser(int id)
        {
            var user = await _context.Cities.FindAsync(id);
            if (user == null) return NotFound();
            return Ok(user);
        }
    }
}
