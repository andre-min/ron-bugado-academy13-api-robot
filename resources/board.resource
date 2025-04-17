*** Settings ***

Resource    ../base.resource

*** Keywords ***
Listar diretoria
    [Documentation]    Listar todas as diretórias cadastradas no sistema
    [Arguments]    ${accessProfile}=
    ${token}       Set Token    ${accessProfile}
    ${params}      Create Dictionary    token=${token}
    ${response}    GET On Session    alias=ron-bugado    expected_status=any    url=/api/board    params=${params}
    RETURN    ${response}

Buscar diretoria pelo id
    [Documentation]    Listar todas as diretórias cadastradas no sistema
    [Arguments]    ${id}    ${accessProfile}=
    ${token}       Set Token    ${accessProfile}
    ${params}      Create Dictionary    token=${token}    
    ${response}    GET On Session    alias=ron-bugado    expected_status=any    url=/api/board/${id}    params=${params}
    RETURN    ${response}

Criar diretoria
    [Documentation]    Criar uma nova diretoria
    [Arguments]    ${boardName}    ${accessProfile}=
    ${body}        Create Dictionary    boardName=${boardName}        #Test&Robot
    ${token}       Set Token    ${accessProfile}
    ${params}      Create Dictionary    token=${token}
    ${response}    POST On Session    alias=ron-bugado    expected_status=any    url=/api/board/    params=${params}    json=${body}
    RETURN    ${response}

Atualizar Board
    [Documentation]    keyword para atualizar dados da diretoria
    [Arguments]    ${boardName}    ${id}    ${accessProfile}=    
    #67c0af89c106476a95e82eca
    ${token}       Set Token    ${accessProfile}
    ${params}      Create Dictionary    token=${token}
    ${body}        Create Dictionary    boardName=${boardName}
    ${response}    PUT On Session    alias=ron-bugado    expected_status=any    url=/api/board/${id}    params=${params}    json=${body} 
    RETURN    ${response}

Contar diretoria
    [Documentation]    Conta a quantidade de diretoria cadastrada
    [Arguments]    ${accessProfile}=
    ${token}       Set Token    ${accessProfile}
    ${params}    Create Dictionary    token=${token}
    ${response}    GET On Session    alias=ron-bugado    expected_status=any    url=/api/board/count    params=${params}
    RETURN    ${response}

