from langchain.llms import Unieai

input = input("What is your question?")
llm = Unieai(model="llama3.2")
res = llm.predict(input)
print (res)
