import random

import Database as db

ADJECTIVES = "names/adjectives.txt"
NOUNS = "names/nouns.txt"


def load_words() -> tuple[list[str], list[str]]:
    with open(ADJECTIVES, encoding="utf-8") as f:
        adjectives = [line.strip() for line in f if line.strip()]

    with open(NOUNS, encoding="utf-8") as f:
        nouns = [line.strip() for line in f if line.strip()]

    return adjectives, nouns


adjectives, nouns = load_words()


def generate() -> str:
    while True:
        name = random.choice(adjectives) + random.choice(nouns)

        if not db.is_name_taken(name):
            return name

