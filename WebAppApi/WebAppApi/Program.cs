using DotNetEnv;
using OpenAI;
using OpenAI.Chat;
using WebAppApi.Interfaces;
using WebAppApi.Services;
using Npgsql;

var builder = WebApplication.CreateBuilder(args);

Env.Load(builder.Configuration["EnvPath"]);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Register LlmContextOptions

var schemaFile = Environment.GetEnvironmentVariable("SCHEMA_FILE");
if (string.IsNullOrEmpty(schemaFile) || !File.Exists(schemaFile))
    throw new Exception("SCHEMA_FILE is missing or invalid");

builder.Services.AddSingleton(new LlmContextOptions
{
    DatabaseContext = System.IO.File.ReadAllText(schemaFile),
});

string llmProvider = builder.Configuration["LlmProvider"];

// Register OpenAIClient only if needed
if (llmProvider.ToUpper() == "OPENAI")
{
    builder.Services.AddSingleton(sp =>
    {
        var apiKey = Environment.GetEnvironmentVariable("OPEN_AI_API_KEY")
            ??throw new Exception("OPEN_AI_API_KEY not set");

        var model = Environment.GetEnvironmentVariable("MODEL")
            ?? throw new Exception("MODEL not set");

        return new ChatClient(model, apiKey);
    });
}


// Register ILLMService using a factory
builder.Services.AddScoped<ILlmService>(sp =>
{
    return llmProvider.ToUpper() switch
    {
        "OPENAI" => new OpenAIService(sp.GetRequiredService<ChatClient>(), sp.GetRequiredService<LlmContextOptions>()),
        _ => throw new Exception($"LLM Provider {llmProvider} not supported")
    };
});

// Register NpgsqlDataSource
string host = Environment.GetEnvironmentVariable("HOST") 
    ?? throw new Exception("HOST not set");

string port = Environment.GetEnvironmentVariable("PORT") 
    ?? throw new Exception("PORT not set");

string username = Environment.GetEnvironmentVariable("USER") 
    ?? throw new Exception("USER not set");

string password = Environment.GetEnvironmentVariable("PASSWORD") 
    ?? throw new Exception("PASSWORD not set");

string database = Environment.GetEnvironmentVariable("DB") 
    ?? throw new Exception("DB not set");

string connectionString = "Host=" + host 
    + ";Port=" + port 
    + ";Username=" + username 
    + ";Password=" + password 
    + ";Database=" + database;

NpgsqlDataSource dataSource = NpgsqlDataSource.Create(connectionString);
builder.Services.AddSingleton(dataSource);

builder.Services.AddScoped<DatabaseService>();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
