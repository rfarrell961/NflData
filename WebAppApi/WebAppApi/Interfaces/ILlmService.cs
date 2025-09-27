namespace WebAppApi.Interfaces
{
    public interface ILlmService
    {
        public string DatabaseContext { get; set; } 
        public string QueryToSql(string query);
        public string ResponseToAnswer(string response);
    }
}
