-- ================================================================
-- TABLA: personajes
-- ================================================================
CREATE TABLE IF NOT EXISTS personajes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    apodo TEXT NOT NULL UNIQUE,
    tipo TEXT NOT NULL CHECK (tipo IN ('Heroe', 'Villano')),
    vida INTEGER NOT NULL,
    fuerza INTEGER NOT NULL,
    defensa INTEGER NOT NULL,
    bendiciones INTEGER DEFAULT 0,
    victorias INTEGER DEFAULT 0,
    derrotas INTEGER DEFAULT 0,
    supremos_usados INTEGER DEFAULT 0,
    armas_invocadas INTEGER DEFAULT 0
);

-- ================================================================
-- TABLA: batallas
-- ================================================================
CREATE TABLE IF NOT EXISTS batallas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    heroe_id INTEGER NOT NULL,
    villano_id INTEGER NOT NULL,
    ganador_id INTEGER NOT NULL,
    turnos INTEGER NOT NULL,
    combat_log TEXT,
    mayor_danio INTEGER,
    armas_heroe INTEGER DEFAULT 0,
    armas_villano INTEGER DEFAULT 0,
    supremos_heroe INTEGER DEFAULT 0,
    supremos_villano INTEGER DEFAULT 0,
    winrate_heroe TEXT,
    winrate_villano TEXT,
    FOREIGN KEY (heroe_id) REFERENCES personajes(id),
    FOREIGN KEY (villano_id) REFERENCES personajes(id),
    FOREIGN KEY (ganador_id) REFERENCES personajes(id)
);

-- ================================================================
-- ÍNDICES (Mejora el rendimiento)
-- ================================================================

-- Índice para búsquedas por apodo (usado frecuentemente)
CREATE INDEX IF NOT EXISTS idx_personajes_apodo ON personajes(apodo);

-- Índice para búsquedas por tipo de personaje
CREATE INDEX IF NOT EXISTS idx_personajes_tipo ON personajes(tipo);

-- Índice para ordenar por victorias (usado en ranking)
CREATE INDEX IF NOT EXISTS idx_personajes_victorias ON personajes(victorias DESC);

-- Índice para ordenar batallas por fecha
CREATE INDEX IF NOT EXISTS idx_batallas_fecha ON batallas(fecha DESC);