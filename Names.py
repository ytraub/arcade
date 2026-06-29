import random
from Database import *

def load_words():
    with open("words.txt", "r", encoding="utf-8") as f:
        return [line.strip() for line in f if line.strip()]

WORD_LIST = load_words()

def generate():
    name = random.choice(WORD_LIST) + random.choice(WORD_LIST)
    if not is_name_taken(name) :
        return name
