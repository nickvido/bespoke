#!/usr/bin/python3
# -*- coding: utf-8 -*-

import sys

from PyQt5.QtWidgets import QApplication, QMessageBox, QWidget, QDesktopWidget
from PyQt5.QtGui import QIcon


class WaveChopperApp(QWidget):

    def __init__(self):
        super().__init__()
        self.init_ui()

    def init_ui(self):
        self.setGeometry(0, 0, 850, 600)
        self.setWindowTitle('WaveChopper')
        self.setWindowIcon(QIcon('wc_icon.png'))
        self.center()
        self.show()

    def center(self):
        qr = self.frameGeometry()
        cp = QDesktopWidget().availableGeometry().center()
        qr.moveCenter(cp)
        self.move(qr.topLeft())

    def closeEvent(self, event):
        resp = QMessageBox.question(self, 'Message', 'Really quit?', QMessageBox.Yes | QMessageBox.No, QMessageBox.No)

        if resp == QMessageBox.Yes:
            event.accept()
        else:
            event.ignore()

if __name__ == '__main__':
    app = QApplication(sys.argv)
    wca = WaveChopperApp()
    sys.exit(app.exec_())
