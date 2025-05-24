#!/bin/bash

source ../helpers.sh

# Array global para almacenar estudiantes en memoria
declare -A ESTUDIANTES

# Cargar estudiantes desde archivo
cargar_estudiantes() {
    if [ -f "$ESTUDIANTES_FILE" ]; then
        while IFS=: read -r codigo nombre carrera; do
            ESTUDIANTES["$codigo"]="$nombre:$carrera"
        done < "$ESTUDIANTES_FILE"
    fi
}

# Guardar estudiantes en archivo
guardar_estudiantes() {
    > "$ESTUDIANTES_FILE"  # Vaciar el archivo primero
    for codigo in "${!ESTUDIANTES[@]}"; do
        echo "$codigo:${ESTUDIANTES[$codigo]}" >> "$ESTUDIANTES_FILE"
    done
}

# Función para formatear la salida de un estudiante
format_estudiante() {
    local codigo="$1"
    local nombre="$2"
    local carrera="$3"
    
    printf "%-10s | %-20s | %-30s\n" "$codigo" "$nombre" "$carrera"
}

# Función para mostrar el encabezado de la tabla
show_estudiante_header() {
    printf "%-10s | %-20s | %-30s\n" "Código" "Nombre" "Carrera"
    printf "%-10s-+-%-20s-+-%-30s\n" "----------" "--------------------" "------------------------------"
}

registrar_estudiante() {
    echo "=== REGISTRAR NUEVO ESTUDIANTE ==="
    
    # Validar código (solo números)
    while true; do
        read -p "Código del estudiante (4 dígitos): " codigo
        if [[ "$codigo" =~ ^[0-9]{4}$ ]]; then
            if [ -n "${ESTUDIANTES[$codigo]}" ]; then
                echo "Error: Ya existe un estudiante con ese código."
            else
                break
            fi
        else
            echo "Error: El código debe tener 4 dígitos numéricos."
        fi
    done
    
    read -p "Nombre del estudiante: " nombre
    read -p "Carrera del estudiante: " carrera
    
    # Guardar en memoria
    ESTUDIANTES["$codigo"]="$nombre:$carrera"
    
    # Guardar en archivo
    echo "$codigo:$nombre:$carrera" >> "$ESTUDIANTES_FILE"
    
    echo "Estudiante registrado con éxito."
    pause "Presione Enter para continuar..."
}

registrar_estudiante() {
    echo "=== REGISTRAR NUEVO ESTUDIANTE ==="
    
    # Validar código (solo números)
    while true; do
        read -p "Código del estudiante (4 dígitos): " codigo
        if [[ "$codigo" =~ ^[0-9]{4}$ ]]; then
            if [ -n "${ESTUDIANTES[$codigo]}" ]; then
                echo "Error: Ya existe un estudiante con ese código."
            else
                break
            fi
        else
            echo "Error: El código debe tener 4 dígitos numéricos."
        fi
    done
    
    read -p "Nombre del estudiante: " nombre
    read -p "Carrera del estudiante: " carrera
    
    # Guardar en memoria
    ESTUDIANTES["$codigo"]="$nombre:$carrera"
    
    # Guardar en archivo con salto de línea
    if [ -s "$ESTUDIANTES_FILE" ]; then
        # Si el archivo no está vacío, añadir un salto de línea primero
        echo "" >> "$ESTUDIANTES_FILE"
    fi
    echo "$codigo:$nombre:$carrera" >> "$ESTUDIANTES_FILE"
    
    echo "Estudiante registrado con éxito."
    pause "Presione Enter para continuar..."
}

mostrar_estudiantes() {
    echo "=== LISTA DE ESTUDIANTES ==="
    
    if [ ${#ESTUDIANTES[@]} -eq 0 ]; then
        echo "No hay estudiantes registrados."
    else
        show_estudiante_header
        for codigo in "${!ESTUDIANTES[@]}"; do
            IFS=: read -r nombre carrera <<< "${ESTUDIANTES[$codigo]}"
            format_estudiante "$codigo" "$nombre" "$carrera"
        done | sort -n  # Ordenar por código numérico
    fi
    
    pause "Presione Enter para continuar..."
}

buscar_estudiante() {
    local codigo="$1"
    if [ -n "${ESTUDIANTES[$codigo]}" ]; then
        IFS=: read -r nombre carrera <<< "${ESTUDIANTES[$codigo]}"
        echo "$codigo:$nombre:$carrera"
    else
        echo ""
    fi
}

# Cargar estudiantes al importar el módulo
cargar_estudiantes