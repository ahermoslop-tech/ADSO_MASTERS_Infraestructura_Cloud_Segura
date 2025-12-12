# 🔐 ADSO_MASTERS - Infraestructura Cloud Segura 2026

## 📋 Descripción del Proyecto

Proyecto ADSO 2025-2026: Infraestructura Cloud Segura con VPC, Bastion Host, Grafana, n8n y gestión avanzada de usuarios. CI.Estella

### 🎯 Objetivos
- Implementar VPC personalizada en Oracle Cloud Infrastructure
- Configurar Bastion Host y acceso seguro SSH con llaves
- Gestionar usuarios con permisos diferenciados (Asier: admin, Jyrer: read-only)
- Desplegar servicios: Grafana + n8n con persistencia y respaldo Git
- Aplicar seguridad restrictiva (NO 0.0.0.0/0 en SSH)
- Documentación diaria obligatoria

---

## 🏗️ Arquitectura de Red

### Topología VPC
```
VPC: 10.0.0.0/16
├── Subred Pública (10.0.1.0/24)
│   └── Bastion Host (SSH desde IP específica)
├── Subred Privada (10.0.2.0/24)
│   ├── Servidor Aplicaciones (Grafana + n8n)
│   └── Acceso solo desde Bastion
└── Internet Gateway
```

### Componentes de Seguridad
- **Bastion Host**: Punto único de acceso SSH
- **Security Lists**: Reglas restrictivas por subred
- **SSH Keys Only**: Sin contraseñas (autenticación por llave)
- **Firewall**: Puerto 22 solo desde IP autorizada

---

## 👥 Gestión de Usuarios

| Usuario | Grupo | Permisos | SSH |
|---------|-------|----------|-----|
| Asier | admins | Lectura/Escritura, sudo | ✅ |
| Jyrer | users | Solo lectura | ✅ |

### Configuración
```bash
# Grupos y permisos aplicados con chmod/chown
# Directorios con permisos 750/755 (NO 777)
# SSH configurado con llaves públicas/privadas
```

---

## 🛠️ Servicios Desplegados

### Grafana
- **Puerto**: 3000
- **Persistencia**: Volumen Docker
- **Acceso**: Navegador web externo

### n8n (Automatización)
- **Puerto**: 5678
- **Respaldo**: Git automático de workflows
- **Persistencia**: Base de datos PostgreSQL

### Servidor Web
- **Nginx**: HTML básico accesible externamente
- **Puerto**: 80/443

---

## 📁 Estructura del Repositorio

```
ADSO_MASTERS_Infraestructura_Cloud_Segura/
├── README.md
├── avances/
│   ├── avance_dia_1.md
│   ├── avance_dia_2.md
│   └── ...
├── scripts/
│   ├── setup_vpc.sh
│   ├── configure_users.sh
│   ├── deploy_services.sh
│   └── backup.sh
├── config/
│   ├── security_lists.json
│   ├── ssh_config
│   ├── grafana/
│   └── n8n/
├── docs/
│   ├── arquitectura.md
│   ├── usuarios.md
│   └── seguridad.md
└── keys/
    └── README.md (instrucciones, NO subir llaves privadas)
```

---

## 🚀 Guía de Implementación

### 1. Preparación OCI
```bash
# Crear VPC y subredes
# Configurar Internet Gateway y Route Tables
# Definir Security Lists restrictivas
```

### 2. Despliegue Bastion
```bash
# Instancia en subred pública
# Configurar SSH con llave
# Restringir acceso a IP específica
```

### 3. Servidor Aplicaciones
```bash
# Instancia en subred privada
# Instalar Docker y docker-compose
# Desplegar Grafana + n8n
```

### 4. Usuarios y Permisos
```bash
# Crear usuarios Asier (admin) y Jyrer (read-only)
# Configurar grupos y permisos
# Generar llaves SSH
```

---

## 📊 Rúbrica de Evaluación (100 pts)

- **Infraestructura VPC** (20 pts): VPC personalizada, subredes, Bastion Host
- **Usuarios y Permisos** (20 pts): Jerarquía clara, chmod/chown correcto
- **Seguridad SSH** (25 pts): Solo llaves, sin contraseñas, firewall restrictivo
- **Servicios** (25 pts): Grafana + n8n con Git + persistencia
- **Documentación** (10 pts): README completo, avances diarios

**Nota mínima**: 60 pts

---

## 📝 Avances Diarios

Ver carpeta [avances/](./avances/) para el progreso día a día.

---

## 🎥 Video Grupal

Video de 5-7 minutos con todos los miembros del equipo demostrando:
- Arquitectura implementada
- Acceso SSH seguro
- Servicios funcionando
- Gestión de usuarios

---

## ⚠️ Advertencias de Seguridad

> 🚫 **NUNCA** permitir 0.0.0.0/0 en el puerto 22 SSH
> 
> 🚫 **NUNCA** usar permisos 777
> 
> 🚫 **NUNCA** subir llaves privadas al repositorio
> 
> ✅ **SIEMPRE** usar SSH con llaves
> 
> ✅ **SIEMPRE** aplicar principio de mínimo privilegio

---

## 👨‍💻 Equipo ADSO_MASTERS

- **Asier** (Administrador)
- **Jyrer** (Usuario)

---

## 📅 Cronograma

- **Día 1**: Planificación y setup VPC
- **Día 2**: Bastion Host y seguridad SSH
- **Día 3**: Servidor aplicaciones y Docker
- **Día 4**: Deploy Grafana + n8n
- **Día 5**: Usuarios y permisos finales
- **Día 6**: Testing y documentación
- **Día 7**: Video grupal y entrega

---

## 📞 Contacto

Repositorio: [ADSO_MASTERS_Infraestructura_Cloud_Segura](https://github.com/ahermoslop-tech/ADSO_MASTERS_Infraestructura_Cloud_Segura)

---

**Fecha inicio**: Enero 2025  
**CI**: Estella  
**Curso**: ADSO 2025-2026
