using Core.Model;
using DatabaseLayer.Database;
using DatabaseLayer.DatabaseControllers;
using DatabaseLayer.DatabaseModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using REST_API.Objects;
using System.Linq;

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

        [HttpPost]
        public async Task<ActionResult<DatabaseCity>> CreateCity([FromBody] City city)
        {
            DatabaseCity newCity = new DatabaseCity()
            {
                Name = city.Name,
            };

            _context.Cities.Add(newCity);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetUser), new { id = city.Id }, city);
        }
    }
}
