import os
import signal
import subprocess
import random

from textual.message import Message
from textual.renderables.gradient import LinearGradient
from textual.app import App, ComposeResult, RenderResult
from textual.containers import Container
from textual.events import Event, Key
from textual.widget import Widget
from textual.widgets import Footer, Label, ListItem, ListView


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
        return """
                            _
    /\\                     | |
   /  \\   _ __ ___ __ _  __| | ___
  / /\\ \\ | '__/ __/ _` |/ _` |/ _ \\
 / ____ \\| | | (_| (_| | (_| |  __/
/_/    \\_\\_|  \\___\\__,_|\\__,_|\\___|
"""


class Splash(Container):
    def on_mount(self) -> None:
        self.styles.background = random.choice(COLORS)

    def compose(self) -> ComposeResult:
        yield Title()
        yield GameList()


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
    def __init__(self, *children: Widget, name: str | None = None, id: str | None = None, classes: str | None = None, disabled: bool = False, markup: bool = True) -> None:
        super().__init__(*children, name=name, id=id, classes=classes, disabled=disabled, markup=markup)
        
        self.p = None
    
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

    def on_list_view_selected(self, event: ListView.Highlighted) -> None:
        if event.item:
            self.p = subprocess.Popen("pico8_dyn", stdout=subprocess.PIPE, shell=True, preexec_fn=os.setsid) 


class Main(App):
    CSS_PATH = "styles.tcss"

    def on_mount(self) -> None:
        self.theme = "atom-one-dark"

    def compose(self) -> ComposeResult:
        yield Splash()

    def on_key(self, event: Key) -> None:
        match event.key:
            case "x":
                game_list = self.query_one(GameList)

                if game_list.p is not None:
                    game_list.p.terminate()
                    game_list.p = None

            case "q":
                self.exit()


if __name__ == "__main__":
    main = Main()
    main.run()
