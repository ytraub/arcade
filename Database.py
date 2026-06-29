import sqlite3 as sql
from UserData import UserData
from datetime import date
import os

DB_NAME = "db/sqlite.db"
DEFAULT_USERS = (("Pommi", 67), ("Pidor", 69))


def add_user(name, nfc):
    conn = sql.connect(DB_NAME)
    cur = conn.cursor()

    cur.execute(
        "INSERT INTO users (username, nfc, tokens) VALUES (?, ?, ?)", (name, nfc, 100)
    )

    conn.commit()

    cur.close()
    conn.close()

def update_coins(name, coins):
    conn = sql.connect(DB_NAME)
    cur = conn.cursor()

    cur.execute(
        "UPDATE users SET tokens = ? WHERE username = ?",
        (coins, name)
    )

    conn.commit()

    cur.close()
    conn.close()

def find_user(nfc):
    conn = sql.connect(DB_NAME)
    cur = conn.cursor()

    res = cur.execute("SELECT * FROM users WHERE nfc = ?", (nfc,))

    out = res.fetchall()

    cur.close()
    conn.close()

    if not out:
        return None

    return UserData(out[0][0], out[0][1], out[0][3], out[0][2])


def is_name_taken(name):
    conn = sql.connect(DB_NAME)
    cur = conn.cursor()

    cur.execute("SELECT 1 FROM users WHERE username = ? LIMIT 1", (name,))

    exists = cur.fetchone() is not None

    cur.close()
    conn.close()

    return exists


def reset():
    conn = sql.connect(DB_NAME)
    cur = conn.cursor()

    today = date.today()

    if today.month in (1, 7) and today.day == 1:
        cur.execute("UPDATE users SET tokens = 100")
        conn.commit()

    conn.close()


def add_default_user_if_not_exists():
    for name, nfc in DEFAULT_USERS:
        if is_name_taken(name):
            continue

        add_user(name, nfc)


def init():
    os.makedirs(os.path.dirname(DB_NAME), exist_ok=True)

    with sql.connect(DB_NAME) as conn:
        conn.execute("""
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT NOT NULL UNIQUE,
                nfc TEXT NOT NULL UNIQUE,
                tokens INTEGER NOT NULL
            )
        """)

    add_default_user_if_not_exists()
