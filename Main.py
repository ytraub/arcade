import Names as names
import Database as db
import NFCReader as nfc

# Title screen
# / check if home button pressed -> default user (1337/pommi) -> show menu
# / if nfc login -> load/register user -> show menu

def main() -> None:
    db.init()

    uid = nfc.read()
    user = db.find_user(uid)

    if user is None:
        db.add_user(names.generate(), uid)
        user = db.find_user(uid)

    print("Name: " + user.name + "\nUID: " + user.uid + "\nCoins: " + str(user.coins)) # type: ignore

# Show Games View

if __name__ == "__main__":
    main()