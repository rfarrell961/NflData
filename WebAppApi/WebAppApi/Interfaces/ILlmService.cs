namespace WebAppApi.Interfaces
{
    public interface ILlmService
    {        
        public Task<string> QueryToSql(string query);
        public Task<string> ResponseToAnswer(string response, string query);
    }
}
