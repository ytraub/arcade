from NFCReader import *
from NameGen import *
from Database import *

# Title screen
# / check if home button pressed -> default user (1337/pommi) -> show menu
# / if nfc login -> load/register user -> show menu

uid = read_nfc()
user = find_user(uid)

if user is None:
    add_user(generate_name(), uid)
    user = find_user(uid)

print("Name: " + user.name + "\nUID: " + user.uid + "\nCoins: " + str(user.coins))

# Show Games View
