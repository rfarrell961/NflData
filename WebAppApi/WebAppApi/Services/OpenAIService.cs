using WebAppApi.Interfaces;
using OpenAI;
using OpenAI.Chat;
using System.ClientModel;
using System.Threading.Tasks;

namespace WebAppApi.Services
{
    public class OpenAIService : ILlmService
    {
        private ChatClient _client;
        private LlmContextOptions _context;        

        public OpenAIService(ChatClient client, LlmContextOptions context)
        {            
            _client = client;
            _context = context;
        }

        public async Task<string> QueryToSql(string query)
        {
            ChatCompletion completion = _client.CompleteChat(
                new SystemChatMessage("You are a helpful assistant that writes SQL queries not intended to be human readable."),
                new UserChatMessage("Given the following schema:\n" + _context.DatabaseContext + "\n" + query)
            );

            return completion.Content[0].Text;
        }

        public async Task<string> ResponseToAnswer(string response, string query)
        {
            ChatCompletion completion = _client.CompleteChat(
                new SystemChatMessage("You are a helpful assistant that turns sql responses into human readable answers"),
                new UserChatMessage("Given the following query: " + query + "\nConvert the following response: " + response)
            );

            return completion.Content[0].Text;
        }
    }
}
