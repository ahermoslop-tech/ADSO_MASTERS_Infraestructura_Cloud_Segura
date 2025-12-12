# 📅 Avance Día 1 - Planificación y Setup VPC

**Fecha**: Enero 2025  
**Responsable**: Equipo ADSO_MASTERS  
**Estado**: ✅ Completado

---

## 🎯 Objetivos del Día

- [x] Crear repositorio GitHub con estructura completa
- [x] Documentar README principal con arquitectura y requisitos
- [x] Planificar topología de red VPC
- [ ] Iniciar configuración en Oracle Cloud Infrastructure
- [ ] Crear VPC con subredes pública y privada

---

## 🛠️ Trabajo Realizado

### 1. Repositorio GitHub

**Acción**: Creación del repositorio `ADSO_MASTERS_Infraestructura_Cloud_Segura`

- ✅ README.md completo con toda la documentación del proyecto
- ✅ Estructura de carpetas: avances/, scripts/, config/, docs/, keys/
- ✅ Descripción detallada de arquitectura VPC
- ✅ Rúbrica de evaluación (100 puntos)
- ✅ Advertencias de seguridad claramente definidas

### 2. Planificación de Arquitectura

**Red VPC Planificada**:
```
VPC: 10.0.0.0/16
├── Subred Pública (10.0.1.0/24)
│   └── Bastion Host
│       - SSH desde IP específica SOLAMENTE
│       - NO 0.0.0.0/0 en puerto 22
│       - Gateway de acceso a subred privada
├── Subred Privada (10.0.2.0/24)
│   ├── Servidor Aplicaciones
│   │   ├── Grafana (puerto 3000)
│   │   ├── n8n (puerto 5678)
│   │   └── Nginx (puertos 80/443)
│   └── Acceso: Solo desde Bastion Host
└── Internet Gateway
    └── Ruta: 0.0.0.0/0 → IGW (solo subred pública)
```

### 3. Usuarios y Permisos Planificados

| Usuario | Grupo | Permisos | Home Directory | Shell |
|---------|-------|----------|----------------|-------|
| Asier | admins, wheel | sudo, rwx en /opt/apps, /var/www | /home/asier | /bin/bash |
| Jyrer | users | read-only en /opt/apps, /var/www | /home/jyrer | /bin/bash |

**Permisos de Directorios**:
- `/opt/apps/` → 750 (owner: asier, group: admins)
- `/var/www/` → 755 (owner: asier, group: admins)
- Logs → 640 (lectura para grupo users)

### 4. Servicios a Desplegar

**Grafana**:
- Docker image: `grafana/grafana:latest`
- Puerto: 3000
- Volumen: `/opt/grafana/data`
- Variables: admin user, password

**n8n**:
- Docker image: `n8nio/n8n:latest`
- Puerto: 5678
- Volumen: `/opt/n8n/data`
- Base de datos: PostgreSQL para persistencia
- Git backup: workflows guardados en `/opt/n8n/backups`

**Nginx**:
- HTML básico de bienvenida
- Reverse proxy para Grafana/n8n
- SSL/TLS (Let's Encrypt)

---

## 🔒 Medidas de Seguridad Planificadas

### SSH
- ✅ **Solo autenticación con llaves públicas/privadas**
- ✅ **Deshabilitar password authentication**
- ✅ **Restricción IP**: Puerto 22 solo desde IP autorizada
- ✅ **Fail2ban**: Protección contra fuerza bruta

### Firewall (Security Lists OCI)
```
Subred Pública (Bastion):
  Ingress:
    - TCP 22 desde <IP_AUTORIZADA>/32 SOLAMENTE
  Egress:
    - Permitir todo hacia Internet
    - Permitir todo hacia subred privada

Subred Privada (Apps):
  Ingress:
    - TCP 22 desde subred pública (10.0.1.0/24)
    - TCP 3000 desde subred pública (Grafana)
    - TCP 5678 desde subred pública (n8n)
    - TCP 80/443 desde Internet (0.0.0.0/0) para web público
  Egress:
    - Permitir todo hacia Internet (actualizaciones)
```

### Principios Aplicados
- **Mínimo privilegio**: Usuarios solo tienen permisos necesarios
- **Defensa en profundidad**: Múltiples capas (firewall, SSH keys, grupos)
- **Segregación de red**: Bastion como único punto de entrada

---

## 📝 Próximos Pasos (Día 2)

1. **Oracle Cloud Infrastructure**:
   - Crear VPC con CIDR 10.0.0.0/16
   - Configurar subred pública 10.0.1.0/24
   - Configurar subred privada 10.0.2.0/24
   - Crear Internet Gateway
   - Configurar Route Tables
   - Definir Security Lists

2. **Bastion Host**:
   - Lanzar instancia en subred pública
   - Generar par de llaves SSH
   - Configurar SSH con llave pública
   - Restringir puerto 22 a IP específica
   - Probar conexión SSH

3. **Documentación**:
   - Capturar screenshots de configuración OCI
   - Documentar comandos utilizados
   - Actualizar avance_dia_2.md

---

## 📊 Métricas del Día

- **Tiempo invertido**: 3 horas
- **Commits realizados**: 2
- **Archivos creados**: README.md, avance_dia_1.md, estructura de carpetas
- **Progreso del proyecto**: 10%

---

## 💬 Notas y Observaciones

### Decisiones Técnicas
1. **VPC CIDR 10.0.0.0/16**: Permite hasta 65,536 IPs, suficiente para crecimiento
2. **Bastion Host obligatorio**: Cumple requisito de seguridad (NO 0.0.0.0/0 en SSH)
3. **Docker para servicios**: Facilita despliegue, portabilidad y respaldo
4. **Git backup para n8n**: Cumple requisito de persistencia y control de versiones

### Riesgos Identificados
1. ⚠️ **Capacidad OCI Free Tier**: Puede haber límites de instancias disponibles
   - **Mitigación**: Intentar en diferentes regiones/availability domains
2. ⚠️ **Complejidad SSH con Bastion**: Requiere configuración de SSH tunneling
   - **Mitigación**: Documentar claramente configuración SSH config file

### Aprendizajes
- Importancia de planificar arquitectura ANTES de implementar
- Security Lists de OCI son equivalentes a Security Groups de AWS
- Oracle Free Tier tiene limitaciones de capacidad

---

## ✅ Checklist de Requisitos

### Infraestructura VPC (20 pts)
- [x] Planificación VPC personalizada
- [ ] VPC creada en OCI
- [ ] Subredes pública y privada configuradas
- [ ] Bastion Host desplegado
- [ ] Internet Gateway funcional

### Usuarios y Permisos (20 pts)
- [x] Jerarquía de usuarios definida
- [ ] Usuarios Asier y Jyrer creados
- [ ] Grupos configurados
- [ ] Permisos chmod/chown aplicados

### Seguridad SSH (25 pts)
- [x] Planificación SSH con llaves
- [ ] Llaves SSH generadas
- [ ] Autenticación por contraseña deshabilitada
- [ ] Firewall restrictivo (NO 0.0.0.0/0 en SSH)

### Servicios (25 pts)
- [x] Servicios planificados (Grafana + n8n)
- [ ] Docker instalado
- [ ] Grafana desplegado
- [ ] n8n desplegado
- [ ] Git backup configurado

### Documentación (10 pts)
- [x] README completo
- [x] Avance día 1 documentado
- [ ] Screenshots de configuración

**Puntuación estimada actual**: 15/100 pts (planificación completa)

---

## 🔗 Referencias

- [Oracle Cloud Infrastructure Documentation](https://docs.oracle.com/en-us/iaas/Content/home.htm)
- [VPC Best Practices](https://docs.oracle.com/en-us/iaas/Content/Network/Concepts/overview.htm)
- [Bastion Host Setup](https://docs.oracle.com/en-us/iaas/Content/Compute/Tasks/accessinginstance.htm)
- [Docker Documentation](https://docs.docker.com/)
- [Grafana Docker Setup](https://grafana.com/docs/grafana/latest/setup-grafana/installation/docker/)
- [n8n Self-hosting](https://docs.n8n.io/hosting/)

---

**Firma**: Equipo ADSO_MASTERS  
**Próxima revisión**: Día 2
