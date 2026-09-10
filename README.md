# Paradigmas de Programação II 
## Back-End com Node.js, Express e Prisma

> API RESTful para o gerenciamento de clientes e veículos da aplicação **Karangos** (concessionária de veículos antigos), construída sob arquitetura em camadas com separação estrita de responsabilidades e tipagem estática.

> O projeto implementa um CRUD completo conectado ao PostgreSQL via Prisma ORM, contemplando validação estrutural com DTOs, histórico de alterações com migrations, tratamento centralizado de erros e conteinerização em nuvem com GitHub Codespaces.

![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)
![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?style=for-the-badge&logo=typescript&logoColor=white)
![Express.js](https://img.shields.io/badge/Express.js-000000?style=for-the-badge&logo=express&logoColor=white)
![Prisma](https://img.shields.io/badge/Prisma-2D3748?style=for-the-badge&logo=prisma&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![GitHub Codespaces](https://img.shields.io/badge/GitHub%20Codespaces-181717?style=for-the-badge&logo=github&logoColor=white)

---

## Arquitetura da Aplicação

O fluxo de dados segue uma estrutura hierárquica e desacoplada, garantindo que o acesso a dados permaneça isolado das regras de negócio e do protocolo HTTP:

```text
[ Cliente / EchoAPI ]
         │  ▲
  (HTTP) │  │ (JSON)
         ▼  │
     server.ts  ───►  app.ts
                        │
                        ▼
                     routes        (Mapeia URLs e métodos HTTP)
                        │
                        ▼
                   controllers     (Gerencia req/res, parâmetros e códigos HTTP)
                        │
                        ▼
                    services       (Concentra regras de negócio e validações)
                        │
                        ▼
                  repositories     (Isola o acesso a dados / CRUD)
                        │
                        ▼
                  Prisma Client    (ORM que executa queries no PostgreSQL)
                        │
                        ▼
                [ BD PostgreSQL ]
```

---

## Camadas e Responsabilidades

| Camada | Arquivos | Responsabilidade Técnica |
| :--- | :--- | :--- |
| **Servidor** | `src/bin/server.ts`, `src/app.ts` | Inicializa o servidor Express na porta `8888` e configura middlewares (`morgan`, `cookieParser`, `json`). |
| **Rotas** | `src/routes/customers.ts` | Declara os endpoints e associa verbos HTTP (`GET`, `POST`, `PUT`, `DELETE`) aos respectivos métodos do controller. |
| **Controllers** | `src/controllers/customerController.ts` | Recebe a requisição HTTP, extrai `params` e `body`, aciona a camada de serviço e define status HTTP (`201`, `204`, etc.). |
| **Services** | `src/services/customerService.ts` | Executa a lógica de negócio da aplicação e validações de existência antes de delegações para o repositório. |
| **Repositories** | `src/repositories/customerRepository.ts` | Camada exclusiva de comunicação com o `PrismaClient` para operações diretas de CRUD (`findMany`, `findUnique`, `create`, `update`, `delete`). |
| **DTOs** | `src/dto/customer/*.ts` | Interfaces TypeScript (`CreateCustomerDto`, `UpdateCustomerDto`) para tipar e validar contratos de entrada de dados. |
| **Erros** | `src/errors/*.ts` | Classes customizadas (`AppError`, `NotFoundError`) para padronização de exceções e códigos de erro HTTP. |

---

## Modelo de Dados (`Customer`)

Definição mapeada no arquivo `back-end/prisma/schema.prisma`:

* `id`: Chave primária inteira autoincremental (`@id @default(autoincrement())`).
* `name`: Nome completo do cliente (`String`).
* `ident_document`: Documento de identidade com unicidade garantida (`String @unique`).
* `birth_date`: Data de nascimento opcional (`DateTime? @db.Date`).
* `street_name`: Logradouro (`String`).
* `house_number`: Número do endereço (`String`).
* `complements`: Complemento residencial opcional (`String?`).
* `district`: Bairro (`String`).
* `municipality`: Município (`String`).
* `state`: Sigla da unidade federativa com tamanho fixo (`String @db.Char(2)`).
* `phone`: Número de contato telefônico (`String`).
* `email`: Endereço eletrônico com unicidade garantida (`String @unique`).

---

## Funcionamento Assíncrono (`async`, `await`, `Promise`)

O acesso ao PostgreSQL via rede ocorre de forma assíncrona para não bloquear a thread principal do Node.js.

### Analogia Instrucional da Aplicação
* **O Service é o Chefe:** Determina a regra e necessita do resultado consolidado.
* **O Repository é o Office-boy:** Recebe a ordem do chefe e executa o trabalho de busca/gravação.
* **O Prisma é o Ônibus:** Meio de transporte que viabiliza o trajeto do repositório até o banco.
* **A Promise é a Execução em Andamento:** O compromisso formal de que o dado retornará.
* **O `await` é a Espera Ativa:** O chefe aguarda a conclusão da tarefa do office-boy antes de despachar a resposta, sem travar o restante da empresa.
* **A Promise Resolvida é o Recibo:** O dado retornado pelo banco, pronto para envio ao cliente final.

---

## Configuração e Execução

### 1. Variáveis de Ambiente
Crie o arquivo `.env` dentro do diretório `back-end/` utilizando o modelo de `.env.example`:

```env
DATABASE_URL="postgres://USUARIO:SENHA@pooled.db.prisma.io:5432/postgres?sslmode=require"
```

### 2. Comandos Operacionais (Terminal em `back-end`)

```bash
# Acessar a pasta do back-end
cd back-end

# Instalar dependências do projeto
npm install

# Aplicar migrações ao banco de dados PostgreSQL
npx prisma migrate dev

# Atualizar os tipos gerados pelo Prisma Client
npx prisma generate

# Abrir a interface visual Prisma Studio
npx prisma studio

# Executar a aplicação em modo de desenvolvimento
npm run dev
```

---

## Teste de Criação de Cliente (EchoAPI / Postman)

* **Método:** `POST`
* **URL:** `http://localhost:8888/customers`
* **Headers:** `Content-Type: application/json`
* **Body (raw > JSON):**

```json
{
  "name": "Maria Silva",
  "ident_document": "12345678900",
  "birth_date": "1990-05-20T00:00:00.000Z",
  "street_name": "Rua das Flores",
  "house_number": "100",
  "complements": "Apto. 12",
  "district": "Centro",
  "municipality": "Franca",
  "state": "SP",
  "phone": "16999999999",
  "email": "maria@example.com"
}
```

* **Retorno Esperado:** Código HTTP `201 Created` contendo o objeto do cliente persistido e o respectivo `id` gerado pelo PostgreSQL.
