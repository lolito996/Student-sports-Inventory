#!/bin/bash

# Configuración de directorios y archivos
DATA_DIR="data"
ESTUDIANTES_FILE="$DATA_DIR/estudiantes.txt"
ARTICULOS_FILE="$DATA_DIR/articulos.txt"
PRESTAMOS_FILE="$DATA_DIR/prestamos.txt"

# Crear estructura de directorios si no existe
initialize_files() {
    mkdir -p "$DATA_DIR"
    touch "$ESTUDIANTES_FILE" "$ARTICULOS_FILE" "$PRESTAMOS_FILE"
}

# Mostrar mensaje y esperar entrada
pause() {
    read -p "$1"
}

# Validar si un valor existe en un archivo
value_exists() {
    local file="$1"
    local field_num="$2"
    local value="$3"
    
    cut -d: -f"$field_num" "$file" | grep -q "^$value$"
    return $?
}

# Obtener línea por campo
get_line_by_field() {
    local file="$1"
    local field_num="$2"
    local value="$3"
    
    grep "^[^:]*:$value:" "$file" | head -n 1
}