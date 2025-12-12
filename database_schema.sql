-- ================================================================
-- SCRIPT SQL - EXAMEN FINAL INTERFAZ GRÁFICA
-- Base de Datos: SQLite
-- Proyecto: Sistema de Batallas Héroe vs Villano
-- ================================================================

-- ================================================================
-- TABLA: personajes
-- Descripción: Almacena información de todos los personajes
--              (Héroes y Villanos) con sus estadísticas
-- ================================================================
CREATE TABLE IF NOT EXISTS personajes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    apodo TEXT UNIQUE NOT NULL,
    tipo TEXT NOT NULL CHECK(tipo IN ('Heroe', 'Villano')),
    vida_final INTEGER DEFAULT 100,
    victorias INTEGER DEFAULT 0,
    derrotas INTEGER DEFAULT 0,
    supremos_usados INTEGER DEFAULT 0,
    armas_invocadas INTEGER DEFAULT 0
);

-- ================================================================
-- TABLA: batallas
-- Descripción: Almacena el historial de todas las batallas
--              realizadas entre héroes y villanos
-- ================================================================
CREATE TABLE IF NOT EXISTS batallas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    heroe_id INTEGER NOT NULL,
    villano_id INTEGER NOT NULL,
    ganador_id INTEGER NOT NULL,
    turnos INTEGER NOT NULL,
    FOREIGN KEY (heroe_id) REFERENCES personajes(id) ON DELETE CASCADE,
    FOREIGN KEY (villano_id) REFERENCES personajes(id) ON DELETE CASCADE,
    FOREIGN KEY (ganador_id) REFERENCES personajes(id) ON DELETE CASCADE
);

-- ================================================================
-- ÍNDICES (Opcional - Mejora el rendimiento)
-- ================================================================

-- Índice para búsquedas por apodo (usado frecuentemente)
CREATE INDEX IF NOT EXISTS idx_personajes_apodo ON personajes(apodo);

-- Índice para búsquedas por tipo de personaje
CREATE INDEX IF NOT EXISTS idx_personajes_tipo ON personajes(tipo);

-- Índice para ordenar por victorias (usado en ranking)
CREATE INDEX IF NOT EXISTS idx_personajes_victorias ON personajes(victorias DESC);

-- Índice para ordenar batallas por fecha
CREATE INDEX IF NOT EXISTS idx_batallas_fecha ON batallas(fecha DESC);

-- ================================================================
-- DATOS DE EJEMPLO (Opcional - Para testing)
-- ================================================================

-- Insertar personajes de ejemplo
INSERT OR IGNORE INTO personajes (nombre, apodo, tipo, vida_final, victorias, derrotas, supremos_usados, armas_invocadas)
VALUES 
    ('Superman', 'El Hombre de Acero', 'Heroe', 100, 0, 0, 0, 0),
    ('Batman', 'El Caballero Oscuro', 'Heroe', 100, 0, 0, 0, 0),
    ('Wonder Woman', 'La Princesa Amazona', 'Heroe', 100, 0, 0, 0, 0),
    ('Lex Luthor', 'El Genio del Mal', 'Villano', 100, 0, 0, 0, 0),
    ('Joker', 'El Payaso del Crimen', 'Villano', 100, 0, 0, 0, 0),
    ('Harley Quinn', 'La Reina del Caos', 'Villano', 100, 0, 0, 0, 0);

-- ================================================================
-- CONSULTAS ÚTILES (Para verificación)
-- ================================================================

-- Ver todos los personajes
-- SELECT * FROM personajes;

-- Ver ranking de personajes por victorias
-- SELECT nombre, apodo, tipo, victorias, derrotas 
-- FROM personajes 
-- ORDER BY victorias DESC;

-- Ver historial de batallas (últimas 10)
-- SELECT 
--     b.id,
--     b.fecha,
--     h.nombre AS heroe,
--     v.nombre AS villano,
--     g.nombre AS ganador,
--     b.turnos
-- FROM batallas b
-- JOIN personajes h ON b.heroe_id = h.id
-- JOIN personajes v ON b.villano_id = v.id
-- JOIN personajes g ON b.ganador_id = g.id
-- ORDER BY b.fecha DESC
-- LIMIT 10;

-- Ver estadísticas generales
-- SELECT 
--     COUNT(*) as total_batallas,
--     AVG(turnos) as promedio_turnos,
--     MAX(turnos) as batalla_mas_larga,
--     MIN(turnos) as batalla_mas_corta
-- FROM batallas;

-- ================================================================
-- NOTAS DE IMPLEMENTACIÓN
-- ================================================================

-- 1. La base de datos se crea automáticamente en:
--    src/main/java/batalla/database/BDjuego.db

-- 2. La conexión se maneja a través de:
--    batalla.Conexion.ConexionSQLite.java

-- 3. Las operaciones CRUD se realizan mediante:
--    - batalla.Conexion.PersonajeDAO.java
--    - batalla.Conexion.BatallaDAO.java

-- 4. La aplicación usa try-with-resources para manejo seguro
--    de conexiones y cierre automático de recursos

-- 5. Todas las operaciones incluyen manejo de excepciones
--    SQLException con mensajes de error claros

-- ================================================================
-- FIN DEL SCRIPT
-- ================================================================
