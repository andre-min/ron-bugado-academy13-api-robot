*** Settings ***
Resource    ../base.resource

*** Test Cases ***
CT01 - Atualizar cadastro de usuario com sucesso
    ${person}      Get Fake Person
    ${response}    Atualizar nome/email do usuário    nome=${person["name"]}    e-mail=${person["email"]}
    ${id}          Set Variable                       ${response["req"].json()["user"]["_id"]}

    TRY

        Status Should Be    200    ${response["res"]}
        Should Be Equal    
        ...    first=Dados atualizados com sucesso!    
        ...    second=${response["res"].json()["msg"]}
        Should Be Equal    
        ...    first=${response["req"].json()["user"]["_id"]}    
        ...    second=${response["res"].json()["updatedUser"]["_id"]}
        Should Be Equal    
        ...    first=${person["name"]}  
        ...    second=${response["res"].json()["updatedUser"]["fullName"]}
        Should Be Equal    
        ...    first=${person["email"]}    
        ...    second=${response["res"].json()["updatedUser"]["mail"]}

    FINALLY
        ${delete_response}    Excluir usuario    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Usuário deletado com sucesso!.    second=${delete_response.json()["msg"]}
    END
    
CT02 - Editar e-mail do usuário com formato inválido
    ${response}    Atualizar nome/email do usuário    e-mail=email@gmail.com.#br    
    ${id}          Set Variable                       ${response["req"].json()["user"]["_id"]}

    TRY

        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O e-mail informado é inválido. Informe um e-mail no formato [nome@domínio.com].    
        ...    second=${response["res"].json()["error"][0]}
    
    FINALLY
        ${delete_response}    Excluir usuario    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Usuário deletado com sucesso!.    second=${delete_response.json()["msg"]}
    END
    
CT03 - Editar e-mail do usuário enviando o valor em branco
    ${response}    Atualizar nome/email do usuário    e-mail=branco
    ${id}          Set Variable                       ${response["req"].json()["user"]["_id"]}

    TRY

        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O campo e-mail é obrigatório.    
        ...    second=${response["res"].json()["error"][0]}

    FINALLY
        ${delete_response}    Excluir usuario    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Usuário deletado com sucesso!.    second=${delete_response.json()["msg"]}
    END
    
CT04 - Editar e-mail do usuário enviando um espaço entre o domínio do e-mail
    ${response}    Atualizar nome/email do usuário    e-mail=espaco@ gmail.com.br
    ${id}          Set Variable                       ${response["req"].json()["user"]["_id"]}

    TRY

        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O e-mail informado é inválido. Informe um e-mail no formato [nome@domínio.com].
        ...    second=${response["res"].json()["error"][0]}   

    FINALLY
        ${delete_response}    Excluir usuario    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Usuário deletado com sucesso!.    second=${delete_response.json()["msg"]}
    END
    
CT05 - Editar nome do usuário enviando apenas o primeiro nome
    ${response}    Atualizar nome/email do usuário    nome=Adriana
    ${id}          Set Variable                       ${response["req"].json()["user"]["_id"]}

    TRY

        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=Informe o nome e sobrenome com as iniciais em letra maiúscula e sem caracteres especiais.
        ...    second=${response["res"].json()["error"][0]}

    FINALLY
        ${delete_response}    Excluir usuario    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Usuário deletado com sucesso!.    second=${delete_response.json()["msg"]}
    END
    
CT06 - Editar nome do usuário enviando letras minúsculas
    ${response}    Atualizar nome/email do usuário    nome=mário alves
    ${id}          Set Variable                       ${response["req"].json()["user"]["_id"]}

    TRY

        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=Informe o nome e sobrenome com as iniciais em letra maiúscula e sem caracteres especiais.
        ...    second=${response["res"].json()["error"][0]}

    FINALLY
        ${delete_response}    Excluir usuario    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Usuário deletado com sucesso!.    second=${delete_response.json()["msg"]}
    END
    
CT07 - Editar nome do usuário enviando nome com caracteres especiais
    ${response}    Atualizar nome/email do usuário    nome=Mário@ Alves#
    ${id}          Set Variable                       ${response["req"].json()["user"]["_id"]}

    TRY

        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=Informe o nome e sobrenome com as iniciais em letra maiúscula e sem caracteres especiais.
        ...    second=${response["res"].json()["error"][0]}

    FINALLY
        ${delete_response}    Excluir usuario    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Usuário deletado com sucesso!.    second=${delete_response.json()["msg"]}
    END
    
CT08 - Editar nome do usuário enviando um nome com 100 caracteres
    ${fullName}    Set Variable    Isabella Gregoria Duarte da Silva Costa Albuquerque Oliveira Barbosa Pimentel Rocha Pereira de Souza
    ${response}    Atualizar nome/email do usuário    nome=${fullName}
    ${id}          Set Variable                       ${response["req"].json()["user"]["_id"]}

    TRY

        Status Should Be    200    ${response["res"]}
        Should Be Equal    
        ...    first=Dados atualizados com sucesso!    
        ...    second=${response["res"].json()["msg"]}
        Should Be Equal    
        ...    first=${response["req"].json()["user"]["_id"]}    
        ...    second=${response["res"].json()["updatedUser"]["_id"]}
        Should Be Equal    
        ...    first=${fullName}  
        ...    second=${response["res"].json()["updatedUser"]["fullName"]}
        Should Be Equal    
        ...    first=${response["req"].json()["user"]["mail"]}     
        ...    second=${response["res"].json()["updatedUser"]["mail"]}
    
    FINALLY
        ${delete_response}    Excluir usuario    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Usuário deletado com sucesso!.    second=${delete_response.json()["msg"]}
    END
    
CT09 - Editar nome do usuário enviando um nome com 101 caracteres
    ${fullName}    Set Variable    Isabella Gregoria Duarte da Silva Costa Albuquerque Oliveira Barbosa Pimentel Rocha Pereira do Amaral
    ${response}    Atualizar nome/email do usuário    nome=${fullName}
    ${id}          Set Variable                       ${response["req"].json()["user"]["_id"]}

    TRY

    Status Should Be    400    ${response["res"]}
    Should Be Equal    
    ...    first=O nome completo deve ter no máximo 100 caracteres.
    ...    second=${response["res"].json()["error"][0]}
    
    FINALLY
        ${delete_response}    Excluir usuario    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Usuário deletado com sucesso!.    second=${delete_response.json()["msg"]}
    END
    
CT10 - Editar nome do usuário enviando um valor alfanumérico
    ${numeros}    Generate Random String    length=3    chars=${DIGITS}
    ${response}    Atualizar nome/email do usuário    nome=Paulo${numeros} Ron Bugado
    ${id}          Set Variable                       ${response["req"].json()["user"]["_id"]}

    TRY

        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O campo nome completo não deve conter números
        ...    second=${response["res"].json()["error"][0]}
    
    FINALLY

        ${delete_response}    Excluir usuario    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Usuário deletado com sucesso!.    second=${delete_response.json()["msg"]}

    END
    
CT11 - Editar nome do usuário enviando um valor em branco
    ${response}    Atualizar nome/email do usuário    nome=branco
    ${id}          Set Variable                       ${response["req"].json()["user"]["_id"]}

    TRY

        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O campo nome completo é obrigatório.
        ...    second=${response["res"].json()["error"][0]}

    FINALLY

        ${delete_response}    Excluir usuario    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Usuário deletado com sucesso!.    second=${delete_response.json()["msg"]}
        
    END
    
CT12 - Editar nome do usuário sem alterar e-mail com sucesso
    ${person}    Get Fake Person
    ${response}    Atualizar nome/email do usuário    nome=${person["name"]}
    ${id}          Set Variable                       ${response["req"].json()["user"]["_id"]}

    TRY

        Status Should Be    200    ${response["res"]}
        Should Be Equal    
        ...    first=Dados atualizados com sucesso!    
        ...    second=${response["res"].json()["msg"]}
        Should Be Equal    
        ...    first=${response["req"].json()["user"]["_id"]}    
        ...    second=${response["res"].json()["updatedUser"]["_id"]}
        Should Be Equal    
        ...    first=${person["name"]}  
        ...    second=${response["res"].json()["updatedUser"]["fullName"]}
        Should Be Equal    
        ...    first=${response["req"].json()["user"]["mail"]}    
        ...    second=${response["res"].json()["updatedUser"]["mail"]}    

    FINALLY

        ${delete_response}    Excluir usuario    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Usuário deletado com sucesso!.    second=${delete_response.json()["msg"]}
        
    END
    
CT13 - Editar dados do usuario acessProfile diferente de ADMIN
    ${response}    Atualizar nome/email do usuário    perfil=aluno
    ${id}          Set Variable                       ${response["req"].json()["user"]["_id"]}

    TRY

        Status Should Be    403    ${response["res"]}
        Should Be Equal    
        ...    first=Você não tem permissão para esta função.    
        ...    second=${response["res"].json()["msg"]}

    FINALLY

        ${delete_response}    Excluir usuario    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Usuário deletado com sucesso!.    second=${delete_response.json()["msg"]}
        
    END
    
CT14 - Editar senha do ususario com sucesso
    ${response}    Atualizar senha usuario    senha=b$xudJsK34    ConfirmarSenha=b$xudJsK34
    ${id}          Set Variable                       ${response["req"].json()["user"]["_id"]}

    TRY

        Status Should Be    200    ${response["res"]}
        Should Be Equal    first=Senha atualizada com sucesso!    second=${response["res"].json()["msg"]}

        ${get_response}    Buscar usuario pelo id    id=${id}
        Status Should Be    200    ${get_response}

       
        ${keys}    Create List    _id    fullName    mail    password    accessProfile    cpf    status    audit    __v

        #${keys}    Convert To Dictionary    ${keys_}
        ${response_json}    Set Variable    ${get_response.json()}
        ${user}    Set Variable    ${get_response.json()}
        FOR    ${key}    IN    @{keys}
            Dictionary Should Contain Key    ${user}    ${key}
        END

        ${register_audit}    Set Variable    ${get_response.json()["audit"][0]}
        ${audit_keys}    Create List    registeredBy    registrationDate    registrationNumber
        FOR    ${key}    IN    @{audit_keys}
            Dictionary Should Contain Key    ${register_audit}    ${key}  
        END        
        
        ${update_audit}    Set Variable     ${get_response.json()["audit"][1]}
        ${update_Keys}    Create List    updatedBy    updateDate     _id   
        FOR    ${key}    IN    @{update_Keys}
            Dictionary Should Contain Key    ${update_audit}    ${key}  
        END 

    FINALLY

        ${delete_response}    Excluir usuario    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Usuário deletado com sucesso!.    second=${delete_response.json()["msg"]}
        
    END
    
    
CT15 - Editar senha do usuário com 7 caracteres
    ${response}    Atualizar senha usuario    senha=C42@xyE    ConfirmarSenha=C42@xyE
    ${id}          Set Variable                       ${response["req"].json()["user"]["_id"]}

    TRY

        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=Senha precisa ter: uma letra maiúscula, uma letra minúscula, um número, um caractere especial(@#$%) e tamanho entre 8-12.    
        ...    second=${response["res"].json()["error"][1]}

    FINALLY

        ${delete_response}    Excluir usuario    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Usuário deletado com sucesso!.    second=${delete_response.json()["msg"]}
        
    END
    
CT16 - Editar senha do usuário com 8 caracteres
    ${response}    Atualizar senha usuario    senha=jhf5VWC@    ConfirmarSenha=jhf5VWC@
    ${id}          Set Variable                       ${response["req"].json()["user"]["_id"]}

    TRY

        Status Should Be    200    ${response["res"]}
        Should Be Equal    first=Senha atualizada com sucesso!    second=${response["res"].json()["msg"]}

    FINALLY

        ${delete_response}    Excluir usuario    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Usuário deletado com sucesso!.    second=${delete_response.json()["msg"]}
        
    END
    
CT17 - Editar senha do usuário enviando 13 caracteres
    ${response}    Atualizar senha usuario    senha=s6Tr5l6YbX@%@    ConfirmarSenha=s6Tr5l6YbX@%@
    ${id}          Set Variable                       ${response["req"].json()["user"]["_id"]}

    TRY

        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=Senha precisa ter: uma letra maiúscula, uma letra minúscula, um número, um caractere especial(@#$%) e tamanho entre 8-12.    
        ...    second=${response["res"].json()["error"][0]}    

    FINALLY

        ${delete_response}    Excluir usuario    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Usuário deletado com sucesso!.    second=${delete_response.json()["msg"]}
        
    END
    
CT18 - Editar senha do usuário enviando 12 caracteres
    ${response}    Atualizar senha usuario    senha=Ht$Na5m7gUe#    ConfirmarSenha=Ht$Na5m7gUe#
    ${id}          Set Variable                       ${response["req"].json()["user"]["_id"]}

    TRY

        Status Should Be    200    ${response["res"]}
        Should Be Equal    first=Senha atualizada com sucesso!    second=${response["res"].json()["msg"]}

    FINALLY

        ${delete_response}    Excluir usuario    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Usuário deletado com sucesso!.    second=${delete_response.json()["msg"]}
        
    END
    
CT19 - Editar senha do usuário sem letras maiúsculas
    ${response}    Atualizar senha usuario    senha=xbof%$848    ConfirmarSenha=xbof%$848
    ${id}          Set Variable                       ${response["req"].json()["user"]["_id"]}

    TRY

        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=Senha precisa ter: uma letra maiúscula, uma letra minúscula, um número, um caractere especial(@#$%) e tamanho entre 8-12.    
        ...    second=${response["res"].json()["error"][0]}    

    FINALLY

        ${delete_response}    Excluir usuario    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Usuário deletado com sucesso!.    second=${delete_response.json()["msg"]}
        
    END
    
CT20 - Editar senha do usuário sem letras minúsculas
    ${response}    Atualizar senha usuario    senha=JJ#78Y8M$    ConfirmarSenha=JJ#78Y8M$
    ${id}          Set Variable                       ${response["req"].json()["user"]["_id"]}

    TRY

        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=Senha precisa ter: uma letra maiúscula, uma letra minúscula, um número, um caractere especial(@#$%) e tamanho entre 8-12.    
        ...    second=${response["res"].json()["error"][0]}   

    FINALLY

        ${delete_response}    Excluir usuario    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Usuário deletado com sucesso!.    second=${delete_response.json()["msg"]}
        
    END
    
CT21 - Editar senha do usuário sem caracteres especiais
    ${response}    Atualizar senha usuario    senha=9To9QdD9h    ConfirmarSenha=9To9QdD9h
    ${id}          Set Variable                       ${response["req"].json()["user"]["_id"]}

    TRY

        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=Senha precisa ter: uma letra maiúscula, uma letra minúscula, um número, um caractere especial(@#$%) e tamanho entre 8-12.    
        ...    second=${response["res"].json()["error"][0]}

    FINALLY

        ${delete_response}    Excluir usuario    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Usuário deletado com sucesso!.    second=${delete_response.json()["msg"]}
        
    END
    
CT22 - Editar senha do usuário sem números
    ${response}    Atualizar senha usuario    senha=S@mN@%gQv    ConfirmarSenha=S@mN@%gQv
    ${id}          Set Variable                       ${response["req"].json()["user"]["_id"]}

    TRY

        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=Senha precisa ter: uma letra maiúscula, uma letra minúscula, um número, um caractere especial(@#$%) e tamanho entre 8-12.    
        ...    second=${response["res"].json()["error"][0]}

    FINALLY

        ${delete_response}    Excluir usuario    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Usuário deletado com sucesso!.    second=${delete_response.json()["msg"]}
        
    END
    
CT23 - Editar senha do usuário enviando o valor da senha em branco
    ${response}    Atualizar senha usuario    senha=branco    ConfirmarSenha=1234@Test
    ${id}          Set Variable                       ${response["req"].json()["user"]["_id"]}

    TRY

        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=Campo senha é obrigatório    
        ...    second=${response["res"].json()["error"][0]}

    FINALLY

        ${delete_response}    Excluir usuario    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Usuário deletado com sucesso!.    second=${delete_response.json()["msg"]}
        
    END
    
CT24 - Editar senha do usuário enviando caracteres não permitido pela regra de negócio
    ${response}    Atualizar senha usuario    senha=WhVzarW2-9    ConfirmarSenha=WhVzarW2-9
    ${id}          Set Variable                       ${response["req"].json()["user"]["_id"]}

    TRY

        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=Senha precisa ter: uma letra maiúscula, uma letra minúscula, um número, um caractere especial(@#$%) e tamanho entre 8-12.  
        ...    second=${response["res"].json()["error"][0]}

    FINALLY

        ${delete_response}    Excluir usuario    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Usuário deletado com sucesso!.    second=${delete_response.json()["msg"]}
        
    END
    
CT25 - Editar senha do usuário enviando valor de confirmar senha em branco
    ${response}    Atualizar senha usuario    senha=1234@Test    ConfirmarSenha=branco
    ${id}          Set Variable                       ${response["req"].json()["user"]["_id"]}

    TRY

        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O campo de confirmação de senha é obrigatório.   
        ...    second=${response["res"].json()["error"][0]}

    FINALLY

        ${delete_response}    Excluir usuario    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Usuário deletado com sucesso!.    second=${delete_response.json()["msg"]}
        
    END
    
CT26 - Editar senha do usuário enviando valores diferentes nos campos senha e confirmar senha.
    ${response}    Atualizar senha usuario    senha=1234@Test    ConfirmarSenha=12345@Test
    ${id}          Set Variable                       ${response["req"].json()["user"]["_id"]}

    TRY

        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=As senhas não conferem.  
        ...    second=${response["res"].json()["error"][0]}
    
    FINALLY

        ${delete_response}    Excluir usuario    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Usuário deletado com sucesso!.    second=${delete_response.json()["msg"]}
        
    END
    
CT27 - Editar senha do usuario com acessProfile de aluno
    ${response}    Atualizar senha usuario    senha=1234@Test    ConfirmarSenha=12345@Test    perfil=aluno
    ${id}          Set Variable                       ${response["req"].json()["user"]["_id"]}

    TRY

        Status Should Be    403    ${response["res"]}
        Should Be Equal    
        ...    first=Você não tem permissão para esta função.    
        ...    second=${response["res"].json()["msg"]}

    FINALLY

        ${delete_response}    Excluir usuario    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Usuário deletado com sucesso!.    second=${delete_response.json()["msg"]}
        
    END
    
CT28 - Editar status para false com sucesso
    ${response}    Atualizar status do usuario    status=false   
    ${id}          Set Variable                       ${response["req"].json()["user"]["_id"]}

    TRY

        Status Should Be    200    ${response["res"]}
        Should Be Equal    
        ...    first=Status do usuario atualizado com sucesso para status false.    
        ...    second=${response["res"].json()["msg"]}
        ${get_response}    Buscar usuario pelo id    id=${id}
        Status Should Be    200    ${get_response}
        Should Be Equal    first=${False}    second=${get_response.json()["status"]}

    FINALLY

        ${delete_response}    Excluir usuario    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Usuário deletado com sucesso!.    second=${delete_response.json()["msg"]}
        
    END
      
CT29 - Editar status para true com sucesso
    ${response}    Atualizar status do usuario    status=false    

    ${id}          Set Variable                       ${response["req"].json()["user"]["_id"]}

    TRY

        Status Should Be    200    ${response["res"]}
        Should Be Equal    
        ...    first=Status do usuario atualizado com sucesso para status false.    
        ...    second=${response["res"].json()["msg"]}
        ${get_response}    Buscar usuario pelo id    id=${id} 
        Status Should Be    200    ${get_response}
        Should Be Equal    first=${False}    second=${get_response.json()["status"]}

        
        ${true_response}    Atualiza status true    id=${id}
        Status Should Be    200    ${true_response}
        Should Be Equal    
        ...    first=Status do usuario atualizado com sucesso para status true.    
        ...    second=${true_response.json()["msg"]}
        ${get_response}    Buscar usuario pelo id    id=${id}
        Status Should Be    200    ${get_response}
        Should Be Equal    first=${True}    second=${get_response.json()["status"]}

    FINALLY

        ${delete_response}    Excluir usuario    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Usuário deletado com sucesso!.    second=${delete_response.json()["msg"]}
        
    END
        
CT30 - Editar status enviando token com acessProfile diferente do ADMIN
    ${response}    Atualizar status do usuario    status=false    perfil=aluno
    ${id}          Set Variable                       ${response["req"].json()["user"]["_id"]}

    TRY

        Status Should Be    403    ${response["res"]}
        Should Be Equal    
        ...    first=Você não tem permissão para esta função.    
        ...    second=${response["res"].json()["msg"]}

    FINALLY

        ${delete_response}    Excluir usuario    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Usuário deletado com sucesso!.    second=${delete_response.json()["msg"]}
        
    END
    