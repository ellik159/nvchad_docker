FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN echo "tzdata tzdata/Areas select Europe" > /tmp/preseed.txt; \
    echo "tzdata tzdata/Zones/Europe select Madrid" >> /tmp/preseed.txt; \
    debconf-set-selections /tmp/preseed.txt && \
    apt-get update && \
    apt-get install -y tzdata
RUN apt install -y git curl wget unzip clang ripgrep
#python install
RUN apt install -y software-properties-common && add-apt-repository ppa:deadsnakes/ppa&& apt update && apt install -y python3.11 python3.10-venv


WORKDIR /root

#Instacion del neovim
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
RUN chmod u+x nvim.appimage
RUN ./nvim.appimage --appimage-extract && mv squashfs-root / && ln -s /squashfs-root/AppRun /usr/bin/nvim
#Nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_20.x |bash -
RUN apt install nodejs
## Correccion permisos
RUN  mkdir ~/.npm-global && npm config set prefix '~/.npm-global' && export PATH=~/.npm-global/bin:$PATH && sh ~/.profile
# Rust install
# RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
COPY custom /root/.config/nvim/lua/custom
CMD ["tail", "-f", "/dev/null"]

