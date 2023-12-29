from tkinter import *
from tkinter import messagebox
from pandas import *
from MySQLdb import _mysql
from flask import Flask, request, jsonify
from flask_basicauth import BasicAuth
from flask_cors import CORS
import random as rand

db = _mysql.connect(
    host="25.62.4.171",
    port=3306,
    user="Ahad",
    password="alexbhatti",
    database="daulatpay",
)

def unblock_clicked():
    account_number = int(ac_number.get())
    
    # Query to unblock the account
    db.query(f"UPDATE user SET AccountStatus = 'UNBLOCKED' WHERE AccountNumber = {account_number}")
    r = db.store_result()

    Label(root, text='ACCOUNT UNBLOCKED   ', fg="green", bg="#181D31", font=("Tw Cen MT", 15)).place(x=98, y=180)

def block_clicked():
    account_number = int(ac_number.get())
    
    # Query to block the account
    db.query(f"UPDATE user SET AccountStatus = 'BLOCKED' WHERE AccountNumber = {account_number}")
    r = db.store_result()
    Label(root, text='     ACCOUNT BLOCKED   ', fg="green", bg="#181D31", font=("Tw Cen MT", 15)).place(x=98, y=180)

root = Tk()
root.configure(bg="#181D31")

root.maxsize(400, 250)
root.minsize(400, 250)

Label(root, text="Enter Account Number", font=("Tw Cen MT", 18, "bold"), bg="#181D31", fg="#F0E9D2").place(x=20, y=16)
Frame(root, width=230, height=2, bg="#F0E9D2").place(x=17, y=50)

ac_number = Entry(root, width=20, fg="#F0E9D2", border=0, bg="#181D31", font=("Tw Cen MT", 12, "bold"))
ac_number.place(x=150, y=100)
Frame(root, width=250, height=2, bg="#F0E9D2").place(x=82, y=120)

block_button = Button(root, text="BLOCK", bg="#F0E9D2", fg="#181D31", command=block_clicked).place(x=128, y=150)
unblock_button = Button(root, text="UNBLOCK", bg="#F0E9D2", fg="#181D31", command=unblock_clicked).place(x=208, y=150)

root.mainloop()

