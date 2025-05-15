# Dermatology Support and Information Mobile Application

This project aims to develop a mobile application where users can get information about skin diseases and facilitate the diagnostic process of dermatologists. The project consists of two main parts :

1. **Dermatology Diagnostic Support System**: To help dermatologists diagnose skin diseases more accurately.
2. **User Information and Product Recommendation System**: Providing users with information about skin diseases and making appropriate product recommendations.

## Screenshots

<div style="display: flex; justify-content: center; gap: 10px; margin-top: 20px;">
  <img src="screenshots/app4.png" style="width:400px; height:500px; object-fit: cover;" alt="Product Recommendations" />
  <img src="screenshots/app1.jpg" style="width:400px; height:500px; object-fit: cover;" alt="Login Screen" />
  <img src="screenshots/app2.jpg" style="width:400px; height:500px; object-fit: cover;" alt="Disease Detection Screen" />
  <img src="screenshots/app3.jpg" style="width:400px; height:500px; object-fit: cover;" alt="Disease Prediction" />
</div>


## Project Structure

- `deritespit_flutter/`: Flutter mobile app codes.
- `deripython_api/`: Python API codes.


## Installation

### Flutter App

1. Install Flutter SDK: [Flutter Install](https://flutter.dev/docs/get-started/install)
2. `flutter_app` dizinine gidin:
    ```sh
    cd flutter_app
    ```                           
3. Install the required packages:
    ```sh
    flutter pub get
    ```
4. Run the application:
    ```sh
    flutter run
    ```

### Python API

1. Install Python and pip. Install the Flutter SDK:
2. `python_api` dizinine gidin:
    ```sh
    cd python_api
    ```
3. Install required dependencies:
    ```sh
    pip install -r requirements.txt
    ```
4. Run the API:
    ```sh
    python app.py
    ```

## Usage

Once the app is opened, users can take a new photo or upload an existing photo from the gallery to detect skin diseases. The uploaded photo is analyzed using the AI-powered Inception V3 model. The model is trained to classify skin diseases with high accuracy. Furthermore, the visual background is removed with the remove.bg API to reduce the noise in the background of the photo and improve the accuracy of disease detection. Thus, the model focuses only on the diseased area on the skin. The user can get detailed information about the predicted disease and access direct product links by viewing recommended products for the disease.
