# Aprendendo Node.js com Docker

Este repositório contém um projeto que ensina como configurar um ambiente de desenvolvimento para Node.js usando **Docker**. A aplicação "Hello World" é criada e executada dentro de um container Docker, e o tutorial completo para configurar o ambiente e desenvolver a aplicação está disponível no arquivo **Tutorial-Aprendendo-Nodejs-com-Docker.md**.

## 🛠️ Requisitos

Antes de começar, você precisa garantir que possui os seguintes requisitos:

- **Docker Desktop** para **Windows** (Windows 10 ou superior)
- **Docker Engine** para **Linux** ou **MacOS**

Você pode baixar e instalar o Docker para a sua plataforma acessando https://www.docker.com/get-started.

Após a instalação, certifique-se de que o Docker está rodando em seu sistema. Você pode verificar isso executando:

```bash
docker --version
docker-compose --version
```

Esses comandos devem retornar a versão do Docker e do Docker Compose.

## 🛠️ Como Executar o Projeto

Para rodar o projeto em seu ambiente local, siga os passos abaixo.

### 1. Clone o Repositório

Clone o repositório para a sua máquina:

```bash
git clone https://github.com/renatotg10/aprendendo-nodejs-com-docker.git
cd aprendendo-nodejs-com-docker
```

### 2. Suba o Container Docker

Certifique-se de que você tenha o **Docker** e o **Docker Compose** instalados. Em seguida, no diretório onde o arquivo `docker-compose.yml` está localizado, execute:

```bash
docker-compose up -d
```

Isso irá criar o container e rodar o ambiente de desenvolvimento configurado para a aplicação Node.js.

### 3. Acesse o Container

Após o container estar em execução, você pode acessar o terminal do container para interagir com ele:

```bash
docker-compose exec ubuntu bash
```

Ou, se preferir:

```bash
docker exec -it ubuntu-nodejs bash
```

Dentro do container, você pode verificar a versão do Node.js e do NPM:

```bash
node -v
npm -v
```

### 4. Executando a Aplicação **Hello World**

Acesse o diretório `/apps/hello-world-node` dentro do container:

```bash
cd /apps/hello-world-node
```

Dentro do diretório `/apps/hello-world-node`, execute:

```bash
node app.js
```

Isso iniciará o servidor na porta **3000**. Para testar, abra o navegador e acesse:

```
http://localhost:3000
```

Você verá a mensagem "Hello World!".

---

## 📚 Tutorial Completo

Para um guia passo a passo de como configurar o ambiente e entender cada parte do processo, consulte o **Tutorial-Aprendendo-Nodejs-com-Docker.md**, que contém instruções detalhadas sobre como construir a aplicação e configurar o ambiente.

Leia o tutorial completo [aqui](Tutorial-Aprendendo-Nodejs-com-Docker.md).

---

## 📄 Licença

Este projeto está licenciado sob a licença MIT. Consulte o arquivo [LICENSE](LICENSE.md) para mais detalhes.

Você pode atualizar a seção de "Autor" no arquivo `README.md` para incluir o seu e-mail, conforme abaixo:

## 👨‍💻 Autor

Este projeto foi desenvolvido por **Renato Teixeira Gomes** como parte do tutorial **"Aprendendo Node.js com Docker"**. Para mais tutoriais e conteúdos, acesse meu [GitHub](https://github.com/renatotg10).

Email: [renatotg10@gmail.com](mailto:renatotg10@gmail.com)
