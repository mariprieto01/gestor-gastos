import os
import sqlite3

from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel

DB_PATH = os.getenv("DB_PATH", "data/gastos.db")
CATEGORIAS = ["Comida", "Transporte", "Ocio", "Servicios", "Otros"]

app = FastAPI(title="Gestor de Gastos")


def init_db():
    os.makedirs(os.path.dirname(DB_PATH), exist_ok=True)
    with sqlite3.connect(DB_PATH) as con:
        con.execute(
            """
            CREATE TABLE IF NOT EXISTS gastos (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                descripcion TEXT NOT NULL,
                monto REAL NOT NULL,
                categoria TEXT NOT NULL,
                fecha TEXT NOT NULL DEFAULT (datetime('now'))
            )
            """
        )


init_db()


class GastoIn(BaseModel):
    descripcion: str
    monto: float
    categoria: str


@app.get("/healthz")
def healthz():
    return {"status": "ok"}


@app.get("/api/categorias")
def categorias():
    return CATEGORIAS


@app.get("/api/gastos")
def listar_gastos():
    with sqlite3.connect(DB_PATH) as con:
        con.row_factory = sqlite3.Row
        rows = con.execute("SELECT * FROM gastos ORDER BY id DESC").fetchall()
        return [dict(r) for r in rows]


@app.post("/api/gastos")
def crear_gasto(gasto: GastoIn):
    with sqlite3.connect(DB_PATH) as con:
        cur = con.execute(
            "INSERT INTO gastos (descripcion, monto, categoria) VALUES (?, ?, ?)",
            (gasto.descripcion, gasto.monto, gasto.categoria),
        )
        return {"id": cur.lastrowid, **gasto.model_dump()}


# Sirve el frontend estático (index.html) en la raíz.
# Se declara al final para que no tape las rutas /api y /healthz.
app.mount("/", StaticFiles(directory="static", html=True), name="static")
