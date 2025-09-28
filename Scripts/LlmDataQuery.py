from sqlalchemy import create_engine, text
from dotenv import load_dotenv
import os
import openai

load_dotenv("./.env")

user=os.getenv('USER')
password=os.getenv('PASSWORD')
host=os.getenv('HOST')
port=os.getenv('PORT')
db=os.getenv('DB')
schema_file = os.getenv('SCHEMA_FILE')
api_key = os.getenv("OPEN_AI_API_KEY")
debug = bool(os.getenv("DEBUG"))

engine = create_engine(f'postgresql+psycopg2://{user}:{password}@{host}:{port}/{db}', echo=False)

openai.api_key = api_key

schema_info = ""
with open(schema_file, "r") as file:
    schema_info = file.read()    

while True:
    user_question = input("Please enter your query: ")

    if (user_question.strip().lower() == "exit"):
        break

    response = openai.chat.completions.create(
        model="gpt-5-mini",
        messages=[
            {"role": "system", "content": "You are a helpful assistant that writes SQL queries not intended to be human readable."},
            {"role": "user", "content": f"Given the following schema:\n{schema_info}\n{user_question}"}        
        ],
        temperature=1    
    )

    sql_query = response.choices[0].message.content
    
    print("")
    if (debug):
        print(f"{sql_query}\n")

    with engine.connect() as connection:
        results = connection.execute(text(sql_query))

        print(results.keys())
        for row in results:
            print(row)

    print("")




