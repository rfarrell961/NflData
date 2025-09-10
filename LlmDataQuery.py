from sqlalchemy import create_engine
from dotenv import load_dotenv
import os
from langchain import OpenAI, SQLDatabase
from langchain.chains import SQLDatabaseSequentialChain

load_dotenv()

user=os.getenv('USER')
password=os.getenv('PASSWORD')
host=os.getenv('HOST')
port=os.getenv('PORT')
db=os.getenv('DB')

api_key = os.getenv("OPEN_AI_API_KEY")

pg_uri = f'postgresql+psycopg2://{user}:{password}@{host}:{port}/{db}'
db = SQLDatabase.from_uri(pg_uri)

llm = OpenAI(temperature=0, openai_api_key=api_key, model_name='gpt-3.5-turbo')

PROMPT = """ 
Given an input question, first create a syntactically correct postgresql query to run,  
then look at the results of the query and return the answer.  
The question: {question}
"""

db_chain = SQLDatabaseSequentialChain(llm=llm, database=db, verbose=True, top_k=3)

question = "What are Tua's regular season total career passing yards" 
# use db_chain.run(question) instead if you don't have a prompt
db_chain.run(PROMPT.format(question=question))