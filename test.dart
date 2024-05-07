import 'dart:convert';

import 'package:http/http.dart' as http;

void main() async {
  // URL of your Flask app
  var url = Uri.parse('http://127.0.0.1:5000/predict');

  // Sample data for testing
  var data = {
    'Weight': [57.0],
    'Height': [1.28],
    'Gender': ['Male'],
    'Age': [20]
  };
  var jsonData = json.encode(data); 
  var response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonData,
  );

  // Check if request was successful
  if (response.statusCode == 200) {
    // Print the prediction result
    print(
        "Predictions: ${json.decode(response.body)['predictions']}"); // Changed from jsonDecode to json.decode
  } else {
    print("Error: ${response.body}");
  }
}
