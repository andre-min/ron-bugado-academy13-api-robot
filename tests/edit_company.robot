*** Settings ***

Resource    ../base.resource

*** Test Cases ***

CT01 - Editar Cadastro de Empresa com sucesso
    ${letras}    Generate Random String    length=4    chars=[LETTERS]
    ${letras_minusculas}    Convert To Lower Case    ${letras}  
    ${get_company}    Get Fake Company
    ${response}    Atualizar cadastro de empresa    
    ...    corporateName=${get_company}[nome_empresa]${letras_minusculas}
    ...    registerCompany=${get_company}[cnpj]   
    ...    mail=${get_company}[email]    
    ...    matriz=${get_company}[nome_empresa]
    ...    responsibleContact=${get_company}[responsavel]    
    ...    telephone=${get_company}[telefone]    
    ...    serviceDescription=${get_company}[descricao]
    
    ${id}                  Set Variable        ${response["empresa"]["_id"]}
    ${updated_response}    Set Variable        ${response["empresaAtualizada"].json()}
    

    TRY
        
        Status Should Be    201    ${response["empresaAtualizada"]}
        Should Be Equal    first=Companhia atualizada com sucesso.                        second=${updated_response["msg"]}
        Should Be Equal    first=${get_company}[nome_empresa]${letras_minusculas}         second=${updated_response["updatedCompany"]["corporateName"]}
        Should Be Equal    first=${get_company}[cnpj]                                     second=${updated_response["updatedCompany"]["registerCompany"]}
        Should Be Equal    first=${get_company}[email]                                    second=${updated_response["updatedCompany"]["mail"]}
        Should Be Equal    first=${get_company}[nome_empresa]                             second=${updated_response["updatedCompany"]["matriz"]}
        Should Be Equal    first=${get_company}[responsavel]                              second=${updated_response["updatedCompany"]["responsibleContact"]}
        Should Be Equal    first=${get_company}[telefone]                                 second=${updated_response["updatedCompany"]["telephone"]}
        Should Be Equal    first=${get_company}[descricao]                                second=${updated_response["updatedCompany"]["serviceDescription"]}
        Should Be Equal    first=${True}                                                  second=${updated_response["updatedCompany"]["status"]}
        Should Be Equal    first=${response["empresa"]["_id"]}                            second=${updated_response["updatedCompany"]["_id"]}

    FINALLY

        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}   

    END
    
    
    
CT02 - Editar nome da empresa adicionando um nome alfanumérico
    
    ${get_company}    Get Fake Company
    ${response}    Atualizar cadastro de empresa    corporateName=123456${get_company}[nome_empresa]

    TRY

        Status Should Be    201    ${response["empresaAtualizada"]}
        Should Be Equal    
        ...    first=Companhia atualizada com sucesso.    
        ...    second=${response["empresaAtualizada"].json()["msg"]}
        Should Be Equal    
        ...    first=123456${get_company}[nome_empresa]    
        ...    second=${response["empresaAtualizada"].json()["updatedCompany"]["corporateName"]}
    
    FINALLY

        ${delete_response}    Excluir cadastro de empresa    id=${response["empresaAtualizada"].json()["updatedCompany"]["_id"]}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}   
        
    END

CT03 - Editar nome da empresa para um nome já cadastrado
    ${response}    Atualizar cadastro de empresa    corporateName=Pietro Pizzaria ME
    ${id}                  Set Variable        ${response["empresa"]["_id"]}
    TRY

        Status Should Be    409    ${response["empresaAtualizada"]}
        Should Be Equal    first=Error: Nome de empresa já está cadastrada.    second=${response.json()["error"]} 
 
    FINALLY

        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}   

    END
    
       
CT04 - Editar nome da empresa para um nome com 100 caracteres
    ${letras}    Generate Random String    length=14    chars=[LETTERS]
    ${letras_minusculas}    Convert To Lower Case    ${letras}
    ${companyName100caracteres}    Set Variable    Serviços Inteligentes de Consultorias Empresarial Focada em Resultados e Crescimento G${letras_minusculas}
    ${response}    Atualizar cadastro de empresa    corporateName=${companyName100caracteres}
    ${id}                  Set Variable        ${response["empresa"]["_id"]}
    
    TRY

        Status Should Be    201    ${response["empresaAtualizada"]}
        Should Be Equal    first=Companhia atualizada com sucesso.    second=${response["empresaAtualizada"].json()["msg"]}
        Should Be Equal    first=${companyName100caracteres}   second=${response["empresaAtualizada"].json()["updatedCompany"]["corporateName"]}   

    FINALLY

        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}

    END
    
    

CT05 - Editar nome da empresa para um nome com 101 caracteres
    
    ${response}    Atualizar cadastro de empresa    corporateName=Tecnologia Avançada para Soluções Inovadoras e Sustentáveis no Mercado Global Consultoria Estratégica
    ${id}                  Set Variable        ${response["empresa"]["_id"]}
    
    TRY
    
        Status Should Be    400    ${response["empresaAtualizada"]}
        Should Be Equal    first=O campo 'Nome da empresa' deve ter no máximo 100 caracteres.    second=${response["empresaAtualizada"].json()["error"][0]}
       
    FINALLY
    
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
   
    END
    
CT06 - Editar nome da empresa enviando valor em branco
    
    ${response}    Atualizar cadastro de empresa    corporateName=branco
    ${id}                  Set Variable        ${response["empresa"]["_id"]}
    
    TRY
    
        Status Should Be    400    ${response["empresaAtualizada"]}
        Should Be Equal    first=O campo 'Nome da empresa' é obrigatório.    second=${response["empresaAtualizada"].json()["error"][0]}
       
    FINALLY
    
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
   
    END
    
CT07 - Editar nome da empresa para um nome que contenha apenas números
    
    ${response}    Atualizar cadastro de empresa    corporateName=34567888990
    ${id}                  Set Variable        ${response["empresa"]["_id"]}
    
    TRY
    
        Status Should Be    201    ${response["empresaAtualizada"]}
        Should Be Equal    first=Companhia atualizada com sucesso.    second=${response["empresaAtualizada"].json()["msg"]}
        Should Be Equal    first=34567888990    second=${response["empresaAtualizada"].json()["updatedCompany"]["corporateName"]}
       
    FINALLY
    
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
   
    END
    
CT08 - Editar CNPJ da empresa enviando 13 caracteres
    ${response}    Atualizar cadastro de empresa    registerCompany=8053036300017
    ${id}                  Set Variable        ${response["empresa"]["_id"]}
    
    TRY
    
        Status Should Be    400    ${response["empresaAtualizada"]}
        Should Be Equal    first=O campo 'CNPJ' da empresa deve ter no máximo 14 caracteres numéricos.    second=${response["empresaAtualizada"].json()["error"][0]}
       
    FINALLY
    
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
   
    END
    
CT09 - Editar CNPJ da empresa enviando 15 caracteres
    ${response}    Atualizar cadastro de empresa    registerCompany=805303630001789
    ${id}                  Set Variable        ${response["empresa"]["_id"]}
    
    TRY
    
        Status Should Be    400    ${response["empresaAtualizada"]}
        Should Be Equal    first=O campo 'CNPJ' da empresa deve ter no máximo 14 caracteres numéricos.    second=${response["empresaAtualizada"].json()["error"][0]}
    
    FINALLY
    
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
   
    END
    
CT10 - Editar CNPJ da empresa enviando um CNPJ que contenha letras e números
    ${response}    Atualizar cadastro de empresa    registerCompany=36300017ABCDEG
    ${id}                  Set Variable        ${response["empresa"]["_id"]}
    
    TRY

        Status Should Be    400    ${response["empresaAtualizada"]}
        Should Be Equal    first=O campo 'CNPJ' da empresa deve conter apenas números.    second=${response["empresaAtualizada"].json()["error"][0]}
    
    FINALLY
    
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
   
    END
    
CT11 - Editar CNPJ da empresa enviando um valor em branco
    ${response}    Atualizar cadastro de empresa    registerCompany=branco
    ${id}                  Set Variable        ${response["empresa"]["_id"]}
    
    TRY

        Status Should Be    400    ${response["empresaAtualizada"]}
        Should Be Equal    first=O campo 'CNPJ' da empresa é obrigatório.    second=${response["empresaAtualizada"].json()["error"][0]}
    
    FINALLY
    
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
   
    END
    

CT12 - Editar Razão Social da empresa para um nome já existente
    ${response}    Atualizar cadastro de empresa    matriz=Cláudia e André Joalheria Ltda
    ${id}                  Set Variable        ${response["empresa"]["_id"]}
    
    TRY

        Status Should Be    409    ${response["empresaAtualizada"]}
        Should Be Equal    first=Error: Essa razão social já está cadastrada.    second=${response.json()["error"]}
    
    FINALLY
    
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
   
    END
    
CT13 - Editar Razão Social da empresa para um nome com 101 caracteres
    ${response}    Atualizar cadastro de empresa    matriz=Empresa XYZ Ltda - Soluções em Tecnologia da Informação e Consultoria Empresarial de Alta Performance
    ${id}                  Set Variable        ${response["empresa"]["_id"]}
    
    TRY

        Status Should Be    400    ${response["empresaAtualizada"]}
        Should Be Equal    first=O campo 'Razão Social' da empresa deve ter no máximo 100 caracteres.    second=${response["empresaAtualizada"].json()["error"][0]}
    
    FINALLY
    
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
   
    END
    
CT14 - Editar nome do responsável para 100 caracteres
    ${responsibleContact}    Set Variable    Isabella Gregoria Duarte da Silva Costa Albuquerque Oliveira Barbosa Pimentel Rocha Pereira de Souza
    ${response}    Atualizar cadastro de empresa    responsibleContact=${responsibleContact}
    ${id}                  Set Variable        ${response["empresa"]["_id"]}
    
    TRY

        Status Should Be    201    ${response["empresaAtualizada"]}
        Should Be Equal    
        ...    first=${responsibleContact}     
        ...    second=${response["empresaAtualizada"].json()["updatedCompany"]["responsibleContact"]}
    
    FINALLY
    
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
   
    END
    
CT15 - Editar nome do responsável com 101 caracteres
    ${response}    Atualizar cadastro de empresa    responsibleContact=Isabella Gregoria Duarte da Silva Costa Albuquerque Oliveira Barbosa Pimentel Rocha Pereira do Amaral
    ${id}                  Set Variable        ${response["empresa"]["_id"]}
    
    TRY

        Status Should Be    400    ${response["empresaAtualizada"]}
        Should Be Equal    
        ...    first=O campo 'Contado do Responsável' deve ter no máximo 100 caracteres.    
        ...    second=${response["empresaAtualizada"].json()["error"][0]}
    
    FINALLY
    
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
   
    END
    
CT16 - Editar nome do responsável enviando apenas o primeiro nome
    ${response}    Atualizar cadastro de empresa    responsibleContact=Amaral
    ${id}                  Set Variable        ${response["empresa"]["_id"]}
    
    TRY

        Status Should Be    400    ${response["empresaAtualizada"]}
        Should Be Equal    
        ...    first=O campo 'Contato do Responsável' deve conter nome e sobrenome.    
        ...    second=${response["empresaAtualizada"].json()["error"][0]}
    
    FINALLY
    
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
   
    END
    
CT17 - Editar cadastro da empresa enviando 15 caracteres no campo telefone
    ${response}    Atualizar cadastro de empresa    telephone=123456789321654
    ${id}                  Set Variable        ${response["empresa"]["_id"]}
    
    TRY

        Status Should Be    201    ${response["empresaAtualizada"]}
        Should Be Equal    
        ...    first=123456789321654         
        ...    second=${response["empresaAtualizada"].json()["updatedCompany"]["telephone"]}
        
    FINALLY
    
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
   
    END
    
CT18 - Editar cadastro da empresa enviando 10 caracteres no campo telefone
    ${response}    Atualizar cadastro de empresa    telephone=1234567890
    ${id}                  Set Variable        ${response["empresa"]["_id"]}
    
    TRY

        Status Should Be    201    ${response["empresaAtualizada"]}
        Should Be Equal    
        ...    first=1234567890         
        ...    second=${response["empresaAtualizada"].json()["updatedCompany"]["telephone"]}
   
    FINALLY
    
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
   
    END
    
CT19 - Editar cadastro da empresa enviando 18 caracteres no campo telefone
    ${response}    Atualizar cadastro de empresa    telephone=123456789012345678
    ${id}                  Set Variable        ${response["empresa"]["_id"]}
    
    TRY

        Status Should Be    400    ${response["empresaAtualizada"]}
        Should Be Equal    
        ...    first=O campo 'Telefone' deve ter entre 13 e 14 caracteres.         
        ...    second=${response["empresaAtualizada"].json()["error"][0]}

    FINALLY
    
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
   
    END
    
CT20 - Editar dados da empresa enviando email formato inválido
    ${response}    Atualizar cadastro de empresa    mail=formatoinvalido@gmail.com.#*br
    ${id}                  Set Variable        ${response["empresa"]["_id"]}
    
    TRY

        Status Should Be    400    ${response["empresaAtualizada"]}
        Should Be Equal    
        ...    first=O campo 'Email' informado é inválido. Informe um e-mail no formato [nome@domínio.com].         
        ...    second=${response["empresaAtualizada"].json()["error"][0]}
        
    FINALLY
    
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
   
    END
    
CT21 - Editar cadastro da empresa enviando uma descrição alfanumérico
    ${serviceDescription}    Set Variable    ech21 Solutions é uma empresa inovadora especializada em soluções tecnológicas avançadas para empresas de todos os tamanhos, desde 2021
    ${response}    Atualizar cadastro de empresa    serviceDescription=${serviceDescription}
    ${id}                  Set Variable        ${response["empresa"]["_id"]}
    
    TRY

        Status Should Be    201    ${response["empresaAtualizada"]}
        Should Be Equal    
        ...    first=${serviceDescription}       
        ...    second=${response["empresaAtualizada"].json()["updatedCompany"]["serviceDescription"]}
        
    FINALLY
    
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
   
    END
    
CT22 - Editar cadastro da empresa enviando uma descrição que contenha apenas letras
    ${serviceDescription}    Set Variable    Escrevendo a descrição da empresa apenas com letras.
    ${response}    Atualizar cadastro de empresa    serviceDescription=${serviceDescription}
    ${id}                  Set Variable        ${response["empresa"]["_id"]}
    
    TRY

        Status Should Be    201    ${response["empresaAtualizada"]}
        Should Be Equal    
        ...    first=${serviceDescription}    
        ...    second=${response["empresaAtualizada"].json()["updatedCompany"]["serviceDescription"]}

    FINALLY
    
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
   
    END
    
CT23 - Editar cadastro da empresa enviando dados obrigatórios com valores em branco
    ${response}    Atualizar cadastro de empresa    
    ...    corporateName=branco    
    ...    registerCompany=branco    
    ...    mail=branco    
    ...    matriz=branco    
    ...    responsibleContact=branco    
    ...    telephone=branco    
    ...    serviceDescription=branco
    ${id}                  Set Variable        ${response["empresa"]["_id"]}
    
    TRY

        Status Should Be    400    ${response["empresaAtualizada"]}
        Should Be Equal    first=O campo 'Nome da empresa' é obrigatório.    second=${response["empresaAtualizada"].json()["error"][0]}
        Should Be Equal    first=O campo 'Email' é obrigatório.    second=${response["empresaAtualizada"].json()["error"][1]}
        Should Be Equal    first=O campo 'CNPJ' da empresa é obrigatório.    second=${response["empresaAtualizada"].json()["error"][2]}
        Should Be Equal    first=O campo 'Razão Social' é obrigatório.    second=${response["empresaAtualizada"].json()["error"][3]}
        Should Be Equal    first=O campo 'Contado do Responsável' é obrigatório.    second=${response["empresaAtualizada"].json()["error"][4]}
        Should Be Equal    first=O campo 'Telefone' é obrigatório.    second=${response["empresaAtualizada"].json()["error"][5]}
        Should Be Equal    first=O campo 'Descrição' é obrigatório.    second=${response["empresaAtualizada"].json()["error"][6]}

    FINALLY
    
        ${delete_response}    Excluir cadastro de empresa    id=${id}
        Status Should Be    200    ${delete_response}
        Should Be Equal    first=Companhia deletado com sucesso.    second=${delete_response.json()["msg"]}
   
    END
    

