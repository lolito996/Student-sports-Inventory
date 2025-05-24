#!/bin/bash

declare -A ARTICULOS

cargar_articulos() {
    if [ -f "$ARTICULOS_FILE" ]; then
        while IFS=: read -r id nombre cantidad; do
            ARTICULOS["$id"]="$nombre:$cantidad"
        done < "$ARTICULOS_FILE"
    fi
}

guardar_articulos() {
    > "$ARTICULOS_FILE"
    for id in "${!ARTICULOS[@]}"; do
        echo "$id:${ARTICULOS[$id]}" >> "$ARTICULOS_FILE"
    done
}

registrar_articulo() {
    echo "=== REGISTRAR NUEVO ARTÍCULO DEPORTIVO ==="

    while true; do
        read -p "ID del artículo (3 dígitos): " id
        if [[ "$id" =~ ^[0-9]{3}$ ]]; then
            if [ -n "${ARTICULOS[$id]}" ]; then
                echo "Error: ya existe un artículo con ese ID."
            else
                break
            fi
        else
            echo "Error: el ID debe tener exactamente 3 dígitos numéricos (por ejemplo: 001, 123)."
        fi
    done

    read -p "Nombre del artículo: " nombre

    while true; do
        read -p "Cantidad disponible: " cantidad
        if [[ "$cantidad" =~ ^[0-9]+$ ]]; then
            break
        else
            echo "Error: la cantidad debe ser un número entero positivo."
        fi
    done

    ARTICULOS["$id"]="$nombre:$cantidad"
    echo "$id:$nombre:$cantidad" >> "$ARTICULOS_FILE"

    echo "Artículo registrado con éxito."
    pause "Presione Enter para continuar..."
}


mostrar_articulos() {
    echo "=== LISTA DE ARTÍCULOS DISPONIBLES ==="
    for id in "${!ARTICULOS[@]}"; do
        IFS=: read -r nombre cantidad <<< "${ARTICULOS[$id]}"
        printf "%-6s | %-25s | Cantidad: %s\n" "$id" "$nombre" "$cantidad"
    done
    pause "Presione Enter para continuar..."
}

buscar_articulo() {
    local id="$1"
    if [ -n "${ARTICULOS[$id]}" ]; then
        echo "${ARTICULOS[$id]}"
    else
        echo ""
    fi
}

# Cargar artículos al iniciar
cargar_articulos
