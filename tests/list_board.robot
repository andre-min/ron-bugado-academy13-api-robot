*** Settings ***

Resource    ../base.resource

*** Test Cases ***

CT19 - Listar diretoria (token aluno)
    ${response}    Listar diretoria    aluno
    Status Should Be    403    ${response}
    Should Be Equal    first=Você não tem permissão para esta função.    second=${response.json()["msg"]} 

CT20 - Listar diretorias com sucesso
   
    ${response}    Listar diretoria    admin
    Status Should Be    200    ${response}
    Should Not Be Empty    item=${response.json()}

CT21 - Listar diretorias e verificar se os campos estão retornando corretamente
    ${response}    Listar diretoria    admin
    Status Should Be    200    ${response}
    ${items}    Get Slice From List    ${response.json()}    0    5
    ${keys}    Create List     _id    boardName    boardCode    status    audit    __v
    FOR    ${item}    IN    @{items}
        FOR    ${key}    IN    @{keys}
            Dictionary Should Contain Key    ${item}    ${key}
        END
    END

   

CT22 - Listar diretorias e verificar se os campos da auditoria estão retornando corretamente
    [Tags]    iteracao
    ${response}    Listar diretoria    admin
    Status Should Be    200    ${response}
    Should Not Be Empty    item=${response.json()}
    ${items}    Get Slice From List    ${response.json()}    0    5
    FOR    ${item}    IN    ${items}
        ${length}    Get Length    ${item}
        ${keys}    Create List     registeredBy    registrationDate    _id
        FOR    ${index}    IN RANGE    0    ${length}
            FOR    ${key}    IN    @{keys}
                Dictionary Should Contain Key    dictionary=${item[${index}]["audit"][0]}    key=${key}  
            END
        END
    END

CT23 - Listar diretorias e verificar se os campos do registeredBy estão retornando corretamente
    [Tags]    smoke
    ${response}    Listar diretoria    admin
    Status Should Be    200    ${response}
    Should Not Be Empty    item=${response.json()}
    ${items}    Get Slice From List    ${response.json()}    0    5
    FOR    ${item}    IN    ${items}
       ${length}=    Get Length    ${item}
       ${keys}=    Create List     userId    userLogin
       FOR    ${index}    IN RANGE    0    ${length}
           FOR    ${key}    IN    @{keys}
               Dictionary Should Contain Key    dictionary=${item[${index}]["audit"][0]["registeredBy"]}    key=${key}  
           END
       END
    END

