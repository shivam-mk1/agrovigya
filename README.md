# Agrovigya

A Flutter-based mobile application designed to assist farmers with various agricultural activities. Agrovigya provides tools for crop recommendation, labor estimation, weather forecasting, and information on government schemes.

## Features

- **Crop Recommendation:** Suggests suitable crops based on soil and weather conditions.
- **Labor Estimation:** Helps in estimating the labor required for different farming tasks.
- **Weather Forecasting:** Provides real-time weather updates and forecasts.
- **Government Schemes:** Information about relevant government schemes for farmers.
- **Multi-language Support:** Available in English, Hindi, Marathi, Bengali, and Oriya.
- **Authentication:** Secure user authentication using Firebase (Email/Password and Google Sign-In).

## Technologies Used

- **Frontend:** Flutter
- **Backend:** Firebase (Authentication)
- **State Management:** Provider
- **Routing:** go_router
- **HTTP:** http package
- **Geolocation:** geolocator and geocoding
- **Localization:** flutter_localization

## Getting Started

### Prerequisites

- Flutter SDK: [Installation Guide](https://flutter.dev/docs/get-started/install)
- A code editor like VS Code or Android Studio.

### Installation

1.  Clone the repository:
    ```sh
    git clone https://github.com/your-username/agrovigya.git
    ```
2.  Navigate to the project directory:
    ```sh
    cd agrovigya
    ```
3.  Install the dependencies:
    ```sh
    flutter pub get
    ```
4.  Run the app:
    ```sh
    flutter run
    ```

## Project Structure

```
lib/
├───models/         # Data models
├───providers/      # State management providers
├───repositories/   # Data repositories
├───services/       # Business logic and services
├───utils/          # Utility functions and widgets
├───viewmodels/     # ViewModels for the UI
├───views/          # UI screens and widgets
└───main.dart       # App entry point
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.