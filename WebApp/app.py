from flask import Flask, redirect, request, jsonify, render_template
import pandas as pd
import joblib
from requests import session
from sklearn.preprocessing import LabelEncoder
from supabase import create_client, Client
# Configurations de Supabase
URL = 'https://zjflooqiypnrqvcbfisy.supabase.co'  # Remplacez avec votre URL de projet
KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpqZmxvb3FpeXBucnF2Y2JmaXN5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTgwMTk4MjYsImV4cCI6MjAzMzU5NTgyNn0.jQvsKl0aN8TCICavH0TT0U5j_cClEu7gMsiqJpzgG0E'  # Remplacez avec votre clé anon
supabase: Client = create_client(URL, KEY)
app = Flask(__name__)

# Load the trained model
model = joblib.load('C:\\Users\\hp\\Documents\\stag\\PFE-GOC\\WebApp\\Apple_storage_model.pkl')

# Load the LabelEncoder
label_encoder = joblib.load('C:\\Users\\hp\\Documents\\stag\\PFE-GOC\\WebApp\\label_encoder.pkl')

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/predict', methods=['POST'])
def predict():
    try:
        apple_type = request.form['apple_type']
        quantity_kg = float(request.form['quantity_kg'])
        
        # Encode apple type
        encoded_apple_type = label_encoder.transform([apple_type])[0]
        
        # Create a DataFrame
        input_data = pd.DataFrame([[encoded_apple_type, quantity_kg]], columns=['Apple_Type', 'Quantity_kg'])
        
        # Make prediction
        prediction = model.predict(input_data)
        response = {
            'optimal_temperature': prediction[0][0],
            'optimal_humidity': prediction[0][1],
            'optimal_co2_percent': prediction[0][2],
            'optimal_o2_percent': prediction[0][3]
        }
        return render_template('result.html', response=response)
    except Exception as e:
        return jsonify({'error': str(e)})

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        user = supabase.auth.sign_in(email=email, password=password)
        if user:
            user_id = user['user'].id
            role_data = supabase.table('AdminRole').select('Role').eq('ID', user_id).execute()
            if role_data.data:
                session['role'] = role_data.data[0]['Role']
                session['user_id'] = user_id
                if session['role'] == 'admin':
                    return redirect('/dashboard')
                else:
                    return 'Access denied'
            return 'Role not found'
        else:
            return 'Login failed'
    return render_template('login.html')

@app.route('/dashboard')
def dashboard():
    if 'role' in session and session['role'] == 'admin':
        return render_template('admin_dashboard.html')
    else:
        return redirect('/login')

@app.route('/logout')
def logout():
    session.pop('user_id', None)
    session.pop('role', None)
    return redirect('/login')

if __name__ == '__main__':
    app.run(debug=True)
