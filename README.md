# ubuntu-xfce-vnc

Imatge Docker basada en Ubuntu 24.04 amb entorn gràfic XFCE, servidor VNC, Visual Studio Code, Python i SSH.

---

## Construir la imatge

```bash
docker build -t elmeuusuari/ubuntu-xfce-vnc .
docker run -d -p 5900:5900 -p 2223:22 --name xfce_vnc --user root ubuntu-xfce-vnc