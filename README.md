================================================================================
GUIA COMPLETO DAS FERRAMENTAS E CAMADAS DO PROJETO (SIMPLES E DIRETO)
================================================================================

--------------------------------------------------------------------------------
FERRAMENTAS EXTERNAS
--------------------------------------------------------------------------------
GITHUB CODESPACES
- O que é: Um computador na nuvem com Linux pronto para programar.
- O que faz no projeto: Roda o projeto na internet com Node.js ja pronto. Tem 60 horas gratuitas por mes e desliga sozinho se ficar sem uso para economizar tempo.

NODE.JS
- O que é: O motor que roda programas em JavaScript/TypeScript fora do navegador.
- O que faz no projeto: E a base do nosso back-end que mantem o servidor funcionando.

NPM E NPX
- O que é: Ferramentas do Node para gerenciar e executar pacotes.
- O que faz no projeto: O npm instala as bibliotecas na pasta node_modules (como Express e Prisma) e o npx roda ferramentas prontas sem precisar instalar antes (como o criador do projeto e as migrations).

TYPESCRIPT
- O que é: O JavaScript com checagem obrigatoria de tipos (texto, numero, data).
- O que faz no projeto: Nao deixa passar dados errados no codigo, avisando os erros no proprio editor antes do programa rodar.

EXPRESS.JS
- O que é: O framework que cuida da parte web da aplicação.
- O que faz no projeto: Fica escutando as chamadas na porta 8888 e ajuda a receber pedidos e enviar respostas.

 POSTGRESQL (EM NUVEM NO PRISMA)
- O que é: O sistema de banco de dados onde os registros ficam gravados em tabelas.
- O que faz no projeto: Guarda definitivamente as informacoes de clientes e veiculos na internet.

--------------------------------------------------------------------------------
CONFIGURAÇÕES
--------------------------------------------------------------------------------
ARQUIVO .ENV
- O que é: Um arquivo de texto que guarda segredos da aplicação.
- O que faz no projeto: Guarda a DATABASE_URL com a senha do banco PostgreSQL e nunca deve ir para o GitHub.

--------------------------------------------------------------------------------
ARQUITETURA DA APLICAÇÃO
--------------------------------------------------------------------------------

SERVER.TS E APP.TS
- O que são: Os arquivos que dao a partida no servidor.
- O que fazem no projeto: O server.ts define a porta 8888 e liga o servidor; o app.ts configura o Express para aceitar requisicoes.

ROUTE (ROTAS)
- O que é: O mapa de enderecos da aplicação.
- O que faz no projeto: Diz qual função deve ser chamada quando alguem acessa uma URL usando metodos como GET, POST, PUT ou DELETE.

MIDDLEWARE
- O que é: Um porteiro intermediario que age no meio do caminho.
- O que faz no projeto: Verifica coisas antes da rota entregar o pedido ao controller, como checar se o usuario esta logado ou validar dados basicos.

CONTROLLER (CONTROLADOR)
- O que é: O atendente da aplicação web.
- O que faz no projeto: Pega as informacoes que vieram pela internet (dados enviados pelo front-end), repassa para o Service trabalhar e devolve a resposta final com o codigo certo (como 200 de sucesso ou 404 de erro).

SERVICE (SERVICO / REGRAS DE NEGOCIO)
- O que é: O cerebro das regras do sistema.
- O que faz no projeto: Aplica as regras da empresa (por exemplo: verificar se um cliente existe antes de atualizar ou apagar). Ele nao sabe nada sobre internet (nao mexe com req ou res) e apenas diz o que deve acontecer.

REPOSITORY (REPOSITORIO DE DADOS)
- O que é: O especialista em falar com o banco de dados.
- O que faz no projeto: E a unica parte do codigo que mexe com o Prisma Client. Ele tem as funções basicas do CRUD: findAll, findById, create, update e remove. Se um dia o banco mudar, so essa camada precisa ser alterada.

ERRORS (CENTRAL DE ERROS / NOTFOUNDERROR)
- O que é: Arquivos que padronizam as mensagens de falha.
- O que faz no projeto: Permite avisar com clareza quando algo deu errado (como disparar "Customer nao encontrado.") sem quebrar o servidor nem expor codigos internos para o usuario.

--------------------------------------------------------------------------------
DADOS, PRISMA E BANCO DE DADOS
--------------------------------------------------------------------------------

SCHEMA.PRISMA
- O que é: O arquivo de desenho do banco de dados escrito na linguagem simples do Prisma.
- O que faz no projeto: Descreve o modelo Customer com seus campos (nome, CPF unico, e-mail unico, endereco, telefone) e tipos de dados.

MIGRATIONS
- O que são: Historicos de alteracoes em SQL criados automaticamente pelo Prisma.
- O que fazem no projeto: Pegam as mudanças feitas no schema.prisma e aplicam de verdade dentro do PostgreSQL (criando ou alterando tabelas), guardando o historico de tudo o que mudou no banco.

PRISMA CLIENT
- O que é: Uma biblioteca gerada sob medida para o nosso projeto.
- O que faz no projeto: Da funcoes prontas em TypeScript para o Repository usar (como prisma.customer.findMany ou prisma.customer.create), evitando ter que digitar comandos SQL manuais.

PRISMA STUDIO
- O que é: Um painel visual que abre no navegador parecido com uma planilha.
- O que faz no projeto: Permite ver as tabelas, checar se as migrations deram certo e adicionar ou ver clientes direto na tela.

DTOS (DATA TRANSFER OBJECTS)
- O que são: Modelos em TypeScript que definem exatamente quais dados podem entrar no sistema.
- O que fazem no projeto:
  * createCustomerDto.ts: Exige todos os dados obrigatorios para cadastrar um novo cliente no banco.
  * updateCustomerDto.ts: Deixa todos os campos com ponto de interrogação (?) para permitir atualizar so o que mudou, sem precisar reenviar tudo.

--------------------------------------------------------------------------------
ASYNC, AWAIT E PROMISE (COMO O SISTEMA ESPERA O BANCO)
--------------------------------------------------------------------------------

- Contexto: Como o banco de dados fica na internet, buscar informacoes leva alguns milissegundos. O Node.js nao pode travar o servidor inteiro enquanto espera essa resposta chegar.
- Promise: A promessa de que o resultado da busca vai chegar no futuro (com os dados ou com um aviso de erro).
- async / await: Palavras que dizem ao codigo: "espere a resposta do banco chegar antes de ir para a linha de baixo, mas deixe o resto do servidor livre para atender outras pessoas".

- Analogia explicada na apostila:
  * O Service e o Chefe: Ele decide a regra e manda pagar a conta.
  * O Repository e o Office-boy: Ele recebe a ordem do chefe e vai fazer o servico de rua.
  * O Prisma e o Onibus: O transporte que leva o office-boy ate o banco de dados.
  * A Promise resolvida e o Recibo: O papel com o resultado do banco entregue de volta para o chefe.
  * O Front-end e o Departamento de Contabilidade: Quem pediu a tarefa e recebe a resposta no final.