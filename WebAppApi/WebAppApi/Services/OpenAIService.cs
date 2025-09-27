using WebAppApi.Interfaces;
using OpenAI;

namespace WebAppApi.Services
{
    public class OpenAIService : ILlmService
    {
        private OpenAIClient _client;

        public string DatabaseContext { get; set; }
        public string Model { get; set; }

        public OpenAIService(OpenAIClient client)
        {            
            _client = client;
        }

        public string QueryToSql(string query)
        {
            //_client.GetChatClient(Model);

            return query + "TestingTesting123";
        }

        public string ResponseToAnswer(string response)
        {
            throw new NotImplementedException();
        }
    }
}
