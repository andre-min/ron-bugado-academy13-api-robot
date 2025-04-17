*** Settings ***
Resource    ../base.resource

*** Test Cases ***

CT01 - Excluir usuario com sucesso
    ${new_user}    Cadastrar usuario
    Status Should Be    201    ${new_user["res"]}

    ${delete_user}    Excluir usuario    id=${new_user["res"].json()["user"]["_id"]}
    Status Should Be    200    ${delete_user}
    Should Be Equal    
    ...    first=Usuário deletado com sucesso!    
    ...    second=${delete_user.json()["msg"]}
    
CT02 - Excluir Cadastro de usuario com id inválido
    ${delete_user}    Excluir usuario    id=67f5a53225b1307d74252f64
    Status Should Be    400    ${delete_user}
    Should Be Equal    
    ...    first=Esse usuário não existe em nossa base de dados.    
    ...    second=${delete_user.json()["alert"][0]}

CT03 - Excluir Cadastro de usuario com acessProfile diferente de ADMIN
    ${new_user}    Cadastrar usuario
    Status Should Be    201    ${new_user["res"]}

    ${delete_user}    Excluir usuario    id=${new_user["res"].json()["user"]["_id"]}    perfil=aluno
    Status Should Be    403    ${delete_user}
    Should Be Equal    
    ...    first=Você não tem permissão para esta função.    
    ...    second=${delete_user.json()["msg"]}    
