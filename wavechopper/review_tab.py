#!/usr/bin/python3
# -*- coding: utf-8 -*-

import sys
from PyQt5 import *
from PyQt5.QtCore import Qt
import PyQt5.QtWidgets as QtWidgets
from PyQt5.QtGui import QIcon

class ReviewTab(QtWidgets.QWidget):
    def __init__(self):
        super().__init__()
        self.init()

    def init(self):
        text = QtWidgets.QTextEdit