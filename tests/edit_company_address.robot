*** Settings ***

Resource    ../base.resource

*** Test Cases ***
CT01 - Editar lograduro com sucesso
    ${logradouro}    Set Variable    Avenida Jandira
    ${response}    Atualizar endereço da empresa    street=${logradouro}
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}

    TRY
        Status Should Be    201    ${response["res"]}
        Should Be Equal    
        ...    first=Endereço da companhia atualizado com sucesso.    
        ...    second=${response["res"].json()["msg"]}
        Should Be Equal    
        ...    first=${logradouro}    
        ...    second=${response["res"].json()["updateCompany"]["address"][0]["street"]}       
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END

CT02 - Editar campo logradouro com mais de 50 caracteres
    ${logradouro}    Set Variable    Avenida Muito Longa Que Ultrapassa O Limite de 50 Caracteres escritos para o limites
    ${response}    Atualizar endereço da empresa    street=${logradouro}
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}
    TRY
        Status Should Be    400    ${response["res"]}

        Should Be Equal    
        ...    first=O campo 'logradouro' deve possuir no máximo 50 caracteres.    
        ...    second=${response["res"].json()["error"]}
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
        
    END

CT03 - Editar campo logradouro com alfanumérico
    ${logradouro}    Set Variable    Avenida 10 de julho
    ${response}    Atualizar endereço da empresa    street=${logradouro}
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}
    TRY
        Status Should Be    201    ${response["res"]}
        Should Be Equal    
        ...    first=Endereço da companhia atualizado com sucesso.    
        ...    second=${response["res"].json()["msg"]}
        Should Be Equal    
        ...    first=${logradouro}    
        ...    second=${response["res"].json()["updateCompany"]["address"][0]["street"]}  
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END

CT04 - Editar campo logradouro com caracteres especiais
    ${logradouro}    Set Variable    '\'Aºe-ndª D\'avo\''
    ${response}    Atualizar endereço da empresa    street=${logradouro}
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}
    
    TRY
        Status Should Be    201    ${response["res"]}
        Should Be Equal    
        ...    first=Endereço da companhia atualizado com sucesso.    
        ...    second=${response["res"].json()["msg"]}
        Should Be Equal    
        ...    first=${logradouro}    
        ...    second=${response["res"].json()["updateCompany"]["address"][0]["street"]}   
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END

CT05 - Editar campo logradouro com caracteres especiais
    ${logradouro}    Set Variable    '\'Aºe-ndª D\'avo\''
    ${response}    Atualizar endereço da empresa    street=${logradouro}
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}
    TRY
        Status Should Be    201    ${response["res"]}
        Should Be Equal    
        ...    first=Endereço da companhia atualizado com sucesso.    
        ...    second=${response["res"].json()["msg"]}
        Should Be Equal    
        ...    first=${logradouro}    
        ...    second=${response["res"].json()["updateCompany"]["address"][0]["street"]} 
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END
    
CT06 - Editar campo logradouro com caracteres especiais invalidos
    ${logradouro}    Set Variable    Avenid@!
    ${response}    Atualizar endereço da empresa    street=${logradouro}
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}

    TRY
        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O campo 'logradouro' só pode conter letras, números e os caracteres especiais 'ª', 'º', '‘' e '-'    
        ...    second=${response["res"].json()["error"][0]}
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}    
    END
    
    
    

CT07 - Editar campo logradouro em branco
    ${response}    Atualizar endereço da empresa    street=branco
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}

    TRY
        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O campo 'logradouro' é obrigatório.    
        ...    second=${response["res"].json()["error"][0]}
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END
    
CT08 - Editar campo numero com sucesso
    ${numero}    Set Variable    101
    ${response}    Atualizar endereço da empresa    number=${numero}
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}

    TRY
        Status Should Be    201    ${response["res"]}
        Should Be Equal    
        ...    first=Endereço da companhia atualizado com sucesso.    
        ...    second=${response["res"].json()["msg"]}
        Should Be Equal    
        ...    first=${numero}    
        ...    second=${response["res"].json()["updateCompany"]["address"][0]["number"]}
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}   
    END
    
CT09 - Editar campo numero com mais de 10 caracteres
    ${response}    Atualizar endereço da empresa    number=12345678901
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}

    TRY
        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O campo 'número' deve possuir no máximo 10 caracteres.    
        ...    second=${response["res"].json()["error"][0]}
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END
    
CT10 - Editar campo numero em branco
    ${response}    Atualizar endereço da empresa    number=branco
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}

    TRY
        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O campo 'número' é obrigatório.    
        ...    second=${response["res"].json()["error"][0]}
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END

CT11 - Editar campo numero com letras
    ${response}    Atualizar endereço da empresa    number=ABCD
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}
    
    TRY
        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O campo 'número' deve conter apenas numeros.
        ...    second=${response["res"].json()["error"][0]}
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END

CT12 - Editar campo numero com alfanumerico
    ${response}    Atualizar endereço da empresa    number=12@!
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}

    TRY
        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O campo 'número' deve conter apenas numeros.
        ...    second=${response["res"].json()["error"][0]}
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END

CT13 - Editar campo complemento com sucesso
    ${complement}    Set Variable    Proximo a caixa de agua - lado ímpar
    ${response}    Atualizar endereço da empresa    complement=${complement}
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}

    TRY
        Status Should Be    201    ${response["res"]}
        Should Be Equal    
        ...    first=Endereço da companhia atualizado com sucesso.    
        ...    second=${response["res"].json()["msg"]}
        Should Be Equal    
        ...    first=${complement}    
        ...    second=${response["res"].json()["updateCompany"]["address"][0]["complement"]}   
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END
    
CT14 - Editar campo complemento em branco
    ${response}    Atualizar endereço da empresa    complement=branco
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}

    TRY
        Status Should Be    201    ${response["res"]}
        Should Be Equal    
        ...    first=Endereço da companhia atualizado com sucesso.    
        ...    second=${response["res"].json()["msg"]}
        Should Be Equal    
        ...    first=${EMPTY}    
        ...    second=${response["res"].json()["updateCompany"]["address"][0]["complement"]}
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END
    
CT15 - Editar campo complemento com mais de 80 caracteres
    ${complement}    Set Variable    Estou criando um complemento de endereço que contenha 81 caracteres para realizar
    ${response}    Atualizar endereço da empresa    complement=${complement}
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}
    
    TRY
        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O campo 'complemento' deve possuir no máximo 80 caracteres.
        ...    second=${response["res"].json()["error"][0]}
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END

CT16 - Editar campo complemento com caracteres especiais
    ${response}    Atualizar endereço da empresa    complement=Bloco Aªº
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}

    TRY
        Status Should Be    201    ${response["res"]}
        Should Be Equal    
        ...    first=Endereço da companhia atualizado com sucesso.    
        ...    second=${response["res"].json()["msg"]}
        Should Be Equal    
        ...    first=Bloco Aªº    
        ...    second=${response["res"].json()["updateCompany"]["address"][0]["complement"]}   
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END
    
CT17 - Editar campo complemento com caracteres especiais invalidos
    ${response}    Atualizar endereço da empresa    complement=Bloc@ T#st!
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}
    
    TRY
        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O campo 'complemento' só pode conter letras, números e os caracteres especiais 'ª', 'º', '‘' e '-'
        ...    second=${response["res"].json()["error"][0]}
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END
   
CT18 - Editar campo complemento com alfanumericos
    ${response}    Atualizar endereço da empresa    complement=Bloco 10
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}

    TRY
        Status Should Be    201    ${response["res"]}
        Should Be Equal    
        ...    first=Endereço da companhia atualizado com sucesso.    
        ...    second=${response["res"].json()["msg"]}
        Should Be Equal    
        ...    first=Bloco 10    
        ...    second=${response["res"].json()["updateCompany"]["address"][0]["complement"]}   
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END

CT19 - Editar campo bairro com sucesso
    ${response}    Atualizar endereço da empresa    district=Coroado
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}

    TRY
        Status Should Be    201    ${response["res"]}
        Should Be Equal    
        ...    first=Endereço da companhia atualizado com sucesso.    
        ...    second=${response["res"].json()["msg"]}
        Should Be Equal    
        ...    first=Coroado    
        ...    second=${response["res"].json()["updateCompany"]["address"][0]["district"]}   
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END

CT20 - Editar campo bairro com caracteres especiais
    ${response}    Atualizar endereço da empresa    district=Coroªdº-bairro
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}

    TRY
        Status Should Be    201    ${response["res"]}
        Should Be Equal    
        ...    first=Endereço da companhia atualizado com sucesso.    
        ...    second=${response["res"].json()["msg"]}
        Should Be Equal    
        ...    first=Coroªdº-bairro    
        ...    second=${response["res"].json()["updateCompany"]["address"][0]["district"]}   
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END   

CT21 - Editar campo bairro com caracteres especiais invalidos
    ${response}    Atualizar endereço da empresa    district=Coroado@@@@
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}
    
    TRY
        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O campo 'bairro' só pode conter letras, números e os caracteres especiais 'ª', 'º', '‘' e '-'
        ...    second=${response["res"].json()["error"][0]}
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END

CT22 - Editar campo bairro em branco
    ${response}    Atualizar endereço da empresa    district=branco
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}
    
    TRY
        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O campo 'bairro' é obrigatório.
        ...    second=${response["res"].json()["error"][0]}
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END

CT23 - Editar campo bairro com alfanumerico
    ${response}    Atualizar endereço da empresa    district=Coro4d01234
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}

    TRY
        Status Should Be    201    ${response["res"]}
        Should Be Equal    
        ...    first=Endereço da companhia atualizado com sucesso.    
        ...    second=${response["res"].json()["msg"]}
        Should Be Equal    
        ...    first=Coro4d01234    
        ...    second=${response["res"].json()["updateCompany"]["address"][0]["district"]}   
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END   

CT24 - Editar campo bairro com mais de 50 caracteres
    ${district}    Set Variable    Residencial Parque das Flores e Jardins do Paraísos
    ${response}    Atualizar endereço da empresa    district=${district}
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}
    
    TRY
        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O campo 'bairro' deve possuir no máximo 50 caracteres.
        ...    second=${response["res"].json()["error"][0]}
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END

CT25 - Editar campo cidade com sucesso
    ${response}    Atualizar endereço da empresa    city=São Paulo
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}

    TRY
        Status Should Be    201    ${response["res"]}
        Should Be Equal    
        ...    first=Endereço da companhia atualizado com sucesso.    
        ...    second=${response["res"].json()["msg"]}
        Should Be Equal    
        ...    first=São Paulo    
        ...    second=${response["res"].json()["updateCompany"]["address"][0]["city"]}   
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END   

CT26 - Editar campo cidade em branco
    ${response}    Atualizar endereço da empresa    city=branco
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}
    
    TRY
        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O campo 'cidade' é obrigatório.
        ...    second=${response["res"].json()["error"][0]}
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END

CT27 - Editar campo cidade com caracteres especiais
    ${response}    Atualizar endereço da empresa    city=Sªº-Pªulº
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}

    TRY
        Status Should Be    201    ${response["res"]}
        Should Be Equal    
        ...    first=Endereço da companhia atualizado com sucesso.    
        ...    second=${response["res"].json()["msg"]}
        Should Be Equal    
        ...    first=Sªº-Pªulº    
        ...    second=${response["res"].json()["updateCompany"]["address"][0]["city"]}   
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END   

CT28 - Editar campo cidade com mais de 50 caracteres  
    ${response}    Atualizar endereço da empresa    city=Residencial Parque das Flores e Jardins do Paraísos
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}
    
    TRY
        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O campo 'cidade' deve possuir no máximo 50 caracteres.
        ...    second=${response["res"].json()["error"][0]}
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END

CT29 - Editar campo cidade com letras e numeros
    ${response}    Atualizar endereço da empresa    city=Cidade123
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}
    
    TRY
        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O campo 'cidade' só pode conter letras e os caracteres especiais 'ª', 'º', '‘' e '-'.
        ...    second=${response["res"].json()["error"][0]}
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END

CT30 - Editar campo estado com sucesso
    ${response}    Atualizar endereço da empresa    state=SP
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}

    TRY
        Status Should Be    201    ${response["res"]}
        Should Be Equal    
        ...    first=Endereço da companhia atualizado com sucesso.    
        ...    second=${response["res"].json()["msg"]}
        Should Be Equal    
        ...    first=SP    
        ...    second=${response["res"].json()["updateCompany"]["address"][0]["state"]}   
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END   

CT31 - Editar campo estado em branco
    ${response}    Atualizar endereço da empresa    state=branco
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}
    
    TRY
        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O campo 'estado' é obrigatório.
        ...    second=${response["res"].json()["error"][0]}
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END

CT32 - Editar campo estado com numeros
    ${response}    Atualizar endereço da empresa    status=12
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}
    
    TRY
        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O campo 'estado' só pode conter letras maiúsculas
        ...    second=${response["res"].json()["error"][0]}
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END

CT33 - Editar campo estado mais de 2 caracteres
    ${response}    Atualizar endereço da empresa    status=SSP
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}
    
    TRY
        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O campo 'estado' deve possuir 2 caracteres.
        ...    second=${response["res"].json()["error"][0]}
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END

CT34 - Editar campo estado com letras minusculas
    ${response}    Atualizar endereço da empresa    status=sp
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}
    
    TRY
        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O campo 'estado' só pode conter letras maiúsculas
        ...    second=${response["res"].json()["error"][0]}
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END

CT35 - Editar campo país com sucesso
    ${response}    Atualizar endereço da empresa    country=Inglaterra
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}

    TRY
        Status Should Be    201    ${response["res"]}
        Should Be Equal    
        ...    first=Endereço da companhia atualizado com sucesso.    
        ...    second=${response["res"].json()["msg"]}
        Should Be Equal    
        ...    first=Inglaterra    
        ...    second=${response["res"].json()["updateCompany"]["address"][0]["country"]}   
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END   

CT36 - Editar campo país com apenas numeros
    ${response}    Atualizar endereço da empresa    country=123
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}
    
    TRY
        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O campo País deve conter apenas letras.
        ...    second=${response["res"].json()["error"][0]}
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END

CT37 - Editar campo país em branco
    ${response}    Atualizar endereço da empresa    country=branco
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}
    
    TRY
        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O campo País é obrigatório.
        ...    second=${response["res"].json()["error"][0]}
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END

CT38 - Editar campo país com alfanumerico
    ${response}    Atualizar endereço da empresa    country=Brasil1234
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}
    
    TRY
        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O campo País deve conter apenas letras.
        ...    second=${response["res"].json()["error"][0]}
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END

CT39 - Editar campo país com mais de 50 caracteres
    ${response}    Atualizar endereço da empresa    country=Residencial Parque das Flores e Jardins do Paraísos
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}
    
    TRY
        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O campo País permite até 50 caracteres.
        ...    second=${response["res"].json()["error"][0]}
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END

CT40 - Editar campo CEP com sucesso
    ${response}    Atualizar endereço da empresa       zipCode=22290031
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}

    TRY
        Status Should Be    201    ${response["res"]}
        Should Be Equal    
        ...    first=Endereço da companhia atualizado com sucesso.    
        ...    second=${response["res"].json()["msg"]}
        Should Be Equal    
        ...    first=22290031    
        ...    second=${response["res"].json()["updateCompany"]["address"][0]["zipCode"]}   
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END       

CT41 - Editar campo CEP em branco
    ${response}    Atualizar endereço da empresa    zipCode=branco
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}
    
    TRY
        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O campo 'CEP' é obrigatório.
        ...    second=${response["res"].json()["error"][0]}
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END

CT42 - Editar campo CEP com letras
    ${response}    Atualizar endereço da empresa    zipCode=pipocass
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}
    
    TRY
        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O campo 'CEP' só pode conter números
        ...    second=${response["res"].json()["error"][0]}
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END

CT43 - Editar campo CEP com mais de 8 digitos
    ${response}    Atualizar endereço da empresa    zipCode=123456789
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}
    
    TRY
        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O campo 'CEP' deve conter 8 dígitos
        ...    second=${response["res"].json()["error"][0]}
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END

CT44 - Editar campo CEP alfanumerico
    ${response}    Atualizar endereço da empresa    zipCode=Teste123
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}
    
    TRY
        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O campo 'CEP' só pode conter números
        ...    second=${response["res"].json()["error"][0]}
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END

CT45 - Editar campo CEP com caracteres especiais
    ${response}    Atualizar endereço da empresa    zipCode=Teste123
    ${id}    Set Variable    ${response["company"].json()["newCompany"]["_id"]}
    
    TRY
        Status Should Be    400    ${response["res"]}
        Should Be Equal    
        ...    first=O campo 'CEP' só pode conter números
        ...    second=${response["res"].json()["error"][0]}
    FINALLY
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
    END



