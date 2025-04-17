*** Settings ***

Resource    ../../base.resource


*** Keywords ***

Criar Sessao
    [Documentation]    Keyword utilizado para criar sessão inicial
    &{hearders}    Create Dictionary    accept=application/json    Content-Type=application/json
    Create Session    alias=ron-bugado    url=${BASE_URL}    headers=${hearders}    verify=True

Pegar Token ADMIN
    [Documentation]    Request usada para pegar o token do admin
    ${env}    Carregar Variaveis Ambiente
    Set Log Level    level=WARN
    ${body}    Create Dictionary
    ...    mail=${env["ADMIN_MAIL"]}
    ...    password=${env["ADMIN_PASSWORD"]}    
    Criar Sessao
    ${resposta}    POST On Session    alias=ron-bugado    url=/api/login    json=${body}
    Set Log Level    level=INFO
    RETURN    ${resposta.json()["token"]}

Pegar Token ALUNO
    [Documentation]    Request usada para pegar o token do aluno
    ${env}    Carregar Variaveis Ambiente
    Set Log Level    level=WARN
    ${body}    Create Dictionary
    ...    mail=${env["ALUNO_MAIL"]}
    ...    password=${env["ALUNO_PASSWORD"]}
        
    Criar Sessao
    ${resposta}    POST On Session    alias=ron-bugado    url=/api/login    json=${body}
    Set Log Level    level=INFO
    RETURN    ${resposta.json()["token"]}

Set Token
    [Arguments]    ${accessProfile}=    
    ${profile}    Convert To Upper Case    ${accessProfile}
    ${result}=    Run Keyword If    '${profile}' == 'ALUNO'    Pegar Token ALUNO
    ...    ELSE IF    '${profile}' == ""   Pegar Token ADMIN
    ...    ELSE    Pegar Token ADMIN
    RETURN    ${result}

Set Default If Empty
    [Arguments]    ${var}    ${default}
    ${result}=    Run Keyword If    '${var}' == ""    Set Variable    ${default}
    ...    ELSE IF    '${var}' == "branco"    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${var}
    RETURN    ${result}


