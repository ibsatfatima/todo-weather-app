# Todo Weather App
 
It combines a **To-Do List** with a **Weather Dashboard**, following feature-first structure, state management with **BLoC**, and local persistence using **Hive**.

I’ve organized the app using a feature-first structure. All cross-cutting concerns like themes and reusable widgets are in core/. Each major feature: Auth, To-Do, Weather has its own folder under features/, containing its Bloc, data, and UI. This keeps related code together, makes the app easier to scale, and follows clean architecture practices. Finally, main.dart is just the entry point where I wire up the app

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

## App UI

<p float="left">
<img src="https://github.com/user-attachments/assets/b361c5a4-23fd-436d-9cc2-cfb9c66632aa"  width=300 height=600>&emsp;&emsp;  
<img src="https://github.com/user-attachments/assets/5e1c62aa-bd24-4d94-9190-d09b6c70bae3"  width=300 height=600>&emsp;&emsp; 
<img src="https://github.com/user-attachments/assets/b6f38e92-e53a-43fa-b008-1f7e774f3a14"  width=300 height=600>&emsp;&emsp; 
 <img src="https://github.com/user-attachments/assets/a7d99de3-1f02-48ae-9048-2a2ce18ade73"  width=300 height=600>&emsp;&emsp;
  <img src="https://github.com/user-attachments/assets/72b93b68-18cd-4e27-b2d1-ca8920e2fcf4"  width=300 height=600>;
</p>

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

##  📂 Project Structure

```bash
lib/
 ├── core/               # Shared theme, widgets, utils
 ├── features/
 │   ├── auth/           # Authentication (login)
 │   ├── todo/           # To-Do list feature
 │   └── weather/        # Weather dashboard feature
 └── main.dart           # Entry point
