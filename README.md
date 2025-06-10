# 🌿 SkinOptix – Smart Acne Detection App

![Flutter](https://img.shields.io/badge/Flutter-v3.0-blue?logo=flutter)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![Status](https://img.shields.io/badge/Status-Active-yellow)
![Platform](https://img.shields.io/badge/Platform-Android-blue?logo=android)

> 👨‍⚕️ *Your personal skincare assistant powered by AI and Flutter.*

---

## 📱 Overview

SkinOptix is a mobile application that detects **acne skin conditions** using **machine learning**. It helps users identify acne types, assess severity, and get treatment tips — all through their smartphone camera!

This app bridges the gap in dermatological care by bringing **real-time skin analysis**, **on-device ML processing**, and **telemedicine support** to your fingertips.

---

## ✨ Key Features

- 🤖 **ML-Powered Acne Detection** – Built using TensorFlow Lite & CNNs  
- 📷 **Real-time Image Analysis** – Snap or upload photos of your skin  
- 🔐 **Private On-Device Processing** – No images stored online  
- 📚 **Educational Skincare Database** – Learn about causes & treatments  
- 🧑‍💻 **Flutter Cross-Platform App** – Runs smoothly on Android devices  


---

## 📸 Screenshots

<p align="center">
  <img src="screenshots/login.png" width="200"/>
  <img src="screenshots/scan.png" width="200"/>
  <img src="screenshots/result.png" width="200"/>
</p>

---

## ⚙️ Tech Stack

| Technology      | Description                          |
|------------------|--------------------------------------|
| Flutter          | UI Framework for cross-platform app  |
| Dart             | Programming language for Flutter     |
| TensorFlow Lite  | On-device ML inference               |
| Firebase         | Authentication & Storage             |
| CNN Model        | Image classification for acne types  |

---

## 🛠️ Installation

### 📋 Requirements

- ✅ Flutter SDK `3.0+`  
- ✅ Android Studio or VS Code  
- ✅ Firebase Project (with `google-services.json`)  

### 🚀 Setup Steps

```bash
# 1. Clone the repo
git clone https://github.com/your-username/SkinOptix.git
cd SkinOptix

# 2. Install dependencies
flutter pub get

# 3. Add Firebase config
# Place google-services.json in android/app/

# 4. Run the app
flutter run
