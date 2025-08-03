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
   cd todo_app
