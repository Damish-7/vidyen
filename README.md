# VIDYEN Conference Portal — Complete Project Documentation

---

## Table of Contents
1. Project Overview
2. Tech Stack
3. Full Project Structure
4. Setup Guide (Step by Step)
5. Admin Panel Guide
6. Flutter App Guide
7. API Reference
8. Database Schema
9. User Flow
10. Troubleshooting

---

## 1. Project Overview

VIDYEN is a full-stack conference management portal with:
- A **Flutter mobile/web app** for conference participants
- A **PHP REST API** backend running on MAMP
- A **PHP Admin Panel** for organizers to manage abstracts and certificates
- A **MySQL database** (vidyen_db) for all data

---

## 2. Tech Stack

| Layer       | Technology                          |
|-------------|-------------------------------------|
| Frontend    | Flutter 3.x + GetX state management |
| Backend API | PHP 8.x (plain PHP, no framework)   |
| Admin Panel | PHP 8.x + vanilla HTML/CSS          |
| Database    | MySQL 8.x via MAMP                  |
| Local Server| MAMP (Apache + MySQL)               |
| HTTP Client | Flutter `http` package              |
| Session     | PHP sessions (admin) + SharedPreferences (app token) |

---

## 3. Full Project Structure

```
vidyen_api/                         ← Copy entire folder to MAMP htdocs/
├── index.php                       ← Main API router
├── .htaccess                       ← Clean URL rewriting
├── vidyen_db.sql                   ← Full database schema + seed data
├── config/
│   └── database.php                ← DB connection (PDO)
├── controllers/
│   ├── AuthController.php          ← Register, Login, Me
│   ├── AbstractsController.php     ← List, Submit abstracts
│   ├── PreConfController.php       ← Sessions, Register/Unregister
│   ├── WorkshopController.php      ← Workshops, Book/Cancel
│   ├── CertificatesController.php  ← List certs, Mark downloaded
│   └── HomeController.php          ← Dashboard stats
├── utils/
│   └── helpers.php                 ← CORS, token, respond(), sanitize()
└── admin/                          ← Admin panel (web browser)
    ├── login.php                   ← Admin login page
    ├── logout.php                  ← Clears session
    ├── index.php                   ← Dashboard with stats
    ├── abstracts.php               ← Review + accept/reject abstracts
    ├── certificates.php            ← Issue + manage certificates
    ├── users.php                   ← View all registered users
    ├── preconf.php                 ← Pre-conf registration lists
    ├── workshops.php               ← Workshop booking lists
    ├── config.php                  ← Admin auth + DB helper
    ├── layout.php                  ← Shared sidebar HTML
    └── assets/
        └── style.css               ← Admin panel dark theme CSS

vidyen_flutter/                     ← Flutter project root
├── pubspec.yaml
└── lib/
    ├── main.dart                   ← App entry point
    ├── controllers/
    │   ├── app_bindings.dart       ← GetX DI registration
    │   ├── auth_controller.dart    ← Login, Register, Logout
    │   ├── dashboard_controller.dart ← Bottom nav tab index
    │   ├── home_controller.dart    ← Fetch home stats
    │   ├── abstracts_controller.dart ← Fetch + filter abstracts
    │   ├── submit_abstract_controller.dart ← Submit form logic
    │   ├── preconf_controller.dart ← Sessions + register/cancel
    │   ├── workshop_controller.dart ← Workshops + book/cancel
    │   └── certificates_controller.dart ← Fetch + download certs
    ├── models/
    │   ├── user_model.dart
    │   ├── abstract_model.dart
    │   ├── preconf_model.dart
    │   ├── workshop_model.dart
    │   └── certificate_model.dart
    ├── services/
    │   ├── api_service.dart        ← Central HTTP client (GET/POST/PUT/DELETE)
    │   └── auth_service.dart       ← Login/Register + token via SharedPreferences
    ├── screens/
    │   ├── splash/splash_screen.dart
    │   ├── auth/login_screen.dart
    │   ├── auth/register_screen.dart
    │   ├── dashboard/dashboard_screen.dart
    │   ├── home/home_screen.dart
    │   ├── abstracts/abstracts_screen.dart
    │   ├── submit_abstract/submit_abstract_screen.dart
    │   ├── preconf/preconf_screen.dart
    │   ├── workshop/workshop_screen.dart
    │   └── certificates/certificates_screen.dart
    ├── utils/
    │   ├── app_colors.dart
    │   ├── app_theme.dart
    │   ├── app_routes.dart
    │   ├── app_constants.dart      ← baseUrl lives here
    │   └── responsive.dart         ← Mobile/Tablet/Desktop breakpoints
    └── widgets/
        ├── gradient_button.dart
        └── vidyen_text_field.dart
```

---

## 4. Setup Guide (Step by Step)

### Step 1 — Start MAMP
1. Open MAMP
2. Click **Start Servers**
3. Confirm Apache and MySQL are both green
4. Default ports: Apache = 8888, MySQL = 8889

### Step 2 — Copy PHP backend to htdocs
```
Copy the entire vidyen_api/ folder to:
/Applications/MAMP/htdocs/vidyen_api/
```
Final path should be:
```
/Applications/MAMP/htdocs/vidyen_api/index.php
/Applications/MAMP/htdocs/vidyen_api/admin/login.php
...
```

### Step 3 — Import the database
1. Open your browser → go to `http://localhost:8888/phpMyAdmin`
2. Click **Import** tab in the top menu
3. Click **Choose File** → select `vidyen_api/vidyen_db.sql`
4. Click **Go** at the bottom
5. You should see: "Import has been successfully finished"

This creates `vidyen_db` with all tables and demo data.

### Step 4 — Verify the API works
Open this URL in your browser:
```
http://localhost:8888/vidyen_api/
```
You should see:
```json
{"success": false, "message": "Route not found"}
```
That means the API is running correctly.

### Step 5 — Flutter setup
```bash
cd vidyen_flutter
flutter pub get
```

Add font files to `assets/fonts/`:
- `Sora-Regular.ttf`
- `Sora-SemiBold.ttf`
- `Sora-Bold.ttf`

Download from: https://fonts.google.com/specimen/Sora

Create empty asset folders:
```bash
mkdir -p assets/images assets/animations
```

### Step 6 — Run the Flutter app
```bash
flutter run
# For web:
flutter run -d chrome
```

### Step 7 — Physical device setup (optional)
If testing on a real phone, find your Mac's local IP:
```bash
ipconfig getifaddr en0
# e.g. 192.168.1.45
```
Then update `lib/utils/app_constants.dart`:
```dart
static const String baseUrl = 'http://192.168.1.45:8888/vidyen_api';
```
Also enable **Allow Arbitrary Loads** in your iOS `Info.plist` or Android `network_security_config.xml` for local HTTP.

---

## 5. Admin Panel Guide

### Accessing the Admin Panel
Open in your browser:
```
http://localhost:8888/vidyen_api/admin/login.php
```

### Login Credentials
```
Username: admin
Password: vidyen@2024
```

### Admin Panel Pages

#### Dashboard (`index.php`)
- Total users, abstracts, registrations, certificates at a glance
- Table of recent abstract submissions

#### Abstracts (`abstracts.php`)
- View all submitted abstracts with filter tabs: All / Pending / Accepted / Rejected
- Change any abstract's status using the dropdown + Save button
- Status changes are reflected instantly in the Flutter app

#### Certificates (`certificates.php`)
- **Issue Certificate** button → issue to a single specific user
  - Select user, type (Participation/Presenter/Workshop/Pre-Conf), event name, date
  - Certificate code is auto-generated
- **Bulk Issue** button → two options:
  - **Option 1**: Issue Participation certificates to ALL registered users at once
  - **Option 2**: Issue Workshop Completion certificates to all registrants of a specific workshop
- Once issued, certificates appear in the user's Certificates tab in the app immediately
- Delete any certificate if issued by mistake

#### Users (`users.php`)
- See all registered users with their name, email, institution
- See count of abstracts, pre-conf registrations, workshop bookings, and certificates per user

#### Pre-Conference (`preconf.php`)
- See all sessions with registration count and capacity bar
- Click "View List" to see all registered participants for any session

#### Workshops (`workshops.php`)
- Same as Pre-Conference but for workshops
- See booking count, capacity, and full participant list per workshop

---

## 6. Flutter App Guide

### Login Screen
- Enter your email OR username + password
- Demo credentials: `arjun.sharma@manipal.edu` / `password`
- Tap "Register" to create a new account

### Home Tab
- Welcome banner with your name and institution
- Live stats: accepted abstracts, pre-conf registrations, workshop bookings
- Quick access cards to all sections
- Conference schedule overview
- Pull to refresh stats

### Abstracts Tab
- View all abstracts with status (Accepted / Pending / Rejected)
- Filter by status using chips at the top
- **"+ Submit Abstract" floating button** (bottom right) to submit a new abstract
- After submitting, it appears as Pending — admin reviews and changes status

### Submitting an Abstract
1. Tap the teal **"+ Submit Abstract"** button on the Abstracts tab
2. Fill in:
   - **Title** — full research title
   - **Authors** — comma separated, e.g. "Smith J., Jones A."
   - **Institution** — your affiliated organization
   - **Category** — select from dropdown
   - **Presentation Type** — Oral or Poster (tap to toggle)
   - **Abstract Text** — minimum 100 characters (counter shown live)
3. Tap **Submit Abstract**
4. On success you are returned to Abstracts tab and the new entry appears

### Pre-Conference Tab
- Shows all pre-conference sessions with time, venue, speaker details
- Capacity progress bar (turns red when full)
- Tap **Register Now** to register, tap again to cancel
- Registration updates live in the admin panel

### Workshop Tab
- Same flow as Pre-Conference
- Shows workshop topics as tags
- Tap **Book My Seat** to register, tap again to cancel

### Certificates Tab
- Shows all certificates issued to your account
- Certificate code for verification
- Tap **Download Certificate** to mark it as downloaded
- Certificate types: Participation, Presenter, Workshop, Pre-Conference

---

## 7. API Reference

### Base URL
```
http://localhost:8888/vidyen_api
```

### Authentication
All endpoints except `/auth/login` and `/auth/register` require:
```
Authorization: Bearer <token>
```
Token is returned on login and stored in SharedPreferences.

### Endpoints

#### Auth
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/auth/register` | Create new account |
| POST | `/auth/login` | Login, returns token + user |
| GET | `/auth/me` | Get current user profile |

**Login request body:**
```json
{
  "identifier": "arjun.sharma@manipal.edu",
  "password": "password"
}
```
**Login response:**
```json
{
  "success": true,
  "data": {
    "token": "eyJ...",
    "user": {
      "id": 1,
      "name": "Dr. Arjun Sharma",
      "email": "arjun.sharma@manipal.edu",
      "username": "arjunsharma",
      "designation": "Associate Professor",
      "institution": "Manipal Academy"
    }
  }
}
```

#### Abstracts
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/abstracts` | List all abstracts (with stats) |
| GET | `/abstracts?status=accepted` | Filter by status |
| GET | `/abstracts?category=Oncology` | Filter by category |
| GET | `/abstracts/{id}` | Get single abstract |
| POST | `/abstracts` | Submit new abstract |

**Submit body:**
```json
{
  "title": "Your Research Title",
  "authors": "Smith J., Jones A.",
  "institution": "University Name",
  "category": "Oncology",
  "abstract_text": "Background: ... Methods: ... Results: ... Conclusion: ...",
  "presentation_type": "oral"
}
```

#### Pre-Conference
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/preconf` | List all sessions with user registration status |
| POST | `/preconf/{id}/register` | Register for session |
| DELETE | `/preconf/{id}/register` | Cancel registration |

#### Workshops
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/workshops` | List all workshops with user registration status |
| POST | `/workshops/{id}/register` | Book workshop seat |
| DELETE | `/workshops/{id}/register` | Cancel booking |

#### Certificates
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/certificates` | List current user's certificates |
| PUT | `/certificates/{id}/download` | Mark certificate as downloaded |

#### Home Stats
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/home/stats` | Returns counts for home screen |

---

## 8. Database Schema

```
vidyen_db
├── users                      ← Registered app users
│   ├── id, name, email, username
│   ├── password_hash (bcrypt)
│   ├── designation, institution, avatar
│   └── created_at
│
├── abstracts                  ← Research abstract submissions
│   ├── id, title, authors, institution
│   ├── category, abstract_text
│   ├── presentation_type (oral/poster)
│   ├── status (pending/accepted/rejected)
│   ├── submitted_by → users.id
│   └── submitted_at
│
├── preconf_sessions            ← Pre-conference sessions
│   ├── id, title, speaker, designation, description
│   ├── session_date, session_time, venue
│   └── max_participants
│
├── preconf_registrations       ← Junction: user ↔ session
│   ├── id, session_id → preconf_sessions.id
│   └── user_id → users.id
│
├── workshops                  ← Conference workshops
│   ├── id, title, facilitator, designation, description
│   ├── workshop_date, workshop_time, duration, venue
│   ├── topics (JSON array)
│   └── max_participants
│
├── workshop_registrations      ← Junction: user ↔ workshop
│   ├── id, workshop_id → workshops.id
│   └── user_id → users.id
│
└── certificates               ← Issued certificates
    ├── id, user_id → users.id
    ├── type (participation/presenter/workshop/preconf)
    ├── title, event_name, issued_at
    ├── certificate_code (unique)
    └── is_downloaded
```

---

## 9. User Flow

```
User opens app
    ↓
Splash screen (2.8s) → checks saved token
    ├── Token exists → Dashboard
    └── No token    → Login Screen
                          ↓
                    Enter email/username + password
                          ↓
                    API: POST /auth/login
                          ↓
                    Token saved to SharedPreferences
                          ↓
                    Dashboard (5 tabs)
                          │
          ┌───────────────┼───────────────────────┐
          ↓               ↓                       ↓
       Home Tab      Abstracts Tab          Pre-Conf Tab
    (stats, schedule) (filter + submit)   (register/cancel)
                          │
                    Submit Abstract
                    form screen
                          │
                    POST /abstracts
                          │
                    Admin sees in panel
                          │
                    Admin: Accept/Reject
                          │
                    User sees status update
                          │
                    Admin issues certificate
                          ↓
                    Certificates Tab shows it
                          ↓
                    User taps Download
```

---

## 10. Troubleshooting

### Admin login not working
**Symptoms:** Page reloads but stays on login, or blank page

**Fixes:**
1. Make sure MAMP is running (both Apache and MySQL green)
2. Visit exactly: `http://localhost:8888/vidyen_api/admin/login.php`
3. Use credentials: `admin` / `vidyen@2024`
4. Check PHP version in MAMP: go to `http://localhost:8888/MAMP/` → it should be PHP 8.x
5. If still not working, check if cookies/sessions are blocked in your browser
6. Try a different browser (Safari, Firefox, Chrome)
7. Clear browser cookies for localhost and try again

### API returning "Route not found"
- `.htaccess` rewriting is not working
- In MAMP → Preferences → PHP, ensure **Apache** is selected (not Nginx)
- In MAMP → Preferences → Apache, check that `mod_rewrite` is enabled

### Flutter app: "Network error. Check your connection and MAMP server"
- MAMP must be running before launching the app
- The base URL in `app_constants.dart` must match your MAMP port:
  ```dart
  static const String baseUrl = 'http://localhost:8888/vidyen_api';
  ```
- On physical device: use your Mac's local IP instead of `localhost`
- On Android emulator: use `http://10.0.2.2:8888/vidyen_api` instead of localhost

### GetX "improper use" red screen
- This means an `Obx` widget is not reading any `.obs` value directly inside it
- Fix: ensure every `Obx(() => ...)` reads at least one `.value` inside the builder function
- Never compute values outside Obx and pass them in as strings — always read `.value` inside

### Abstract text character count not updating
- Fixed in latest version: the `SubmitAbstractController` now uses a dedicated `charCount` RxInt
- Updated via `abstractTextController.addListener()` in `onInit()`
- The Obx for char count only reads `controller.charCount.value` — nothing else

### Database import fails
- Make sure `vidyen_db` does not already exist before importing
- In phpMyAdmin: drop the database first if it exists, then import the SQL file fresh

### Certificates not appearing in app after admin issues them
- The Certificates tab fetches from `GET /certificates` which filters by `user_id`
- Make sure you are logged in as the correct user the certificate was issued to
- Pull down on the Certificates tab to refresh

### Password for demo users
All seeded demo users have password: `password`

---

## Default Credentials Summary

| Access | Username / Email | Password |
|--------|-----------------|----------|
| Admin Panel | `admin` | `vidyen@2024` |
| App Demo User 1 | `arjun.sharma@manipal.edu` | `password` |
| App Demo User 2 | `priya.nair@aims.edu` | `password` |
| App Demo User 3 | `rahul.menon@iit.ac.in` | `password` |
| phpMyAdmin | `root` | `root` |

---

*VIDYEN Conference Portal — Built with Flutter + PHP + MySQL + MAMP*
