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

# Devolver artículo
devolver_articulo() {
    echo "=== DEVOLVER ARTÍCULO PRESTADO ==="
    read -p "Código del estudiante: " codigo_est

    if [ -z "${ESTUDIANTES[$codigo_est]}" ]; then
        echo "Error: el estudiante no está registrado."
        pause "Presione Enter para continuar..."
        return
    fi

    # Mostrar préstamos del estudiante
    prestamos=$(grep "^$codigo_est:" "$PRESTAMOS_FILE")

    if [ -z "$prestamos" ]; then
        echo "Este estudiante no tiene artículos en préstamo."
        pause "Presione Enter para continuar..."
        return
    fi

    echo "Artículos prestados:"
    echo "$prestamos" | while IFS=: read -r _ id_art; do
        if [ -n "${ARTICULOS[$id_art]}" ]; then
            IFS=: read -r nombre_art _ <<< "${ARTICULOS[$id_art]}"
            echo "  - $id_art: $nombre_art"
        else
            echo "  - $id_art: [Artículo eliminado]"
        fi
    done

    echo ""
    read -p "Ingrese el ID del artículo que desea devolver: " id_devolver

    if ! grep -q "^$codigo_est:$id_devolver$" "$PRESTAMOS_FILE"; then
        echo "Error: ese artículo no está prestado a este estudiante."
        pause "Presione Enter para continuar..."
        return
    fi

    # Eliminar préstamo (crear temporal sin esa línea)
    grep -v "^$codigo_est:$id_devolver$" "$PRESTAMOS_FILE" > "$PRESTAMOS_FILE.tmp" && mv "$PRESTAMOS_FILE.tmp" "$PRESTAMOS_FILE"

    # Aumentar inventario si el artículo sigue registrado
    if [ -n "${ARTICULOS[$id_devolver]}" ]; then
        IFS=: read -r nombre_art cantidad <<< "${ARTICULOS[$id_devolver]}"
        cantidad=$((cantidad + 1))
        ARTICULOS["$id_devolver"]="$nombre_art:$cantidad"
        guardar_articulos
    fi

    echo "Artículo devuelto con éxito."
    pause "Presione Enter para continuar..."
}



# Mostrar préstamos por id estudiante
mostrar_articulos_estudiante() {
    echo "=== ARTÍCULOS PRESTADOS A UN ESTUDIANTE ==="
    read -p "Ingrese el código del estudiante: " codigo_est

    if [ -z "${ESTUDIANTES[$codigo_est]}" ]; then
        echo "Error: el estudiante no está registrado."
        pause "Presione Enter para continuar..."
        return
    fi

    # Extraer nombre del estudiante
    IFS=: read -r nombre carrera <<< "${ESTUDIANTES[$codigo_est]}"
    echo "Estudiante: $nombre ($codigo_est)"

    prestamos=$(grep "^$codigo_est:" "$PRESTAMOS_FILE")

    if [ -z "$prestamos" ]; then
        echo "No hay artículos prestados a este estudiante."
    else
        echo ""
        echo "ID   | Nombre del artículo"
        echo "-----+----------------------"
        echo "$prestamos" | while IFS=: read -r codigo id_art; do
            if [ -n "${ARTICULOS[$id_art]}" ]; then
                IFS=: read -r nombre_art cantidad <<< "${ARTICULOS[$id_art]}"
                printf "%-4s | %s\n" "$id_art" "$nombre_art"
            else
                printf "%-4s | [Artículo eliminado]\n" "$id_art"
            fi
        done
    fi

    pause "Presione Enter para continuar..."
}

# Mostrar todos los préstamos
mostrar_prestamos() {
    echo "=== TODOS LOS PRÉSTAMOS REGISTRADOS ==="

    if [ ! -s "$PRESTAMOS_FILE" ]; then
        echo "No hay préstamos registrados."
        pause "Presione Enter para continuar..."
        return
    fi

    echo ""
    declare -A prestamos_por_estudiante

    # Agrupar préstamos por código de estudiante
    while IFS=: read -r codigo_est id_art; do
        prestamos_por_estudiante["$codigo_est"]+="$id_art "
    done < "$PRESTAMOS_FILE"

    for codigo_est in "${!prestamos_por_estudiante[@]}"; do
        IFS=: read -r nombre carrera <<< "${ESTUDIANTES[$codigo_est]}"
        echo "Estudiante: $nombre ($codigo_est)"
        echo "  Carrera: $carrera"
        echo "  Artículos prestados:"
        for id_art in ${prestamos_por_estudiante[$codigo_est]}; do
            if [ -n "${ARTICULOS[$id_art]}" ]; then
                IFS=: read -r nombre_art cantidad <<< "${ARTICULOS[$id_art]}"
                echo "    - $nombre_art (ID: $id_art)"
            else
                echo "    - [Artículo eliminado] (ID: $id_art)"
            fi
        done
        echo ""
    done

    pause "Presione Enter para continuar..."
}
