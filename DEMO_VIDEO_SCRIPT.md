# 🎬 VIDEO DEMONSTRATION SCRIPT & WALKTHROUGH
## Project: CampusEventHub
### Course: Flutter Hybrid Mobile Application Development (Final Video Submission)

> **Target Duration**: 4 to 6 Minutes  
> **Target Audience**: Course Evaluator / Mentor / External Examiner  
> **Speaker Roles**: Team Members 1 through 5

---

### Segment 1: Introduction & Problem Statement (0:00 - 0:45)
- **Visual**: Title screen showing `CampusEventHub` logo, team names, and course details.
- **Narrator**: "Welcome to our final project presentation for Flutter Hybrid Mobile Application Development. Our project is **CampusEventHub**, a smart campus event lifecycle and fest management platform designed to solve the problem of fragmented student notices, paper tickets, and organizer inefficiency."
- **Visual**: App launches into `SplashScreen` showing smooth circular logo expansion and routing into `OnboardingScreen`.

---

### Segment 2: Onboarding & Authentication with Role-Based Access (0:45 - 1:30)
- **Visual**: Swiping through the 3 animated onboarding slides (Explore, Instant QR Pass, Interactive Venues).
- **Narrator**: "New students are greeted with an interactive walkthrough of features. Next, we arrive at the Authentication screen."
- **Action**: Tap on the quick **"Student View"** demo review button.
- **Narrator**: "Notice our quick review access chips built specifically for mentors. With one tap, we log in as student Aarav Sharma, with full session persistence via `SharedPreferences`."

---

### Segment 3: Student Experience Dashboard & Event Discovery (1:30 - 2:30)
- **Visual**: Home Dashboard displaying live metric cards (Active Events, Confirmed Passes, Saved Bookmarks).
- **Narrator**: "The student dashboard gives real-time metrics on campus activities. Students can filter events by category—such as Hackathons, Tech, Cultural, and Sports—or use the instant search bar to find events like 'HackNova'."
- **Action**: Tap on the category chip **"Hackathon"**, then type "AI" in the search bar.
- **Narrator**: "Search results filter dynamically with zero lag. Let's tap on the HackNova 2026 event card."

---

### Segment 4: Event Details, Form Validation & Digital QR Pass (2:30 - 3:30)
- **Visual**: `EventDetailScreen` showcasing the hero image, organizer badge, venue specs, and rules.
- **Action**: Scroll to bottom and tap **"Register Now"**.
- **Narrator**: "The registration bottom sheet automatically populates the student's name, roll number, and department. Students can specify their team name and team size."
- **Action**: Fill in team name `ByteForce`, select team size `4`, and tap **"Confirm & Generate Pass"**.
- **Visual**: `QrTicketDialog` pops up with the dynamic scannable QR code and unique ticket ID.
- **Narrator**: "Instantly, a digital pass with a cryptographic QR code is generated. This pass is saved to local storage and accessible offline in the My Passes tab."

---

### Segment 5: Campus Geo-Venue Locator (3:30 - 4:15)
- **Action**: Navigate to the **"Venues"** tab.
- **Visual**: Custom-painted interactive campus map with venue pins (Auditorium, Turing Lab, Amphitheatre, Sports Arena).
- **Narrator**: "Here is our Campus Venue Locator. Tapping on any venue pin displays its building, floor, seating capacity, facility amenities like Dolby Sound or WiFi 6, and a list of all events currently scheduled at that location."

---

### Segment 6: Live University REST API Feed (4:15 - 4:45)
- **Action**: Navigate to the **"Live News"** tab and pull down to refresh.
- **Visual**: Animated Shimmer skeleton cards appear during the HTTP fetch, followed by live circulars.
- **Narrator**: "The Live News module integrates with a remote REST API to fetch real-time university notices, complete with animated shimmer loaders and offline fallback protection."

---

### Segment 7: Club Coordinator Console & Full CRUD Operations (4:45 - 5:30)
- **Action**: Open Profile, toggle the **"Active App View"** switch to Coordinator Desk, and navigate to the Desk tab.
- **Visual**: Organizer dashboard showing registration metrics and an interactive `fl_chart` bar graph.
- **Action**: Tap **"+ Add Event"**, fill out the validated form with a new event, and hit **"Publish"**.
- **Narrator**: "In the Coordinator Console, organizers can track participation analytics using bar charts and execute full CRUD operations: creating, editing, and deleting events with immediate UI updates."

---

### Segment 8: Conclusion & Wrap-up (5:30 - 5:45)
- **Visual**: Profile screen showing the digital student ID card, theme switcher, and app version details.
- **Action**: Toggle **Dark Mode Appearance** on and off to show dynamic Material 3 theming.
- **Narrator**: "CampusEventHub satisfies 100% of the course rubric requirements across UI design, state management, local database persistence, and API networking. Thank you!"
