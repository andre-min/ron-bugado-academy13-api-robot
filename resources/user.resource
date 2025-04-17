*** Settings ***

Resource    ../base.resource

Library    ../venv/lib/python3.12/site-packages/robot/libraries/OperatingSystem.py
Library    ../venv/lib/python3.12/site-packages/robot/libraries/Telnet.py

*** Keywords ***

Cadastrar usuario
    [Documentation]    keyword utilizado para cadastro de um novo usuário
    [Arguments]    ${perfil}=    ${fullName}=    ${mail}=    ${cpf}=    ${password}=    ${accessProfile}=    ${confirmPassword}=
    
    ${token}    Set Token    ${perfil}
    ${person}    Get Fake Person
    
    ${personName}               Set Default If Empty    ${fullName}           ${person}[name]
    ${personMail}               Set Default If Empty    ${mail}               ${person}[email]
    ${personCPF}                Set Default If Empty    ${cpf}                ${person}[cpf]
    ${personPassword}           Set Default If Empty    ${password}           1234@Test
    ${personAccessProfile}      Set Default If Empty    ${accessProfile}      ADMIN  
    ${personConfirmPassword}    Set Default If Empty    ${confirmPassword}    1234@Test

    ${body}    Create Dictionary
    ...    fullName=${personName}
    ...    mail=${personMail}
    ...    cpf=${personCPF}
    ...    password=${personPassword}
    ...    accessProfile=${personAccessProfile}
    ...    confirmPassword=${personConfirmPassword}
    
    ${response}    POST On Session    alias=ron-bugado    expected_status=any    url=/api/user/?token=${token}    json=${body}
    ${results}    Create Dictionary    
    ...    req    ${body}    
    ...    res    ${response}

    RETURN    ${results}    

Excluir usuario
    [Documentation]    keyword utilizado para excluir cadastro de usuário
    [Arguments]    ${id}    ${perfil}=    
    ${token}    Set Token    ${perfil}
    ${params}    Create Dictionary    token=${token}
    ${response}    DELETE On Session    alias=ron-bugado    expected_status=any    url=/api/user/${id}    params=${params}
    RETURN    ${response}

Atualizar nome/email do usuário
    [Documentation]    Keyword utilizada para atualizar nome e e-mail
    [Arguments]    ${nome}=    ${e-mail}=    ${id}=    ${perfil}=
    ${user}             Cadastrar usuario
    ${user_response}    Set Variable             ${user["res"]}
    ${token}    Set Token    ${perfil}
    ${params}    Create Dictionary    token=${token}
    ${user_name}    Set Default If Empty    ${nome}      ${user_response.json()["user"]["fullName"]}
    ${user_mail}    Set Default If Empty    ${e-mail}    ${user_response.json()["user"]["mail"]}
    ${user_id}      Set Default If Empty    ${id}        ${user_response.json()["user"]["_id"]}

    ${body}    Create Dictionary    
    ...    fullName=${user_name}
    ...    mail=${user_mail}
    
    ${response}    PUT On Session    alias=ron-bugado    expected_status=any    url=/api/user/${user_id}    params=${params}    json=${body}

    ${result}    Create Dictionary    
    ...    req=${user_response}    
    ...    res=${response}
    RETURN    ${result}

Atualizar senha usuario
    [Documentation]    Keyword utilizado para atualizar senha do usuário
    [Arguments]    ${senha}=    ${ConfirmarSenha}=    ${id}=    ${perfil}=
    ${user}             Cadastrar usuario
    ${token}    Set Token    ${perfil}
    ${params}    Create Dictionary    token=${token}
    ${password}            Set Default If Empty    ${senha}             1234@Test
    ${confirmPassword}     Set Default If Empty    ${ConfirmarSenha}    1234@Test
    ${id}                  Set Default If Empty    ${id}                ${user["res"].json()["user"]["_id"]}
    ${body}    Create Dictionary    password=${password}    confirmPassword=${confirmPassword}
    ${response}    PUT On Session    alias=ron-bugado    expected_status=any    url=/api/user/password/${id}    params=${params}    json=${body}
    
    ${result}    Create Dictionary    
    ...    req=${user["res"]}    
    ...    res=${response}

    RETURN    ${result}

Atualizar status do usuario
    [Documentation]    Keyword utilizado para atualizar status do usuário
    [Arguments]    ${status}    ${id}=    ${perfil}=
    
    ${user}             Cadastrar usuario
    ${token}    Set Token    ${perfil}
    ${params}    Create Dictionary    token=${token}
    ${_id}                  Set Default If Empty    ${id}                ${user["res"].json()["user"]["_id"]}
    ${body}    Create Dictionary    status=${status}
    ${response}    PUT On Session    alias=ron-bugado    expected_status=any    url=/api/user/status/${_id}    params=${params}    json=${body}

    ${result}    Create Dictionary    
    ...    req=${user["res"]}
    ...    res=${response}

    RETURN    ${result}

Atualiza status true
    [Arguments]    ${id}
    
    ${token}    Set Token   
    ${params}    Create Dictionary    token=${token}
    ${body}    Create Dictionary    status=true
    ${response}    PUT On Session    alias=ron-bugado    expected_status=any    url=/api/user/status/${id}    params=${params}    json=${body}
    RETURN    ${response}


Buscar usuario pelo id
    [Documentation]    keyword utilizado para buscar usuário pelo _id
    [Arguments]    ${id}    ${perfil}=
    ${token}    Set Token    ${perfil}
    ${params}    Create Dictionary    token=${token}
    ${response}    GET On Session    alias=ron-Bugado    expected_status=any    url=/api/user/${id}    params=${params}

    RETURN    ${response}

login usuario
    [Documentation]    keyword utilizada para realizar login no sistema 
    [Arguments]    ${e-mail}    ${senha}
    Set Log Level    level=WARN
    ${body}    Create Dictionary    
    ...    mail=${e-mail}    
    ...    password=${senha}
    
    Criar Sessao
    ${resposta}    POST On Session    alias=ron-bugado    expected_status=any    url=/api/login    json=${body}
    
    Set Log Level    level=INFO

    RETURN    ${resposta}    

