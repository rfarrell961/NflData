using DotNetEnv;
using OpenAI;
using WebAppApi.Interfaces;
using WebAppApi.Services;

var builder = WebApplication.CreateBuilder(args);

Env.Load(builder.Configuration["EnvPath"]);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

string llmProvider = builder.Configuration["LlmProvider"];
if (string.IsNullOrEmpty(llmProvider))
{
    throw new Exception("No LLM Provider selected");
}

// Register OpenAIClient only if needed
if (llmProvider.ToUpper() == "OPENAI")
{
    builder.Services.AddSingleton(sp =>
    {
        var apiKey = Environment.GetEnvironmentVariable("OPEN_AI_API_KEY");
        if (string.IsNullOrEmpty(apiKey))
            throw new Exception("OPEN_AI_API_KEY not set");
        return new OpenAIClient(apiKey);
    });
}


// Register ILLMService using a factory
builder.Services.AddScoped<ILlmService>(sp =>
{
    return llmProvider.ToUpper() switch
    {
        "OPENAI" => new OpenAIService(sp.GetRequiredService<OpenAIClient>()),
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
