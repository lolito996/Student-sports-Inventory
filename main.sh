#!/bin/bash

# Importar helpers y módulos
source setup.sh
source lib/estudiantes.sh
source lib/articulos.sh
source lib/prestamos.sh

# Inicializar archivos
initialize_files

# Función para mostrar el menú principal
mostrar_menu() {
    clear
    echo "===================================="
    echo "  SISTEMA DE GESTIÓN DE PRÉSTAMOS    "
    echo "===================================="
    echo "1. Registrar nuevo estudiante"
    echo "2. Registrar nuevo artículo deportivo"
    echo "3. Realizar préstamo de artículo"
    echo "4. Mostrar artículos prestados por estudiante"
    echo "5. Devolver artículo"
    echo "6. Mostrar todos los estudiantes"
    echo "7. Mostrar todos los artículos"
    echo "8. Mostrar todos los préstamos"
    echo "9. Salir"
    echo "===================================="
    echo -n "Seleccione una opción: "
}

# Bucle principal del programa
while true; do
    mostrar_menu
    read opcion
    
    case $opcion in
        1) registrar_estudiante ;;
        2) registrar_articulo ;;
        3) realizar_prestamo ;;
        4) mostrar_articulos_estudiante ;;
        5) devolver_articulo ;;
        6) mostrar_estudiantes ;;
        7) mostrar_articulos ;;
        8) mostrar_prestamos ;;
        9) echo "Saliendo del sistema..."; exit 0 ;;
        *) echo "Opción no válida. Intente nuevamente." ;;
    esac
done