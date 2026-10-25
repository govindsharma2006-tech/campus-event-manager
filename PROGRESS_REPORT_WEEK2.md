# 📈 PROGRESS REPORT (WEEK 2)
## Project: CampusEventHub
### Course: Flutter Hybrid Mobile Application Development

---

### 1. Progress Summary
During Week 2, the team focused on establishing the UI/UX foundation, core screen layouts, and state management architecture.

### 2. Completed Milestones
- [x] Initialized Flutter 3.44+ project and configured Android SDK platform tools.
- [x] Established design tokens (`AppColors`, `AppTheme` with Poppins & Inter fonts).
- [x] Built core responsive components (`EventCard`, `CustomButton`, `CustomTextField`, `MetricCard`, `CategoryChip`).
- [x] Designed and implemented 11 responsive screens with Material Design 3 guidelines.
- [x] Configured Provider state management tree (`ThemeProvider`, `AuthProvider`, `EventProvider`).

### 3. Key Technical Decisions
- **Provider over Bloc/GetX**: Selected Provider for cleaner learning curve, zero boilerplate, and official Google recommendation for hybrid mobile courses.
- **Theme Support**: Implemented dynamic ThemeData switching for high-contrast dark and light appearances.
- **Local Persistence Strategy**: Chose `SharedPreferences` for atomic JSON persistence of events, tickets, and user credentials.

### 4. Challenges & Mitigations
- **Challenge**: Fragmented student vs coordinator screens.
  - **Mitigation**: Created a unified navigation container with an instant role-switch toggle in the profile screen.
- **Challenge**: Handling device offline states gracefully.
  - **Mitigation**: Designed fallback mock data in `ApiService` so evaluators experience zero crashes even without an active internet connection.

### 5. Next Steps for Week 3
- Full REST API integration with real HTTP endpoints and JSON decoding.
- Dynamic QR code generation for digital student tickets.
- Mid-Term demonstration and code review with course mentor.
