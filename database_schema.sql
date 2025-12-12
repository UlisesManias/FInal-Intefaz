-- Verificar si no existe el DataBase, en caso de no existir lo creará.
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'BatallaDB')
BEGIN
    CREATE DATABASE BatallaDB;
END
GO
-- Usar BatallaDB en vez de master.
USE BatallaDB;
GO
-- Verificar si no existe la tabla 'personajes', en caso de no existir entonces la creará.
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'personajes')
BEGIN
    CREATE TABLE personajes (
        id INT IDENTITY(1,1) PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        apodo VARCHAR(100) NOT NULL UNIQUE,
        tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('Heroe', 'Villano')),
        vida_final INT NOT NULL DEFAULT 0,
        victorias INT NOT NULL DEFAULT 0,
        derrotas INT NOT NULL DEFAULT 0,
        supremos_usados INT NOT NULL DEFAULT 0,
        armas_invocadas INT NOT NULL DEFAULT 0
    );
END
GO
-- Tabla 'batallas'
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'batallas')
BEGIN
    CREATE TABLE batallas (
        id INT IDENTITY(1,1) PRIMARY KEY,
        fecha DATETIME NOT NULL DEFAULT GETDATE(),
        heroe_id INT NOT NULL,
        villano_id INT NOT NULL,
        ganador_id INT NOT NULL,
        turnos INT NOT NULL,

        FOREIGN KEY (heroe_id) REFERENCES personajes(id),
        FOREIGN KEY (villano_id) REFERENCES personajes(id),
        FOREIGN KEY (ganador_id) REFERENCES personajes(id)
    );
END
GO
-- Tabla 'eventos_batalla'
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'eventos_batalla')
BEGIN
    CREATE TABLE eventos_batalla (
        id INT IDENTITY(1,1) PRIMARY KEY,
        batalla_id INT NOT NULL,
        turno INT NOT NULL,
        descripcion VARCHAR(255) NOT NULL,

        FOREIGN KEY (batalla_id) REFERENCES batallas(id)
    );
END
GO

-- Consultas

-- Ranking
SELECT nombre, apodo, victorias, derrotas
FROM personajes
ORDER BY victorias DESC;

-- Historial
SELECT TOP 10 
    b.id,
    b.fecha,
    h.nombre AS heroe,
    v.nombre AS villano,
    g.nombre AS ganador,
    b.turnos
FROM batallas b
JOIN personajes h ON b.heroe_id = h.id
JOIN personajes v ON b.villano_id = v.id
JOIN personajes g ON b.ganador_id = g.id
ORDER BY b.fecha DESC;
