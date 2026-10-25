
function Find-TablaGastosDB {
    param (
        [string] $camino,
        [string] $scriptSQL
    )

    $tabla = Invoke-SqliteQuery `
        -DataSource $camino `
        -Query $scriptSQL `
        -ErrorAction 'Ignore'

    if (-not $tabla) {
        $tabla = Invoke-SqliteQuery -DataSource $camino -Query $scriptSQL
    }

    return $($null -ne $tabla)
}

function New-TablaGastosDB {
    param (
        [string] $camino,
        [string] $scriptSQL
    )

    return Invoke-SqliteQuery -DataSource $camino -Query $scriptSQL
}

function Add-IntoGastosDB {
    param (
        [string] $camino,
        [string] $scriptSQL,
        [datetime] $fechaCompra,
        [string] $categoriaCompra,
        [string] $descripcionCompra,
        [double] $valorCompra
    )

    return Invoke-SqliteQuery `
        -DataSource $camino `
        -Query $scriptSQL `
        -SqlParameters @{
            fechaRegistro = Get-Date
            fechaCompra = $fechaCompra
            categoria = $categoriaCompra
            descripcion = $descripcionCompra
            valor = $valorCompra
        }
}

function Find-IntoGastosDB {
    param (
        [string] $camino,
        [string] $scriptSQL,
        [psobject] $parametrosSQL
    )

    return Invoke-SqliteQuery `
        -DataSource $camino `
        -Query $scriptSQL `
        -SqlParameters $parametrosSQL
}

function Remove-IntoGastosDB {
    param (
        [string] $camino,
        [string] $scriptSQL,
        [int] $indiceRegistro
    )

    return Invoke-SqliteQuery `
        -DataSource $camino `
        -Query $scriptSQL `
        -SqlParameters @{
            id = $indiceRegistro
        }
}

function Remove-GastosDB {
    param (
        [string] $camino,
        [string] $scriptSQL,
        [switch] $EliminarArchivoDB
    )

    $tabla = Invoke-SqliteQuery `
        -DataSource $camino `
        -Query $scriptSQL `
        -ErrorAction 'Ignore'

    if ($EliminarArchivoDB) {
        if (Test-Path -Path $camino) {
            Remove-Item -Path $camino
        }
    }

    return $tabla
}

Export-ModuleMember -Function New-TablaGastosDB,
    Add-IntoGastosDB,
    Find-IntoGastosDB,
    Find-TablaGastosDB,
    Remove-IntoGastosDB,
    Remove-GastosDB
