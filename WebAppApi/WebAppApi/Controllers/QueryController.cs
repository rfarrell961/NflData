using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Data;
using System.Threading.Tasks;
using WebAppApi.Interfaces;
using WebAppApi.Services;

namespace WebAppApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class QueryController : ControllerBase
    {
        private ILlmService _llmService;
        private DatabaseService _dbService;

        public QueryController(ILlmService llmService, DatabaseService dbService)
        {
            _llmService = llmService;
            _dbService = dbService;
        }


        [HttpPost]
        public async Task<ActionResult<string>> Post([FromBody]string query)
        {
            if (string.IsNullOrWhiteSpace(query))
            {
                return BadRequest("Value cannot be null or empty.");
            }

            string retval = await _llmService.QueryToSql(query);
            DataTable queryResult = await _dbService.ExecuteQueryAsync(retval);
            string result = JsonConvert.SerializeObject(queryResult);
            string humanReadableResponse = await _llmService.ResponseToAnswer(result, query);

            return Ok(humanReadableResponse);
        } 
    }
}
