# RetinaScan AI

Premium Flutter healthcare application for AI-powered diabetic retinopathy screening.

## Features

- **Premium UI/UX** — ShadCN-inspired design with glassmorphism, gradients, and smooth animations
- **Retina Capture** — Professional camera interface with alignment guides and quality indicators
- **AI Analysis** — Animated multi-step processing pipeline with progress tracking
- **Diagnostic Reports** — Comprehensive results with risk gauges, confidence meters, and recommendations
- **Patient Management** — Search, filter, and manage patient records
- **Dashboard Analytics** — Animated charts, statistics, and severity distribution
- **Dark Mode** — Full light/dark theme support with dynamic switching
- **Clean Architecture** — Feature-first folder structure with Riverpod state management

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter (Dart) |
| State Management | Riverpod |
| Navigation | GoRouter |
| Typography | Google Fonts (Inter) |
| Animations | Flutter Animate |
| Charts | FL Chart |
| Architecture | Clean Architecture, Feature-first |

## Project Structure

```
lib/
├── core/           # Config, theme, routes, models, repositories
├── features/       # Feature modules (auth, dashboard, camera, etc.)
├── widgets/        # Reusable UI components
├── animations/     # Shared animation presets
└── utils/          # Helpers and responsive utilities
```

## Getting Started

### Prerequisites

- Flutter SDK 3.24+ ([Install Flutter](https://docs.flutter.dev/get-started/install))
- Android Studio / Xcode for device emulation
- VS Code or Android Studio with Flutter extensions

### Setup

```bash
cd "Diabetic Retinopathy"
flutter pub get
flutter run
```

### Demo Login

Use any email/password on the login screen (e.g. `doctor@retinacare.org` / `password`).

## Screens

| Screen | Description |
|--------|-------------|
| Splash | Animated brand intro |
| Login | Secure authentication |
| Dashboard | Overview stats, charts, recent scans |
| Patients | Patient list with search |
| Camera | Retina capture with alignment overlay |
| AI Processing | 7-step animated analysis pipeline |
| Results | Full diagnostic report |
| Reports | Historical scan reports |
| Profile | Doctor profile and statistics |
| Settings | Theme, notifications, preferences |

## Color Palette

| Token | Hex |
|-------|-----|
| Primary | `#2563EB` |
| Secondary | `#0EA5E9` |
| Accent | `#22C55E` |
| Success | `#16A34A` |
| Warning | `#F59E0B` |
| Danger | `#DC2626` |

## License

Proprietary — RetinaScan AI © 2026
