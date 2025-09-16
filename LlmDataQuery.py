from sqlalchemy import create_engine
from dotenv import load_dotenv
import os
import openai

load_dotenv()

user=os.getenv('USER')
password=os.getenv('PASSWORD')
host=os.getenv('HOST')
port=os.getenv('PORT')
db=os.getenv('DB')
schema_file = os.getenv('SCHEMA_FILE')
api_key = os.getenv("OPEN_AI_API_KEY")

openai.api_key = api_key

schema_info = ""
with open(schema_file, "r") as file:
    schema_info = file.read()    

user_question = "Get Top Rushers in the 2008 regular season"

response = openai.chat.completions.create(
    model="gpt-5-nano",
    messages=[
        {"role": "system", "content": "You are a helpful assistant that writes SQL queries not intended to be human readable."},
        {"role": "user", "content": f"Given the following schema:\n{schema_info}\n{user_question}"}        
    ],
    temperature=1    
)

sql_query = response.choices[0].message.content
print(sql_query)