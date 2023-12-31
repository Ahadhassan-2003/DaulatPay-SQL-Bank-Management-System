import tkinter as tk
from MySQLdb import _mysql

db = _mysql.connect(
    host="25.62.4.171",
    port=3306,
    user="Ahad",
    password="alexbhatti",
    database="daulatpay",
)

# Fetch data from the MySQL database
data = []
db.query("SELECT * FROM user")
result = db.store_result()
rows = result.fetch_row(maxrows=100, how=0)
column_names = result.describe()

# Exclude columns by index
exclude_columns = {2, 10}  # Index numbers to exclude (Password and SessionID)

# Create the main window
root = tk.Tk()
root.title("ACCOUNT DETAILS")

# Create the labels for column names
for i, desc in enumerate(column_names):
    col_name = desc[0]  # Column name is at index 0
    if i not in exclude_columns:
        label = tk.Label(root, text=col_name, width=15, borderwidth=1, relief="solid")
        label.grid(row=0, column=len([j for j in range(i) if j not in exclude_columns]))

# Create the labels for each row
for i, row in enumerate(rows):
    for j, val in enumerate(row):
        if j not in exclude_columns:
            decoded_val = val.decode("utf-8") if val is not None else ""
            label = tk.Label(root, text=decoded_val, width=15, borderwidth=1, relief="solid")
            label.grid(row=i + 1, column=len([k for k in range(j) if k not in exclude_columns]))

# Run the main loop
root.mainloop()
