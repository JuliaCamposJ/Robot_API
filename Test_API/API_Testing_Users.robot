*** Settings ***
Resource    ../Resources/API_Testing_Users_Resources.robot

*** Variables ***

*** Test Cases ***
Cenário 01: Cadastro de usuário com sucesso
    Criar um novo usuário
    Cadastrar o usuário na ServeRest  email=${EMAIL_TESTE}  status_code_desejado=201
    Conferir se o cadastro foi bem sucedido

Cenário 02: Cadastro de usuário já existente
    Criar um novo usuário
    Cadastrar o usuário na ServeRest  email=${EMAIL_TESTE}  status_code_desejado=201
    Repetir o cadastro
    Validar que a API não permitiu o cadastro

Cenário 03: Consultar dados de um novo usuário
    Criar um novo usuário
    Cadastrar o usuário na ServeRest  email=${EMAIL_TESTE}  status_code_desejado=201
    Consultar os dados do novo usuário
    Conferir os dados retornados

Cenário 04: Logar com o novo usuário criado
    Criar um novo usuário
    Cadastrar o usuário na ServeRest  email=${EMAIL_TESTE}  status_code_desejado=201
    Realizar Login com o usuário
    Conferir se o Login ocorreu com sucesso
