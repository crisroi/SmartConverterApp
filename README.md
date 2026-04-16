# smart_utility_toolkit_app

A Flutter app that combines unit converters and a task manager in one clean, dark-themed interface.

---

## Features

### Converters
- **Currency** — live exchange rates via `open.exchangerate-api.com` with offline fallback
- **Weight** — kg, lb, g, oz, and more
- **Length** — m, ft, cm, in, and more

### Task Manager
- **Create** tasks with an optional note
- **Complete** tasks with an animated checkbox
- **Edit** tasks (swipe right on any card)
- **Delete** tasks (swipe left on any card)
- **Persistent offline storage** — tasks survive app restarts via `shared_preferences`
- Separate views for **Active** and **Completed** tasks
- **Clear all** completed tasks at once

---

## Navigation

```
Home
├── Converters
│   ├── Currency
│   ├── Weight
│   └── Length
└── Tasks
    ├── Active Tasks   (+FAB to add)
    └── Completed Tasks
```

---

## Tech Stack

| Package | Purpose |
|---|---|
| `flutter 3.24` | Framework |
| `provider` | State management |
| `shared_preferences` | Local persistent storage |
| `http` | Live currency API calls |
| `google_fonts` | Poppins typography |
| `flutter_animate` | Entrance animations |
| `flutter_native_splash` | Launch splash screen |
| `intl` | Number formatting |

---

## Getting Started

### Prerequisites
- Flutter 3.24+
- Dart 3.x
- Android Studio / VS Code with Flutter plugin

### Run locally

```bash
git clone https://github.com/YOUR_USERNAME/smart_converter_app.git
cd smart_converter_app
flutter pub get
flutter run
```

### Build release APK

```bash
flutter build apk --release
```

The APK will be at `build/app/outputs/flutter-apk/app-release.apk`.

---

## Project Structure

```
lib/
├── main.dart
├── app.dart
├── constants/
│   ├── length_units.dart
│   └── weight_units_model.dart
├── models/
│   ├── task_model.dart
│   └── exchange_rate_model.dart
├── providers/
│   └── task_provider.dart
├── screens/
│   ├── home_screen.dart
│   ├── converters/
│   │   ├── converter_hub_screen.dart
│   │   ├── currency_screen.dart
│   │   ├── weight_screen.dart
│   │   └── length_screen.dart
│   └── tasks/
│       ├── tasks_hub_screen.dart
│       ├── active_tasks_screen.dart
│       └── completed_tasks_screen.dart
├── services/
│       └── currecy_service.dart
├── utils/
        ├── length_converter.dart
│       └── weight_converter.dart
└── widgets/
    ├── task_card.dart
    ├── converter_card.dart
    ├── screen_header.dart
    ├── unit_dropdown.dart
    └── add_task_sheet.dart
```

---

## Design

- Background: `#0F0F1A`
- Surface/Card: `#1A1A2E`
- Converters accent: `#00BFA5` (teal)
- Tasks accent: `#E91E8C` (rose)
- Length accent: `#FFB300` (amber)
- Font: Poppins (Google Fonts)
