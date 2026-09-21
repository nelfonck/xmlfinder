@echo off
title Actualizador Automatizado

:: 1. Entrar a la carpeta donde está el repositorio Git
cd app

:: 2. Intentar actualizar desde el repositorio de forma silenciosa
echo Buscando actualizaciones en el servidor...
git fetch origin main >nul 2>&1

:: Verificar si hay cambios pendientes por descargar
git status -uno | findstr /C:"behind" >nul
if %errorlevel% equ 0 (
    echo Descargando nueva version...
    git pull origin main
    echo Aplicacion actualizada con exito.
) else (
    echo Ya tienes la ultima version instalada.
)

:: 3. Lanzar la aplicación de Flutter en segundo plano
echo Iniciando aplicacion...
start "" "comprassj.exe"

:: 4. Cerrar la ventana negra de la consola inmediatamente
exit