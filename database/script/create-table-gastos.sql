CREATE TABLE gastos (
    id INTEGER PRIMARY KEY,
    fechaRegistro DATETIME NOT NULL,
    fechaCompra DATETIME NOT NULL,
    categoria TEXT NOT NULL,
    descripcion TEXT NOT NULL,
    valor DECIMAL(10,2) NOT NULL
);
