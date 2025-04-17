from faker import Faker
import random

faker = Faker('pt_BR')

def remover_titulo(nome):
    # Divida o nome em partes usando o espaço como delimitador
    partes = nome.split()
    
    # Encontre a posição do primeiro ponto na lista
    for i, parte in enumerate(partes):
        if parte.endswith('.'):
            # Retorna o nome completo, removendo a parte antes do ponto
            return ' '.join(partes[i+1:])
    
    # Se não houver ponto (sem título), retorna o nome como está
    return nome

# Gerando um nome com Faker
nome_faker = faker.name()

print(f'Nome original: {nome_faker}')
# Aplica a função para remover os títulos
nome_sem_titulo = remover_titulo(nome_faker)

print(f'Nome sem título: {nome_sem_titulo}')

def telefone_14_caracteres():
    numero_14_digitos = ''.join(str(random.randint(1, 9)) for _ in range(14))
    return numero_14_digitos
print(telefone_14_caracteres())

def telefone_16_caracteres():
    numero_16_digitos = ''.join(str(random.randint(1, 9)) for _ in range(16))
    return numero_16_digitos
print(telefone_16_caracteres())

def gerar_telefone_sem_formatacao():
    return faker.msisdn()

def limpar_zipCode(zipCode):
    zipCode_limpo = zipCode.replace('.', '').replace('-', '').replace('/', '')
    return zipCode_limpo

def limpar_cnpj(cnpj):
    cnpj_limpo = cnpj.replace('.', '').replace('-', '').replace('/', '')
    return cnpj_limpo

def get_fake_company():
    
    company = {
        "nome_empresa": faker.company(),
        "cnpj": limpar_cnpj(faker.cnpj()),
        "telefone": gerar_telefone_sem_formatacao(),
        "email": faker.company_email(),
        "zipCode": limpar_zipCode(faker.postcode()),
        "city": faker.city(),
        "state": faker.state_abbr(),
        "district": faker.street_name(),
        "street": faker.street_name(),
        "number": faker.building_number(),
        "country": faker.city(),
        "descricao": faker.job(),
        "responsavel": nome_sem_titulo, 
    }
    return company



print(get_fake_company()["nome_empresa"])


