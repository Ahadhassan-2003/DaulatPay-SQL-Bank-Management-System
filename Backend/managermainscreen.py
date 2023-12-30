from tkinter import *
from pandas import *
from numpy import *
from MySQLdb import _mysql
from flask import Flask, request, jsonify
from flask_basicauth import BasicAuth
from flask_cors import CORS
import random as rand


def newaccount():
    mg_sc.destroy()
    import newaccountant
def goback():
    mg_sc.destroy()
    import managerlogin
def remove_account():
    import delete_account
def blockaccount():
    import blockaccount
def accountdetails():
    import detailswindow

db = _mysql.connect(
    host="25.62.4.171",
    port=3306,
    user="Ahad",
    password="alexbhatti",
    database="daulatpay",
)

mg_sc=Toplevel()

mg_sc.maxsize(500,720)
mg_sc.minsize(500,720)
name = "Ahad Hassan"

bgimage1=PhotoImage(file="bg4.png")
Label(mg_sc,image=bgimage1).place(x=0,y=0)

mgimage=PhotoImage(file="manager.png")
Label(mg_sc,image=mgimage,bg="#181D31").place(x=20,y=20)

Label(mg_sc,text=name,font=("Tw Cen MT",35,"bold"),fg="#E6DDC4",bg="#181D31",padx=12,pady=5).place(x=100,y=30)
Label(mg_sc,text='BANK MANAGER',font=("Tw Cen MT",15,"bold"),fg="#E6DDC4",bg="#181D31",padx=12,pady=5).place(x=120,y=80)
b1=Button(mg_sc,text="   Block/Unblock ",font=("Tw Cen MT",20,"bold"),fg="#F0E9D2",bg="#181D31",padx=15,activebackground="#181D31",activeforeground="#F0E9D2",relief=GROOVE,command=blockaccount)
b1.place(x=130,y=180)

b2=Button(mg_sc,text=" Accounts Detail ",font=("Tw Cen MT",20,"bold"),fg="#F0E9D2",bg="#181D31",padx=16,activebackground="#181D31",activeforeground="#F0E9D2",relief=GROOVE,command=accountdetails)
b2.place(x=130,y=270)

b3=Button(mg_sc,text="Add an Accountant",font=("Tw Cen MT",20,"bold"),fg="#F0E9D2",bg="#181D31",padx=3,activebackground="#181D31",activeforeground="#F0E9D2",relief=GROOVE,command=newaccount)
b3.place(x=130,y=360)

b4=Button(mg_sc,text="Remove an Account",font=("Tw Cen MT",20,"bold"),fg="#F0E9D2",bg="#181D31",activebackground="#181D31",activeforeground="#F0E9D2",relief=GROOVE,command=remove_account)
b4.place(x=130,y=450)

backarrow=PhotoImage(file="backlight.png")
back_button=Button(mg_sc,image=backarrow,bg="#181D31",command=goback).place(x=10,y=630)
mg_sc.mainloop()