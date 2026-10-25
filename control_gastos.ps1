# La ruta raiz del proyecto
$RootDirectory = Resolve-Path -Path $PSScriptRoot

# La ruta de los scripts de Powershell
$ModulesDirectory = "$RootDirectory/source"

# Impoartación de los scripts de PowerShell
Import-Module `
    -Global `
    -Name "$ModulesDirectory/database.psm1" `
    -Function New-TablaGastosDB,
        Add-IntoGastosDB,
        Find-IntoGastosDB,
        Find-TablaGastosDB,
        Remove-GastosDB,
        Remove-IntoGastosDB

# La ruta del archivo de DB
$base = "$RootDirectory/database/data/gastos.db"

# Los archivos que manipulan la tabla misma
# Los scripts de SQL
$archivoSQLNuevoTablaGastos = "$RootDirectory/database/script/create-table-gastos.sql"
$archivoSQLSeleccionarTablaGastos = "$RootDirectory/database/script/select-table-gastos.sql"
$archivoSQLEliminarTablaGastos = "$RootDirectory/database/script/Delete-table-gastos.sql"
# El contenido de los archivos mediante SQL
$scriptCrearTablaGastos = Get-Content -Path $archivoSQLNuevoTablaGastos -Raw
$scriptSeleccionarTablaGastos = Get-Content -Path $archivoSQLSeleccionarTablaGastos -Raw
$scriptEliminarTablaGastos = Get-Content -Path $archivoSQLEliminarTablaGastos -Raw

# Los archivos que manipulan dentro de la tabla
# Los scripts de SQL
$archivoSQLInserirEnTablaGastos = "$RootDirectory/database/script/insert-into-table-gastos.sql"
$archivoSQLSeleccionarEnTablaGastos = "$RootDirectory/database/script/select-into-table-gastos.sql"
$archivoSQLEliminarEnTablaGastos = "$RootDirectory/database/script/Delete-into-table-gastos.sql"
# El contenido de los archivos mediante SQL
$scriptInserirEnTablaGastos = Get-Content -Path $archivoSQLInserirEnTablaGastos -Raw
$scriptSeleccionarEnTablaGastos = Get-Content -Path $archivoSQLSeleccionarEnTablaGastos -Raw
$scriptEliminarEnTablaGastos = Get-Content -Path $archivoSQLEliminarEnTablaGastos -Raw

# Comprobar si la tabla existe
$ResultadoSeleccionarTablaGastos = Find-TablaGastosDB `
    -camino $base `
    -scriptSQL $scriptSeleccionarTablaGastos

# wait-debugger
# Si la tabla no existe
if (-not $ResultadoSeleccionarTablaGastos) {
    # Crear la base de datos
    New-TablaGastosDB `
        -camino $base `
        -scriptSQL $scriptCrearTablaGastos
}

# Datos para añadir en la tabla
$fechaCompra = Get-Date -Date '24/10/2026'
$categoriaCompra = 'Curso'
$descripcionCompra = 'Global Career Summit - November 2026'
$valorCompra = 25.90

# Añadir el registro en la tabla
Add-IntoGastosDB `
    -camino $base `
    -scriptSQL $scriptInserirEnTablaGastos `
    -fechaCompra $fechaCompra `
    -categoriaCompra $categoriaCompra `
    -descripcionCompra $descripcionCompra `
    -valorCompra $valorCompra

# Datos para la búsqueda de registro en la tabla
# $parametrosSQL = @{
#     fechaCompra = Get-Date -Date '24/10/2026'
# }

# La búsqueda de registro en la tabla
# $ResultadoSeleccionarEnTablaGastos = Find-IntoGastosDB `
#     -camino $base `
#     -scriptSQL $scriptSeleccionarEnTablaGastos `
#     -parametrosSQL $parametrosSQL 

# Eliminar un registro en la tabla
# Remove-IntoGastosDB `
#     -camino $base `
#     -scriptSQL $scriptEliminarEnTablaGastos `
#     -indiceRegistro 1 

# Eliminar la tabla misma
# Remove-GastosDB `
#     -camino $base `
#     -scriptSQL $scriptEliminarTablaGastos `
#     -EliminarArchivoDB
