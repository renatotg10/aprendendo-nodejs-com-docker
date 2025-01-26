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
