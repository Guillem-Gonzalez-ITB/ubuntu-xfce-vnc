FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=devuser
ENV PASSWORD=devpass
RUN echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
# Actualitzar i instal·lar paquets bàsics
RUN apt-get update && apt-get install -y \
    xfce4 xfce4-goodies \
    x11vnc xvfb \
    python3 python3-pip \
    openssh-server \
    wget curl software-properties-common \
    apt-transport-https gnupg \
    && apt-get clean

# Crear usuari no root
RUN useradd -m -s /bin/bash $USER \
    && echo "$USER:$PASSWORD" | chpasswd \
    && adduser $USER sudo

# Instal·lar Visual Studio Code (repo oficial MS)
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
    && install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/ \
    && sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list' \
    && apt-get update \
    && apt-get install -y code \
    && rm -f microsoft.gpg

# Configurar SSH
RUN mkdir /var/run/sshd
RUN echo "PermitRootLogin no" >> /etc/ssh/sshd_config
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

# Configurar x11vnc (sense password per simplificar, pots afegir password si vols)
RUN mkdir -p /home/$USER/.vnc
RUN x11vnc -storepasswd $PASSWORD /home/$USER/.vnc/passwd

# Copiar script d’inici
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 5900 22

USER $USER
WORKDIR /home/$USER

CMD ["/start.sh"]