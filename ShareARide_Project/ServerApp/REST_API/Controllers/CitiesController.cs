using Core.Model;
using DatabaseLayer.Database;
using DatabaseLayer.DatabaseControllers;
using DatabaseLayer.DatabaseModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using REST_API.Objects;
using REST_API.ResponseObjects;
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
        public async Task<ActionResult<IEnumerable<CityResponse>>> GetCities()
        {
            return await _context.Cities
                .AsNoTracking() 
                .Select(c => new CityResponse
                {
                    Id = c.Id,
                    Name = c.Name
                })
                .ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<DatabaseCity>> GetCity(int id)
        {
            var city = await _context.Cities
                .AsNoTracking()
                .Where(c => c.Id == id)
                .Select(c => new CityResponse
                {
                    Id = c.Id,
                    Name = c.Name
                })
                .FirstOrDefaultAsync();

            if (city == null)
            {
                return NotFound($"City with ID {id} not found.");
            }

            return Ok(city);
        }


        // remove later maybe
        [HttpPost]
        public async Task<ActionResult<DatabaseCity>> CreateCity([FromBody] City city)
        {
            DatabaseCity newCity = new DatabaseCity()
            {
                Name = city.Name,
            };

            _context.Cities.Add(newCity);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetCity), new { id = city.Id }, city);
        }
    }
}
