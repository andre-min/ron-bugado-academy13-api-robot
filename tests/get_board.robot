*** Settings ***

Resource    ../base.resource

*** Test Cases ***
CT01 - Buscar diretoria pelo id com sucesso (token admi)
    ${id}    Board Id Valido
    ${response}    Buscar diretoria pelo id       ${id}
    Status Should Be    200    ${response}
    Should Not Be Empty    item=${response.json()}

CT02 - Buscar diretoria pelo id (token aluno)
    ${id}    Board Id Valido
    ${response}    Buscar diretoria pelo id    aluno    ${id}
    Status Should Be    403
    Should Be Equal    Você não tem permissão para esta função.    ${response.json()["msg"]}

CT03 - Buscar diretoria pelo id enviando id inválido (token admi)
    ${id}    Board Id Invalido
    ${response}    Buscar diretoria pelo id    admin    ${id}
    Status Should Be    404    ${response}
    Should Be Equal    Não foi possível encontrar a diretoria com o id especificado    ${response.json()["msg"]}