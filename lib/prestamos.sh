#!/bin/bash

realizar_prestamo() {
    echo "=== REALIZAR PRÉSTAMO DE ARTÍCULO ==="
    read -p "Código del estudiante: " codigo_est

    if [ -z "${ESTUDIANTES[$codigo_est]}" ]; then
        echo "Error: estudiante no registrado."
        pause "Presione Enter para continuar..."
        return
    fi

    read -p "ID del artículo: " id_art
    if [ -z "${ARTICULOS[$id_art]}" ]; then
        echo "Error: artículo no registrado."
        pause "Presione Enter para continuar..."
        return
    fi

    IFS=: read -r nombre_art cantidad <<< "${ARTICULOS[$id_art]}"

    if [ "$cantidad" -le 0 ]; then
        echo "Error: no hay unidades disponibles de '$nombre_art'."
        pause "Presione Enter para continuar..."
        return
    fi

    # Registrar préstamo
    echo "$codigo_est:$id_art" >> "$PRESTAMOS_FILE"
    # Actualizar inventario
    cantidad=$((cantidad - 1))
    ARTICULOS["$id_art"]="$nombre_art:$cantidad"
    guardar_articulos

    echo "Préstamo registrado: $nombre_art para $codigo_est"
    pause "Presione Enter para continuar..."
}
