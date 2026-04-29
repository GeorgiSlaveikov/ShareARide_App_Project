using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace REST_API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class BaseController : ControllerBase
    {
        [HttpGet("check")]
        public ActionResult<bool> CheckConnection()
        {
            Console.WriteLine("Client Connected");
            return Ok(new { status = "online", timestamp = DateTime.UtcNow });
        }
    }
}
