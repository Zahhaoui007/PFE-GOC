import os
from flask import Flask, redirect, request, jsonify, render_template, session, url_for
import pandas as pd
import joblib
from requests import Session as requests_session  # Renommage de l'import
from sklearn.preprocessing import LabelEncoder
from supabase import create_client, Client

# Configurations de Supabase
URL = 'https://zjflooqiypnrqvcbfisy.supabase.co'  # Remplacez avec votre URL de projet
KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpqZmxvb3FpeXBucnF2Y2JmaXN5Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcxODAxOTgyNiwiZXhwIjoyMDMzNTk1ODI2fQ.gSV-IFIsajz9krhvb2Zq7pwhT57aQS60kepL_nWF7uQ'  # Remplacez avec votre clé anon
supabase: Client = create_client(URL, KEY)

model = joblib.load(r'C:\Users\WD\Documents\DERASSA\3eme annee\Frigoo\goc\WebAPP\Apple_storage_model.pkl')
label_encoder = joblib.load(r'C:\Users\WD\Documents\DERASSA\3eme annee\Frigoo\goc\WebAPP\label_encoder.pkl')

app = Flask(__name__)
app.secret_key = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpqZmxvb3FpeXBucnF2Y2JmaXN5Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcxODAxOTgyNiwiZXhwIjoyMDMzNTk1ODI2fQ.gSV-IFIsajz9krhvb2Zq7pwhT57aQS60kepL_nWF7uQ' 

@app.route('/')
def home():
    return redirect(url_for('login'))

@app.route('/login', methods=['GET', 'POST'])
def login():
    print("Login route accessed") 
    if request.method == 'POST':
        print("POST request received")  
        email = request.form['email']
        password = request.form['password']
        print(f"Email: {email}")  
        try:
            print("Attempting to sign in")  # Debug log
            response = supabase.auth.sign_in_with_password({"email": email, "password": password})
            user = response.user
            if user:
                user_id = user.id  # Get the user ID dynamically
                print(f"User logged in: {user_id}")  # Debug log

                print(f"Checking admin status for user: {user_id}")  # Debug log
                admin_check = supabase.from_('adminrole').select('user_id').eq('user_id', user_id).execute()  # Corrected table name
                print(f"Admin check query result: {admin_check.data}")  # Detailed logging

                if admin_check.data:
                    # If the user is found in the AdminRole table, they are an admin
                    session.pop('user_id', None)  # Clear specific session data
                    session.pop('role', None)  # Clear specific session data
                    print("User is admin, redirecting to dashboard")  # Debug log
                    session['user_id'] = user_id
                    session['role'] = 'admin'
                    return redirect(url_for('dashboard'))
                else:
                    print("User is not admin")  # Debug log
                    return render_template('login.html', error='Access denied. You are not an admin.')

            else:
                print("Login failed")  # Debug log
                return render_template('login.html', error='Login failed, please try again.')
        except Exception as e:
            print(f"Exception occurred: {str(e)}")  # Debug log
            return render_template('login.html', error=f'An unexpected error occurred: {str(e)}')

    return render_template('login.html')

@app.route('/dashboard')
def dashboard():
    print("Dashboard route accessed")  # Debug log
    if 'user_id' in session and session.get('role') == 'admin':
        try:
            # Retrieve users' data for the admin dashboard
            users_data = supabase.table('users').select('*').execute()
            users = users_data.data if users_data.data else []
            return render_template('admin_dashboard.html', users=users)
        except Exception as e:
            print(f"Exception occurred while fetching users: {str(e)}")  # Debug log
            return render_template('dashboard.html', error=f"An error occurred: {str(e)}")
    else:
        print("User not allowed to access dashboard")  # Debug log
        return redirect(url_for('login'))


@app.route('/logout')
def logout():
    session.clear()  # Ensure the session is fully cleared
    return redirect(url_for('login'))

if __name__ == '__main__':
    app.run(debug=True)
