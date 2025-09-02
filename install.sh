#!/bin/bash
set -e

echo "--- Atualizando sistema ----"
sudo pacman -Syu --noconfirm

echo "==== Instalando pacotes principais ===="
sudo pacman -S --noconfirm \
  postgresql \
  docker \
  redis \
  memcached \
  gcc \
  jdk21-openjdk \
  git


echo "Instalando MongoDB 8.0 (via AUR)"
if ! command -v yay &> /dev/null; then
  echo "yay não encontrado, instalando..."
  sudo pacman -S --needed --noconfirm base-devel git
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay
  makepkg -si --noconfirm
  cd -
fi
yay -S --noconfirm mongodb-bin

echo "Instalando Redis GUI (AnotherRedisDesktopManager)"
yay -S --noconfirm another-redis-desktop-manager-bin

echo "Habilitando e iniciando serviços"
sudo systemctl enable --now postgresql
sudo systemctl enable --now docker
sudo systemctl enable --now redis
sudo systemctl enable --now memcached
sudo systemctl enable --now mongodb

echo "Adicionando usuário atual ao grupo docker"
sudo usermod -aG docker $USER

echo "Instalação concluída!"
echo ">> Hora de reiniciar para aplicar as mudanças."
