*** Settings ***
Resource    ../base.resource

*** Test Cases ***
CT01 - Login com sucesso
    ${env}    Carregar Variaveis Ambiente
    ${response}    login usuario    e-mail=${env["ADMIN_MAIL"]}    senha=${env["ADMIN_PASSWORD"]}
 
    Status Should Be    200    ${response}
    Should Be Equal    
    ...    first=Olá ${response.json()["user"]["fullName"]}, autenticação autorizada com sucesso!    
    ...    second=${response.json()["msg"]}

CT02 - Login com e-mail invalido
    ${env}    Carregar Variaveis Ambiente
    ${response}    login usuario    e-mail=emailinvalido@teste.com.br    senha=${env["ADMIN_PASSWORD"]}
    Status Should Be    400    ${response}
    Should Be Equal    first=E-mail ou senha informados são inválidos.    second=${response.json()["alert"]}

CT03 - Login com senha invalida
    ${env}    Carregar Variaveis Ambiente
    ${response}    login usuario    e-mail=${env["ADMIN_MAIL"]}    senha=Invali123@
    Status Should Be    400    ${response}
    Should Be Equal    first=E-mail ou senha informados são inválidos.    second=${response.json()["alert"]}

CT04 - Login com email em branco
    ${env}    Carregar Variaveis Ambiente
    ${response}    login usuario    e-mail=${EMPTY}    senha=${env["ADMIN_PASSWORD"]}
    Status Should Be    400    ${response}
    Should Be Equal    
    ...    first=O campo e-mail é obrigatório.    
    ...    second=${response.json()["mail"]}

CT05 - Login com senha em branco
    ${env}    Carregar Variaveis Ambiente
    ${response}    login usuario    e-mail=${env["ADMIN_MAIL"]}    senha=${EMPTY}
    Status Should Be    400    ${response}
    Should Be Equal    
    ...    first=O campo senha é obrigatório.    
    ...    second=${response.json()["password"]}



