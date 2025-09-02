# Todo Weather App
 
It combines a **To-Do List** with a **Weather Dashboard**, following clean architecture, state management with **BLoC**, and local persistence using **Hive**.

---

## ✨ Features

### 🔑 Authentication
- Simple login screen (dummy user: `test / 1234`)
- Basic local validation
- Navigates to dashboard on success

### 📋 To-Do List
- Add tasks with **title + description**
- Mark tasks as complete/incomplete
- Persist tasks locally with **Hive**
- Pull-to-refresh support
- Smooth UI animations for adding/removing tasks

### 🌤 Weather Dashboard
- Fetches live weather using **OpenWeatherMap API**
- Shows **city name, temperature, and condition icon**
- Pull-to-refresh support
- Search weather by city
- Fallback option to get **current location weather**

### 🎨 UI & Theming
- Material 3 inspired design
- Light & Dark mode support
- Custom snackbar for success/error messages
- Custom Textfield and button widgets

### 🧪 Testing
- Added **unit tests** for To-Do repository (add/remove)
- Easily extendable for widget & integration testing

---

## 🛠️ Tech Stack

- **Flutter**
- **Dart**
- **Bloc (flutter_bloc)** → State management
- **Hive** → Local persistence
- **Dio** → API integration
- **flutter_screenutil** → Responsive UI
- **OpenWeatherMap API** → Weather data
- **mocktail + flutter_test** → Unit testing
  
---

## Instructions to run the code

- Install dependencies
  ```bash
  flutter pub get
- Generate Hive adapters (if not already generated)
```bash
 flutter packages pub run build_runner build
- Set up API key for weather
- Create a .env file or use Flutter defines
- Add your OpenWeatherMap API key
```bash
 flutter run --dart-define=OWM_API_KEY=your_api_key_here
  
---

## 📂 Project Structure

```bash
lib/
 ├── core/               # Shared theme, widgets, utils
 ├── features/
 │   ├── auth/           # Authentication (login)
 │   ├── todo/           # To-Do list feature
 │   └── weather/        # Weather dashboard feature
 └── main.dart           # Entry point
