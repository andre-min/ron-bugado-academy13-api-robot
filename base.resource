*** Settings ***

Library    RequestsLibrary
Library    String
Library    Collections
Library    BuiltIn


Library    libs/person.py
Library    libs/board_resouce.py
Library    libs/company_resource.py
Library    load_env.py

Resource    resources/utils/customKeywords.resource
Resource    resources/board.resource
Resource    resources/company.resource
Resource    resources/user.resource

*** Variables ***

${BASE_URL}    https://ron-bugado.qacoders.dev.br
${DIGITS}    0123456789



