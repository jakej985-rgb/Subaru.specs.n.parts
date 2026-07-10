Version 0.1


---

# 1. Mission Statement

*Subaru Specs & Garage is an offline-first mobile app that helps Subaru owners manage their vehicles using accurate VIN decoding, factory specifications, maintenance tracking, and customizable vehicle data. The app is designed to be fast, reliable, and useful whether you're doing a simple oil change or building a fully modified project car.*


---

# 2. Core Principles


 * ✅ Offline-first

 * ✅ User owns their data

 * ✅ Factory data is never overwritten

 * ✅ User modifications are tracked separately

 * ✅ Every feature should reduce the number of taps

 * ✅ Speed is more important than flashy animations



---

# 3. Minimum Viable Product (MVP)

 * [ ] Add vehicle

 * [ ] VIN decode

 * [ ] Manual vehicle entry

 * [ ] Garage

 * [ ] Vehicle details

 * [ ] Maintenance tracking

 * [ ] Fluid specifications

 * [ ] Settings


> Everything else waits until after version 1.0.


---

# 4. Data Models

```text
Vehicles Models
└── Vehicle
    ├── VIN
    ├── Nickname
    ├── Year
    ├── Make
    ├── Model
    ├── Trim
    ├── Factory Specs
    ├── Current Specs
    ├── Maintenance
    ├── Photos
    └── Documents
'''

'''text
Maintenance Record
└── Maintenance
    ├── Date
    ├── Mileage
    ├── Category
    ├── Notes
    ├── Cost
    ├── Photos
    └── Receipts
```

---

# 5. Screen List

---

### 5.1 Home

#### Purpose:
 * *Give the user a quick overview of their selected vehicle.*

#### Widgets:

 * Change vehicle 
 * Current vehicle
 * Mileage
 * Upcoming maintenance
 * Quick actions

---

### 5.2 Garage:

#### Purpose:
 * *This page is for you to view cars in garage. Also able to view and edit records and engine/drivetrain if you have modified it.*

#### Widgets 

 * list all cars
 * view/edit cars motor/trans
 * view/edit records



---

# 6. Features

Each feature gets a short description.

VIN Decoder

Scan barcode

Manual VIN entry

Decode online

Allow editing after decoding

Save factory specs separately



---

# 7. Roadmap

Version 1.0

Garage

VIN

Maintenance


Version 1.5

Parts database

Torque specs


Version 2.0

Cloud sync

Shared garages