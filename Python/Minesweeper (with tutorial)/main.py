from tkinter import *
from cell import Cell
import settings
import util


#create
root = Tk()
root.configure(bg="black")
#Chanze size
root.geometry(f"{settings.WIDTH}x{settings.HEIGHT}")

#Forbid resizing
root.resizable(False, False)

#Change title
root.title("Minesweeper Game")

top_frame = Frame(
    root,
    bg="black",
    width=settings.WIDTH,
    height=util.height_prct(25)
)
top_frame.place(x=0,y=0)

game_title = Label(
    top_frame,
    bg="black",
    fg="white",
    text="Minesweeper Game",
    font=("", 48)
)

game_title.place(
    x=util.width_prct(25)+50, y=10
)

left_frame = Frame(
    root,
    bg="black",
    width=util.width_prct(25),
    height=util.height_prct(75)
)
left_frame.place(x=0, y=util.height_prct(25))

centre_frame = Frame(
    root,
    bg="black",
    width=settings.CENTRE_WIDTH,
    height=settings.CENTRE_HEIGHT
)
centre_frame.place(x=util.width_prct(25), y=util.height_prct(25))


for x in range(settings.GRID_SIZE):
    for y in range(settings.GRID_SIZE):
        c = Cell(x, y)
        c.create_btn_object(centre_frame)
        c.cell_btn_object.grid(
            column=x, row=y
        )
#Call the Label from Cell class
Cell.create_cell_count_label(left_frame)
Cell.cell_count_label_object.place(
    x=0, y=0
)

Cell.randomize_mines()

#Run window
root.mainloop()
