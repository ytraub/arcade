from UserData import UserData
from Database import *

RECEIVE_FILE = "/home/judithfister/.lexaloffle/pico-8/carts/receive.txt"
SENDER_FILE = "send.txt"

def send_userdata(ud: UserData) :
    with open(SENDER_FILE, "w", encoding="utf-8") as f:
        f.write(f"{ud.name}:{ud.coins}\n")

def receive_userdata(ud: UserData) :
    with open(RECEIVE_FILE, "r", encoding="utf-8") as f:
        data = f.read().strip()

        try:
            name, coins = data.split(":")
            ud.name = name
            ud.coins = int(coins)
        except ValueError:
            print("Invalid data format")


def userdata_updator():
    user = UserData(-1, "", 0, "")

    while True:
        receive_userdata(user)

        if user.name:
            update_coins(user.name, user.coins)

            user.name = ""
            user.coins = 0