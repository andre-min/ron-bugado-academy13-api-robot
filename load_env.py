from dotenv import load_dotenv
import os

def carregar_variaveis_ambiente():
    load_dotenv()  # Carrega o arquivo .env automaticamente
    return os.environ  # Retorna todas as variáveis carregadas para o ambiente

print(carregar_variaveis_ambiente())