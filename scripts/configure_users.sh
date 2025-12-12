#!/bin/bash
# Script para configurar usuarios Asier (admin) y Jyrer (read-only)
# ADSO_MASTERS - Infraestructura Cloud Segura 2026

set -e

echo "=================================="
echo "Configuración de Usuarios ADSO"
echo "=================================="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar que se ejecuta como root
if [ "$EUID" -ne 0 ]; then 
  echo -e "${RED}ERROR: Este script debe ejecutarse como root${NC}"
  exit 1
fi

# Crear grupos
echo -e "${YELLOW}Creando grupos...${NC}"
if ! getent group admins > /dev/null 2>&1; then
    groupadd admins
    echo -e "${GREEN}Grupo 'admins' creado${NC}"
else
    echo "Grupo 'admins' ya existe"
fi

if ! getent group users > /dev/null 2>&1; then
    groupadd users
    echo -e "${GREEN}Grupo 'users' creado${NC}"
else
    echo "Grupo 'users' ya existe"
fi

# Crear usuario Asier (administrador)
echo -e "\n${YELLOW}Configurando usuario Asier (Administrador)...${NC}"
if ! id "asier" &>/dev/null; then
    useradd -m -s /bin/bash -G admins,wheel asier
    echo -e "${GREEN}Usuario 'asier' creado${NC}"
    
    # Deshabilitar password login para asier
    passwd -l asier
    echo -e "${GREEN}Password login deshabilitado para asier (solo SSH key)${NC}"
else
    echo "Usuario 'asier' ya existe"
    usermod -aG admins,wheel asier
fi

# Crear usuario Jyrer (read-only)
echo -e "\n${YELLOW}Configurando usuario Jyrer (Read-only)...${NC}"
if ! id "jyrer" &>/dev/null; then
    useradd -m -s /bin/bash -G users jyrer
    echo -e "${GREEN}Usuario 'jyrer' creado${NC}"
    
    # Deshabilitar password login para jyrer
    passwd -l jyrer
    echo -e "${GREEN}Password login deshabilitado para jyrer (solo SSH key)${NC}"
else
    echo "Usuario 'jyrer' ya existe"
    usermod -aG users jyrer
fi

# Crear directorios de trabajo
echo -e "\n${YELLOW}Configurando directorios de trabajo...${NC}"
mkdir -p /opt/apps
mkdir -p /var/www/html

# Configurar permisos
echo -e "\n${YELLOW}Aplicando permisos...${NC}"

# /opt/apps - Asier admin puede escribir, Jyrer solo leer
chown -R asier:admins /opt/apps
chmod 750 /opt/apps
echo -e "${GREEN}/opt/apps -> owner:asier group:admins perms:750${NC}"

# /var/www - Asier admin puede escribir, Jyrer solo leer
chown -R asier:admins /var/www
chmod 755 /var/www
echo -e "${GREEN}/var/www -> owner:asier group:admins perms:755${NC}"

# Configurar sudoers para Asier
echo -e "\n${YELLOW}Configurando sudo para Asier...${NC}"
if ! grep -q "asier ALL=(ALL) ALL" /etc/sudoers; then
    echo "asier ALL=(ALL) ALL" >> /etc/sudoers
    echo -e "${GREEN}Sudo habilitado para asier${NC}"
else
    echo "Sudo ya configurado para asier"
fi

# Crear directorios .ssh para ambos usuarios
echo -e "\n${YELLOW}Preparando directorios SSH...${NC}"
for user in asier jyrer; do
    mkdir -p /home/$user/.ssh
    touch /home/$user/.ssh/authorized_keys
    chmod 700 /home/$user/.ssh
    chmod 600 /home/$user/.ssh/authorized_keys
    chown -R $user:$user /home/$user/.ssh
    echo -e "${GREEN}Directorio SSH configurado para $user${NC}"
done

# Configurar SSH para deshabilitar password authentication
echo -e "\n${YELLOW}Configurando SSH (solo llaves, sin passwords)...${NC}"
if [ -f /etc/ssh/sshd_config ]; then
    # Backup del archivo original
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
    
    # Deshabilitar password authentication
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    
    # Habilitar solo public key authentication
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
    
    echo -e "${GREEN}SSH configurado para usar solo llaves${NC}"
    echo -e "${YELLOW}IMPORTANTE: Reiniciar sshd con 'systemctl restart sshd'${NC}"
fi

# Mostrar resumen
echo -e "\n=================================="
echo -e "${GREEN}Configuración completada${NC}"
echo -e "=================================="
echo -e "\nUsuarios creados:"
echo -e "  - ${GREEN}asier${NC} (Administrador, grupo: admins, wheel)"
echo -e "  - ${GREEN}jyrer${NC} (Read-only, grupo: users)"
echo -e "\nPermisos aplicados:"
echo -e "  - /opt/apps: 750 (asier:admins)"
echo -e "  - /var/www: 755 (asier:admins)"
echo -e "\nSeguridad SSH:"
echo -e "  - ✅ Password authentication DESHABILITADO"
echo -e "  - ✅ Solo autenticación con llaves SSH"
echo -e "\nPróximos pasos:"
echo -e "  1. Copiar llaves públicas SSH a /home/{asier,jyrer}/.ssh/authorized_keys"
echo -e "  2. Reiniciar SSH: ${YELLOW}systemctl restart sshd${NC}"
echo -e "  3. Probar conexión SSH con llaves"
echo -e "\n=================================="
