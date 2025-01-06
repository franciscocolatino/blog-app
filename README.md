## Pré-requisitos

Você precisa ter as seguintes ferramentas instalados:

- **Docker**

## Passos para Configurar e Rodar o Projeto

### 1. Clone o Repositório

Primeiro, clone o repositório do projeto:

```bash
git clone https://github.com/franciscocolatino/blog-app
cd blog_app
```
### 2. Após isso, basta executar o docker:

```bash
sudo docker-compose up
```
### 3.Quando o docker terminar de instalar todas as dependencias, deve-se executar a criação do banco de dados

```bash
sudo docker-compose exec app rails db:create
```

### 4. Realizamos o migrate e seed

```bash
sudo docker-compose exec app rails db:migrate
```

### Pronto, aplicação funcionando!
