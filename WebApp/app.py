from flask import Flask, request, jsonify, render_template
import pandas as pd
import joblib
from sklearn.preprocessing import LabelEncoder

app = Flask(__name__)

# Load the trained model
model = joblib.load('apple_storage_model.pkl')

# Load the LabelEncoder
encoder = joblib.load('label_encoder.pkl')

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/predict', methods=['POST'])
def predict():
    try:
        apple_type = request.form['apple_type']
        quantity_kg = float(request.form['quantity_kg'])
        
        # Encode apple type
        encoded_apple_type = encoder.transform([apple_type])[0]
        
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

if __name__ == '__main__':
    app.run(debug=True)
