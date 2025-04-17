*** Settings ***

Resource    ../base.resource


*** Test Cases ***
CT01 - Criar diretoria com sucesso
    ${letras}    Generate Random String    length=4    chars=[LETTERS]
    ${letras_minusculas}    Convert To Lower Case    ${letras}
    ${response}    Criar diretoria    Bugado${letras_minusculas}    Admin
    Status Should Be    201    ${response}
    Should Be Equal    first=Cadastro realizado com sucesso!    second=${response.json()["msg"]}
    Should Be Equal    first=Bugado${letras_minusculas}    second=${response.json()["newBoard"]["boardName"]}

CT02 - Criar diretoria com boardName em branco
    ${response}    Criar diretoria    ${EMPTY}    Admin
    Status Should Be    400    ${response}   
    Should Be Equal    first=O campo 'diretoria' é obrigatório.    second=${response.json()["error"][0]} 

CT03 - Criar diretoria com boardName alfanumerico
    ${letras}    Generate Random String    length=40    chars=[LETTERS]
    ${letras_minusculas}    Convert To Lower Case    ${letras}
    ${nameAlfaNumerico}    Board Name Alfanumerico
    ${response}    Criar diretoria    ${nameAlfaNumerico}
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'diretoria' só pode conter letras e o caractere especial '&'.    second=${response.json()["error"][0]}

CT04 - Criar diretoria com boardName de 50 caracteres
    ${letras}    Generate Random String    length=40    chars=[LETTERS]
    ${letras_minusculas}    Convert To Lower Case    ${letras}
    ${boardAlfanumerico}    Board Name Alfanumerico
    ${response}    Criar diretoria    Ron Bugado${letras_minusculas}    Admin
    Status Should Be    201    ${response}
    Should Be Equal    first=Cadastro realizado com sucesso!    second=${response.json()["msg"]}
    Should Be Equal    first=Ron Bugado${letras_minusculas}    second=${response.json()["newBoard"]["boardName"]}
    
CT05 - Criar diretoria com boardName de 51 caracteres
    ${letras}    Generate Random String    length=41    chars=[LETTERS]
    ${letras_minusculas}    Convert To Lower Case    ${letras}
    ${boardAlfanumerico}    Board Name Alfanumerico
    ${response}    Criar diretoria    Ron Bugado${letras_minusculas}    Admin
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'diretoria' deve possuir no máximo 50 caracteres.    second=${response.json()["error"][0]}

CT06 - Criar diretoria com boardName caracter especial invalido
    ${boardNameCaracterInvalido}    Board Name Caracter Invalido
    ${response}    Criar diretoria    ${boardNameCaracterInvalido}    Admin
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'diretoria' só pode conter letras e o caractere especial '&'.    second=${response.json()["error"][0]}
    
CT07 - Criar diretoria com boardName já existente
    ${boardNameDuplicidade}    Board Name Duplicidade
    ${response}    Criar diretoria    ${boardNameDuplicidade}    Admin
    Status Should Be    409    ${response}
    Should Be Equal    first=Não é possível salvar esse registro. Diretoria já cadastrada no sistema.    second=${response.json()["alert"][0]} 

CT08 - Criar diretoria com accessProfile de Aluno
    ${letras}    Generate Random String    length=4    chars=[LETTERS]
    ${letras_minusculas}    Convert To Lower Case    ${letras}
    ${response}    Criar diretoria   Ron Bugado${letras_minusculas}    aluno
    Status Should Be    403    ${response}
    Should Be Equal    first=Você não tem permissão para esta função.    second=${response.json()["msg"]}
    

CT17 - Contar diretoria com sucesso (token admin)
    ${response}    Contar diretoria       admin
    Status Should Be    200    ${response}
    Should Not Be Empty    item=${response.json()}

CT18 - Contar diretoria com sucesso (token aluno)
    ${response}    Contar diretoria       aluno
    Status Should Be    403    ${response}
    Should Be Equal    first=Você não tem permissão para esta função.    second=${response.json()["msg"]}



