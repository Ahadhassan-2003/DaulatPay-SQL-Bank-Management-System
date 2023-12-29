from MySQLdb import _mysql
from flask import Flask, request,jsonify
from flask_basicauth import BasicAuth
from flask_cors import CORS
import random as rand
import json
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email import encoders
import pandas as pd


app = Flask(__name__)
CORS(app)
app.config['BASIC_AUTH_USERNAME'] = 'amaan'
app.config['BASIC_AUTH_PASSWORD'] = '12345'
basic_auth = BasicAuth(app)

def get_column_names(result):
    return [desc[0] for desc in result.describe()]


@app.route('/login', methods=['GET'])
@basic_auth.required
def login():
    Username = str(request.args['Username'])
    password = str(request.args['Password'])
    Username = f'"{Username}"'

    def authenticate_user(username, password):
        db.query("Select * from user where Username= " + Username)
        r = db.store_result()
        rows = r.fetch_row(maxrows=1)
        for row in rows:
            print(row[1])
            print(row[0])
            Pass = row[2].decode("utf-8")
            if password == Pass:
                #Use the below query when all changes are made to the database
                db.query(f"""Select * from transaction where SenderAccountNumber = {row[0].decode('utf-8')} or 
                         ReceiverAccountNumber = {row[0].decode('utf-8')} order by TransactionDate desc""")
                rt = db.store_result()
                trows = rt.fetch_row(maxrows=100)
                column_names = get_column_names(rt)
                decoded_trows = [dict(zip(column_names, map(lambda x: x.decode("utf-8"), trow))) for trow in trows]                
                return {
                        "success": True, 
                        "AccountNumber": row[0].decode("utf-8"),
                        "FirstName": row[3].decode("utf-8"),
                        "LastName": row[4].decode("utf-8"),
                        "CashAmount": row[7].decode("utf-8"),
                        "SessionID": row[10].decode("utf-8"),
                        "Transactions": decoded_trows
                    }
            else:
                return {"success": False}

    result = authenticate_user(Username, password)
    return result


@app.route("/deposit", methods=["GET"])
def deposit():
    account_number = f"{str(request.args['account_no'])}"
    account_number = int(account_number)
    amount = f"{str(request.args['amount'])}"
    amount = int(amount)
    #query to get the amount of the user
    db.query(f"Select CashAmount from user where AccountNumber = {account_number}")
    result = db.store_result()
    rows = result.fetch_row()
    res = rows[0][0].decode("utf-8")
    #adding the amount
    res = float(res)
    res += amount
    #query to update the amount in user's account
    db.query(f"UPDATE user SET CashAmount = {res} WHERE AccountNumber = {account_number}")
    r = db.store_result()

    #query to insert this transaction in the transaction table
    transaction_status = "Successful"
    db.query(f"""INSERT INTO transaction(Amount,TransactionDate, SenderAccountNumber, ReceiverAccountNumber,
                TransactionType, TransactionDescription, MerchantName, TransactionStatus)
                VALUES({amount},curdate(),{account_number},{account_number},"withdrawal","Withdrew amount from account",
                "None",'{transaction_status}')""")

    return {
        "account_number": account_number,
        "amount": res,
        "message": "Money deposit was successful"
    }


@app.route("/money_transfer", methods=["GET"])
def money_transfer():
    sender_account = f"{str(request.args['saccount'])}"
    receiver_account = f"{str(request.args['raccount'])}"
    amount = f"{str(request.args['amount'])}"
    amount = int(amount)

    #retrieveing cash of both th sender and the receiver
    db.query(f"Select CashAmount from user where AccountNumber = {sender_account}")
    result_sender = db.store_result()
    row_sender = result_sender.fetch_row()
    cash_sender = row_sender[0][0].decode("utf-8")
    cash_sender = float(cash_sender)

    db.query(f"Select CashAmount from user where AccountNumber = {receiver_account}")
    result_receiver = db.store_result()
    row_receiver = result_receiver.fetch_row()
    cash_receiver = row_receiver[0][0].decode("utf-8")
    cash_receiver = float(cash_receiver)

    if cash_sender < amount:
        return {
            "sender_account": sender_account,
            "receiver_account": receiver_account,
            "amount": amount,
            "status": "Failed"
        }

    #deducting and adding the amount
    cash_receiver += amount
    cash_sender -= amount

    #updating the cash in both the sender and the receiver's account
    db.query(f"UPDATE user SET CashAmount = {cash_receiver} WHERE AccountNumber = {receiver_account}")
    db.store_result()

    db.query(f"UPDATE user SET CashAmount = {cash_sender} WHERE AccountNumber = {sender_account}")
    db.store_result()

    #inserting the transaction in the transaction table
    transaction_type = "Money Transfer"
    db.query(f'''INSERT INTO transaction (Amount, TransactionDate, SenderAccountNumber, RecieverAccountNumber,
            TransactionType, TransactionDescription, MerchantName, TransactionStatus)  
            VALUES({amount},curdate(),{sender_account},{receiver_account},{transaction_type},"Jo user se aaye ga","None",
            "Successful")''')
    db.store_result()

    return {
        "sender_account": sender_account,
        "receiver_account": receiver_account,
        "amount_transferred": amount,
        "status": "Successful"
    }

@app.route('/signup', methods=['GET'])
@basic_auth.required
def SignUp():
    Username = f'"{str(request.args["Username"])}"'
    password = f'"{str(request.args["Password"])}"'
    Firstname = f'"{str(request.args["FirstName"])}"'
    LastName = f'"{str(request.args["LastName"])}"'
    Email = f'"{str(request.args["Email"])}"'
    CMS = f'"{str(request.args["CMS"])}"'
    address = f'"{str(request.args["Address"])}"'
    cash = 0
    session = f'"123"'
    dob = f'"{str(request.args["DOB"])}"'
    phoneno = f'"{str(request.args["Phone"])}"'
    AccountNumber = rand.randint(100000, 999999)
    db.query(f'''INSERT INTO USER 
    (AccountNumber, Username, Password, FirstName, LastName, Email, Address, CashAmount, DateOfBirth, PhoneNumber, SessionID,CMS)
    VALUES
    ({AccountNumber}, {Username}, {password}, {Firstname}, {LastName},{Email},{address},{cash}, {dob}, {phoneno},{session},{CMS})
    ''')
    r = db.store_result()
    db.query(f"create view statement_{AccountNumber} as select * from transaction where SenderAccountNumber = {AccountNumber} or ReceiverAccountNumber = {AccountNumber} order by TransactionDate desc")
    rv = db.store_result()
    return {
        "success":True,
        "Username": Username,
        "FirstName": Firstname,
        "LastName": LastName,
        "CashAmount": cash,
        "SessionID": session,
    }


@app.route("/generate_statement", methods=["GET"])
def generate_statement():
    account_number = f"{str(request.args['AccountNumber'])}"
    account_number = int(account_number)
    db.query(f"Select * from statement_{account_number}")
    rt = db.store_result()
    trows = rt.fetch_row(maxrows=100)
    column_names = get_column_names(rt)
    decoded_trows = [dict(zip(column_names, map(lambda x: x.decode("utf-8"), trow))) for trow in trows]
    # xlsx generation
    df = pd.DataFrame(decoded_trows)
    # Save the DataFrame to an Excel file
    excel_file_path = "output.xlsx"
    df.to_excel(excel_file_path, index=False, engine='openpyxl')  # Change the encoding if needed
    print(f"Data saved to {excel_file_path}")
    # Save the DataFrame to a CSV file (text format)
    csv_file_path = "output.csv"
    df.to_csv(csv_file_path, index=False)  # Change the encoding if needed
    print(f"Data saved to {csv_file_path}")
    # email sending
    db.query(f"Select Email from user where AccountNumber = {account_number}")
    r = db.store_result()
    remail = r.fetch_row(maxrows=1)
    remail = remail[0][0]
    remail = remail.decode("utf-8")
    print(remail)
    def sendmail(remail):
        smtp_user = 'amaanashraf222999@gmail.com'
        smtp_password = 'bmkebaddondkkgop'
        server = 'smtp.gmail.com'
        port = 587

        msg = MIMEMultipart()
        msg["Subject"] = 'DAULAT PAY'
        msg["From"] = smtp_user
        msg["To"] = remail

        # Attach the CSV file
        csv_file_path = 'output.csv'
        attachment = open(csv_file_path, 'rb')
        part = MIMEBase('application', 'octet-stream')
        part.set_payload((attachment).read())
        encoders.encode_base64(part)
        part.add_header('Content-Disposition', "attachment; filename= %s" % csv_file_path)
        msg.attach(part)

        # Add email body
        msg.attach(MIMEText("Your Statement for the time is attached below. Thank you for using Daulat Pay."))

        # Send the email
        with smtplib.SMTP(server, port) as s:
            s.ehlo()
            s.starttls()
            s.login(smtp_user, smtp_password)
            s.sendmail(smtp_user, remail, msg.as_string())
    sendmail(remail)
    return {
        "account_number": account_number,
        "transactions": decoded_trows
    }

@app.route("/get_bill_amount", methods=["GET"])
def get_bill_amount():
    invoice_number = f"{str(request.args['invoice_number'])}"
    invoice_number = int(invoice_number)
    db.query(f"Select Amount from bill where InvoiceNumber = {invoice_number}")
    result = db.store_result()
    rows = result.fetch_row()
    res = rows[0][0].decode("utf-8")
    print(res)
    return{
        "invoice_number": invoice_number,
        "amount": res
    }
@app.route("/change_password",methods=["GET"])
def change_password():
    new_password = f'"{str(request.args["password"])}"'
    account_number = f'"{str(request.args["account_no"])}"'

    db.query(f"""UPDATE user SET Password = {new_password} WHERE AccountNumber = {account_number}""")
    db.store_result()

    return{
        "success": True,
        "message": "Password change was successful"
    }
@app.route("/bill_payment",methods=["GET"])
def bill_payment():
    amount = float(request.args['amount'])
    account_number = 2  # Replace with the actual account number
    bill_type = f'"{str(request.args["billtype"])}"'

    #query to retrieve amount from user's account
    db.query(f"SELECT CashAmount FROM user WHERE AccountNumber = {account_number}")

    result = db.store_result()
    rows = result.fetch_row()
    cash = float(rows[0][0].decode("utf-8"))

    if cash < amount:
        return {
            "success": False,
            "message": "Transaction was unsuccessful"
        }

    #deducting the cash
    cash -= amount
    bill_status = '"Paid"'

    #inserting the bill status into the bill table
    db.query(f"""UPDATE bill SET BillStatus = {bill_status}, PaymentDate = curdate() WHERE BillType = {bill_type} AND 
            AccountNumber = {account_number} AND BillStatus = "Unpaid";""")
    db.store_result()

    #uodating the amount in the user;s account
    db.query(f"UPDATE user SET CashAmount = {cash} WHERE AccountNumber = {account_number}")
    db.store_result()

    receiver_account_no = 1
    merchant_name = "NUST Sports Complex"
    transaction_status = "Successful"

    #inserting the transaction in the transaction table
    db.query(f"""INSERT INTO transaction(Amount,TransactionDate, SenderAccountNumber, ReceiverAccountNumber,
            TransactionType, TransactionDescription, MerchantName, TransactionStatus)
            VALUES({amount},curdate(),{account_number},{receiver_account_no},"money_transfer","Gym fee is paid",
            '{merchant_name}','{transaction_status}')""")

    return {"success": True}


@app.route("/generate_otp", methods=["GET"])
def generate_otp():
    account_number = f"{str(request.args['account_no'])}"
    account_number = int(account_number)
    otp = rand.randint(100000, 999999)
    db.query(f"select Email from user where AccountNumber = {account_number}")
    r = db.store_result()
    rows = r.fetch_row()
    remail = rows[0][0].decode("utf-8")
    print(remail)
    def sendmail(remail):
        smtp_user = 'amaanashraf222999@gmail.com'
        smtp_password = 'bmkebaddondkkgop'
        server = 'smtp.gmail.com'
        port = 587

        msg = MIMEMultipart()
        msg["Subject"] = 'DAULAT PAY'
        msg["From"] = smtp_user
        msg["To"] = remail

        # Add email body
        msg.attach(MIMEText("Your OTP for Password Change is: " + str(otp) + ".\nPlease do not share this with anyone else.\nThank you for using Daulat Pay."))

        # Send the email
        with smtplib.SMTP(server, port) as s:
            s.ehlo()
            s.starttls()
            s.login(smtp_user, smtp_password)
            s.sendmail(smtp_user, remail, msg.as_string())
    sendmail(remail)
    return {
        "status": "OTP sent successfully",
        "account_number": account_number,
        "otp": otp
    }


@app.route("/withdrawal", methods=["GET"])
def withdrawal():
    account_number = f"{str(request.args['account_no'])}"
    account_number = int(account_number)
    amount = f"{str(request.args['amount'])}"
    amount = int(amount)
    #query to retrieve amount from the account of the user
    db.query(f"Select CashAmount from user where AccountNumber = {account_number}")
    result = db.store_result()
    rows = result.fetch_row()
    cash = rows[0][0].decode("utf-8")
    cash = float(cash)

    if cash < amount:
        return{
            "account_number": account_number,
            "amount": cash,
            "message": "Insufficient funds"
        }

    #deducting the amount
    cash -= amount

    #query to update cash in the use's account;
    db.query(f"UPDATE user SET CashAmount = {cash} WHERE AccountNumber = {account_number}")
    r = db.store_result()

    #query to add this transaction in transaction table
    transaction_status = "Successful"
    db.query(f"""INSERT INTO transaction(Amount,TransactionDate, SenderAccountNumber, ReceiverAccountNumber,
            TransactionType, TransactionDescription, MerchantName, TransactionStatus)
            VALUES({amount},curdate(),{account_number},{account_number},"withdrawal","Withdrew amount from account",
            "None",'{transaction_status}')""")

    return {
        "account_number": account_number,
        "amount": cash,
        "message": "Money withdrawal was successful"
    }


db = _mysql.connect(
    host="25.62.4.171",
    port=3306,
    user="Ammar",
    password="alexbhatti",
    database="daulatpay",
)

if __name__ == '__main__':
    app.run(  #ssl_context=('D:\PyCharmProjects\cert.pem', 'D:\PyCharmProjects\key.pem'),
        debug=True, host='0.0.0.0', port=8000)
