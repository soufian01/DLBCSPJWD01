import unittest
import sqlite3
import os
from flask import Flask
from flask_login import login_user, current_user
from app import app, User, init_db, DATABASE

TEST_DATABASE = 'test_database.db'

def create_test_db():
    conn = sqlite3.connect(TEST_DATABASE)
    with open('init.sql', 'r') as f:
        conn.executescript(f.read())
    cursor = conn.cursor()
    cursor.execute('''
        INSERT INTO Users (name, email, password, phone, address, birth_date)
        VALUES (?, ?, ?, ?, ?, ?)
    ''', ('Test User', 'test@example.com', '$2b$12$J6Z6Z6Z6Z6Z6Z6Z6Z6Z6Z.', '1234567890', '123 Test St', '1990-01-01'))
    cursor.execute('''
        INSERT INTO Hosts (user_id) VALUES (?)
    ''', (1,))
    cursor.execute('''
        INSERT INTO Accommodations (host_id, title, price_per_night)
        VALUES (?, ?, ?)
    ''', (1, 'Test Accommodation', 100.00))
    cursor.execute('''
        INSERT INTO Guests (user_id) VALUES (?)
    ''', (1,))
    cursor.execute('''
        INSERT INTO Bookings (guest_id, accommodation_id, status, checkin_date, checkout_date)
        VALUES (?, ?, ?, ?, ?)
    ''', (1, 1, 'Confirmed', '2025-05-01', '2025-05-05'))
    cursor.execute('''
        INSERT INTO Discounts (accommodation_id, discount_percentage, start_date, end_date)
        VALUES (?, ?, ?, ?)
    ''', (1, 10.0, '2025-05-01', '2025-05-10'))
    conn.commit()
    conn.close()

class FlaskAppTests(unittest.TestCase):
    def setUp(self):
        app.config['TESTING'] = True
        app.config['SECRET_KEY'] = 'test-secret-key'
        app.config['WTF_CSRF_ENABLED'] = False
        global DATABASE
        DATABASE = TEST_DATABASE
        if os.path.exists(TEST_DATABASE):
            os.remove(TEST_DATABASE)
        create_test_db()
        self.app = app.test_client()
        self.ctx = app.app_context()
        self.ctx.push()

    def tearDown(self):
        if os.path.exists(TEST_DATABASE):
            os.remove(TEST_DATABASE)
        self.ctx.pop()

    def test_login_success(self):
        response = self.app.post('/login', data={
            'email': 'test@example.com',
            'password': 'testpassword'
        }, follow_redirects=True)
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'dashboard', response.data)

    def test_login_failure(self):
        response = self.app.post('/login', data={
            'email': 'wrong@example.com',
            'password': 'wrongpassword'
        }, follow_redirects=True)
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'login', response.data)

    def test_register(self):
        response = self.app.post('/register', data={
            'name': 'New User',
            'email': 'newuser@example.com',
            'password': 'newpassword',
            'phone': '0987654321',
            'address': '456 Test St',
            'birth_date': '1995-02-02'
        }, follow_redirects=True)
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'login', response.data)
        with sqlite3.connect(TEST_DATABASE) as conn:
            cursor = conn.cursor()
            cursor.execute('SELECT * FROM Users WHERE email = ?', ('newuser@example.com',))
            user = cursor.fetchone()
            self.assertIsNotNone(user)

if __name__ == '__main__':
    unittest.main()
