class UserInfo {
  String gender;
  double height;
  double weight;
  double age;
  String activity;

  UserInfo({
    required this.gender,
    required this.height,
    required this.weight,
    required this.age,
    required this.activity,
  });

  set caloriseRemining(double caloriseRemining) {}

  // Method to update activity level
  UserInfo updateActivity(String newActivity) {
    return UserInfo(
      gender: gender,
      height: height,
      weight: weight,
      age: age,
      activity: newActivity,
    );
  }

  //Calculate daily calories based on user information

  // Method to calculate BMR
  double calculateBMR() {
    double bmr;
    if (gender == 'Male') {
      bmr = ((10 * weight) + (6.25 * height) - (5 * age)) + 5;
    } else {
      bmr = ((10 * weight) + (6.25 * height) - (5 * age)) - 161;
    }
    return bmr;
  }

  double get dailyCalories {
    double bmr = calculateBMR();
    double activityFactor = getActivityFactor();
    double calories = bmr * activityFactor;

    return calories;
  }

  // Method to get activity factor based on activity level
  double getActivityFactor() {
    double activityFactor = 1; // Default activity factor
    switch (activity) {
      case 'Sedentary':
        activityFactor = 1.2;
        break;
      case 'Lightly Active':
        activityFactor = 1.375;
        break;
      case 'Moderately Active':
        activityFactor = 1.55;
        break;
      case 'Very Active':
        activityFactor = 1.725;
        break;
      case 'Extra Active':
        activityFactor = 1.9;
        break;
    }
    return activityFactor;
  }

  double calculateBMI() {
    double heightInMeter = height / 100; // Convert height from cm to m
    double bmi = weight / (heightInMeter * heightInMeter);
    return bmi;
  }

  String calculateAndDetermineBMI() {
    // Formula for BMI: weight (kg) / (height (m) * height (m))
    double heightInMeter = height / 100; // Convert height from cm to m
    double bmi = weight / (heightInMeter * heightInMeter);

    // Determine BMI category
    if (bmi < 16.0) {
      return 'Severely Underweight';
    } else if (bmi >= 16.0 && bmi < 16.9) {
      return 'Underweight';
    } else if (bmi >= 17.0 && bmi < 18.4) {
      return 'Mildly Underweight';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return 'Normal Weight';
    } else if (bmi >= 25.0 && bmi < 29.9) {
      return 'Overweight';
    } else if (bmi >= 30.0 && bmi < 34.9) {
      return 'Obesity class I\n    (Moderate)';
    } else if (bmi >= 35.0 && bmi < 39.9) {
      return 'Obesity class II\n   (severe)';
    } else {
      return 'Obesity class II\n   (Very severe)';
    }
  }

  // Method to calculate ideal weight for men
  double calculateIdealWeightForMen() {
    // Ideal weight formula for men: 48 + 1.1 * (height in cm - 150)
    return 48 + 1.1 * (height - 150);
  }

  // Method to calculate ideal weight for women
  double calculateIdealWeightForWomen() {
    // Ideal weight formula for women: 45 + 0.9 * (height in cm - 150)
    return 45 + 0.9 * (height - 150);
  }

  // Method to determine ideal weight based on gender
  double calculateIdealWeight() {
    if (gender == 'Male') {
      return calculateIdealWeightForMen();
    } else {
      return calculateIdealWeightForWomen();
    }
  }

  double calculateWaterIntake() {
    double baseWaterIntake = 30;
    double adjustedWaterIntake = baseWaterIntake;
    switch (activity) {
      case 'Sedentary':
        adjustedWaterIntake *= 1.0;
        break;
      case 'Lightly Active':
        adjustedWaterIntake *= 1.1;
        break;
      case 'Moderately Active':
        adjustedWaterIntake *= 1.2;
        break;
      case 'Very Active':
        adjustedWaterIntake *= 1.3;
        break;
      case 'Extra Active':
        adjustedWaterIntake *= 1.4;
        break;
      default:
        adjustedWaterIntake *= 1.0;
    }

    double recommendedWaterIntakeInMl = adjustedWaterIntake * weight;
    double recommendedWaterIntakeInLiters = recommendedWaterIntakeInMl / 1000;

    return recommendedWaterIntakeInLiters;
  }

  // Method to calculate optimal sleep duration
  String calculateOptimalSleepDuration() {
    // Define sleep duration recommendations based on age groups
    if (age <= 12) {
      return '9-12';
    } else if (age <= 19) {
      return '8-10';
    } else if (age <= 64) {
      return '7-9';
    } else {
      return '7-8';
    }
  }
}
