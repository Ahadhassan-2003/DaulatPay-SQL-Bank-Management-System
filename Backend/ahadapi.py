from MySQLdb import _mysql
from flask import Flask, request,jsonify
from flask_basicauth import BasicAuth
from flask_cors import CORS
import random as rand
import json

app = Flask(__name__)
CORS(app)
app.config['BASIC_AUTH_USERNAME'] = 'amaan'
app.config['BASIC_AUTH_PASSWORD'] = '12345'
basic_auth = BasicAuth(app)


@app.route('/login', methods=['GET'])
@basic_auth.required
def login():
    Username = str(request.args['Username'])
    password = str(request.args['password'])
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
                def get_column_names(result):
                    return [desc[0] for desc in result.describe()]

                db.query(f"Select * from transaction where SenderAccountNumber = {row[0].decode('utf-8')} or RecieverAccountNumber = {row[0].decode('utf-8')} order by TransactionDate desc")
                rt = db.store_result()
                trows = rt.fetch_row(maxrows=100)
                column_names = get_column_names(rt)
                decoded_trows = [dict(zip(column_names, map(lambda x: x.decode("utf-8"), trow))) for trow in trows]                
                return {"success": True, 
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
    db.query(f"create view statement_{AccountNumber} as select * from transaction where SenderAccountNumber = {AccountNumber} or RecieverAccountNumber = {AccountNumber} order by TransactionDate desc")
    rv = db.store_result()
    return {
        "success":True,
        "Username": Username,
        "FirstName": Firstname,
        "LastName": LastName,
        "CashAmount": cash,
        "SessionID": session,
    }


@app.route("/money_transfer", methods=["GET"])
def money_transfer():
    sender_account = f"{str(request.args['saccount'])}"
    receiver_account = f"{str(request.args['raccount'])}"
    amount = f"{str(request.args['amount'])}"
    amount = int(amount)
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

    cash_receiver += amount
    cash_sender -= amount

    db.query(f"UPDATE user SET CashAmount = {cash_receiver} WHERE AccountNumber = {receiver_account}")
    db.store_result()

    db.query(f"UPDATE user SET CashAmount = {cash_sender} WHERE AccountNumber = {sender_account}")
    db.store_result()

    db.query(f'''INSERT INTO transaction (Amount, TransactionDate, SenderAccountNumber, RecieverAccountNumber,
     TransactionType, TransactionDescription, MerchantName, TransactionStatus)
    VALUES({amount},"2023-12-27",{sender_account},{receiver_account},"Money Transfer","Testing","Nust Swimming Pool",
    "Successful")''')
    db.store_result()

    return {
        "sender_account": sender_account,
        "receiver_account": receiver_account,
        "amount_transferred": amount,
        "status": "Successful"
    }


@app.route("/deposit", methods=["GET"])
def deposit():
    account_number = f"{str(request.args['account_no'])}"
    account_number = int(account_number)
    amount = f"{str(request.args['amount'])}"
    amount = int(amount)
    db.query(f"Select CashAmount from user where AccountNumber = {account_number}")
    result = db.store_result()
    rows = result.fetch_row()
    res = rows[0][0].decode("utf-8")
    print(res)
    res = float(res)
    res += amount
    db.query(f"UPDATE user SET CashAmount = {res} WHERE AccountNumber = {account_number}")
    r = db.store_result()
    return {
        "account_number": account_number,
        "amount": res,
        "message": "Money deposit was successful"
    }


@app.route("/withdrawal", methods=["GET"])
def withdrawal():
    account_number = f"{str(request.args['account_no'])}"
    account_number = int(account_number)
    amount = f"{str(request.args['amount'])}"
    amount = int(amount)
    db.query(f"Select CashAmount from user where AccountNumber = {account_number}")
    result = db.store_result()
    rows = result.fetch_row()
    res = rows[0][0].decode("utf-8")
    print(res)
    am = float(res)
    am -= amount
    db.query(f"UPDATE user SET CashAmount = {am} WHERE AccountNumber = {account_number}")
    r = db.store_result()
    return {
        "account_number": account_number,
        "amount": am,
        "message": "Money withdrawal was successful"
    }


db = _mysql.connect(
    host="25.62.4.171",
    port=3306,
    user="Ahad",
    password="alexbhatti",
    database="daulatpay",
)

if __name__ == '__main__':
    app.run(  # ssl_context=('D:\PyCharmProjects\cert.pem', 'D:\PyCharmProjects\key.pem'),
        debug=True, host='0.0.0.0', port=8000)
