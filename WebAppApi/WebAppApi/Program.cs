using DotNetEnv;
using OpenAI;
using OpenAI.Chat;
using WebAppApi.Interfaces;
using WebAppApi.Services;

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
