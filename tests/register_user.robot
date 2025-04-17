*** Settings ***

Resource    ../base.resource

*** Test Cases ***

CT01 - Cadastrar usuario com sucesso
    ${response}    Cadastrar usuario    
    Status Should Be    201    ${response["res"]}
    Should Be Equal    
    ...    first=Olá ${response["req"]["fullName"]}, cadastro realizado com sucesso.    
    ...    second=${response["res"].json()["msg"]}
    ${deleteResponse}    Excluir usuario    ${response["res"].json()["user"]["_id"]}
    Status Should Be    200    ${deleteResponse}
    Should Be Equal    first=Usuário deletado com sucesso!.    second=${deleteResponse.json()["msg"]}
CT02 - Cadastro com campo nome completo em branco
    ${response}    Cadastrar usuario    fullName=branco
    Status Should Be    400    ${response["res"]}
    Should Be Equal    
    ...    first=O campo nome completo é obrigatório.    
    ...    second=${response["res"].json()["error"][0]}

CT03 - Cadastro com campo nome completo com mais de 100 caracteres
    ${letras}    Generate Random String    length=3    chars=[LETTERS]
    ${letras_minusculas}    Convert To Lower Case    ${letras}
    ${fullNameLog}    Set Variable    Maximiliano Eduardo Pereira da Silva Costa Martins Albuquerque Barbosa dos Santos Oliveira Barro${letras_minusculas}
    ${response}    Cadastrar usuario    fullName=${fullNameLog} 
    Status Should Be    201    ${response["res"]}
    Should Be Equal    
    ...    first=Olá ${fullNameLog}, cadastro realizado com sucesso.    
    ...    second=${response["res"].json()["msg"]}
    Should Be Equal    
    ...    first=${fullNameLog}    
    ...    second=${response["res"].json()["user"]["fullName"]}
    ${deleteResponse}    Excluir usuario    ${response["res"].json()["user"]["_id"]}
    Status Should Be    200    ${deleteResponse}
    Should Be Equal    first=Usuário deletado com sucesso!.    second=${deleteResponse.json()["msg"]}

CT04 - Cadastro com campo nome completo com nome alfanumérico.
    ${numeros}    Generate Random String    length=3    chars=${DIGITS}
    ${response}    Cadastrar usuario    fullName=Paulo Siqueira${numeros}
    Status Should Be    400    ${response["res"]}
    Log    ${response["req"]["fullName"]}
    Should Be Equal    
    ...    first=O campo nome completo não deve conter números    
    ...    second=${response["res"].json()["error"][0]}

CT05 - Cadastro com campo nome completo com caracteres especiais
    ${response}    Cadastrar usuario    fullName=Paulo Siqueira@
    Status Should Be    400    ${response["res"]}
    Should Be Equal    
    ...    first=Informe o nome e sobrenome com as iniciais em letra maiúscula e sem caracteres especiais.    
    ...    second=${response["res"].json()["error"][0]}
    
CT06 - Cadastro com campo nome completo somente com primeiro nome
    ${response}    Cadastrar usuario    fullName=Paulo
    Status Should Be    400    ${response["res"]}
    Should Be Equal    
    ...    first=Informe o nome e sobrenome.    
    ...    second=${response["res"].json()["error"][0]}

CT07 - Cadastro com campo nome completo com as letras minúsculas
    ${response}    Cadastrar usuario    fullName=paulo siqueira
    Status Should Be    400    ${response["res"]}
    Should Be Equal    
    ...    first=Informe o nome e sobrenome.    
    ...    second=${response["res"].json()["error"][0]}
    
CT08 - Cadastro com campo nome completo com as letras maiusculas
    ${response}    Cadastrar usuario    fullName=MATHEUS SOUSA
    Status Should Be    400    ${response["res"]}
    Should Be Equal    
    ...    first=Informe o nome e sobrenome.
    ...    second=${response["res"].json()["error"][0]}
    
CT09 - Cadastro com campo nome com mais de duas palavras composta
    ${response}    Cadastrar usuario    fullName=João Tavares Tavares
    Status Should Be    201    ${response["res"]}
    Should Be Equal    
    ...    first=Olá ${response["req"]["fullName"]}, cadastro realizado com sucesso.    
    ...    second=${response["res"].json()["msg"]}
    Should Be Equal    
    ...    first=${response["req"]["fullName"]}    
    ...    second=${response["res"].json()["user"]["fullName"]}
    ${deleteResponse}    Excluir usuario    ${response["res"].json()["user"]["_id"]}
    Status Should Be    200    ${deleteResponse}
    Should Be Equal    first=Usuário deletado com sucesso!.    second=${deleteResponse.json()["msg"]}

CT10 - Cadastro com campo e-mail em branco
    ${response}    Cadastrar usuario    mail=branco
    Status Should Be    400    ${response["res"]}
    Should Be Equal    
    ...    first=O campo e-mail é obrigatório.    
    ...    second=${response["res"].json()["error"][0]}

CT11 - Cadastro com campo e-mail com formato de e-mail inválido
    ${response}    Cadastrar usuario    mail=teste123@gmail.com#br
    Status Should Be    400    ${response["res"]}
    Should Be Equal    
    ...    first=O e-mail informado é inválido. Informe um e-mail no formato [nome@domínio.com].    
    ...    second=${response["res"].json()["error"][0]}

CT12 - Cadastro com campo e-mail com espaço entre o domínio
    ${response}    Cadastrar usuario    mail=test@ test.com.br
    Status Should Be    400    ${response["res"]}
    Should Be Equal    
    ...    first=O e-mail informado é inválido. Informe um e-mail no formato [nome@domínio.com].    
    ...    second=${response["res"].json()["error"][0]}

CT13 - Cadastro com Sucesso com domínio de outro países
    ${response}    Cadastrar usuario    mail=oliviaoliveira@qacoders.com.pt
    Status Should Be    201    ${response["res"]}
    Should Be Equal    
    ...    first=oliviaoliveira@qacoders.com.pt    
    ...    second=${response["res"].json()["user"]["mail"]}
    ${deleteResponse}    Excluir usuario    ${response["res"].json()["user"]["_id"]}
    Status Should Be    200    ${deleteResponse}
    Should Be Equal    first=Usuário deletado com sucesso!.    second=${deleteResponse.json()["msg"]}

CT14 - Cadastro com campo senha em branco
    ${response}    Cadastrar usuario    password=branco
    Status Should Be    400    ${response["res"]}
    Should Be Equal    
    ...    first=O campo senha é obrigatório    
    ...    second=${response["res"].json()["error"][0]}
    
CT15 - Cadastro com campo senha com menos de 8 caracteres
    ${response}    Cadastrar usuario    password=Asdf1@    confirmPassword=Asdf1@
    Status Should Be    400    ${response["res"]}
    Should Be Equal    
    ...    first=Senha precisa ter: uma letra maiúscula, uma letra minúscula, um número, um caractere especial(@#$%) e tamanho entre 8-12.    
    ...    second=${response["res"].json()["error"][0]}

CT16 - Cadastro com campo senha com mais de 12 caracteres
    ${response}    Cadastrar usuario    password=Asdfg1@asdfgasdfg    confirmPassword=Asdfg1@asdfgasdfg
    Status Should Be    400    ${response["res"]}
    Should Be Equal    
    ...    first=Senha precisa ter: uma letra maiúscula, uma letra minúscula, um número, um caractere especial(@#$%) e tamanho entre 8-12.    
    ...    second=${response["res"].json()["error"][0]}

CT17 - Cadastro com campo senha sem letra maiuscula
    ${response}    Cadastrar usuario    password=asdfgh1@    confirmPassword=asdfgh1@
    Status Should Be    400    ${response["res"]}
    Should Be Equal    
    ...    first=Senha precisa ter: uma letra maiúscula, uma letra minúscula, um número, um caractere especial(@#$%) e tamanho entre 8-12.    
    ...    second=${response["res"].json()["error"][0]}

CT18 - Cadastro com campo senha sem letra minúscula
    ${response}    Cadastrar usuario    password=ASDFGH1@    confirmPassword=ASDFGH1@
    Status Should Be    400    ${response["res"]}
    Should Be Equal    
    ...    first=Senha precisa ter: uma letra maiúscula, uma letra minúscula, um número, um caractere especial(@#$%) e tamanho entre 8-12.    
    ...    second=${response["res"].json()["error"][0]}

CT19 - Cadastro com campo senha sem caracteres especiais
    ${response}    Cadastrar usuario    password=Asdfgh12    confirmPassword=Asdfgh12
    Status Should Be    400    ${response["res"]}
    Should Be Equal    
    ...    first=Senha precisa ter: uma letra maiúscula, uma letra minúscula, um número, um caractere especial(@#$%) e tamanho entre 8-12.    
    ...    second=${response["res"].json()["error"][0]}

CT20 - Cadastro com campo senha sem número
    ${response}    Cadastrar usuario    password=Asdfgh@as    confirmPassword=Asdfgh@as
    Status Should Be    400    ${response["res"]}
    Should Be Equal    
    ...    first=Senha precisa ter: uma letra maiúscula, uma letra minúscula, um número, um caractere especial(@#$%) e tamanho entre 8-12.    
    ...    second=${response["res"].json()["error"][0]}

CT21 - Cadastro com campo senha com carácter diferente do permitido
    ${response}    Cadastrar usuario    password=Asdfgh1&    confirmPassword=Asdfgh1&
    Status Should Be    400    ${response["res"]}
    Should Be Equal    
    ...    first=Senha precisa ter: uma letra maiúscula, uma letra minúscula, um número, um caractere especial(@#$%) e tamanho entre 8-12.    
    ...    second=${response["res"].json()["error"][0]}

CT22 - Cadastro com campo confirmar senha em branco
    ${response}    Cadastrar usuario    confirmPassword=branco
    Status Should Be    400    ${response["res"]}
    Should Be Equal    
    ...    first=O campo de confirmação de senha é obrigatório.    
    ...    second=${response["res"].json()["error"][0]}

CT23 - Cadastro com campo confirmar senha com senha diferente do campo senha
    ${response}    Cadastrar usuario    confirmPassword=Asdfgh1@
    Status Should Be    400    ${response["res"]}
    Should Be Equal    
    ...    first=As senhas não conferem.    
    ...    second=${response["res"].json()["error"][0]}

CT24 - Cadastro com campo Perfil de Acesso em branco
    ${response}    Cadastrar usuario    accessProfile=branco
    Status Should Be    400    ${response["res"]}
    Should Be Equal    
    ...    first=O campo perfil de acesso é obrigatório.    
    ...    second=${response["res"].json()["error"][0]}

CT25 - Cadastro com campo Perfil de Acesso diferente de ADMIN
    ${response}    Cadastrar usuario    perfil=ALUNO
    Status Should Be    403    ${response["res"]}
    Should Be Equal    first=Você não tem permissão para esta função.    second=${response["res"].json()["msg"]}

CT26 - Cadastro com campo CPF em branco
    ${response}    Cadastrar usuario    cpf=branco    
    Status Should Be    400    ${response["res"]}
    Should Be Equal    
    ...    first=O campo CPF é obrigatório.    
    ...    second=${response["res"].json()["error"][0]}

CT27 - Cadastro com campo CPF ja cadastrado
    ${response}    Cadastrar usuario    cpf=11111111111
    Status Should Be    409    ${response["res"]}
    Should Be Equal    
    ...    first=O cpf informado já existe em nossa base de dados.    
    ...    second=${response["res"].json()["alert"][0]}

