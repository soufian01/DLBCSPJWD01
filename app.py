import os
import sqlite3
from flask import Flask, render_template, request, redirect, url_for
from flask_login import LoginManager, UserMixin, login_user, login_required, logout_user, current_user
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)
app.config['SECRET_KEY'] = os.urandom(24)  # use a random secret key for the session

# configure the login manager
login_manager = LoginManager()
login_manager.init_app(app)

# database name file
DATABASE = 'database.db'

# function to initialize the database
def init_db():
    # verify if the database exists
    if not os.path.exists(DATABASE):
        conn = sqlite3.connect(DATABASE)
        with open('init.sql', 'r') as f:  # use the init.sql file to create the database
            conn.executescript(f.read())
        conn.close()
        print("Database creato con successo!")
    else:
        print("Il database esiste già.")

# initialize the database at the start of the app
init_db()

# class for the user object
class User(UserMixin):
    def __init__(self, id, name, email, phone, address):
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.address = address

    def get_id(self):
        return str(self.id)

# load user by ID
@login_manager.user_loader
def load_user(user_id):
    print(f"Loading user with ID {user_id}")
    with sqlite3.connect(DATABASE) as conn:
        cursor = conn.cursor()
        # query to get the user by ID
        cursor.execute('SELECT * FROM Users WHERE id = ?', (user_id,))
        user = cursor.fetchone()
        if user:
            print(f"User found with ID: {user[0]}")  # Aggiungi log per il debug
            return User(user[0], user[1], user[2], user[4], user[5])
        else:
            print("User not found.")
        return None

# route for the home page
@app.route('/')
def index():
    return render_template('index.html')


@app.route('/query1')
@login_required
def query1():
    with sqlite3.connect(DATABASE) as conn:
        cursor = conn.cursor()
        # query to get the top 5 most expensive listings
        cursor.execute("""SELECT u.name AS host_name, a.title AS accommodation_title, a.price_per_night
                            FROM Hosts h
                            JOIN Users u ON h.user_id = u.id
                            JOIN Accommodations a ON h.id = a.host_id
                            ORDER by a.price_per_night DESC LIMIT 5;""")
        # get column names
        columns = [description[0] for description in cursor.description]
        users = cursor.fetchall()

    # converti le righe in dizionari
    data = [dict(zip(columns, row)) for row in users]

    return render_template('results.html', title="Most expensive listings", data=data)

@app.route('/query2')
@login_required
def query2():
    with sqlite3.connect(DATABASE) as conn:
        cursor = conn.cursor()
        # query to get the top 5 cheapest listings
        cursor.execute("""SELECT u.name AS host_name, a.title AS accommodation_title, a.price_per_night
                            FROM Hosts h
                            JOIN Users u ON h.user_id = u.id
                            JOIN Accommodations a ON h.id = a.host_id
                            ORDER by a.price_per_night LIMIT 5;""")
        # get column names
        columns = [description[0] for description in cursor.description]
        users = cursor.fetchall()

    # converti le righe in dizionari
    data = [dict(zip(columns, row)) for row in users]

    return render_template('results.html', title="Cheapest listings", data=data)

@app.route('/query3')
@login_required
def query3():
    with sqlite3.connect(DATABASE) as conn:
        cursor = conn.cursor()
        # query to get all listings
        cursor.execute("""SELECT u.name AS host_name, a.title AS accommodation_title, a.price_per_night
                            FROM Hosts h
                            JOIN Users u ON h.user_id = u.id
                            JOIN Accommodations a ON h.id = a.host_id;""")
        columns = [description[0] for description in cursor.description]
        users = cursor.fetchall()

    # convert rows to dictionaries
    data = [dict(zip(columns, row)) for row in users]
    return render_template('results.html', title="All listings", data=data)

@app.route('/query4')
@login_required
def query4():
    with sqlite3.connect(DATABASE) as conn:
        cursor = conn.cursor()
        # query to get the top 5 most expensive listings
        cursor.execute("""SELECT u.name AS guest_name, a.title AS accommodation_title, b.status, b.checkin_date, b.checkout_date
                            FROM Bookings b
                            JOIN Guests g ON b.guest_id = g.id
                            JOIN Users u ON g.user_id = u.id
                            JOIN Accommodations a ON b.accommodation_id = a.id
                            WHERE b.status = "Confirmed" """)
        columns = [description[0] for description in cursor.description]
        users = cursor.fetchall()

    # convert rows to dictionaries
    data = [dict(zip(columns, row)) for row in users]
    return render_template('results.html', title="Confirmed listings", data=data)

@app.route('/query5')
@login_required
def query5():
    with sqlite3.connect(DATABASE) as conn:
        cursor = conn.cursor()
        # query to get the top 5 most expensive listings
        cursor.execute("""SELECT u.name AS guest_name, a.title AS accommodation_title, b.status, b.checkin_date, b.checkout_date
                            FROM Bookings b
                            JOIN Guests g ON b.guest_id = g.id
                            JOIN Users u ON g.user_id = u.id
                            JOIN Accommodations a ON b.accommodation_id = a.id
                            WHERE b.status = "Pending" """)
        columns = [description[0] for description in cursor.description]
        users = cursor.fetchall()

    # convert rows to dictionaries
    data = [dict(zip(columns, row)) for row in users]
    return render_template('results.html', title="Pending listings", data=data)

@app.route('/query6')
@login_required
def query6():
    with sqlite3.connect(DATABASE) as conn:
        cursor = conn.cursor()
        # query to get the top 5 most expensive listings
        cursor.execute("""SELECT u.name AS guest_name, a.title AS accommodation_title, b.status, b.checkin_date, b.checkout_date
                            FROM Bookings b
                            JOIN Guests g ON b.guest_id = g.id
                            JOIN Users u ON g.user_id = u.id
                            JOIN Accommodations a ON b.accommodation_id = a.id
                            WHERE b.status = "Cancelled" """)
        columns = [description[0] for description in cursor.description]
        users = cursor.fetchall()

    # convert rows to dictionaries
    data = [dict(zip(columns, row)) for row in users]
    return render_template('results.html', title="Cancelled listings", data=data)

@app.route('/query7')
@login_required
def query7():
    with sqlite3.connect(DATABASE) as conn:
        cursor = conn.cursor()
        # query to get the top 5 most expensive listings
        cursor.execute("""SELECT a.title AS accommodation_title, d.discount_percentage, d.start_date, d.end_date
                            FROM Discounts d
                            JOIN Accommodations a ON d.accommodation_id = a.id
                            ORDER BY d.discount_percentage DESC LIMIT 5 """)
        
        columns = [description[0] for description in cursor.description]
        users = cursor.fetchall()

    # convert rows to dictionaries
    data = [dict(zip(columns, row)) for row in users]
    return render_template('results.html', title="Highest discounts", data=data)


# Esempio di query 5
@app.route('/query8')
@login_required
def query8():
    with sqlite3.connect(DATABASE) as conn:
        cursor = conn.cursor()
        # query to get the top 5 most expensive listings
        cursor.execute("""SELECT a.title AS accommodation_title, d.discount_percentage, d.start_date, d.end_date
                            FROM Discounts d
                            JOIN Accommodations a ON d.accommodation_id = a.id
                            ORDER BY d.discount_percentage LIMIT 5 """)
        columns = [description[0] for description in cursor.description]
        users = cursor.fetchall()

    # convert rows to dictionaries
    data = [dict(zip(columns, row)) for row in users]
    return render_template('results.html', title="Lowest discounts", data=data)

@app.route('/query9')
@login_required
def query9():
    with sqlite3.connect(DATABASE) as conn:
        cursor = conn.cursor()
        # query to get the top 5 most expensive listings
        cursor.execute("""SELECT a.title AS accommodation_title, d.discount_percentage, d.start_date, d.end_date
                            FROM Discounts d
                            JOIN Accommodations a ON d.accommodation_id = a.id
                            ORDER BY d.discount_percentage """)
        columns = [description[0] for description in cursor.description]
        users = cursor.fetchall()

    # convert rows to dictionaries
    data = [dict(zip(columns, row)) for row in users]
    return render_template('results.html', title="All discounts", data=data)

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        
        with sqlite3.connect(DATABASE) as conn:
            cursor = conn.cursor()
            cursor.execute('SELECT * FROM Users WHERE email = ?', (email,))
            user = cursor.fetchone()

            if user and check_password_hash(user[3], password):  # verify the password 
                print(user)
                print(f"User ID from database: {user[0]}")
                user_obj = User(user[0], user[1], user[2], user[4], user[5])  # create a user object passing all relevant user info
                print(f"User {user_obj.name} is logging in.")  # print for debugging
                
                # associate the user object with the current session
                login_user(user_obj)
                
                # add this to verify that the user is logged in
                print(f"User {user_obj.name} has logged in. User ID: {user_obj.get_id()}")
                
                if current_user.is_authenticated:
                    print(f"User {current_user.name} is authenticated.")  # print for debugging
                    return redirect(url_for('dashboard'))
                else:
                    print("Authentication failed.")  # print for debugging
                    return redirect(url_for('login'))  # failed, go back to the login page
            else:
                print("Incorrect email or password.")  # print for debugging
                return redirect(url_for('login'))  # failed, go back to the login page

    return render_template('login.html')


@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        name = request.form['name']
        email = request.form['email']
        password = generate_password_hash(request.form['password']) # command to hash the password
        phone = request.form['phone']
        address = request.form['address']
        birth_date = request.form['birth_date']

        with sqlite3.connect(DATABASE) as conn:
            cursor = conn.cursor()
            cursor.execute(''' 
                INSERT INTO Users (name, email, password, phone, address, birth_date)
                VALUES (?, ?, ?, ?, ?, ?)
            ''', (name, email, password, phone, address, birth_date))
            conn.commit()

        return redirect(url_for('login'))

    return render_template('register.html')


@app.route('/dashboard')
@login_required
def dashboard():
    print(f"Is user authenticated? {current_user.is_authenticated}")  # print for debugging
    if current_user.is_authenticated:
        print(f"User {current_user.name} is authenticated.")  # print for debugging
        return render_template('dashboard.html', name=current_user.name, email=current_user.email, phone=current_user.phone, address=current_user.address)
    else:
        print("User is not authenticated.")  # print for debugging
        return redirect(url_for('login'))  # failed, go back to the login page


@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('index'))


# this command is used to launche the Faslk app, debug mode in this case
if __name__ == '__main__':
    app.run(debug=True)
