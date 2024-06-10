*** Settings ***
Library  RequestsLibrary
Library  String
Library    Collections

*** Keywords ***

Criar um novo usuário
    ${palavra_aleatória}  Generate Random String    chars=[LETTERS]
    ${palavra_aleatória}  Convert To Lower Case    ${palavra_aleatória}
    Set Test Variable   ${EMAIL_TESTE}  ${palavra_aleatória}@emailteste.com
    Log    ${EMAIL_TESTE}

Cadastrar o usuário na ServeRest
    [Arguments]  ${email}  ${status_code_desejado}
    ${body}    Create Dictionary
    ...        nome=Amalia de Fraga
    ...        email=${email}
    ...        password=3456
    ...        administrador=true
    Log      ${body}

    Criar sessão na ServeRest

    ${headers}  Create Dictionary  accept=application/json  Content-Type=application/json

    ${resposta}  POST On Session 
    ...          alias=ServeRest
    ...          url=/usuarios
    ...          json=${body}
    ...          expected_status=${status_code_desejado}

    Log  ${resposta.json()}

    IF  ${resposta.status_code} == 201
        Set Test Variable    ${ID_USUARIO}   ${resposta.json()["_id"]} 
    END

    Set Test Variable    ${RESPOSTA}    ${resposta.json()}

# body criado a partir da doc da api via ServeRest
# {
#   "nome": "Fulano da Silva",
#   "email": "beltrano@qa.com.br",
#   "password": "teste",
#   "administrador": "true"
# }

Criar sessão na ServeRest
    ${headers}  Create Dictionary  accept=application/json  Content-Type=application/json
    Create Session    alias=ServeRest    url=https://serverest.dev   headers=${headers}

Conferir se o cadastro foi bem sucedido
    Log   ${RESPOSTA}
    Dictionary Should Contain Item    ${RESPOSTA}    message  Cadastro realizado com sucesso
    Dictionary Should Contain Key    ${RESPOSTA}     _id

Repetir o cadastro
    Cadastrar o usuário na ServeRest  email=${EMAIL_TESTE}  status_code_desejado=400

Validar que a API não permitiu o cadastro
        Dictionary Should Contain Item    ${RESPOSTA}    message  Este email já está sendo usado

Consultar os dados do novo usuário
    ${resposta_consulta}  GET On Session  alias=ServeRest  url=/usuarios/${ID_USUARIO}  expected_status=200 
# Não precisa informar esse expected_status sempre, mas se quiser não haverá problema, se torna uma boa prática. Para não conferir só passar expected_status=any
    Set Test Variable    ${RESP_CONSULTA}  ${resposta_consulta.json()}
Conferir os dados retornados
    Log    ${RESP_CONSULTA}
    Dictionary Should Contain Item    ${RESP_CONSULTA}    nome             Amalia de Fraga
    Dictionary Should Contain Item    ${RESP_CONSULTA}    email            ${EMAIL_TESTE}
    Dictionary Should Contain Item    ${RESP_CONSULTA}    password         3456
    Dictionary Should Contain Item    ${RESP_CONSULTA}    administrador    true
    Dictionary Should Contain Item    ${RESP_CONSULTA}    _id              ${ID_USUARIO}

Realizar Login com o usuário
    ${body}     Create Dictionary
    ...        email=${EMAIL_TESTE}
    ...        password=3456  
    
    Criar Sessão na ServeRest

    ${resposta}  POST On Session
    ...          alias=ServeRest
    ...          url=/login
    ...          json=${body}
    ...          expected_status=200

    Set Test Variable    ${RESPOSTA}    ${resposta.json()} 
Conferir se o Login ocorreu com sucesso
    Log  ${RESPOSTA}
    Dictionary Should Contain Item  ${RESPOSTA}  message  Login realizado com sucesso
    Dictionary Should Contain Key   ${RESPOSTA}  authorization