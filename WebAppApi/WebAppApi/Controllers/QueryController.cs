using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using WebAppApi.Interfaces;

namespace WebAppApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class QueryController : ControllerBase
    {
        [HttpPost]
        public async Task<ActionResult<string>> Post(ILlmService llmService, string value)
        {
            if (string.IsNullOrWhiteSpace(value))
            {
                return BadRequest("Value cannot be null or empty.");
            }

            string retval = await llmService.QueryToSql(value);

            // For demonstration, just return the received value in uppercase
            return Ok(retval);
        } 
    }
}
