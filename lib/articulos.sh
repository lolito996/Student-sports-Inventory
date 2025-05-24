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
    read -p "ID del artículo: " id

    if [ -n "${ARTICULOS[$id]}" ]; then
        echo "Error: ya existe un artículo con ese ID."
        pause "Presione Enter para continuar..."
        return
    fi

    read -p "Nombre del artículo: " nombre
    read -p "Cantidad disponible: " cantidad

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
