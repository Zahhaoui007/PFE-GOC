import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error, r2_score
import joblib

# Load the dataset
df = pd.read_csv('Apple_Storage_Conditions_Dataset.csv')

# Encode the 'Apple_Type' column because it is categorical
encoder = LabelEncoder()
df['Apple_Type'] = encoder.fit_transform(df['Apple_Type'])

# Split the data into features and labels
X = df[['Apple_Type', 'Quantity_kg']]  # Features
y = df[['Optimal_Temperature_C', 'Optimal_Humidity_Percent', 'Optimal_CO2_Percent', 'Optimal_O2_Percent']]  # Labels

# Split the dataset into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Initialize the model
model = RandomForestRegressor(n_estimators=100, random_state=42)

# Train the model
model.fit(X_train, y_train)

# Make predictions on the test set
predictions = model.predict(X_test)

# Evaluate the model
mae = mean_absolute_error(y_test, predictions)
r2 = r2_score(y_test, predictions)
print("Mean Absolute Error:", mae)
print("R^2 Score:", r2)

# Save the model to a file
joblib.dump(model, 'apple_storage_model.pkl')

# Optionally, save the LabelEncoder if you need to use it later for prediction
joblib.dump(encoder, 'label_encoder.pkl')
