from flask import Flask, request, jsonify
import pickle
import os
import pandas as pd
from sklearn.preprocessing import LabelEncoder

# Load the trained model
with open('decision_tree_model3.pkl', 'rb') as f:
    loaded_model = pickle.load(f)

# Initialize Flask app
app = Flask(__name__)

# Define the path to save the LabelEncoder state
label_encoder_path = 'label_encoder.pkl'

# Initialize LabelEncoder
le = LabelEncoder()

# Define a function to fit and save the LabelEncoder
def fit_and_save_label_encoder(data):
    le.fit(data)
    with open(label_encoder_path, 'wb') as f:
        pickle.dump(le, f)

# Define a route for prediction
@app.route('/predict', methods=['POST'])
def predict():
    try:
        # Get input data from request
        data = request.json

        # Fit and save LabelEncoder with 'Gender' data
        fit_and_save_label_encoder(data['Gender'])

        # Convert input data to DataFrame
        input_data = pd.DataFrame(data)

        # Transform 'Gender' using the fitted LabelEncoder
        input_data['Gender'] = le.transform(input_data['Gender'])

        # Make predictions using the loaded model
        predictions = loaded_model.predict(input_data)

        # Return predictions as JSON response
        return jsonify({'predictions': predictions.tolist()}), 200
    except Exception as e:
        # Return error message if an exception occurs
        return jsonify({'error': str(e)}), 400

# Run the Flask app
if __name__ == '__main__':
    # Change the host to '0.0.0.0' to make the server accessible from other devices on the same network
    app.run(debug=True)
