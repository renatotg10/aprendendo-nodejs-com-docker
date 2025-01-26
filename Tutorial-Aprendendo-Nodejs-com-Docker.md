# Aprendendo Node.js com Docker
`26/01/2025 - Renato Teixeira Gomes - renatotg10@gmail.com`

Iremos utilizar um container Docker utilizando uma imagem Docker com Ubuntu. Dessa forma poderemos utilizar o container para instalar o Node.js e criar a aplicação em um ambiente Linux Ubuntu.

Para executar o conteúdo descrito neste documento, foi utilizado o Sitema Operacional Windows 10 e com terminal foi utilizado o GitBash.

O GitBash executa os mesmos comandos do terminal do Linux, portando, se estiver utilizando o Sistema Operacinal Linux ou MacOS, os comandos tamnbém irão funcionar.

## Requisitos

- Ter o Docker Desktop instalado
- Ter o Git instalado
- Ter o Visual Studio Code (VS Code) instalado

##  Alternativa 1 - Criando o container apenas com a imagem Linux Ubuntu

Iremos criar um container Docker com uma imagem do Linux Ubuntu 22.04 utilizando apenas o `docker-compose.yml`. Nesse caso, será necessário fazer as instalações de pacotes, como o Node.js diretamente no `bash` do container.

Crie e acesse o diretório `aprendendo-nodejs`:

```bash
mkdir aprendendo-nodejs
cd aprendendo-nodejs
```

Cria o diretório `apps` e o arquivo `docker-compose.yml`:

```bash
mkdir apps
touch docker-compose.yml
```

Abrir o diretório `aprendendo-nodejs` no VS Code:

```bash
code .
```

Abra o arquivo `docker-complose.yml` e adicione o código:

```bash
services:
  ubuntu:
    image: ubuntu:22.04  # Utiliza a imagem oficial do Ubuntu 22.04
    container_name: ubuntu-container
    volumes:
      - ./apps:/apps  # Opcional: Monta o diretório 'app' da sua máquina local para o container
    command: bash  # Mantém o container rodando com o bash
    stdin_open: true  # Permite o acesso interativo ao container
    tty: true  # Mantém o terminal interativo
    ports:
      - "3000:3000"
```

No diretório onde o arquivo `docker-compose.yml` está localizado, execute:

```bash
docker-compose up -d
```

Para verificar se o container está ativo execute o comando:

```bash
docker ps
```

Deverá retornar algo como:

```bash
CONTAINER ID   IMAGE          COMMAND   CREATED          STATUS          PORTS     NAMES
43c235056261   ubuntu:22.04   "bash"    27 seconds ago   Up 26 seconds             ubuntu-container
```

Para verificar todos os container, até mesmo os que estão inativos (parados), execute o comando:

```bash
docker ps -a
```

Com o container em execução, poderá acessar o bash interativo do container com o seguinte comando:

```bash
docker-compose exec ubuntu bash
```

Ou também pode utilizar o comando:

```bash
docker exec -it ubuntu-container bash
```

Isso abrirá o bash dentro do seu container Ubuntu, permitindo que você execute os comandos que desejar, como se estivesse em uma máquina Ubuntu normal.

**Quando usar cada um?**

- **Use `docker-compose exec`**:
  - Se os contêineres foram iniciados com `docker-compose`.
  - Para referenciar diretamente os **serviços** do `docker-compose.yml`.

- **Use `docker exec`**:
  - Se o contêiner foi criado manualmente (com `docker run`).
  - Quando você tem o nome ou o ID do contêiner.

**Dica:**
Se estiver em dúvida, use `docker ps` para listar os contêineres e identificar se o contêiner está rodando e qual o nome correto para usar com `docker exec`.

Para sair do bash do container execute o comando:

```bash
exit
```

Para parar o container, precisa informar o `ID` do container, que pode ser obtido através do comando:

```bash
docker ps
```

Que deverá retornar algo como:

```bash
CONTAINER ID   IMAGE          COMMAND   CREATED          STATUS          PORTS     NAMES
43c235056261   ubuntu:22.04   "bash"    12 minutes ago   Up 12 minutes             ubuntu-container
```

O `ID` do container pode ser verificado na coluna `CONTAINER ID`. Usando este exemplo, para parar esse container, execute o comando:

```bash
docker stop 43c235056261
```

Também pode ser informado o `NOME` do container, que consta na coluna `NAMES`. Usando o nosso exemplo, para parar o container utilizando o `NOME`, basta exetuar o comando:

```bash
docker stop ubuntu-container
```

Para iniciar um container parado (inativo), também iremos precisar do `ID` ou `NOME`. Para obter essas informações, execute o comando:

```bash
docker ps -a
```

Que deverá retornar algo como:

```bash
CONTAINER ID   IMAGE          COMMAND   CREATED          STATUS                        PORTS     NAMES
43c235056261   ubuntu:22.04   "bash"    16 minutes ago   Exited (137) 13 seconds ago             ubuntu-container
```

O `ID` do container pode ser verificado na coluna `CONTAINER ID`. Usando este exemplo, para iniciar esse container, execute o comando:

```bash
docker start 43c235056261
```

Também pode ser informado o `NOME` do container, que consta na coluna `NAMES`. Usando o nosso exemplo, para iniciar o container utilizando o `NOME`, basta exetuar o comando:

```bash
docker start ubuntu-container
```

### Instalando o Node.js no container através do `bash`

Acesse o bash do container:

```bash
docker-compose exec ubuntu bash
```

Para atualizar a lista de pacotes disponíveis nos repositórios configurados no sistema, execute o comando:

```bash
apt update
apt install -y curl
```

Para configurar o repositório NodeSource no seu sistema e preparar a instalação do Node.js na versão mais recente (ou "current"), execute o comando:

```bash
curl -fsSL https://deb.nodesource.com/setup_current.x | bash -
```

Após adicionar o repositório do NodeSource, instale o Node.js e o npm com o comando:

```bash
apt install -y nodejs
```

Para verificar se o Node.js foi instalado corretamente, você pode usar os seguintes comandos:

```bash
node -v
npm -v
```

## Alternativa 2 - Utilizando o Dockerfile para criar uma imagem personalizada com o Linux Ubuntu e o Node.js instalado

Iremos criar um container Docker com uma imagem do Linux Ubuntu 22.04 utilizando `docker-compose.yml` junto com o `Dockerfile`. No `Dockerfile` iremos adicionar os comandos para já instalar o Node.js.


Crie e acesse o diretório `aprendendo-nodejs`:

```bash
mkdir aprendendo-nodejs
cd aprendendo-nodejs
```

Cria o diretório `apps`, o arquivo `docker-compose.yml` e o arquivo `Dockerfile`:

```bash
mkdir apps
touch docker-compose.yml
touch Dockerfile
```

Abrir o diretório `aprendendo-nodejs` no VS Code:

```bash
code .
```

Abra o arquivo `docker-complose.yml` e adicione o código:

```bash
services:
  ubuntu:
    build:
      context: .  # Usando o diretório atual onde está o Dockerfile
    container_name: ubuntu-nodejs
    volumes:
      - ./apps:/apps
    stdin_open: true
    tty: true
    ports:
      - "3000:3000"  # Mapeando a porta 3000 do container para a porta 3000 na máquina host
```

Abra o arquivo `Dockerfile` e adicione o código:

```bash
# Usar a imagem base do Ubuntu 22.04
FROM ubuntu:22.04

# Atualizar os pacotes e instalar dependências
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    lsb-release \
    ca-certificates \
    && apt-get clean

# Instalar o Node.js a partir do repositório oficial
RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean

# Definir o diretório de trabalho
WORKDIR /apps

# Manter a entrada interativa aberta e usar TTY (semelhante ao que é feito no docker-compose.yml)
CMD ["bash"]
```

No diretório onde o arquivo `docker-compose.yml` está localizado, execute:

```bash
docker-compose up -d
```

Com o container em execução, poderá acessar o bash interativo do container com o seguinte comando:

```bash
docker-compose exec ubuntu bash
```

Ou também pode utilizar o comando:

```bash
docker exec -it ubuntu-nodejs bash
```

Isso abrirá o bash dentro do seu container Ubuntu, permitindo que você execute os comandos que desejar, como se estivesse em uma máquina Ubuntu normal.

Para verificar se o Node.js foi instalado corretamente, você pode usar os seguintes comandos:

```bash
node -v
npm -v
```

## Criando o projeto Hello World! com Node.js

Para criar uma aplicação simples "Hello World" em Node.js, siga os passos abaixo:

### Passo 1: Criar o diretório do projeto dentro da pasta `apps`

Primeiro, crie um diretório para o seu projeto e entre nele:

```bash
cd apps
mkdir hello-world-node
cd hello-world-node
```

### Passo 2: Inicializar o projeto

Dentro do diretório, inicialize um novo projeto Node.js com o comando:

```bash
npm init -y
```

Isso criará um arquivo `package.json` com as configurações padrão.

Para usar `import` em vez de `require` em sua aplicação Node.js, você precisará garantir que o Node.js esteja configurado para suportar módulos ES6.

**Passo 1: Atualizar o arquivo `package.json`**

No seu arquivo `package.json`, adicione a chave `"type": "module"` para que o Node.js saiba que você deseja usar a sintaxe de módulos ES6 (com `import` e `export`).

Edite o arquivo `package.json` para ficar assim:

```json
{
  "name": "hello-world-node",
  "version": "1.0.0",
  "description": "",
  "main": "app.js",
  "type": "module",
  "scripts": {
    "start": "node app.js"
  },
  "author": "",
  "license": "ISC"
}
```

A chave `"type": "module"` é crucial para permitir o uso de `import` e `export` no Node.js.

**Nota:**

A partir do Node.js 12 e versões mais recentes, é possível usar a sintaxe `import` em vez de `require` quando você define `"type": "module"` no `package.json`. Isso facilita a transição para a sintaxe de módulos ES6 em projetos Node.js.

### Passo 3: Criar o arquivo do servidor

Agora, crie um arquivo chamado `app.js` dentro do diretório:

```bash
touch app.js
```

### Passo 4: Escrever o código Hello World

No arquivo `app.js`, adicione o seguinte código:

```javascript
// Importando o módulo http usando a sintaxe de import
import http from 'http';

// Criando o servidor
const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('Hello World!\n');
});

// Definindo a porta do servidor
const port = 3000;
server.listen(port, () => {
  console.log(`Servidor rodando em http://localhost:${port}`);
});
```

Este código cria um servidor HTTP básico que responde com "Hello World!" para qualquer requisição.

### Passo 5: Executar o servidor

Agora, no terminal, execute o seu servidor com o comando:

```bash
node app.js
```

Se tudo estiver correto, você verá a mensagem:

```
Servidor rodando em http://localhost:3000
```

### Passo 6: Testar a aplicação

Abra o navegador e acesse o endereço `http://localhost:3000`. Você verá a mensagem "Hello World!".

Pronto! Você criou sua primeira aplicação Node.js simples.

---

## **Apêndice A: Comandos Comuns do Docker**

Este apêndice fornece uma lista de comandos essenciais do Docker que você usará durante seu trabalho com containers e imagens. Para facilitar o entendimento, os comandos estão agrupados por categorias, com explicações rápidas e exemplos práticos.

---

#### 1. **Comandos Básicos do Docker**

- **`docker --version`**  
  Exibe a versão do Docker instalada no sistema.
  **Exemplo:**
  ```bash
  docker --version
  ```

- **`docker info`**  
  Exibe informações detalhadas sobre a instalação do Docker, incluindo configurações e status.
  **Exemplo:**
  ```bash
  docker info
  ```

---

#### 2. **Gerenciamento de Imagens**

- **`docker pull <imagem>`**  
  Baixa uma imagem do Docker Hub (ou de outro repositório).
  **Exemplo:**
  ```bash
  docker pull ubuntu:22.04
  ```

- **`docker images`**  
  Lista todas as imagens Docker armazenadas localmente.
  **Exemplo:**
  ```bash
  docker images
  ```

- **`docker rmi <imagem>`**  
  Remove uma imagem Docker do sistema.
  **Exemplo:**
  ```bash
  docker rmi ubuntu:22.04
  ```

---

#### 3. **Gerenciamento de Containers**

- **`docker run <imagem>`**  
  Cria e inicia um container a partir de uma imagem.
  **Exemplo:**
  ```bash
  docker run -it ubuntu:22.04 bash
  ```
  Este comando cria um container a partir da imagem `ubuntu:22.04` e executa um shell `bash` dentro dele.

- **`docker ps`**  
  Lista todos os containers em execução.
  **Exemplo:**
  ```bash
  docker ps
  ```

- **`docker ps -a`**  
  Lista todos os containers, incluindo os que não estão em execução.
  **Exemplo:**
  ```bash
  docker ps -a
  ```

- **`docker stop <container_id>`**  
  Para um container em execução.
  **Exemplo:**
  ```bash
  docker stop <container_id>
  ```

- **`docker start <container_id>`**  
  Inicia um container que foi parado.
  **Exemplo:**
  ```bash
  docker start <container_id>
  ```

- **`docker restart <container_id>`**  
  Reinicia um container.
  **Exemplo:**
  ```bash
  docker restart <container_id>
  ```

- **`docker rm <container_id>`**  
  Remove um container parado.
  **Exemplo:**
  ```bash
  docker rm <container_id>
  ```

- **`docker rm -f <container_id>`**  
  Remove um container em execução (força a remoção).
  **Exemplo:**
  ```bash
  docker rm -f <container_id>
  ```

- **`docker exec -it <container_id> bash`**  
  Executa um comando dentro de um container em execução (neste caso, abre um terminal bash).
  **Exemplo:**
  ```bash
  docker exec -it <container_id> bash
  ```

- **`docker logs <container_id>`**  
  Exibe os logs de um container em execução.
  **Exemplo:**
  ```bash
  docker logs <container_id>
  ```

---

#### 4. **Gerenciamento de Volumes e Redes**

- **`docker volume ls`**  
  Lista todos os volumes Docker.
  **Exemplo:**
  ```bash
  docker volume ls
  ```

- **`docker volume rm <volume_name>`**  
  Remove um volume Docker.
  **Exemplo:**
  ```bash
  docker volume rm <volume_name>
  ```

- **`docker network ls`**  
  Lista todas as redes Docker.
  **Exemplo:**
  ```bash
  docker network ls
  ```

---

#### 5. **Docker Compose**

O **Docker Compose** permite que você defina e execute aplicativos multi-containers. Com o Compose, você usa um arquivo YAML para configurar os serviços do seu aplicativo, e então, com um único comando, você cria e inicia todos os containers a partir da configuração.

- **`docker-compose up`**  
  Inicia todos os containers definidos no arquivo `docker-compose.yml`.
  **Exemplo:**
  ```bash
  docker-compose up
  ```

- **`docker-compose up -d`**  
  Inicia os containers em segundo plano (modo "detached").
  **Exemplo:**
  ```bash
  docker-compose up -d
  ```

- **`docker-compose down`**  
  Para e remove os containers, redes e volumes definidos no `docker-compose.yml`.
  **Exemplo:**
  ```bash
  docker-compose down
  ```

- **`docker-compose exec <service_name> <command>`**  
  Executa um comando dentro de um container em execução.  
  **Exemplo:**
  ```bash
  docker-compose exec ubuntu bash
  ```

- **`docker-compose logs <service_name>`**  
  Exibe os logs de um serviço específico.
  **Exemplo:**
  ```bash
  docker-compose logs ubuntu
  ```

---

#### 6. **Comandos de Limpeza**

- **`docker system prune`**  
  Remove todos os containers, redes e volumes não utilizados.
  **Exemplo:**
  ```bash
  docker system prune
  ```

- **`docker system prune -a`**  
  Remove todas as imagens não utilizadas, além de containers, redes e volumes não utilizados.
  **Exemplo:**
  ```bash
  docker system prune -a
  ```

---

### **Conclusão**

Neste apêndice, você aprendeu sobre os comandos mais comuns e essenciais do Docker. Esses comandos são os blocos básicos para trabalhar com containers, imagens, volumes, redes e para utilizar o Docker Compose. Eles são fundamentais para gerenciar e automatizar ambientes de desenvolvimento e produção com Docker.

---

## **Apêndice B: Comandos Comuns de Bash no Linux**

Este apêndice fornece uma lista de comandos essenciais para navegar, manipular arquivos e gerenciar o sistema em um terminal Bash no Linux. Todos os comandos estão acompanhados de explicações rápidas e exemplos práticos para facilitar o aprendizado.

---

#### 1. **Comandos de Navegação e Manipulação de Diretórios**

- **`pwd`**  
  Exibe o diretório atual em que você está.
  **Exemplo:**
  ```bash
  pwd
  ```

- **`cd <diretório>`**  
  Muda para o diretório especificado.
  **Exemplo:**
  ```bash
  cd /home/usuario
  ```

- **`ls`**  
  Lista os arquivos e pastas no diretório atual.
  **Exemplo:**
  ```bash
  ls
  ```

- **`ls -l`**  
  Lista os arquivos e pastas no diretório atual com detalhes (como permissões e tamanho).
  **Exemplo:**
  ```bash
  ls -l
  ```

- **`cd ..`**  
  Volta para o diretório anterior.
  **Exemplo:**
  ```bash
  cd ..
  ```

---

#### 2. **Comandos de Criação e Manipulação de Arquivos**

- **`touch <arquivo>`**  
  Cria um arquivo vazio com o nome especificado.
  **Exemplo:**
  ```bash
  touch novo_arquivo.txt
  ```

- **`mkdir <diretório>`**  
  Cria um novo diretório.
  **Exemplo:**
  ```bash
  mkdir meu_diretorio
  ```

- **`cp <origem> <destino>`**  
  Copia um arquivo ou diretório para o destino.
  **Exemplo:**
  ```bash
  cp arquivo.txt /home/usuario/novo_diretorio/
  ```

- **`mv <origem> <destino>`**  
  Move ou renomeia um arquivo ou diretório.
  **Exemplo:**
  ```bash
  mv arquivo.txt novo_nome.txt
  ```

- **`rm <arquivo>`**  
  Remove um arquivo.
  **Exemplo:**
  ```bash
  rm arquivo.txt
  ```

- **`rm -r <diretório>`**  
  Remove um diretório e todo o seu conteúdo.
  **Exemplo:**
  ```bash
  rm -r meu_diretorio
  ```

---

#### 3. **Comandos para Exibir Conteúdo de Arquivos**

- **`cat <arquivo>`**  
  Exibe o conteúdo de um arquivo no terminal.
  **Exemplo:**
  ```bash
  cat arquivo.txt
  ```

- **`more <arquivo>`**  
  Exibe o conteúdo de um arquivo, permitindo rolar a tela para baixo.
  **Exemplo:**
  ```bash
  more arquivo.txt
  ```

- **`less <arquivo>`**  
  Exibe o conteúdo de um arquivo, permitindo rolar para cima e para baixo.
  **Exemplo:**
  ```bash
  less arquivo.txt
  ```

- **`head <arquivo>`**  
  Exibe as primeiras linhas de um arquivo.
  **Exemplo:**
  ```bash
  head arquivo.txt
  ```

- **`tail <arquivo>`**  
  Exibe as últimas linhas de um arquivo.
  **Exemplo:**
  ```bash
  tail arquivo.txt
  ```

---

#### 4. **Comandos de Busca e Filtragem**

- **`grep <expressão> <arquivo>`**  
  Pesquisa por uma expressão dentro de um arquivo e exibe as linhas que a contêm.
  **Exemplo:**
  ```bash
  grep "erro" arquivo.log
  ```

- **`find <diretório> -name <nome>`**  
  Busca arquivos ou diretórios por nome dentro de um diretório especificado.
  **Exemplo:**
  ```bash
  find /home/usuario/ -name "arquivo.txt"
  ```

- **`locate <arquivo>`**  
  Localiza arquivos rapidamente no sistema (requer banco de dados atualizado com o comando `updatedb`).
  **Exemplo:**
  ```bash
  locate arquivo.txt
  ```

---

#### 5. **Comandos de Gerenciamento de Processos**

- **`ps`**  
  Exibe a lista de processos em execução.
  **Exemplo:**
  ```bash
  ps
  ```

- **`top`**  
  Exibe uma lista dinâmica de processos em execução, com informações sobre uso de CPU e memória.
  **Exemplo:**
  ```bash
  top
  ```

- **`kill <pid>`**  
  Envia um sinal para finalizar um processo com o identificador `<pid>`.
  **Exemplo:**
  ```bash
  kill 1234
  ```

- **`killall <nome_do_processo>`**  
  Envia um sinal para finalizar todos os processos com o nome especificado.
  **Exemplo:**
  ```bash
  killall firefox
  ```

---

#### 6. **Comandos de Permissões de Arquivos**

- **`chmod <permissões> <arquivo>`**  
  Modifica as permissões de leitura, gravação e execução de arquivos.
  **Exemplo:**
  ```bash
  chmod 755 script.sh
  ```

- **`chown <usuário>:<grupo> <arquivo>`**  
  Modifica o proprietário e o grupo de um arquivo.
  **Exemplo:**
  ```bash
  chown usuario:grupo arquivo.txt
  ```

---

#### 7. **Comandos de Rede**

- **`ping <host>`**  
  Envia pacotes ICMP para verificar a conectividade com um host.
  **Exemplo:**
  ```bash
  ping google.com
  ```

- **`ifconfig`**  
  Exibe informações de rede do sistema (interface de rede, IPs, etc.).
  **Exemplo:**
  ```bash
  ifconfig
  ```

- **`curl <url>`**  
  Realiza uma requisição HTTP e exibe a resposta.
  **Exemplo:**
  ```bash
  curl https://www.exemplo.com
  ```

---

#### 8. **Comandos de Gerenciamento de Usuários**

- **`useradd <nome_do_usuario>`**  
  Cria um novo usuário no sistema.
  **Exemplo:**
  ```bash
  useradd usuario_novo
  ```

- **`passwd <nome_do_usuario>`**  
  Altera a senha de um usuário.
  **Exemplo:**
  ```bash
  passwd usuario_novo
  ```

- **`usermod -aG <grupo> <usuario>`**  
  Adiciona um usuário a um grupo.
  **Exemplo:**
  ```bash
  usermod -aG sudo usuario_novo
  ```

---

#### 9. **Comandos de Arquivamento e Compressão**

- **`tar -cvf <arquivo.tar> <diretório>`**  
  Cria um arquivo tar (compactado) a partir de um diretório.
  **Exemplo:**
  ```bash
  tar -cvf arquivo.tar meu_diretorio/
  ```

- **`tar -xvf <arquivo.tar>`**  
  Extrai o conteúdo de um arquivo tar.
  **Exemplo:**
  ```bash
  tar -xvf arquivo.tar
  ```

- **`zip <arquivo.zip> <arquivo>`**  
  Cria um arquivo ZIP.
  **Exemplo:**
  ```bash
  zip arquivo.zip meu_arquivo.txt
  ```

- **`unzip <arquivo.zip>`**  
  Extrai o conteúdo de um arquivo ZIP.
  **Exemplo:**
  ```bash
  unzip arquivo.zip
  ```

---

### **Conclusão**

Neste apêndice, você aprendeu os comandos mais comuns usados no Bash Linux para navegar no sistema, manipular arquivos, gerenciar processos e trabalhar com redes e usuários. Esses comandos são essenciais para quem deseja se aprofundar no uso de sistemas Linux, tanto para administração de sistemas quanto para tarefas diárias.

---

### **Apêndice C: Comandos Comuns do Node.js**

Este apêndice apresenta uma lista de comandos e práticas essenciais para o trabalho com **Node.js**, um dos ambientes mais populares para desenvolvimento de aplicativos JavaScript do lado do servidor. Inclui comandos para gerenciamento de pacotes, execução de aplicativos e configuração do ambiente.

---

#### 1. **Instalação do Node.js**

Antes de usar qualquer comando do Node.js, você precisa ter o **Node.js** e o **npm** (Node Package Manager) instalados. Você pode verificar se o Node.js está instalado com:

- **`node --version`**  
  Exibe a versão do Node.js instalada.
  **Exemplo:**
  ```bash
  node --version
  ```

- **`npm --version`**  
  Exibe a versão do npm instalada.
  **Exemplo:**
  ```bash
  npm --version
  ```

Se o Node.js não estiver instalado, você pode instalá-lo conforme as instruções do [site oficial](https://nodejs.org/).

---

#### 2. **Gerenciamento de Pacotes com npm**

- **`npm init`**  
  Cria um arquivo `package.json` para o seu projeto. Esse comando irá pedir algumas informações sobre o seu projeto.
  **Exemplo:**
  ```bash
  npm init
  ```

- **`npm init -y`**  
  Cria o arquivo `package.json` com valores padrão automaticamente, sem pedir informações adicionais.
  **Exemplo:**
  ```bash
  npm init -y
  ```

- **`npm install <pacote>`**  
  Instala um pacote e adiciona ao seu arquivo `package.json`.
  **Exemplo:**
  ```bash
  npm install express
  ```

- **`npm install <pacote> --save-dev`**  
  Instala um pacote como dependência de desenvolvimento, ou seja, ele será utilizado apenas em ambientes de desenvolvimento e não será instalado em produção.
  **Exemplo:**
  ```bash
  npm install mocha --save-dev
  ```

- **`npm install`**  
  Instala todas as dependências listadas no arquivo `package.json`.
  **Exemplo:**
  ```bash
  npm install
  ```

- **`npm uninstall <pacote>`**  
  Remove um pacote do seu projeto.
  **Exemplo:**
  ```bash
  npm uninstall express
  ```

- **`npm update`**  
  Atualiza as dependências do seu projeto para suas versões mais recentes compatíveis.
  **Exemplo:**
  ```bash
  npm update
  ```

- **`npm list`**  
  Lista todas as dependências instaladas no projeto.
  **Exemplo:**
  ```bash
  npm list
  ```

---

#### 3. **Comandos para Execução de Aplicações Node.js**

- **`node <arquivo.js>`**  
  Executa um arquivo JavaScript com o Node.js.
  **Exemplo:**
  ```bash
  node app.js
  ```

- **`node -v`**  
  Exibe a versão do Node.js.
  **Exemplo:**
  ```bash
  node -v
  ```

- **`node`**  
  Inicia um shell interativo do Node.js, onde você pode testar código JavaScript diretamente no terminal.
  **Exemplo:**
  ```bash
  node
  ```

- **`node --inspect-brk <arquivo.js>`**  
  Inicia o Node.js com a capacidade de depuração. O `--inspect-brk` faz com que o Node.js pause a execução do código na primeira linha e permita que você se conecte com uma ferramenta de depuração.
  **Exemplo:**
  ```bash
  node --inspect-brk app.js
  ```

---

#### 4. **Gerenciamento de Scripts no package.json**

- **`npm run <script>`**  
  Executa um script definido no arquivo `package.json`. Você pode definir scripts personalizados, como iniciar o servidor ou rodar testes.
  **Exemplo:**
  ```bash
  npm run start
  ```

- **`npm run test`**  
  Executa o script `test` definido no arquivo `package.json`.
  **Exemplo:**
  ```bash
  npm run test
  ```

---

#### 5. **Comandos de Debug e Monitoramento**

- **`node --inspect <arquivo.js>`**  
  Inicia a depuração do Node.js. Você pode se conectar ao processo de depuração usando ferramentas como o Chrome DevTools ou IDEs compatíveis com o Node.js.
  **Exemplo:**
  ```bash
  node --inspect app.js
  ```

- **`console.log(<variável>)`**  
  Utilizado no código para imprimir informações no terminal durante a execução. Este comando é útil para depuração.
  **Exemplo dentro do código JavaScript:**
  ```javascript
  console.log('Hello, World!');
  ```

---

#### 6. **Outros Comandos e Utilitários Importantes**

- **`npm audit`**  
  Verifica vulnerabilidades de segurança nas dependências do seu projeto.
  **Exemplo:**
  ```bash
  npm audit
  ```

- **`npm audit fix`**  
  Corrige automaticamente as vulnerabilidades de segurança nas dependências, quando possível.
  **Exemplo:**
  ```bash
  npm audit fix
  ```

- **`npm cache clean --force`**  
  Limpa o cache do npm. Útil quando há problemas com o cache ou pacotes corrompidos.
  **Exemplo:**
  ```bash
  npm cache clean --force
  ```

- **`npm run dev`**  
  Executa o script `dev` (geralmente usado para rodar servidores de desenvolvimento, como com o `nodemon`).
  **Exemplo (definindo no `package.json`):**
  ```json
  "scripts": {
    "dev": "nodemon app.js"
  }
  ```

---

#### 7. **Comando `npm ci`**

- **`npm ci`**  
  O comando `npm ci` (Continuous Integration) é usado para instalações rápidas e confiáveis em ambientes de integração contínua. Ele instala as dependências do projeto de acordo com o arquivo `package-lock.json`, garantindo que as versões exatas das dependências sejam usadas. Isso é útil para garantir que a instalação das dependências seja reproduzível em diferentes máquinas e ambientes, como em pipelines de CI/CD.
  
  - Ao contrário de **`npm install`**, que pode atualizar o arquivo `package-lock.json` ou modificar dependências, o **`npm ci`** ignora alterações no arquivo `package.json` e **instala exatamente as dependências definidas no `package-lock.json`**.
  - Ele também **exclui a pasta `node_modules`** antes de iniciar a instalação, garantindo uma instalação limpa.

  **Exemplo:**
  ```bash
  npm ci
  ```

  **Vantagens do `npm ci`:**
  - Instalação mais rápida, pois não há necessidade de resolver dependências.
  - Resultados consistentes, já que as dependências são instaladas exatamente conforme o especificado no `package-lock.json`.
  - Ideal para pipelines de CI/CD, onde a consistência da instalação é crucial.

---

#### 8. **Gerenciamento de Pacotes Globais**

- **`npm install -g <pacote>`**  
  Instala um pacote globalmente, tornando-o disponível em qualquer lugar do sistema.
  **Exemplo:**
  ```bash
  npm install -g nodemon
  ```

- **`npm list -g --depth=0`**  
  Lista os pacotes globais instalados no sistema.
  **Exemplo:**
  ```bash
  npm list -g --depth=0
  ```

- **`npm uninstall -g <pacote>`**  
  Remove um pacote globalmente.
  **Exemplo:**
  ```bash
  npm uninstall -g nodemon
  ```

---

### **Conclusão**

Neste apêndice, você aprendeu sobre os principais comandos do **Node.js** e do **npm** para gerenciar dependências, executar aplicativos e depurar seu código. Agora, com a inclusão do **`npm ci`**, você tem uma ferramenta adicional importante para ambientes de integração contínua, que garante uma instalação consistente e reproduzível das dependências, essencial para garantir a confiabilidade e a velocidade de suas builds. Esses comandos são fundamentais para o desenvolvimento eficiente com Node.js, seja para criar aplicações simples ou para trabalhar em projetos mais complexos.
