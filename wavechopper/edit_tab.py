#!/usr/bin/python3
# -*- coding: utf-8 -*-

import sys
from PyQt5 import *
from PyQt5.QtCore import Qt
import PyQt5.QtWidgets as QtWidgets
from PyQt5.QtGui import QIcon

class EditTab(QtWidgets.QWidget):
    def __init__(self):
        super().__init__()
        self.init()

    def init(self):
        text = QtWidgets.QLineEdit(self)

        grid = QtWidgets.QGridLayout()
        grid.setSpacing(10)

        grid.addWidget(text, 1, 0)

        self.setLayout(grid)
        self.show()
