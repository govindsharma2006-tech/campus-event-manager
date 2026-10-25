# 📄 PROJECT PROPOSAL
## Course: Flutter Hybrid Mobile Application Development
### Project Title: CampusEventHub — Smart Campus Event Lifecycle & Fest Management Platform

---

### 1. Executive Summary
University campuses host vibrant student activities including technical hackathons, cultural festivals, academic symposiums, coding bootcamps, and inter-collegiate sports championships. However, event discovery and management remain fragmented across unstructured communication channels. **CampusEventHub** is an all-in-one Flutter hybrid mobile application designed to bridge the communication gap between university event organizers and students. Featuring real-time event discovery, seat-capacity tracking, digital QR-code pass generation, interactive campus venue mapping, and live university notice boards, the application streamlines the entire campus event lifecycle.

---

### 2. Problem Statement & Motivation
#### Key Challenges Identified:
1. **Scattered Information**: Students frequently miss registration deadlines because notices are dispersed across WhatsApp chats, notice boards, and departmental mailing lists.
2. **Paper-Based Ticketing & Long Entry Queues**: Manual paper tickets and sign-in sheets lead to congestion at venue entry gates and permit unauthorized entry.
3. **Inefficient Club Management**: Student clubs lack tools to track real-time seat availability, announce last-minute schedule/room changes, or gauge attendee interest.
4. **Wayfinding Difficulties**: External college participants and newly admitted students struggle to locate specific laboratories, conference halls, and auditoriums.

#### Target Audience:
- **Undergraduate & Postgraduate Students**: Effortless event discovery, bookmarking, and instant digital pass generation.
- **Student Club Coordinators & Societies**: Complete CRUD tools to create, schedule, publish, edit, and manage registrations.
- **Faculty Conveners & Campus Administration**: High-level analytics on student participation and capacity utilization.

---

### 3. Project Objectives
- To design a responsive, modern Flutter application adhering to Material Design 3 guidelines.
- To implement dual-dashboard architectures catering to both **Students** and **Club Organizers**.
- To incorporate local database persistence via `SharedPreferences` for offline-first capabilities.
- To integrate live REST API endpoints for university notifications with error handling and shimmer loaders.
- To generate digital entry passes equipped with dynamic QR codes.
- To provide an interactive Campus Venue Map with facility specifications and directions.

---

### 4. Proposed Technology Stack
- **Framework**: Flutter (Channel Stable 3.44+)
- **Language**: Dart 3.12+
- **Architecture**: Provider-based State Management (Separation of Concerns / Clean Pattern)
- **Local Storage**: `shared_preferences` (Session, Bookmarks, Events, Passes)
- **Networking**: `http` (REST API Client, JSON serialization)
- **Typography & UI**: `google_fonts` (Poppins & Inter), custom Material 3 color palettes
- **Ticketing & Visualization**: `qr_flutter` (Digital Entry Passes), `fl_chart` (Analytics Dashboard)
- **Version Control**: Git & GitHub

---

### 5. Functional Modules
1. **Authentication & Role-Based Access Module**: Student, Club Coordinator, and Guest roles with secure state handling.
2. **Event Discovery & Filter Engine**: Search by title, venue, club name, and categories (Tech, Cultural, Sports, Hackathon, Workshop).
3. **Event Management (CRUD) Module**: Full organizer dashboard for creating, modifying, and deleting campus events.
4. **Digital Ticketing & Pass Module**: Real-time seat reservation, cancellation, and dynamic QR pass preview.
5. **Campus Map & Venue Locator**: Map pins, seating capacities, building/floor specs, and scheduled sessions.
6. **Live University Bulletin (REST API)**: Network-resilient circulars and announcements feed.
7. **Analytics & Reporting Desk**: Bar charts illustrating category distributions and student turnout.

---

### 6. Timeline & Sprint Planning (4 Weeks)
- **Week 1**: Requirements Analysis, Problem Identification, Architecture Design, Proposal & Slides Submission.
- **Week 2**: UI/UX Wireframing, Material Design System, Core Screens Scaffolding, Progress Report.
- **Week 3**: State Management with Provider, CRUD Persistence, REST API Networking, Mid-Term Review Live Demo.
- **Week 4**: QR Ticketing, Analytics Charts, Unit & Widget Testing, APK Compilation, Final Project Report & Viva.
