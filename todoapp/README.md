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
    ```bash
    lib/
    ├── config/              # Theme, constants, default sizes
    ├── helper/              # Utilities, extensions, shared widgets
    ├── src/
    │   └── home/
    │       ├── data/        # Hive models, repository implementation
    │       ├── bloc/        # BLoC logic, events, states
    │       └── presentation/ # UI layer
    └── main.dart



