CREATE TABLE
    IF NOT EXISTS receipts (
        id TEXT PRIMARY KEY,
        image_path TEXT NOT NULL,
        thumbnail_path TEXT,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        store_name TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        deleted_at TEXT
    );

CREATE TABLE
    IF NOT EXISTS stores (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        keywords TEXT NOT NULL,
        icon_path TEXT
    )