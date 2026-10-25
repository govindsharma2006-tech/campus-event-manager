# 🎓 CampusEventHub — Smart Campus Event & Fest Management Platform

[![Flutter](https://img.shields.io/badge/Flutter-3.44.4-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12.2-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-Academic%20Project-green.svg)](#)
[![Status](https://img.shields.io/badge/Build-Passing-brightgreen.svg)](#)

> **Course**: Flutter Hybrid Mobile Application Development  
> **Assessment**: Classroom Continuous Assessment (CCA) + Final Project Evaluation (100 Marks)  
> **Team Size**: 5 Members (Team Leader, UI/UX Designer, Flutter Developer, Backend/API Developer, QA & Documentation Lead)

---

## 📌 Executive Summary & Problem Statement

In colleges and universities, hundreds of events—hackathons, technical workshops, cultural galas, guest lectures, and sports tournaments—are organized by student clubs and faculty departments every semester. However, institutions face systemic challenges:
1. **Fragmented Communication**: Notices are scattered across WhatsApp groups, notice boards, and unofficial social media pages.
2. **Clumsy Ticketing & Attendance**: Long entry queues, lost paper passes, and lack of QR-verified gate checks.
3. **Organizer Inefficiency**: Club coordinators struggle with Google Forms, manual seat tracking, and schedule updates.
4. **Campus Navigation Issues**: Students and external visitors struggle to locate specific halls, auditoriums, and labs.

**CampusEventHub** provides a unified, cross-platform mobile ecosystem featuring dual dashboards for **Students** and **Club Coordinators**, interactive **Campus Venue GPS mapping**, **Digital QR ticketing**, **Local Persistence (CRUD)**, **Live University REST API feed**, and **Dark/Light Material 3 Design**.

---

## 📱 Core Features & Rubric Compliance

| Rubric Requirement | Implementation in CampusEventHub | Location in Codebase |
| :--- | :--- | :--- |
| **Minimum 6 Screens** | **11 Production Screens** (Splash, Onboarding, Auth, Student Dashboard, Event Details, Venue Map, Passes, Coordinator Desk, Event Create/Edit Form, Live API Feed, Profile) | `lib/screens/` |
| **Responsive UI & Material 3** | Adaptive layouts, Google Fonts (Poppins & Inter), HSL gradients, Glassmorphic cards, Dark & Light themes | `lib/constants/app_theme.dart` |
| **Navigation** | Animated `NavigationBar`, sliver collapsible headers, modal sheets, tab controllers, named transitions | `lib/screens/main_nav_screen.dart` |
| **Forms with Validation** | Multi-field Login, Registration, Event Creation, and Attendee forms with RegEx, date/time pickers, capacity limiters | `lib/screens/event_form_screen.dart`, `lib/screens/auth_screen.dart` |
| **CRUD Operations** | **Create** event, **Read** (instant search & categories), **Update** details/time/venue, **Delete** with confirmation | `lib/providers/event_provider.dart` |
| **Local Storage** | `SharedPreferences` persisting authentication session, created events, tickets, bookmarks, and theme mode | `lib/services/storage_service.dart` |
| **REST API Integration** | Real-time HTTP client fetching campus notices from public endpoints with timeout, JSON decoding, and offline fallback | `lib/services/api_service.dart`, `lib/screens/campus_news_screen.dart` |
| **Error Handling & Loaders** | Network exception catches, empty state illustrations, custom animated shimmer skeleton loaders | `lib/widgets/shimmer_loading.dart` |
| **Digital QR Pass** | Real-time dynamic QR code generation for gate entry and ticket verification | `lib/widgets/qr_ticket_dialog.dart` |
| **Campus Venue Map** | Interactive campus map layout with GPS pins, room directions, amenities, and venue schedule | `lib/screens/campus_map_screen.dart` |
| **Analytics Charts** | Visual bar chart breakdown of event registrations and fill rates using `fl_chart` | `lib/screens/organizer_dashboard_screen.dart` |
| **Dual Role Architecture** | Seamless toggle between **Student Experience** and **Club Coordinator Desk** | `lib/providers/auth_provider.dart` |

---

## 🏗️ Architecture & Project Structure

```
lib/
├── main.dart                          # App Entry Point & Provider Setup
├── constants/
│   ├── app_colors.dart                # Brand Palette, Accents, Gradients
│   └── app_theme.dart                 # Material 3 Light & Dark Theme Definitions
├── models/
│   ├── event_model.dart               # Event Data Model with Capacity & Rules
│   ├── registration_model.dart        # Digital Pass Model with QR Payload
│   ├── venue_model.dart               # Campus Venue Coordinates & Amenities
│   ├── news_model.dart                # Live Notice Model for REST API
│   └── user_model.dart                # Student & Coordinator User Profiles
├── services/
│   ├── storage_service.dart           # SharedPreferences Persistence Layer
│   ├── api_service.dart               # REST API HTTP Client with Fallbacks
│   └── notification_service.dart      # In-App Notification & Alert Manager
├── providers/
│   ├── auth_provider.dart             # Role Management & Auth State
│   ├── event_provider.dart            # Core CRUD Engine & Ticket Controller
│   └── theme_provider.dart            # Light / Dark Mode Controller
├── widgets/
│   ├── event_card.dart                # Card with Image, Badges & Fill Progress
│   ├── custom_button.dart             # Gradient Button with Loading Indicator
│   ├── custom_text_field.dart         # Validated Input Fields
│   ├── category_chip.dart             # Interactive Filter Chips
│   ├── metric_card.dart               # Dashboard Metric & Stat Cards
│   ├── shimmer_loading.dart           # Skeleton Loaders
│   └── qr_ticket_dialog.dart          # QR Pass Generator & Attendee Details
└── screens/
    ├── splash_screen.dart             # Animated Logo & Session Check
    ├── onboarding_screen.dart         # 3-Slide Interactive Walkthrough
    ├── auth_screen.dart               # Sign In, Registration & Demo Fast-Logins
    ├── main_nav_screen.dart           # Persistent Navigation & Notification Sheet
    ├── home_dashboard_screen.dart     # Student Exploration & Live Campus Metrics
    ├── event_detail_screen.dart       # Event Specs, Rules & Registration Sheet
    ├── campus_map_screen.dart         # Interactive Campus Venue Locator & Pins
    ├── organizer_dashboard_screen.dart# Coordinator CRUD Desk & Chart Analytics
    ├── event_form_screen.dart         # Create & Edit Event Validated Form
    ├── my_tickets_screen.dart         # Digital Pass Wallet & QR Preview
    ├── campus_news_screen.dart        # Live University REST API Feed
    └── profile_screen.dart            # Digital Student ID Card & View Switcher
```

---

## 🚀 Getting Started & Installation

### Prerequisites
- Flutter SDK (v3.20.0 or higher)
- Dart SDK (v3.4.0 or higher)
- Android Studio / VS Code with Flutter extension
- Google Chrome (for web testing) or Android device / emulator

### Step 1: Clone Repository
```bash
git clone https://github.com/govindsharma2006-tech/bridgeLab-Assignment.git
cd bridgeLab-Assignment
```

### Step 2: Install Dependencies
```bash
flutter pub get
```

### Step 3: Run the Application
- **On Google Chrome (Web)**:
  ```bash
  flutter run -d chrome
  ```
- **On Android Device / Emulator**:
  ```bash
  flutter run
  ```

### Step 4: Run Static Analysis & Tests
```bash
flutter analyze
flutter test
```

---

## 📦 Deliverables & APK Location

- **Android Debug APK**: `build/app/outputs/flutter-apk/app-debug.apk`
- **Web Build Bundle**: `build/web/`
- **Week 1 Proposal**: `PROJECT_PROPOSAL.md`
- **Week 1 PPT Slides**: `PRESENTATION_SLIDES.md`
- **Week 2 UI/UX Design**: `UI_UX_DESIGN.md`
- **Week 2 Progress Report**: `PROGRESS_REPORT_WEEK2.md`
- **Week 3 Mid-Term Review**: `MID_TERM_REVIEW.md`
- **Week 4 Final Project Report**: `FINAL_PROJECT_REPORT.md`
- **Video Demonstration Script**: `DEMO_VIDEO_SCRIPT.md`

---

## 👥 Team Members & Suggested Roles

1. **Student 1 (Team Leader)**: Project Management, Provider State Architecture, System Integration.
2. **Student 2 (UI/UX Designer)**: Material 3 Design System, Color Tokens, Responsive Layouts.
3. **Student 3 (Flutter Developer)**: Screens Development, Form Validations, QR Ticket Generation.
4. **Student 4 (Backend & API Developer)**: REST API Integration, JSON Serialization, SharedPreferences Local Storage.
5. **Student 5 (QA & Documentation Lead)**: Unit Testing, Widget Testing, Academic Reports, Slide Presentation.

---

## 📄 License
Academic Course Project — Developed for Flutter Hybrid Mobile Application Development Course.
