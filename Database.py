import sqlite3 as sql
from UserData import UserData
from datetime import date

DB_NAME = "test.db"

def add_user(name, nfc) :
    conn = sql.connect(DB_NAME)
    cur = conn.cursor()

    cur.execute(
        'INSERT INTO users (username, nfc, tokens) VALUES (?, ?, ?)',
        (name, nfc, 100)
    )

    conn.commit()

    cur.close()
    conn.close()

def find_user(nfc) :
    conn = sql.connect(DB_NAME)
    cur = conn.cursor()

    res = cur.execute(
        'SELECT * FROM users WHERE nfc = ?',
        (nfc,)
    )

    out = res.fetchall()

    cur.close()
    conn.close()

    if not out:
        return None

    return UserData(out[0][0], out[0][1], out[0][3], out[0][2])

def is_name_taken(name) :
    conn = sql.connect(DB_NAME)
    cur = conn.cursor()

    cur.execute("SELECT 1 FROM users WHERE username = ? LIMIT 1", (name,))

    exists = cur.fetchone() is not None

    cur.close()
    conn.close()

    return exists

def reset_db() :
    conn = sql.connect(DB_NAME)
    cur = conn.cursor()

    today = date.today()

    if today.month in (1, 7) and today.day == 1:
        cur.execute("UPDATE users SET tokens = 100")
        conn.commit()

    conn.close()

