from faker import Faker

faker = Faker('pt_BR')

# Remove pontos de uma string
def limpar_ponto_nome(nome):
    nome_limpo = nome.replace('.', '')
    return nome_limpo

def limpar_cpf(cpf):
    cpf_limpo = cpf.replace('.', '').replace('-', '')
    return cpf_limpo

def get_fake_person():
    person = {
        "name": limpar_ponto_nome(faker.name()),
        "email": faker.email(),
        "cpf": limpar_cpf(faker.cpf()),
        "rg": faker.rg()
    }
    
    return person

print(get_fake_person())