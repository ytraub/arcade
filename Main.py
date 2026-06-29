import os
import signal
import subprocess
import random

from textual.app import App, ComposeResult, RenderResult
from textual.containers import Container
from textual.events import Key
from textual.widget import Widget
from textual.widgets import Label, ListItem, ListView
from textual import work

import Names as names
import Database as db
import NFCReader as nfc

from UserData import UserData

P = None

COLORS = [
    "#00005f",
    "#0000af",
    "#0000ff",
    "#0087ff",
    "#00d7ff",
    "#00ffff",
    "#00ff87",
    "#00ff00",
    "#87ff00",
    "#d7ff00",
    "#ffff00",
    "#ffaf00",
    "#ff5f00",
    "#ff0000",
    "#d700af",
    "#8700af",
]


class Title(Widget):
    def render(self) -> RenderResult:
        return r"""
                            _
    /\                     | |
   /  \   _ __ ___ __ _  __| | ___
  / /\ \ | '__/ __/ _` |/ _` |/ _ \
 / ____ \| | | (_| (_| | (_| |  __/
/_/    \_\_|  \___\__,_|\__,_|\___|
"""


class GameListItem(ListItem):
    def __init__(self, label: str) -> None:
        super().__init__()
        self.label_text = label
        self.label_widget = Label(label)

    def compose(self) -> ComposeResult:
        yield self.label_widget

    def set_highlighted(self, state: bool) -> None:
        if state:
            self.label_widget.update("➤  " + self.label_text)
        else:
            self.label_widget.update(self.label_text)


class GameList(Widget):
    def compose(self) -> ComposeResult:
        self.list_view = ListView(
            GameListItem("Hello"),
            GameListItem("Hello"),
            GameListItem("Hello"),
            GameListItem("Hello"),
            GameListItem("Hello"),
        )
        yield self.list_view

    def on_list_view_highlighted(self, event: ListView.Highlighted) -> None:
        for item in self.list_view.children:
            item.set_highlighted(False)  # type: ignore
            item.remove_class("highlighted-item")

        if event.item:
            event.item.set_highlighted(True)  # type: ignore
            event.item.add_class("highlighted-item")

    def on_list_view_selected(self, event: ListView.Selected) -> None:
        global P

        if event.item:
            if P is not None and P.poll() is None:
                os.killpg(os.getpgid(P.pid), signal.SIGTERM)

            P = subprocess.Popen(
                "pico8_dyn",
                stdout=subprocess.PIPE,
                shell=True,
                preexec_fn=os.setsid,
            )


class Splash(Container):
    def __init__(self):
        super().__init__()

        self.login_complete = False

        self.player1 = None
        self.player2 = None

        self.login_stage = 1

    def on_mount(self) -> None:
        self.styles.background = random.choice(COLORS)

        # Start NFC thread
        self.wait_for_nfc()

    def compose(self) -> ComposeResult:
        yield Title()

        self.login_label = Label(
            "PLAYER 1\n\nTap NFC Card\n\n[Z] Skip",
            id="login-label",
        )
        yield self.login_label

        self.player_info = Label("")
        self.player_info.display = False
        yield self.player_info

        self.game_list = GameList()
        self.game_list.display = False
        yield self.game_list

    @work(thread=True)
    def wait_for_nfc(self):
        while not self.login_complete:

            uid = nfc.read()

            if self.login_complete:
                return

            if uid is None:
                continue

            user = db.find_user(uid)

            if user is None:
                db.add_user(names.generate(), uid)
                user = db.find_user(uid)

            if user is None:
                continue

            # Prevent same card for both players
            if (
                self.player1 is not None
                and self.player1.uid == user.uid
            ):
                continue

            self.app.call_from_thread(
                self.complete_login,
                user,
            )

    def complete_login(self, user: UserData):
        if self.login_complete:
            return

        #
        # PLAYER 1
        #
        if self.login_stage == 1:
            self.player1 = user
            self.login_stage = 2

            self.login_label.update(
                f"PLAYER 1: {user.name}\n\n"
                f"PLAYER 2\n\n"
                f"Tap NFC Card\n\n"
                f"[Z] Skip"
            )

            return

        #
        # PLAYER 2
        #
        if (
            self.player1 is not None
            and self.player1.uid == user.uid
        ):
            return

        self.player2 = user
        self.login_complete = True

        self.login_label.display = False

        self.player_info.update(
            f"P1: {self.player1.name} ({self.player1.coins} coins)\n"  # type: ignore
            f"P2: {self.player2.name} ({self.player2.coins} coins)"
        )

        self.player_info.display = True
        self.game_list.display = True

        self.refresh()


class Main(App):
    CSS_PATH = "styles.tcss"

    def on_mount(self) -> None:
        self.theme = "atom-one-dark"

    def compose(self) -> ComposeResult:
        yield Splash()

    def on_key(self, event: Key) -> None:
        global P

        splash = self.query_one(Splash)

        #
        # LOGIN FLOW
        #
        if not splash.login_complete:

            match event.key:

                case "z":
                    if splash.login_stage == 1:
                        guest = db.find_user(69)
                    else :
                        guest = db.find_user(67)

                    splash.complete_login(guest)

                case "q":
                    self.exit()

            return

        #
        # NORMAL APPLICATION
        #
        match event.key:

            case "x":
                if P is not None and P.poll() is None:
                    os.killpg(os.getpgid(P.pid), signal.SIGTERM)
                    P = None

            case "q":
                if P is not None and P.poll() is None:
                    os.killpg(os.getpgid(P.pid), signal.SIGTERM)

                self.exit()


if __name__ == "__main__":
    open(RECEIVE_FILE, "x").close()
    open(SENDER_FILE, "x").close()
    Main().run()