*** Settings ***

Resource    ../base.resource

*** Test Cases ***

CT01 - Editar diretoria com sucesso
     ${id}    Board Id Valido
    ${letras}    Generate Random String    length=2    chars=[LETTERS]
    ${letras_minusculas}    Convert To Lower Case    ${letras}
    ${response}    Atualizar Board    Ron Bugado Editado${letras_minusculas}     ${id}
    Status Should Be    200    ${response}
    Should Be Equal    first=Cadastro atualizado com sucesso.    second=${response.json()["msg"]}
    Should Be Equal    first=Ron Bugado Editado${letras_minusculas}    second=${response.json()["updatedBoard"]["boardName"]}

CT02 - Editar diretoria com accessProfile de aluno
     ${id}    Board Id Valido
    ${letras}    Generate Random String    length=2    chars=[LETTERS]
    ${letras_minusculas}    Convert To Lower Case    ${letras}
    ${response}    Atualizar Board    Ron Bugado Editado${letras_minusculas}    aluno    ${id}
    Status Should Be    403    ${response}    
    Should Be Equal    first=Você não tem permissão para esta função.    second=${response.json()["msg"]}

CT03 - Editar diretoria com boardName em branco
     ${id}    Board Id Valido
    ${boardName}    Board Name Em Branco
    ${response}    Atualizar Board    ${boardName}    admin    ${id}
    Status Should Be    400    ${response}    
    Should Be Equal    first=O campo 'diretoria' é obrigatório.    second=${response.json()["error"][0]}

CT04 - Editar diretoria com boardName alfanumerico
     ${id}    Board Id Valido
    ${boardAlfanumerico}    Board Name Alfanumerico
    ${response}    Atualizar Board    ${boardAlfanumerico}    Admin    ${id}
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'diretoria' só pode conter letras e o caractere especial '&'.    second=${response.json()["error"][0]}

CT05 - Editar diretoria com boardName caracter especial invalido
     ${id}    Board Id Valido
    ${boardNameCaracterInvalido}    Board Name Caracter Invalido
    ${response}    Atualizar Board    ${boardNameCaracterInvalido}    Admin    ${id}
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'diretoria' só pode conter letras e o caractere especial '&'.    second=${response.json()["error"][0]}
     
CT14 - Editar diretoria com boardName de 50 caracteres
     ${id}    Board Id Valido
    ${letras}    Generate Random String    length=40    chars=[LETTERS]
    ${letras_minusculas}    Convert To Lower Case    ${letras}
    ${boardAlfanumerico}    Board Name Alfanumerico
    ${response}    Atualizar Board    Ron Bugado${letras_minusculas}    Admin    ${id}
    Status Should Be    200    ${response}
    Should Be Equal    first=Cadastro atualizado com sucesso.    second=${response.json()["msg"]}
    Should Be Equal    first=Ron Bugado${letras_minusculas}    second=${response.json()["updatedBoard"]["boardName"]}

CT06 - Editar diretoria com boardName de 51 caracteres
     ${id}    Board Id Valido
    ${letras}    Generate Random String    length=41    chars=[LETTERS]
    ${letras_minusculas}    Convert To Lower Case    ${letras}
    ${boardAlfanumerico}    Board Name Alfanumerico
    ${response}    Atualizar Board    Ron Bugado${letras_minusculas}    Admin    ${id}
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo 'diretoria' deve possuir no máximo 50 caracteres.    second=${response.json()["error"][0]}


CT07 - Editar diretoria com boardName já existente
    ${id}    Board Id Valido
    ${boardNameDuplicidade}    Board Name Duplicidade
    ${response}    Atualizar Board    ${boardNameDuplicidade}    Admin    ${id}
    Status Should Be    409    ${response}
    Should Be Equal    first=Não é possível salvar esse registro. Diretoria já cadastrada no sistema.    second=${response.json()["alert"][0]} 

