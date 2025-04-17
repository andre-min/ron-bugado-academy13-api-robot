*** Settings ***
Resource    ../base.resource

*** Test Cases ***
CT01 - Cadastro de empresa com sucesso
    
    ${response}    Criar Empresa    perfil=aln
    Status Should Be    201    ${response}
    Should Be Equal    first=Olá a companhia ${response.json()["newCompany"]["corporateName"]} foi cadastrada com sucesso.    second=${response.json()["msg"]}

CT02 - Cadastro com o campo Nome da empresa em branco   
    
    ${response}    Criar Empresa    companyName=branco
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'Nome da empresa' é obrigatório.    second=${response.json()["error"][0]}

CT03 - Cadastro com o campo Nome da empresa com todas as letras minusculas
    
    ${get_company}    Get Fake Company
    ${companyName}    Set Variable    ${get_company}[nome_empresa] LTDA
    ${companyNameLetrasMinuscula}    Convert To Lower Case    ${companyName}
    ${response}    Criar Empresa    companyName=${companyNameLetrasMinuscula}
    Status Should Be    201    ${response}
    Should Be Equal    first=Olá a companhia ${companyNameLetrasMinuscula} foi cadastrada com sucesso.    second=${response.json()["msg"]}
    
CT04 - Cadastro com o campo Nome da empresa alfanumerico
    
    ${letras}    Generate Random String    length=4    chars=[LETTERS]
    ${letras_minusculas}    Convert To Lower Case    ${letras}
    ${response}    Criar empresa    companyName=Bugado123456${letras_minusculas}    
    Status Should Be    201    ${response}
    Should Be Equal    first=Olá a companhia Bugado123456${letras_minusculas} foi cadastrada com sucesso.    second=${response.json()["msg"]}
    
CT05 - Cadastro com o campo Nome da empresa com caractere especial
    
    ${get_company}    Get Fake Company
    ${response}    Criar empresa    companyName=${get_company}[nome_empresa]%#&LTDA
    Status Should Be    201    ${response}
    Should Be Equal    first=Olá a companhia ${get_company}[nome_empresa]%#&LTDA foi cadastrada com sucesso.    second=${response.json()["msg"]}
    
    
CT06 - Cadastro com o campo Nome da empresa com mais de 100 caracteres
     
    ${response}    Criar empresa    companyName=Isabella Gregoria Duarte da Silva Costa Albuquerque Oliveira Barbosa Pimentel Rocha Pereira do Amaral
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'Nome da empresa' deve ter no máximo 100 caracteres.    second=${response.json()["error"][0]}

CT07 - Cadastro com o campo Nome da empresa ja existente
    #Teste falhando
    #Sysnova Bitware
    ${response}    Criar empresa    companyName=Sysnova Bitware
    Status Should Be    409    ${response}
    Should Be Equal    first=Olá    second=${response.json()["error"][0]}

CT08 - Cadastro com o campo CNPJ em branco
    
    ${response}    Criar empresa    cnpj=branco
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'CNPJ' da empresa é obrigatório.    second=${response.json()["error"][0]}

CT09 - Cadastro com o campo CNPJ ja existente
     
    ${response}    Criar empresa    cnpj=67548329000162
    Status Should Be    400    ${response}
    Should Be Equal    first=Essa companhia já está cadastrada. Verifique o nome, CNPJ e a razão social da companhia.    second=${response.json()["alert"][0]}

CT10 - Cadastro com o campo CNPJ com letras
    
    ${letras}    Generate Random String    length=14    chars=[LETTERS]
    ${letras_maiusculas}    Convert To Upper Case    ${letras}
    ${response}    Criar empresa    cnpj=${letras_maiusculas}
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'CNPJ' da empresa deve conter apenas números.    second=${response.json()["error"][0]}

CT11 - Cadastro com o campo CNPJ com caracteres especiais
    
    ${response}    Criar empresa    cnpj=1234567891234@
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'CNPJ' da empresa deve conter apenas números.    second=${response.json()["error"][0]}

CT12 - Cadastro com o campo CNPJ com menos de 14 digitos 
    #Verificar com Matheus
    ${response}    Criar empresa    cnpj=1234567891234
    Status Should Be    400    ${response}
    Should Be Equal    first=O     second=${response.json()["error"][0]}

CT13 - Cadastro com o campo CNPJ com mais de 14 digitos
    
    ${get_company}    Get Fake Company
    ${response}    Criar empresa    cnpj=${get_company}[cnpj]9
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'CNPJ' da empresa deve ter no máximo 14 caracteres numéricos.     second=${response.json()["error"][0]}

CT14 - Cadastro com o campo Contato Responsável em branco
    
    ${response}    Criar empresa    responsibleContact=branco
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'Contado do Responsável' é obrigatório.     second=${response.json()["error"][0]}

CT15 - Cadastro com o campo Contato Responsável apenas com primeiro nome
    
    ${letras}    Generate Random String    length=2    chars=[LETTERS]
    ${letras_minusculas}    Convert To Lower Case    ${letras}
    ${response}    Criar empresa    responsibleContact=Bugado${letras_minusculas}
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'Contato do Responsável' deve conter nome e sobrenome.     second=${response.json()["error"][0]}

CT16 - Cadastro com o campo Contato Responsável nome alfanumerico
   
    ${letras}    Generate Random String    length=2    chars=[LETTERS]
    ${letras_minusculas}    Convert To Lower Case    ${letras}
    ${response}    Criar empresa    responsibleContact=Bugado9${letras_minusculas} Souza24
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'Contato do Responsável' deve conter nome e sobrenome.     second=${response.json()["error"][0]}

CT17 - Cadastro com o campo Contato Responsável com caracteres especiais
    
    ${get_company}    Get Fake Company
    
    ${response}    Criar empresa    responsibleContact=${get_company}[responsavel]#%$
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'Contato do Responsável' deve conter nome e sobrenome.     second=${response.json()["error"][0]}

CT18 - Cadastro com o campo Contato Responsável com mais de 100 caracteres
    
    ${letras}    Generate Random String    length=82    chars=[LETTERS]
    ${letras_minusculas}    Convert To Lower Case    ${letras}
    ${response}    Criar empresa    responsibleContact=Bugado Bugado Squad${letras_minusculas}
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'Contado do Responsável' deve ter no máximo 100 caracteres.    second=${response.json()["error"][0]}

CT19 - Cadastro com o campo Telefone em branco
    
    ${response}    Criar empresa    telephone=branco
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'Telefone' é obrigatório.    second=${response.json()["error"][0]}
    
CT20 - Cadastro com o campo Telefone com menos de 15 caracteres

    ${tel_14_dig}    Telefone 14 Caracteres
    ${response}    Criar empresa    telephone=${tel_14_dig}
    Status Should Be    201    ${response}
    Should Be Equal    first=Olá a companhia ${response.json()["newCompany"]["corporateName"]} foi cadastrada com sucesso.    second=${response.json()["msg"]}
    
CT21 - Cadastro com o campo Telefone com mais de 15 caracteres
    
    ${tel_16_dig}    Telefone 16 Caracteres
    ${response}    Criar empresa    telephone=${tel_16_dig}
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'Telefone' deve ter entre 13 e 14 caracteres.    second=${response.json()["error"][0]}

CT22 - Cadastro com o campo Telefone com letras
    
    ${response}    Criar empresa    telephone=123456qertaydy
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'Telefone' deve conter somente números.    second=${response.json()["error"][0]}

CT23 - Cadastro com o campo Telefone com caractere especial
    
    ${response}    Criar empresa    telephone=123456789@#$%$
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'Telefone' deve conter somente números.    second=${response.json()["error"][0]}

CT24 - Cadastro com o campo Email em branco
    
    ${response}    Criar empresa    email=branco   
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'Email' é obrigatório.    second=${response.json()["error"][0]}

CT25 - Cadastro com o campo Email com espaço entre o nome e o dominio
    
    ${response}    Criar empresa    email=test@ test.com.br   
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'Email' informado é inválido. Informe um e-mail no formato [nome@domínio.com].    second=${response.json()["error"][0]}

CT26 - Cadastro com o campo Email com dominio invalido
    
    ${response}    Criar empresa    email=test@test.com.ptbrptbr  
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'Email' informado é inválido. Informe um e-mail no formato [nome@domínio.com].    second=${response.json()["error"][0]}

CT27 - Cadastro com o campo Descrição em branco

    ${response}    Criar empresa      serviceDescription=branco
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'Descrição' é obrigatório.    second=${response.json()["error"][0]}

CT28 - Cadastro com o campo Descrição alfanumerico
    
    ${response}    Criar empresa      serviceDescription=Mais de 20 anos atuando no mercado.
    Status Should Be    201    ${response}
    Should Be Equal    first=Olá a companhia ${response.json()["newCompany"]["corporateName"]} foi cadastrada com sucesso.    second=${response.json()["msg"]}
    Should Be Equal    first=Mais de 20 anos atuando no mercado.    second=${response.json()["newCompany"]["serviceDescription"]}

CT29 - Cadastro com o campo Descrição somente com numeros
   
    ${response}    Criar empresa      serviceDescription=123456789101112
    Status Should Be    201    ${response}
    Should Be Equal    first=Olá a companhia ${response.json()["newCompany"]["corporateName"]} foi cadastrada com sucesso.    second=${response.json()["msg"]}
    Should Be Equal    first=123456789101112    second=${response.json()["newCompany"]["serviceDescription"]}

CT30 - Cadastro com o campo Descrição com caracteres especiais

    ${response}    Criar empresa      serviceDescription=Tecnologia @ # $ % para todos!
    Status Should Be    201    ${response}
    Should Be Equal    first=Olá a companhia ${response.json()["newCompany"]["corporateName"]} foi cadastrada com sucesso.    second=${response.json()["msg"]}
    Should Be Equal    first=Tecnologia @ # $ % para todos!    second=${response.json()["newCompany"]["serviceDescription"]}

CT31 - Cadastro com o campo Logradouro em branco
    
    ${response}    Criar empresa    street=branco
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'logradouro' é obrigatório.    second=${response.json()["error"][0]}

CT32 - Cadastro com o campo Logradouro com letras e numero
    
    ${response}    Criar empresa    street=Parada 15 de novembro
    Status Should Be    201    ${response}
    Should Be Equal    first=Olá a companhia ${response.json()["newCompany"]["corporateName"]} foi cadastrada com sucesso.    second=${response.json()["msg"]}
    Should Be Equal    first=Parada 15 de novembro    second=${response.json()["newCompany"]["address"][0]["street"]}

CT33 - Cadastro com o campo Logradouro somente com numeros
    
    ${response}    Criar empresa    street=123456789 9875364555
    Status Should Be    201    ${response}
    Should Be Equal    first=Olá a companhia ${response.json()["newCompany"]["corporateName"]} foi cadastrada com sucesso.    second=${response.json()["msg"]}
    Should Be Equal    first=123456789 9875364555    second=${response.json()["newCompany"]["address"][0]["street"]}

CT34 - Cadastro com o campo Logradouro com mais de 50 caracteres
    
    ${letras}    Generate Random String    length=19    chars=[LETTERS]
    ${letras_minusculas}    Convert To Lower Case    ${letras}
    ${response}    Criar empresa    street=Rua do teste da squad Ron bugado${letras_minusculas}
    Status Should Be    400    ${response}
    
CT35 - Cadastro com o campo Logradouro com caracteres especial invalido
    
    ${response}    Criar empresa    street=Rua # Joao & Maria
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'logradouro' só pode conter letras, números e os caracteres especiais 'ª', 'º', '‘' e '-'    second=${response.json()["error"][0]}
    
CT36 - Cadastro com o campo Logradouro com caracteres especial 'º'
    
    ${response}    Criar empresa    street=Avenida 1º de abril
    Status Should Be    201    ${response}
    Should Be Equal    first=Olá a companhia ${response.json()["newCompany"]["corporateName"]} foi cadastrada com sucesso.    second=${response.json()["msg"]}
    Should Be Equal    first=Avenida 1º de abril    second=${response.json()["newCompany"]["address"][0]["street"]}

CT37 - Cadastro com o campo Logradouro com caracteres especial 'ª'
    
    ${response}    Criar empresa    street=Rua dos trilhos 1ª batalão 
    Status Should Be    201    ${response}
    Should Be Equal    first=Olá a companhia ${response.json()["newCompany"]["corporateName"]} foi cadastrada com sucesso.    second=${response.json()["msg"]}
    Should Be Equal    first=Rua dos trilhos 1ª batalão    second=${response.json()["newCompany"]["address"][0]["street"]}

CT38 - Cadastro com o campo Logradouro com caracteres especial '-'
    
    ${response}    Criar empresa    street=Rua pré-requisito para o teste 
    Status Should Be    201    ${response}
    Should Be Equal    first=Olá a companhia ${response.json()["newCompany"]["corporateName"]} foi cadastrada com sucesso.    second=${response.json()["msg"]}
    Should Be Equal    first=Rua pré-requisito para o teste    second=${response.json()["newCompany"]["address"][0]["street"]}
    
#CT39 - Cadastro com o campo Logradouro com caracteres especial '‘' aspas simples

CT40 - Cadastro com o campo Numero em branco
    
    ${response}    Criar empresa    number=branco
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'número' é obrigatório.    second=${response.json()["error"][0]}

CT41 - Cadastro com o campo Numero com caracteres especiais
   
    ${response}    Criar empresa    number=10@
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'número' só pode conter letras, números e o caractere especial '/'    second=${response.json()["error"][0]}

CT42 - Cadastro com o campo Numero com letras e numero
    
    ${response}    Criar empresa    number=12B
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'número' só pode conter letras, números e o caractere especial '/'    second=${response.json()["error"][0]}

CT43 - Cadastro com o campo Numero com mais de 10 caracteres
    
    ${response}    Criar empresa    number=12345678912
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'número' deve possuir no máximo 10 caracteres.    second=${response.json()["error"][0]}

CT44 - Cadastro com o campo Complemento com letras e numeros

    ${response}    Criar empresa    complement=Casa 2
    Status Should Be    201    ${response}
    Should Be Equal    first=Olá a companhia ${response.json()["newCompany"]["corporateName"]} foi cadastrada com sucesso.    second=${response.json()["msg"]}
    Should Be Equal    first=Casa 2    second=${response.json()["newCompany"]["address"][0]["complement"]}
    
CT45 - Cadastro com o campo Complemento com caracteres especial 'º'
  
    ${response}    Criar empresa    complement=Casa 1º
    Status Should Be    201    ${response}
    Should Be Equal    first=Olá a companhia ${response.json()["newCompany"]["corporateName"]} foi cadastrada com sucesso.    second=${response.json()["msg"]}
    Should Be Equal    first=Casa 1º    second=${response.json()["newCompany"]["address"][0]["complement"]}

CT46 - Cadastro com o campo Complemento com caracteres especial 'ª'
   
    ${response}    Criar empresa    complement=Casa 1ª
    Status Should Be    201    ${response}
    Should Be Equal    first=Olá a companhia ${response.json()["newCompany"]["corporateName"]} foi cadastrada com sucesso.    second=${response.json()["msg"]}
    Should Be Equal    first=Casa 1ª    second=${response.json()["newCompany"]["address"][0]["complement"]}
        
CT47 - Cadastro com o campo Complemento com caracteres especial '-'
    
    ${response}    Criar empresa    complement=Casa - 1
    Status Should Be    201    ${response}
    Should Be Equal    first=Olá a companhia ${response.json()["newCompany"]["corporateName"]} foi cadastrada com sucesso.    second=${response.json()["msg"]}
    Should Be Equal    first=Casa - 1    second=${response.json()["newCompany"]["address"][0]["complement"]}
    
CT48 - Cadastro com o campo Complemento com caractere especial invalido
    
    ${response}    Criar empresa    complement=Casa #$ 2
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'complemento' só pode conter letras, números e os caracteres especiais 'ª', 'º', '‘' e '-'    second=${response.json()["error"][0]}

CT49 - Cadastro com o campo Complemento com mais de 80 caracteres
  
    ${response}    Criar empresa    complement=Ouviram do Ipiranga as margens plácidas De um povo heroico o brado retumbante e o
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'complemento' deve possuir no máximo 80 caracteres.    second=${response.json()["error"][0]}

CT50 - Cadastro com o campo Bairro em branco
    
    ${response}    Criar Empresa    district=branco
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'bairro' é obrigatório.    second=${response.json()["error"][0]}

CT51 - Cadastro com o campo Bairro com letras e numeros
    
    ${response}    Criar Empresa    district=Parada 15 de novembro
    Status Should Be    201    ${response}
    Should Be Equal    first=Olá a companhia ${response.json()["newCompany"]["corporateName"]} foi cadastrada com sucesso.    second=${response.json()["msg"]}
    Should Be Equal    first=Parada 15 de novembro    second=${response.json()["newCompany"]["address"][0]["district"]}
    
CT52 - Cadastro com o campo Bairro com caracteres especial 'º'
    
    ${response}    Criar Empresa    district=Parada 15º
    Status Should Be    201    ${response}
    Should Be Equal    first=Olá a companhia ${response.json()["newCompany"]["corporateName"]} foi cadastrada com sucesso.    second=${response.json()["msg"]}
    Should Be Equal    first=Parada 15º    second=${response.json()["newCompany"]["address"][0]["district"]}
    
CT53 - Cadastro com o campo Bairro com caracteres especial 'ª'
    
    ${response}    Criar Empresa    district=Parada 15ª
    Status Should Be    201    ${response}
    Should Be Equal    first=Olá a companhia ${response.json()["newCompany"]["corporateName"]} foi cadastrada com sucesso.    second=${response.json()["msg"]}
    Should Be Equal    first=Parada 15ª    second=${response.json()["newCompany"]["address"][0]["district"]}
    
CT54 - Cadastro com o campo Bairro com caracteres especial '-'
   
    ${response}    Criar Empresa    district=Parada - 15
    Status Should Be    201    ${response}
    Should Be Equal    first=Olá a companhia ${response.json()["newCompany"]["corporateName"]} foi cadastrada com sucesso.    second=${response.json()["msg"]}
    Should Be Equal    first=Parada - 15    second=${response.json()["newCompany"]["address"][0]["district"]}
    
CT55 - Cadastro com o campo Bairro com caracteres especial invalido
    
    ${response}    Criar Empresa    district=Parada 15 # % $
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'bairro' só pode conter letras, números e os caracteres especiais 'ª', 'º', '‘' e '-'    second=${response.json()["error"][0]}

CT55 - Cadastro com o campo Bairro com mais de 50 caracteres
    
    ${response}    Criar Empresa    district=Cidade jardim do centro da capital paulistana perto
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'bairro' deve possuir no máximo 50 caracteres.    second=${response.json()["error"][0]}

CT56 - Cadastro com o campo Cidade em branco
    
    ${response}    Criar Empresa    city=branco
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'cidade' é obrigatório.    second=${response.json()["error"][0]}

CT57 - Cadastro com o campo Cidade com caracteres especial 'º'
    
    ${response}    Criar Empresa    city=Sao Pauloº
    Status Should Be    201    ${response}
    Should Be Equal    first=Olá a companhia ${response.json()["newCompany"]["corporateName"]} foi cadastrada com sucesso.    second=${response.json()["msg"]}
    Should Be Equal    first=Sao Pauloº    second=${response.json()["newCompany"]["address"][0]["city"]}

CT58 - Cadastro com o campo Cidade com caracteres especial 'ª'
    
    ${response}    Criar Empresa    city=Sao Pauloª
    Status Should Be    201    ${response}
    Should Be Equal    first=Olá a companhia ${response.json()["newCompany"]["corporateName"]} foi cadastrada com sucesso.    second=${response.json()["msg"]}
    Should Be Equal    first=Sao Pauloª    second=${response.json()["newCompany"]["address"][0]["city"]}

CT59 - Cadastro com o campo Cidade com caracteres especial '-'
    
    ${response}    Criar Empresa    city=São - Paulo
    Status Should Be    201    ${response}
    Should Be Equal    first=Olá a companhia ${response.json()["newCompany"]["corporateName"]} foi cadastrada com sucesso.    second=${response.json()["msg"]}
    Should Be Equal    first=São - Paulo    second=${response.json()["newCompany"]["address"][0]["city"]}

CT60 - Cadastro com o campo cidade com caracteres especial invalido
    
    ${response}    Criar Empresa    city=São Paulo #
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'cidade' só pode conter letras e os caracteres especiais 'ª', 'º', '‘' e '-'.    second=${response.json()["error"][0]}

CT61 - Cadastro com o campo Cidade com numeros
    
    ${response}    Criar Empresa    city=São Paulo 23
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'cidade' só pode conter letras e os caracteres especiais 'ª', 'º', '‘' e '-'.    second=${response.json()["error"][0]}

CT62 - Cadastro com o campo Cidade com mais de 50 caracteres
    
    ${response}    Criar Empresa    city=São Paulo uma cidade que possui carros de vários tp
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'cidade' deve possuir no máximo 50 caracteres.    second=${response.json()["error"][0]}

CT63 - Cadastro com o campo estado em branco
    
    ${response}    Criar Empresa    state=branco
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'estado' é obrigatório.    second=${response.json()["error"][0]}

CT64 - Cadastro com o campo Estado com numero
    
    ${response}    Criar Empresa    state=22
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'estado' só pode conter letras maiúsculas    second=${response.json()["error"][0]}

CT65 - Cadastro com o campo Estado com caractere especial
    
    ${response}    Criar Empresa    state=@M
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'estado' só pode conter letras maiúsculas    second=${response.json()["error"][0]}

CT66 - Cadastro com o campo Estado com letra minuscula
    
    ${response}    Criar Empresa    state=sP
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'estado' só pode conter letras maiúsculas    second=${response.json()["error"][0]}

CT67 - Cadastro com o campo Estado com menos de 2 letras
    
    ${response}    Criar Empresa    state=P
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'estado' deve possuir 2 caracteres.    second=${response.json()["error"][0]}

CT68 - Cadastro com o campo Estado com mais de 2 letras
    
    ${response}    Criar Empresa    state=SPQ
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'estado' deve possuir 2 caracteres.    second=${response.json()["error"][0]}

CT69 - Cadastro com o campo País em branco
    
    ${response}    Criar Empresa    country=branco
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo País é obrigatório.    second=${response.json()["error"][0]}

CT70 - Cadastro com o campo País com numero
    
    ${response}    Criar Empresa    country=Brasil21
    Status Should Be    400    ${response}
    
CT71 - Cadastro com o campo País com caractere especial
    
    ${response}    Criar Empresa    country=Brasil@
    Status Should Be    400    ${response}

CT72 - Cadastro com o campo País com mais de 50 caracteres
    
    ${response}    Criar Empresa    country=Brasil Argentina Paraguai Uruguai Alemanha Inglaterra
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo País permite até 50 caracteres.    second=${response.json()["error"][0]}

CT73 - Cadastro com o campo CEP em branco
    
    ${response}    Criar Empresa    zipCode=branco    
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'CEP' é obrigatório.    second=${response.json()["error"][0]}

CT74 - Cadastro com o campo CEP com letras
    
    ${response}    Criar Empresa    zipCode=0824706A    
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'CEP' só pode conter números    second=${response.json()["error"][0]}

CT75 - Cadastro com o campo CEP com caractere especial
    
    ${response}    Criar Empresa    zipCode=0824706@    
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'CEP' só pode conter números    second=${response.json()["error"][0]}

CT76 - Cadastro com o campo CEP com mais de 8 numeros
    
    ${response}    Criar Empresa    zipCode=080300000    
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'CEP' deve conter 8 dígitos    second=${response.json()["error"][0]}

CT77 - Cadastro com o campo CEP com menos de 8 numeros
    [Tags]    aqui
    ${response}    Criar Empresa    zipCode=0803000    
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'CEP' deve conter 8 dígitos    second=${response.json()["error"][0]}

