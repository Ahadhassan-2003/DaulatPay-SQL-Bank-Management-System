from MySQLdb import _mysql
from MySQLdb import *
from flask import Flask, request
import requests
from flask_basicauth import BasicAuth
from flask_cors import CORS

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
        rows = r.fetch_row(maxrows=100)
        for row in rows:
            print(row[1])
            Pass = row[2].decode("utf-8")
            print(Pass)
            print(password)
            if password == Pass:
                return {"success": True}
            else:
                return {"success": False}

    result=authenticate_user(Username, password)
    return result



@app.route('/signup', methods=['GET'])
@basic_auth.required
def SignUp():
    Username = f'"{str(request.args["Username"])}"'
    password = f'"{str(request.args["password"])}"'
    Firstname = f'"{str(request.args["FirstName"])}"'
    LastName = f'"{str(request.args["LastName"])}"'
    Email = f'"{str(request.args["Email"])}"'
    CMS = f'"{str(request.args["CMS"])}"'
    address = f'"{str(request.args["Address"])}"'
    cash=0
    session=f'"123"'
    dob = f'"{str(request.args["DOB"])}"'
    phoneno = f'"{str(request.args["Phone"])}"'
    db.query(f'''INSERT INTO USER 
    (UserID, Username, Password, FirstName, LastName, Email, Address, CashAmount, DateOfBirth, PhoneNumber, SessionID)
    VALUES
    ({CMS}, {Username}, {password}, {Firstname}, {LastName},{Email},{address},{cash}, {dob}, {phoneno},{session})
    ''')
    r = db.store_result()
    r=r.fetch_row(maxrows=1)
    print(r)
db = _mysql.connect(
    host="localhost",
    user="Amaan",
    password="amaanhere",
    database="daulatpay",
)
#
# db.query("Select * from user where Username= "+Username)
# r = db.store_result()
# rows = r.fetch_row(maxrows=100)
# for row in rows:
#     print(row)
if __name__ == '__main__':
    app.run(  # ssl_context=('D:\PyCharmProjects\cert.pem', 'D:\PyCharmProjects\key.pem'),
        debug=True, host='0.0.0.0', port=8000)
