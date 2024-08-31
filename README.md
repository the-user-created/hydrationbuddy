# Hydration Buddy

Hydration Buddy is a simple Flutter-based Android application designed to help users track their 
daily water intake. The app allows users to set a daily water intake goal, log the amount of 
water they consume, and track their progress toward meeting their goal.

## Features
* **Set Daily Water Intake Goal:** Users can set a personalized daily water intake goal in milliliters.
* **Track Water Consumption:** Log water intake in increments of 200 ml, 500 ml, or 750 ml. 
* **Progress Visualization:** A progress bar shows how close users are to meeting their daily goal.
* **Reset Water Consumption:** Reset your water consumption progress at any time. 
* **Congratulatory Notifications:** Receive a congratulatory message when you reach your daily goal.

## Getting Started
### Prerequisites
To build and run this app, you'll need:
* [Flutter SDK](https://flutter.dev/docs/get-started/install)
* [Android Studio](https://developer.android.com/studio) or another IDE with Flutter support

### Installation
1. Clone the repository:
    ```sh
    git clone https://github.com/the-user-created/hydrationbuddy.git
    cd hydrationbuddy
    ```
2. Install dependencies:
    ```sh
    flutter pub get
    ```
3. Run the app:
    ```sh
    flutter run
    ```

### Building the APK
To build the APK for release:
```sh
flutter build apk --release
```
The output APK will be located in the `build/app/outputs/flutter-apk/` directory.

## CI/CD Pipeline
The project is configured to use GitHub Actions for Continuous Integration and Continuous Deployment (CI/CD). The pipeline:
* Runs tests on every push to the main branch.
* Checks if the app version has changed before proceeding with build and deployment steps to reduce unnecessary computational usage.
* Builds an APK artifact. 
* Automatically signs the APK during the build process.
* Automatically creates a release on GitHub when a new app version is merged into the main branch.

### GitHub Actions Workflow
The CI/CD pipeline is defined in the `flutter.yml` file, which includes steps to:

* Checkout the repository.
* Check if the app version has changed to reduce unnecessary builds.
* Set up Flutter.
* Install dependencies.
* Run tests.
* Build APK.
* Sign the APK automatically during the build process using the stored keystore in GitHub Secrets.
* Archive the build artifact.
* Create a release on GitHub with the signed APK.

## Project Structure
* `lib/main.dart`: The main entry point of the application. 
* `lib/providers/hydration_provider.dart`: Contains the logic for tracking water intake and managing goals. 
* `test/`: Contains unit tests and widget tests for the application.

## Dependencies
This project relies on the following packages:
* [provider](https://pub.dev/packages/provider): State management for the app.
* [shared_preferences](https://pub.dev/packages/shared_preferences): Persistent storage of user data, such as daily goals and water consumption.

For a complete list of dependencies, refer to the `pubspec.yaml` file.

## License
This project is licensed under the BSD-3-Clause License. For more information, see the [LICENSE](LICENSE) file.

## Contributing
Contributions are welcome! Please fork this repository, create a new branch, and submit a pull request.

---

If you have any questions or feedback, feel free to open an issue or reach out directly.

Happy hydrating! 💧