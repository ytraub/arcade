import subprocess

from textual.message import Message
from textual.renderables.gradient import LinearGradient
from textual.app import App, ComposeResult, RenderResult
from textual.containers import Container
from textual.events import Event, Key
from textual.widget import Widget
from textual.widgets import Footer, Label, ListItem, ListView


COLORS = [
    "#00005f",
    "#000087",
    "#0000af",
    "#0000d7",
    "#0000ff",  # blue
    "#005fff",
    "#0087ff",
    "#00afff",
    "#00d7ff",
    "#00ffff",  # cyan
    "#00ffaf",
    "#00ff87",
    "#00ff5f",
    "#00ff00",
    "#5fff00",  # green
    "#87ff00",
    "#afff00",
    "#d7ff00",
    "#ffff00",  # yellow
    "#ffd700",
    "#ffaf00",
    "#ff8700",
    "#ff5f00",
    "#ff0000",  # orange/red
    "#ff00af",
    "#d700af",
    "#af00af",
    "#8700af",
    "#5f00af",  # purple
]


STOPS = [(i / (len(COLORS) - 1), color) for i, color in enumerate(COLORS)]


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
        pass

    def compose(self) -> ComposeResult:
        yield Title()
        yield GameList()

    def render(self) -> RenderResult:
        return LinearGradient(90, STOPS)


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

    def on_list_view_selected(self, event: ListView.Highlighted) -> None:
        if event.item:
            subprocess.run(["pico8"])


class Main(App):
    CSS_PATH = "styles.tcss"

    def on_mount(self) -> None:
        self.theme = "atom-one-dark"

    def compose(self) -> ComposeResult:
        yield Splash()

    def on_key(self, event: Key) -> None:
        match event.key:
            case "q":
                self.exit()


if __name__ == "__main__":
    main = Main()
    main.run()
