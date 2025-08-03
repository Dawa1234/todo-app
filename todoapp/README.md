# ✅ Todo App

A simple and structured **Todo application** built with Flutter, following **Clean Architecture** and the **Repository Pattern**. The app uses **Hive** for local storage and `flutter_bloc` for state management.

---

## 🔧 Tech Stack

- **Flutter Version**: `3.24.0`
- **Dart Version**: `3.5.0`
- **State Management**: BLoC
- **Local Storage**: Hive
- **Architecture**: Clean Architecture  
  - Divided into:
    - **UI Layer**: Screens, widgets, navigation
    - **Logic Layer**: BLoC, events, states
    - **Data Layer**: Models, Hive integration, repositories

---

## 🧱 Design Pattern

- **Repository Pattern**: abstracts data access logic from business logic
- State transitions are handled using **BLoC**

---

## 🚀 Getting Started

Follow these steps to run the app:

1. **Clone the repository**:
   ```bash
   git clone <your_repo_url>
   
2.  **Switch Flutter version (recommended)**:
    ```bash
    flutter version 3.24.0

3.  **Get Dependencies**:
    ```bash
    flutter pub get

4.  **Run the app**:
    ```bash
    flutter run

## 📁 Folder Structure
    lib/
    ├── config/              # Theme, constants, default sizes
    ├── helper/              # Utilities, extensions, shared widgets
    ├── src/
    │   └── home/
    │       ├── data/        # Hive models, repository implementation
    │       ├── bloc/        # BLoC logic, events, states
    │       └── presentation/ # UI layer
    └── main.dart

## 📦 Dependencies used

    flutter_bloc: ^9.1.1
    firebase_core: ^4.0.0
    shared_preferences: ^2.5.3
    hive: ^2.2.3
    drift: ^2.28.1
    go_router: ^15.1.2
    dio: ^5.8.0+1
    flutter_secure_storage: ^9.2.4
    connectivity_plus: ^6.1.4
    path_provider: ^2.1.5
    get_it: ^8.1.0
    uuid: ^4.5.1
    equatable: ^2.0.7
    intl: ^0.20.2

## 🧪 Testing
    This project supports unit and bloc testing using:

    flutter_test
    bloc_test
    mocktail

    To run tests:
    
    ```bash
    flutter test


