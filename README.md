# 📖 Yesterdays

<p align="center">
  <b>A minimal, iOS 18 Liquid Glass-inspired daily journal with an enforced 100-word daily rule.</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.10+-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter Badge" />
  <img src="https://img.shields.io/badge/Architecture-Clean%20MVVM-007AFF?style=for-the-badge" alt="MVVM Architecture" />
  <img src="https://img.shields.io/badge/Privacy-100%25%20Offline-34C759?style=for-the-badge" alt="Privacy Badge" />
  <img src="https://img.shields.io/badge/License-MIT-FF9500?style=for-the-badge" alt="License Badge" />
</p>

---

## 🌟 Overview

**Yesterdays** is a minimal, elegant personal journaling app built for users who want to build a disciplined habit of writing down their life story every single day. 

To turn daily reflection into a lasting habit, **Yesterdays** introduces a strict **100-Word Rule**: if you haven't recorded at least 100 words for yesterday's experience, an hourly reminder notification will sound until yesterday's entry is complete. Tapping the notification takes you directly to yesterday's editor screen.

---

## ✨ Features

- 🍷 **iOS 18 Liquid Glass UI/UX**: Designed around Apple's modern translucent glass design system—featuring frosted glass floating capsule navigation bars, optical backdrop blurs, specular rim reflections, and an animated ambient liquid background mesh.
- ⏱️ **The 100-Word Daily Rule**: Requires writing at least 100 words for each day's entry. Includes live progress meters and word counters.
- 🔔 **Yesterday Reminder Alarms**: Scheduled hourly notifications alert you when yesterday's entry remains under 100 words. (Rule activates automatically after your first saved log entry).
- 🔤 **Custom Quicksand Typography**: Integrated with local `Quicksand` font weights (`Light`, `Regular`, `Medium`, `SemiBold`, `Bold`) for clean, elegant rounded text formatting across the entire app.
- 🏆 **Streak Tracker**: Real-time streak tracking to reward your consistent daily journaling.
- 🛡️ **100% Offline & Private**: All history logs are stored locally on your device in SQLite. No accounts, no cloud sync, zero tracking.

---

## 🏗️ Architecture & Technology Stack

**Yesterdays** is built using **Feature-First Clean Architecture (MVVM)** to ensure scalable, testable, and maintainable code:

- **Framework**: [Flutter](https://flutter.dev) (Cupertino Widgets)
- **State Management**: [Riverpod (`flutter_riverpod`)](https://riverpod.dev)
- **Local Database**: [SQLite (`sqflite`)](https://pub.dev/packages/sqflite)
- **Notifications & Alarms**: [`flutter_local_notifications`](https://pub.dev/packages/flutter_local_notifications)
- **Icons**: [`hugeicons`](https://pub.dev/packages/hugeicons)
- **Typography**: Local Asset Font (`Quicksand`)

### Directory Structure

```
lib/
├── core/
│   ├── database/        # SQLite helper and table schemas
│   ├── notifications/   # Local notification & hourly alarm service
│   ├── theme/           # iOS Liquid Glass design system, painters, & mesh background
│   └── utils/           # Date formatters and word count algorithms
├── features/
│   └── daily_history/
│       ├── data/        # Datasources and Repository implementation
│       ├── domain/      # Immutable models and repository contracts
│       └── presentation/# Riverpod providers, screens, and glass widgets
└── main.dart
```

---

## 🚀 Getting Started

### Prerequisites

Ensure you have the following installed on your machine:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>= 3.10.0`)
- Android Studio / VS Code with Flutter plugins
- Android SDK (Target SDK API 34+)

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/inogami-dev/Yesterdays.git
   cd Yesterdays
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the application**:
   ```bash
   flutter run
   ```

---

## 🧪 Testing & Code Quality

Run static code analysis and unit tests:

```bash
# Run Linter
flutter analyze

# Run Unit Tests
flutter test
```

---

## 📄 License

Distributed under the **MIT License**. See `LICENSE` for details.
