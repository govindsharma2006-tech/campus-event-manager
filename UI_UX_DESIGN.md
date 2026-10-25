# 🎨 UI/UX DESIGN SPECIFICATION & SCREEN FLOW
## Project: CampusEventHub
### Course: Flutter Hybrid Mobile Application Development (Week 2 Deliverable)

---

### 1. Design Philosophy & Guidelines
CampusEventHub is built following **Material Design 3 (M3)** principles, focused on visual hierarchy, accessibility, and high engagement for college students:
- **Clean Micro-Interactions**: Animated button state transitions, card scaling, and smooth shimmer skeleton loaders.
- **Glassmorphism & Gradients**: Deep Indigo (`#4F46E5`) transitioning into Royal Violet (`#7C3AED`) for primary action cards.
- **Modern Typography**: Heading font `Poppins` for punchy headers and `Inter` for highly readable body text.
- **Theme Adaptability**: High-contrast Dark Mode (`#0F172A` background) and Crisp Light Mode (`#F8FAFC`).

---

### 2. Design Tokens & Color Palette
```
Primary Color:       #4F46E5 (Indigo 600 - Brand Leadership)
Primary Gradient:    LinearGradient(#4F46E5 -> #7C3AED)
Accent Color:        #06B6D4 (Cyan 500 - Secondary Highlights)
Success Green:       #10B981 (Confirmed Tickets & Status)
Amber Warning:       #F59E0B (Low Capacity Alerts)
Error Red:           #EF4444 (Validation & Deletion)
Surface Light:       #FFFFFF (Cards & Inputs)
Surface Dark:        #1E293B (Slate 800 for Dark Cards)
```

---

### 3. Screen Hierarchy & Navigation Architecture
```
                                 [ Splash Screen ]
                                         │
                         ┌───────────────┴───────────────┐
                         ▼                               ▼
                 [ Onboarding View ]             [ Main Nav Host ]
                         │                               │
                         ▼                               ├─► Tab 1: Student Home Dashboard
                 [ Auth (Login/Reg) ]                    ├─► Tab 2: Campus Venues Map
                                                         ├─► Tab 3: Live REST API News Feed
                                                         ├─► Tab 4: My Digital Passes Wallet
                                                         └─► Tab 5: Coordinator Desk / Profile
                                                                 │
                                                                 ├─► Event Creation / Edit Form (CRUD)
                                                                 ├─► Event Details & Pass Registration
                                                                 └─► QR Ticket Modal Preview
```

---

### 4. Detailed Screen Specifications

#### 1. Splash Screen (`lib/screens/splash_screen.dart`)
- **Visuals**: Fullscreen gradient with animated scaling circular university emblem and title.
- **Behavior**: Auto-restores existing user session from `SharedPreferences` within 2 seconds.

#### 2. Onboarding Screen (`lib/screens/onboarding_screen.dart`)
- **Visuals**: 3-slide animated carousel showcasing Event Discovery, Instant QR Pass, and Campus Maps.
- **Actions**: Dynamic page indicators (dots), "Skip", "Back", and "Get Started" buttons.

#### 3. Authentication & Role Switcher Screen (`lib/screens/auth_screen.dart`)
- **Tabs**: Tabbed layout for "Sign In" and "Register".
- **Form Controls**: RegEx email validation, password visibility toggle, role chips (Student vs Coordinator).
- **Reviewer Accelerator**: One-click "Student Demo" and "Coordinator Demo" buttons for fast evaluation.

#### 4. Home Dashboard Screen (`lib/screens/home_dashboard_screen.dart`)
- **Header**: Gradient welcome banner with personalized student greeting and role badge.
- **Stat Cards**: 3 Metric cards for Active Events, Registered Passes, and Bookmarked items.
- **Filter Row**: Horizontal category chips (All, Hackathon, Tech, Cultural, Sports, Workshop).
- **Search Bar**: Instant real-time query filtering by event title, club name, or venue.
- **Feed**: High-resolution event cards with capacity progress bar and bookmark toggle.

#### 5. Event Detail Screen (`lib/screens/event_detail_screen.dart`)
- **Hero Image**: Sliver collapsible cover image with category and fee badge overlays.
- **Venue & Timing Card**: Clean rows displaying formatted date, timing, hall name, and remaining seats.
- **Rules Section**: Bulleted guidelines and coordinator contact details.
- **Sticky Bottom Action**: "Register Now" (opens validated bottom sheet) or "View Digital Pass".

#### 6. Interactive Campus Venue Map (`lib/screens/campus_map_screen.dart`)
- **Custom Map Canvas**: CustomPainter rendering campus lawns, roads, and interactive venue pins.
- **Venue Specs**: Building, floor, seating capacity, and facility tags (Dolby, Smartboards, AC, WiFi).
- **Schedule Sync**: Displays all events scheduled specifically at the selected venue.

#### 7. Coordinator Dashboard (`lib/screens/organizer_dashboard_screen.dart`)
- **Metrics**: Total events, total student registrations, total campus capacity, and fill rate %.
- **Visual Analytics**: Interactive Bar Chart using `fl_chart` showing registrations per category.
- **CRUD Operations**: Edit button (in-place modification) and Delete button (with safety dialog).

#### 8. Event Creation & Edit Form (`lib/screens/event_form_screen.dart`)
- **Validation**: 10+ validated fields including title length, capacity numbers, phone/email formats.
- **Pickers**: Date picker dialog, time picker dialog, category and venue dropdowns.
- **Poster Presets**: Quick horizontal carousel of high-res campus fest poster images.

#### 9. My Tickets Screen (`lib/screens/my_tickets_screen.dart`)
- **Pass Cards**: Digital ticket with booking ID, event timestamp, venue, and attendee roll number.
- **Interactive QR Pass**: Tapping opens `QrTicketDialog` with a high-resolution scannable QR code.

#### 10. Live University Feed (`lib/screens/campus_news_screen.dart`)
- **REST API Integration**: Live notices streamed from REST endpoint with pull-to-refresh.
- **Shimmer Loaders**: Animated skeleton placeholders while network request executes.
- **Error States**: Dedicated offline retry container with network exception feedback.

#### 11. Profile Screen (`lib/screens/profile_screen.dart`)
- **Digital ID Card**: University identity card layout with student avatar, RFID chip icon, and roll no.
- **Theme Mode**: Instant Dark/Light mode toggle.
- **Role Switcher**: Quick toggle between Student and Coordinator experience.
