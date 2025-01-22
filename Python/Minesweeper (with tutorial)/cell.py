from time import sleep
from tkinter import *
import settings
import random
import ctypes

class Cell:
    all = []
    cell_count_label_object = None
    cell_count = settings.CELL_COUNT
    def __init__(self, x, y, is_mine=False):
        self.is_mine = is_mine
        self.is_open = False
        self.is_marked = False
        self.cell_btn_object = None
        self.x = x
        self.y = y

        #Append the object to the Cell.all list
        Cell.all.append(self)
    def create_btn_object(self, location):
        btn=Button(
            location,
            width=settings.BUTTON_WIDTH,
            height=settings.BUTTON_HEIGHT,
        )
        btn.bind("<Button-1>", self.left_click_actions) #Left Click
        btn.bind("<Button-3>", self.right_click_actions) #Right Click
        self.cell_btn_object = btn

    def left_click_actions(self, event):
        if self.is_mine:
            self.show_mine()
        else:
            if self.surrounded_cells_mines_length == 0:
                for cell_obj in self.surrounded_cells:
                    cell_obj.show_cell()
            self.show_cell()
            #Winning logic
            if Cell.cell_count == settings.AMOUNT_MINES:
                ctypes.windll.user32.MessageBoxW(0, "You Won", "Congratulation", 0)

        #Cancel click event if cell is open
        self.cell_btn_object.unbind("<Button-1>")
        self.cell_btn_object.unbind("<Button-3>")

    #return a cell object based on x and y
    def get_cell_by_axis(self, x, y):
        for cell in Cell.all:
            if cell.x == x and cell.y == y:
                return cell

    #get surrounding cells
    @property
    def surrounded_cells(self):
        cells = [
            self.get_cell_by_axis(self.x -1, self.y -1),
            self.get_cell_by_axis(self.x -1, self.y),
            self.get_cell_by_axis(self.x -1, self.y +1),
            self.get_cell_by_axis(self.x, self.y -1),
            self.get_cell_by_axis(self.x, self.y +1),
            self.get_cell_by_axis(self.x +1, self.y -1),
            self.get_cell_by_axis(self.x +1, self.y),
            self.get_cell_by_axis(self.x +1, self.y +1),
        ]
        #eliminate None
        cells = [
            cell for cell in cells if cell is not None
        ]
        return cells

    #mine count
    @property
    def surrounded_cells_mines_length(self):
        counter=0
        for cell in self.surrounded_cells:
            if cell.is_mine:
                counter += 1
        return counter

    #cell and mine count
    def show_cell(self):
        if not self.is_open:
            self.cell_btn_object.configure(text=self.surrounded_cells_mines_length,)
            self.cell_btn_object.configure(bg="#adadad")
            #replace cell_count_label text with new text
            if Cell.cell_count_label_object:
                Cell.cell_count += -1
                Cell.cell_count_label_object.configure(
                    text=f"Cells Left:{Cell.cell_count}"
                )
            self.is_open = True
            self.is_marked = False

    #Logic for Gameover
    def show_mine(self):
        self.cell_btn_object.configure(bg="red")
        sleep(0.1)
        ctypes.windll.user32.MessageBoxW(0, "You clicked on a mine", "Game Over", 0)
        sys.exit()

    def right_click_actions(self, event):
        if not self.is_marked and not self.is_open:
            self.cell_btn_object.configure(bg="orange")
            self.is_marked = True
        elif self.is_marked:
            self.cell_btn_object.configure(bg="SystemButtonFace")
            self.is_marked = False


    @staticmethod
    def randomize_mines():
        mines = random.sample(
            Cell.all, settings.AMOUNT_MINES
        )
        for mines in mines:
            mines.is_mine = True

    def __repr__(self):
        return f"Cell({self.x}, {self.y})"

    @staticmethod
    def create_cell_count_label(location):
        lbl = Label(
            location,
            bg="black",
            fg="white",
            text=f"Cells Left:{Cell.cell_count}",
            width=12,
            height=4,
            font=("", 30)
        )
        Cell.cell_count_label_object = lbl
