*** Settings ***

Resource    ../base.resource

*** Keywords ***

Criar Empresa
    [Arguments]    
    ...    ${perfil}=
    ...    ${companyName}=    
    ...    ${cnpj}=    
    ...    ${email}=    
    ...    ${fatasyName}=    
    ...    ${responsibleContact}=    
    ...    ${telephone}=    
    ...    ${serviceDescription}=    
    ...    ${address}=    
    ...    ${zipCode}=    
    ...    ${city}=    
    ...    ${state}=    
    ...    ${district}=    
    ...    ${street}=    
    ...    ${number}=    
    ...    ${complement}=    
    ...    ${country}=    

    ${get_company}    Get Fake Company
    ${token}          Set Token    ${perfil}

    ${addressList}    Create List

    ${zipCode}       Set Default If Empty    ${zipCode}       ${get_company}[zipCode]
    ${city}          Set Default If Empty    ${city}          ${get_company}[city]
    ${state}         Set Default If Empty    ${state}         ${get_company}[state]
    ${district}      Set Default If Empty    ${district}      ${get_company}[district]
    ${street}        Set Default If Empty    ${street}        ${get_company}[street]
    ${number}        Set Default If Empty    ${number}        ${get_company}[number]
    ${complement}    Set Default If Empty    ${complement}    ${EMPTY}  
    ${country}       Set Default If Empty    ${country}       "Brasil"

    
    ${addressItem}    Create Dictionary
    ...    zipCode=${zipCode}
    ...    city=${city}
    ...    state=${state}
    ...    district=${district}
    ...    street=${street}
    ...    number=${number}
    ...    complement=${complement}
    ...    country=${country}

   
    Append To List    ${addressList}    ${addressItem}

    
    ${companyName}           Set Default If Empty    ${companyName}           ${get_company}[nome_empresa]
    ${cnpj}                  Set Default If Empty    ${cnpj}                  ${get_company}[cnpj]
    ${email}                 Set Default If Empty    ${email}                 ${get_company}[email]
    ${fatasyName}            Set Default If Empty    ${fatasyName}            ${get_company}[nome_empresa]
    ${responsibleContact}    Set Default If Empty    ${responsibleContact}    ${get_company}[responsavel]
    ${telephone}             Set Default If Empty    ${telephone}             ${get_company}[telefone]
    ${serviceDescription}    Set Default If Empty    ${serviceDescription}    ${get_company}[descricao]

    
    ${address}=    Set Default If Empty    ${address}    ${addressList}

    
    ${body}    Create Dictionary
    ...    corporateName=${companyName}
    ...    registerCompany=${cnpj}
    ...    mail=${email}
    ...    matriz=${fatasyName}
    ...    responsibleContact=${responsibleContact}
    ...    telephone=${telephone}
    ...    serviceDescription=${serviceDescription}
    ...    address=${address}

    ${response}    POST On Session    alias=ron-bugado    expected_status=any    url=/api/company/?token=${token}    json=${body}
    RETURN    ${response}

Atualizar cadastro de empresa
    [Documentation]    Keyword utilizado para atualizar cadastro de Empresa
    [Arguments]    
    ...    ${perfil}=
    ...    ${corporateName}=    
    ...    ${registerCompany}=    
    ...    ${mail}=    
    ...    ${matriz}=    
    ...    ${responsibleContact}=    
    ...    ${telephone}=    
    ...    ${serviceDescription}=    

    
    ${token}         Set Token    ${perfil}
    ${company}       Criar Empresa
    ${newCompany}    Set Variable     ${company.json()["newCompany"]}
    ${letras}    Generate Random String    length=6    chars=[LETTERS]
    ${letras_minusculas}    Convert To Lower Case    ${letras}  
    ${corporate_name}            Set Default If Empty    ${corporate_name}           ${newCompany["corporateName"]}${letras_minusculas}
    ${register_company}          Set Default If Empty    ${registerCompany}                  ${newCompany["registerCompany"]}
    ${mail_}                     Set Default If Empty    ${mail}                 ${newCompany["mail"]}
    ${matriz_}                   Set Default If Empty    ${matriz}            ${newCompany["matriz"]}
    ${responsible_contact}       Set Default If Empty    ${responsibleContact}    ${newCompany["responsibleContact"]}
    ${telephone_}                Set Default If Empty    ${telephone}             ${newCompany["telephone"]}
    ${service_description}       Set Default If Empty    ${serviceDescription}    ${newCompany["serviceDescription"]}

    ${body}    Create Dictionary
    ...    corporateName=${corporate_name}
    ...    registerCompany=${register_company}
    ...    mail=${mail_}
    ...    matriz=${matriz_}
    ...    responsibleContact=${responsible_contact}
    ...    telephone=${telephone_}
    ...    serviceDescription=${service_description}
    
    ${id}        Set Variable         ${newCompany["_id"]}
    ${params}    Create Dictionary    token=${token}

    ${response}    PUT On Session    alias=ron-bugado    expected_status=any    url=/api/company/${id}    params=${params}    json=${body}
    
    ${result}    Create Dictionary
    ...    empresa          ${newCompany}
    ...    empresaAtualizada    ${response}

    RETURN    ${result}

Excluir cadastro de empresa
    [Documentation]    Keyword utilizada para excluir cadastro de empresa
    [Arguments]    ${id}    ${perfil}=
    ${token}    Set Token    ${perfil}
    ${params}    Create Dictionary    token=${token}
    ${response}    DELETE On Session    alias=ron-bugado    expected_status=any    url=/api/company/${id}    params=${params}
    RETURN    ${response}

Listar empresas cadastradas no sistema
    [Documentation]    Keyword utilizada para lista empresas
    [Arguments]    ${perfil}=
    ${token}    Set Token    ${perfil}
    ${params}    Create Dictionary    token=${token}
    ${response}    GET On Session    alias=ron-bugado    expected_status=any    url=/api/company/    params=${params}
    RETURN    ${response.json()}

Atualizar endereço da empresa
    [Documentation]    Keyword utilizada para atualizar endereço da empresa
    [Arguments]    
    ...    ${perfil}=
    ...    ${zipCode}=    
    ...    ${city}=    
    ...    ${state}=    
    ...    ${district}=    
    ...    ${street}=    
    ...    ${number}=    
    ...    ${complement}=    
    ...    ${country}=    
    ${token}    Set Token    ${perfil}
    ${company}    Criar Empresa
    ${new_company}    Set Variable    ${company.json()["newCompany"]["address"][0]}

    
    
    ${zipCode_}       Set Default If Empty    ${zipCode}       ${new_company["zipCode"]}
    ${city_}          Set Default If Empty    ${city}          ${new_company["city"]}
    ${state_}         Set Default If Empty    ${state}         ${new_company["state"]}
    ${district_}      Set Default If Empty    ${district}      ${new_company["district"]}
    ${street_}        Set Default If Empty    ${street}        ${new_company["street"]}
    ${number_}        Set Default If Empty    ${number}        ${new_company["number"]}
    ${complement_}    Set Default If Empty    ${complement}    ${EMPTY}  
    ${country_}       Set Default If Empty    ${country}       "Brasil"

    ${addressList}    Create List    
    
    ${addressItem}    Create Dictionary
    ...    zipCode=${zipCode_}
    ...    city=${city_}
    ...    state=${state_}
    ...    district=${district_}
    ...    street=${street_}
    ...    number=${number_}
    ...    complement=${complement_}
    ...    country=${country_}

   
    Append To List    ${addressList}    ${addressItem}

    ${body}      Create Dictionary    address=${addressList}
    ${params}    Create Dictionary    token=${token}
    ${id}    Set Variable    ${company.json()["newCompany"]["_id"]}
    ${response}    PUT On Session    alias=ron-bugado    expected_status=any    url=/api/company/address/${id}    params=${params}    json=${body}
    ${result}    Create Dictionary    
    ...    company=${company}    
    ...    res=${response}
    RETURN    ${result}

