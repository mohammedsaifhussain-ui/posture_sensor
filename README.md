# PosturePulse 🧘‍♂️📡

PosturePulse is a cross-platform Flutter web dashboard for a BLE-enabled dual-IMU posture monitoring wearable. 

It connects to an ESP32 microcontroller equipped with two MPU6050 6-axis IMUs to track spinal curvature in real-time, delivering actionable ergonomic insights without cloud dependency.

## 🚀 Live Demo
Check out the live app here: **[https://mohammedsaifhussain-ui.github.io/posture_sensor/](https://mohammedsaifhussain-ui.github.io/posture_sensor/)**

*(Note: The demo uses a Mock BLE service generating sine-wave data so you can test the UI without the physical hardware).*

## ✨ Features
- **Real-time Telemetry**: 5 Hz updates of upper/lower spine deltas and net curvature.
- **Dynamic Gauge**: Visual status ring (GOOD, PENDING, ALERT) with buttery-smooth animations.
- **AI Training Wizard**: A 40-second guided flow to learn your personal slouch threshold.
- **Analytics**: Day/Week/Month views with hourly heatmaps and trend charts.
- **Local-First**: All data is stored locally on the device using SQLite (Drift). No cloud, no tracking.
- **Offline Support**: Full UI and historical data accessible even without a BLE connection.

## 🛠️ Tech Stack
- **Framework**: Flutter (Dart 3)
- **State Management**: Riverpod
- **Database**: Drift (SQLite) + WebAssembly for Web
- **Charts**: fl_chart
- **Routing**: go_router
- **BLE**: flutter_blue_plus

## 🧠 Hardware Architecture (ESP32)
The wearable uses a differential approach to cancel out whole-torso hip leaning (benign) and isolate true spinal slouching (harmful):
Δθ_curvature = Δθ_upper − Δθ_lower

- **Upper Sensor**: MPU6050 (I²C 0x68) at C7/T1 thoracic junction
- **Lower Sensor**: MPU6050 (I²C 0x69) at L3/L4 lumbar region

## 💻 Local Development
1. Clone the repo:
   git clone https://github.com/mohammedsaifhussain-ui/posture_sensor.git
2. Get dependencies:
   lutter pub get
3. Generate database code:
   dart run build_runner build
4. Run the app (Web):
   lutter run -d chrome

## 👥 Credits
- **Md Saif**
- **Deepak**
- **Bhargav**
- KLH University

---
*Disclaimer: PosturePulse is a non-diagnostic ergonomic habit-awareness tool. It is not intended to diagnose, treat, or prevent any medical condition.*
