# 📊 PRESENTATION SLIDES OUTLINE (PowerPoint Ready)
## Project: CampusEventHub — Smart Campus Event Lifecycle Platform
### Course: Flutter Hybrid Mobile Application Development

---

### Slide 1: Title Slide
- **Title**: CampusEventHub
- **Subtitle**: Smart Campus Event Lifecycle & Fest Management Platform
- **Course**: Flutter Hybrid Mobile Application Development
- **Team Size**: 5 Members
- **Presented To**: Project Review Board & Mentors
- **Date**: Academic Session 2026

---

### Slide 2: Problem Identification & Need
- **The University Dilemma**: Over 150+ club events, guest seminars, hackathons, and sports trials take place every semester.
- **Pain Points**:
  - Information fragmentation across WhatsApp and social media.
  - Paper passes and manual attendance lead to gate congestion.
  - No single source of truth for venue locations and schedule changes.
  - Lack of centralized participation analytics for campus leadership.

---

### Slide 3: Proposed Solution — CampusEventHub
- A cross-platform Flutter application providing:
  - **Dual Dashboards**: Student Discovery Desk & Organizer Admin Console.
  - **Instant Registration & QR Pass**: Digital passes with scannable QR verification.
  - **Campus Geo-Venue Locator**: Interactive campus map with amenities and route details.
  - **Live University Notices**: Real-time REST API integration.
  - **Full Offline Persistence**: Powered by `SharedPreferences` local storage.

---

### Slide 4: System Architecture & Technology Stack
- **Frontend Framework**: Flutter 3.44+ & Dart 3.12+ (Single Codebase for Android, iOS & Web)
- **State Management**: Provider (Separation of Concerns: Models, Services, Providers, Screens)
- **Local Storage**: `SharedPreferences` for user session, offline events, and ticket wallet.
- **REST API Networking**: HTTP client with timeout handling and offline fallback mechanisms.
- **Visuals & Charting**: `fl_chart` for registration analytics, `qr_flutter` for entry badges.
- **Design System**: Material Design 3 with Google Fonts (Poppins & Inter) and Dark/Light themes.

---

### Slide 5: Core Application Modules (11 Screens)
1. **Splash & 3-Slide Interactive Onboarding**
2. **Authentication**: Role-based access (Student vs Club Coordinator) with quick-demo reviewer logins.
3. **Student Exploration Dashboard**: Real-time search, category chips, and live metric cards.
4. **Event Details & Form Validation**: Team registration, dynamic capacity counter, rules & contact desk.
5. **Interactive Campus Venue Map**: GPS campus pins, seating limits, and indoor directions.
6. **Coordinator CRUD Console**: Add, modify, and delete campus events with instant feedback.
7. **Digital Ticket Wallet**: Verified QR entry passes and registration cancellation.
8. **Live University Bulletin**: REST API news feed with pull-to-refresh and shimmer skeletons.
9. **Student ID & Profile Desk**: Digital university ID card, theme switcher, and role toggle.

---

### Slide 6: Database & Local Persistence Flow
```
User Action (Register / Create Event)
       │
       ▼
EventProvider / AuthProvider
       │
       ├──► Updates In-Memory State (Instant UI Re-render)
       │
       └──► StorageService (Serializes to JSON in SharedPreferences)
                 │
                 ├──► Key: 'campus_user_data'
                 ├──► Key: 'campus_custom_events'
                 ├──► Key: 'campus_user_registrations'
                 └──► Key: 'campus_theme_mode'
```

---

### Slide 7: REST API Integration & Error Resilience
- **API Endpoint**: University live announcements stream (`https://jsonplaceholder.typicode.com/posts`).
- **Resilience Strategy**:
  - 8-second network timeout.
  - Status code validation (`200 OK`).
  - Graceful fallback seed data for zero-downtime offline demonstrations.
  - Animated Shimmer skeleton cards during network fetches.

---

### Slide 8: Demonstration Highlights
- **Real-Time CRUD**: Creating a new hackathon immediately reflects on both dashboards.
- **Digital Ticketing**: Instant generation of QR codes upon form submission.
- **Live Theme Toggle**: Instant transition between Light and Dark mode without data loss.
- **Role Switching**: Instant toggling between Student and Coordinator views for mentor evaluation.

---

### Slide 9: Project Evaluation & Rubric Mapping
| Rubric Item | Weight | Project Fulfillment |
| :--- | :--- | :--- |
| **Problem Innovation** | 10 Marks | Solves collegiate event chaos with QR passes & campus mapping |
| **Project Planning** | 5 Marks | Strict 4-week SDLC sprints with weekly milestones |
| **UI/UX Design** | 15 Marks | Material 3, Dark Mode, Google Fonts, Shimmer Loaders |
| **Flutter Development** | 20 Marks | 11 Screens, Provider Architecture, Form Validation |
| **App Functionality** | 15 Marks | End-to-end bug-free workflows, unit tested |
| **API & Database** | 10 Marks | REST API HTTP client + SharedPreferences CRUD storage |
| **Code Quality & Git** | 10 Marks | Effective Dart styling, zero lint errors, GitHub commits |
| **Documentation & Viva** | 15 Marks | Full Reports, Demo Video Script, Slide Deck |

---

### Slide 10: Conclusion & Q&A
- **Key Takeaways**: Complete mastery of Flutter UI, Provider state management, local database persistence, and asynchronous REST APIs.
- **Future Scope**: Direct Firebase Cloud Messaging push notifications, online payment gateway (UPI/Razorpay), and turn-by-turn AR navigation.
- **Thank you! Questions and comments are welcomed.**
