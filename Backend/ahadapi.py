import random as rand
import smtplib
from email import encoders
from email.mime.base import MIMEBase
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import pandas as pd
from MySQLdb import _mysql
from argon2 import PasswordHasher
from flask import Flask, request
from flask_basicauth import BasicAuth
from flask_cors import CORS

app = Flask(__name__)
CORS(app)
app.config['BASIC_AUTH_USERNAME'] = 'amaan'
app.config['BASIC_AUTH_PASSWORD'] = '12345'
basic_auth = BasicAuth(app)
ph = PasswordHasher()


def get_column_names(result):
    return [desc[0] for desc in result.describe()]


@app.route('/login', methods=['GET'])
@basic_auth.required
def login():
    Username = str(request.args['Username'])
    password = str(request.args['Password']).strip('"')
    Username = f'"{Username}"'

    def authenticate_user(username, password):
        db.query("Select * from user where Username= " + Username)
        r = db.store_result()
        rows = r.fetch_row(maxrows=1)
        for row in rows:
            Pass = row[2]
            #line to check the hashed password and entered password
            is_valid = ph.verify(Pass, password)
            print((is_valid))

        if is_valid:
            # Use the below query when all changes are made to the database
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
                "Transactions": decoded_trows,
                "AccountStatus": row[12].decode("utf-8")
                }
        else:
            return {"success": False}

    result = authenticate_user(Username, password)
    return result


@app.route("/forget_password",methods=["GET"])
def forget_password():
    email = f"{str(request.args['email'])}"
    print(email)

    db.query(f"""SELECT AccountNumber FROM user WHERE Email = '{email}'""")
    r = db.store_result()
    r = r.fetch_row(maxrows=1)
    account_no = r[0][0].decode("utf-8")
    print(account_no)
    result = generate_otp(account_no)
    return result


@app.route("/deposit", methods=["GET"])
def deposit():
    account_number = f"{str(request.args['account_no'])}"
    account_number = int(account_number)
    amount = f"{str(request.args['amount'])}"
    amount = int(amount)
    # query to get the amount of the user
    db.query(f"Select CashAmount from user where AccountNumber = {account_number}")
    result = db.store_result()
    rows = result.fetch_row()
    res = rows[0][0].decode("utf-8")
    # adding the amount
    res = float(res)
    res += amount
    # query to update the amount in user's account
    db.query(f"UPDATE user SET CashAmount = {res} WHERE AccountNumber = {account_number}")
    r = db.store_result()

    # query to insert this transaction in the transaction table
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

    # retrieveing cash of both th sender and the receiver
    db.query(f"Select CashAmount from user where AccountNumber = {sender_account}")
    result_sender = db.store_result()
    row_sender = result_sender.fetch_row()
    cash_sender = row_sender[0][0].decode("utf-8")
    cash_sender = float(cash_sender)

    db.query(f"Select CashAmount from user where AccountNumber = {receiver_account}")
    result_receiver = db.store_result()
    row_receiver = result_receiver.fetch_row()
    print(row_receiver)
    cash_receiver = row_receiver[0][0].decode("utf-8")
    cash_receiver = float(cash_receiver)

    if cash_sender < amount:
        return {
            "sender_account": sender_account,
            "receiver_account": receiver_account,
            "amount": amount,
            "success": False
        }

    # deducting and adding the amount
    cash_receiver += amount
    cash_sender -= amount

    # updating the cash in both the sender and the receiver's account
    db.query(f"UPDATE user SET CashAmount = {cash_receiver} WHERE AccountNumber = {receiver_account}")
    db.store_result()

    db.query(f"UPDATE user SET CashAmount = {cash_sender} WHERE AccountNumber = {sender_account}")
    db.store_result()

    # inserting the transaction in the transaction table
    transaction_type = "Money Transfer"
    print(transaction_type)
    db.query(f'''INSERT INTO transaction (Amount, TransactionDate, SenderAccountNumber, ReceiverAccountNumber,
            TransactionType, TransactionDescription, MerchantName, TransactionStatus)  
            VALUES({amount},curdate(),{sender_account},{receiver_account},'{transaction_type}',"None","None",
            "Successful")''')
    print("input done")
    db.store_result()

    return {
        "sender_account": sender_account,
        "receiver_account": receiver_account,
        "amount_transferred": amount,
        "success": True
    }
@app.route("/updated_details", methods=["GET"])
def updated_details():
    account_number = str(request.args['AccountNumber'])
    account_number = int(account_number)
    db.query(f"SELECT * FROM user WHERE AccountNumber = {account_number}")
    r = db.store_result()
    rows = r.fetch_row()
    row = rows[0]
    db.query(f"""Select * from transaction where SenderAccountNumber = {account_number} or 
               ReceiverAccountNumber = {account_number} order by TransactionDate desc""")
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
        "Transactions": decoded_trows,
    }
@app.route('/signup', methods=['GET'])
@basic_auth.required
def SignUp():
    Username = f'"{str(request.args["Username"])}"'
    password = str(request.args["Password"])
    #hashing the password using the ph object
    hashed_password = ph.hash(password=password)
    hash
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
    db.query(f'''INSERT INTO user (AccountNumber, Username, Password, FirstName, LastName, Email, Address, CashAmount, 
            DateOfBirth, PhoneNumber, SessionID, CMS, AccountStatus) VALUES ({AccountNumber}, {Username}, 
            '{hashed_password}', {Firstname}, {LastName},{Email},{address},{cash}, {dob}, {phoneno},{session},{CMS},
            "UNBLOCKED")''')
    r = db.store_result()
    db.query(f"""create view statement_{AccountNumber} as select * from transaction where SenderAccountNumber = 
            {AccountNumber} or ReceiverAccountNumber = {AccountNumber} order by TransactionDate desc""")
    rv = db.store_result()
    return {
        "success": True,
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
    bill_id = f"{str(request.args['bill_id'])}"
    bill_id = int(bill_id)
    db.query(f"Select Amount from bill where InvoiceNumber = {bill_id}")
    result = db.store_result()
    rows = result.fetch_row()
    res = rows[0][0].decode("utf-8")
    print(res)
    return {
        "bill_id": bill_id,
        "amount": res
    }


@app.route("/bill_payment", methods=["GET"])
def bill_payment():
    account_number = int(str(request.args['account_no']))
    bill_id = f'"{str(request.args["bill_id"])}"'

    db.query(f"Select Amount from bill where BillID = {bill_id}")
    result = db.store_result()
    rows = result.fetch_row()
    amount = float(rows[0][0].decode("utf-8"))
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

    # deducting the cash
    cash -= amount
    bill_status = '"Paid"'

    #inserting the bill status into the bill table
    db.query(f"""UPDATE bill SET BillStatus = {bill_status}, PaymentDate = curdate() WHERE BillID = {bill_id}""")
    db.store_result()

    # uodating the amount in the user;s account
    db.query(f"UPDATE user SET CashAmount = {cash} WHERE AccountNumber = {account_number}")
    db.store_result()

    receiver_account_no = 1
    merchant_name = "NUST Sports Complex"
    transaction_status = "Successful"

    # inserting the transaction in the transaction table
    db.query(f"""INSERT INTO transaction(Amount,TransactionDate, SenderAccountNumber, ReceiverAccountNumber,
            TransactionType, TransactionDescription, MerchantName, TransactionStatus)
            VALUES({amount},curdate(),{account_number},NULL,"money_transfer","Gym fee is paid",
            '{merchant_name}','{transaction_status}')""")

    return {"success": True}


@app.route("/get_old_password", methods=["GET"])
def get_old_password():
    account_number = f"{str(request.args['account_no'])}"
    db.query(f"""SELECT Password FROM user WHERE AccountNumber = {account_number}""")
    r = db.store_result()
    rows = r.fetch_row()
    password = rows[0][0].decode("utf-8")
    print(password)
    return {
        "Password": password
    }



@app.route("/change_password", methods=["GET"])
def change_password():
    new_password = f'"{str(request.args["password"])}"'
    account_number = f"{str(request.args['account_no'])}"

    db.query(f"""UPDATE user SET Password = {new_password} WHERE AccountNumber = {account_number}""")
    db.store_result()

    return {
        "success": True
    }


@app.route("/generate_otp", methods=["GET"])
def generate_otp(*account_no):
    account_number = account_no[0]
    print(account_number)
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

        msg.attach(MIMEText("Your OTP for Password Change is: " + str(otp) + ".\nPlease do not share this with anyone "
                                                                             "else.\nThank you for using Daulat Pay."))

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
    # query to retrieve amount from the account of the user
    db.query(f"Select CashAmount from user where AccountNumber = {account_number}")
    result = db.store_result()
    rows = result.fetch_row()
    cash = rows[0][0].decode("utf-8")
    cash = float(cash)

    if cash < amount:
        return {
            "account_number": account_number,
            "amount": cash,
            "message": "Insufficient funds"
        }

    # deducting the amount
    cash -= amount

    # query to update cash in the use's account;
    db.query(f"UPDATE user SET CashAmount = {cash} WHERE AccountNumber = {account_number}")
    r = db.store_result()

    # query to add this transaction in transaction table
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

@app.route("/ticket_info", methods=["GET"])
def ticket_info():
    db.query(f"SELECT * FROM ticket")
    r = db.store_result()
    rows = r.fetch_row(maxrows=100)
    column_names = get_column_names(r)
    decoded_rows = [dict(zip(column_names, map(lambda x: x.decode("utf-8"), row))) for row in rows]
    return {
        "tickets": decoded_rows
    }

@app.route("/buy_tickets", methods=["GET"])
def buy_tickets():
    account_number = f"{str(request.args['account_no'])}"
    account_number = int(account_number)
    ticket_id = f"{str(request.args['ticket_id'])}"
    ticket_id = int(ticket_id)
    tickets_bought = f"{str(request.args['tickets_bought'])}"
    tickets_bought = int(tickets_bought)
    ticket_price = f"{str(request.args['ticket_price'])}"
    ticket_price = float(ticket_price)
    amount = tickets_bought * ticket_price

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
            VALUES({amount},curdate(),{account_number},{account_number},"Tickets Bought","{tickets_bought} tickets bought",
            "None",'{transaction_status}')""")
    db.store_result()

    db.query(f"update ticket set TicketCount = TicketCount - {tickets_bought} where TicketID = {ticket_id}")
    db.store_result()
    db.query(f"update ticket set AmountCollected = AmountCollected + {amount} where TicketID = {ticket_id}")
    db.store_result()
    #query to update the ticket table
    db.query(f"select * from tickets_bought where AccountNumber = {account_number} and TicketID = {ticket_id}")
    r = db.store_result()
    rows = r.fetch_row()
    if len(rows) == 0:
        db.query(f"Insert into tickets_bought values({account_number},{ticket_id},{tickets_bought})")
    else:
        db.query(f"Update tickets_bought set TicketCount = TicketCount + {tickets_bought} where AccountNumber = {account_number} and TicketID = {ticket_id}")
    return {
        "account_number": account_number,
        "amount": cash,
        "message": "Tickets bought successfully"
    }

@app.route("/updated_details", methods=["GET"])
def updated_details():
    account_number = str(request.args['AccountNumber'])
    account_number = int(account_number)
    db.query(f"SELECT * FROM user WHERE AccountNumber = {account_number}")
    r = db.store_result()
    rows = r.fetch_row()
    row = rows[0]
    db.query(f"""Select * from transaction where SenderAccountNumber = {account_number} or 
               ReceiverAccountNumber = {account_number} order by TransactionDate desc""")
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
        "Transactions": decoded_trows,
        "AccountStatus": row[12].decode("utf-8")
    }

db = _mysql.connect(
    host="localhost",
    port=3306,

    user="Ahad",
    password="alexbhatti",
    database="daulatpay",
)

if __name__ == '__main__':
    app.run(  # ssl_context=('D:\PyCharmProjects\cert.pem', 'D:\PyCharmProjects\key.pem'),
        debug=True, host='0.0.0.0', port=8000)
