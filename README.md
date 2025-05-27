# README - Sistema de Gestión de Préstamos Deportivos

## 📝 Descripción

Este proyecto es un sistema de gestión desarrollado en Bash que permite administrar estudiantes, artículos deportivos y préstamos de estos artículos a los estudiantes. El sistema ofrece un menú interactivo para realizar todas las operaciones para cada entidad, además de gestionar los préstamos con sus respectivas validaciones.

## 🛠️ Funcionalidades principales

- **Gestión de Estudiantes**:
  - Registrar nuevos estudiantes (código, nombre, carrera)
  - Mostrar lista completa de estudiantes
- **Gestión de Artículos Deportivos**:
  - Registrar nuevos artículos (ID, nombre, cantidad disponible)
  - Mostrar inventario completo
- **Gestión de Préstamos**:
  - Realizar préstamos validando existencia y disponibilidad
  - Mostrar artículos prestados por estudiante
  - Registrar devoluciones de artículos

## 🗂️ Estructura del proyecto

```
gestion_prestamos/
├── main.sh                 # Script principal
├── README.md               # Documentación del proyecto
├── helpers.sh              # Funciones auxiliares comunes
├── data/                   # Directorio de almacenamiento
│   ├── estudiantes.txt     # Datos de estudiantes
│   ├── articulos.txt       # Datos de artículos
│   └── prestamos.txt       # Registro de préstamos
└── lib/                    # Módulos del sistema
    ├── estudiantes.sh      # Lógica de estudiantes
    ├── articulos.sh        # Lógica de artículos
    └── prestamos.sh        # Lógica de préstamos
```

## 🚀 Cómo ejecutar el sistema

### Requisitos previos
- Sistema operativo Linux o macOS
- Bash (generalmente incluido por defecto)
- Permisos de ejecución

### Pasos para ejecución

1. Clonar repositorio

2. Navegar al directorio del proyecto:
   ```bash
   cd Students-sports-Inventory/
   ```
   ```bash
   cd lib/
   ```
3. Dar permisos de ejecución:
   ```bash
   chmod +x main.sh
   ```
4. Ejecutar el sistema:
   ```bash
   ./main.sh
   ```

## 👥 Integrantes del equipo

- **Alejandro Muñoz** - Desarrollo y lógica de estudiantes
- **David Malte** - Desarrollo y lógica de artículos
- **Samuel Ibarra** - Desarrollo y lógica de préstamos

## 📌 Notas adicionales

- Los datos se guardan automáticamente en archivos de texto dentro del directorio `data/`
- El sistema incluye validaciones básicas para evitar errores
- Para contribuciones o reporte de problemas, por favor contactar a los integrantes del equipo

