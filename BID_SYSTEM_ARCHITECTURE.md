messagae icnon and serch box ka bhi messagae icnon and serch box ka bhi # Naka Bid System Architecture

## 📋 Current State

### Existing Components
- **JobHomeScreen**: Main dashboard showing jobs (Workers) or workers (Contractors)
- **JobDetailsPage**: Job details display with "आवेदन करें" (Apply) button
- **BidModel.dart**: Data model for bids
- **PlaceBidScreen**: Worker interface to place bids (DISABLED)
- **JobBidsListScreen**: Contractor view to manage bids (DISABLED)

---

## 🎯 New Architecture

### Data Model Enhancement

```
Job {
  - id
  - title
  - company
  - salary
  - location
  - workersNeeded
  - daysRequired
  - description
  + allowBids: boolean    // NEW
  + bidStatus: String    // "active", "closed"
}

Bid {
  - id
  - jobTitle
  - workerName
  - bidAmount
  - daysRequired
  - message
  - status: "pending", "accepted", "rejected"
  - bidDate
  + jobId: String        // NEW - link to job
  + allowedByJob: boolean // NEW
}
```

---

## 🔄 Complete Flow

### Worker Flow (बोली लगाने वाले)
```
JobHomeScreen 
  ↓
JobDetailsPage
  ├─ If allowBids == true
  │  └─ "बोली लगाएं" Button
  │     └─ PlaceBidScreen
  │        └─ Save to SharedPreferences
  └─ If allowBids == false
     └─ "बोलियाँ बंद हैं" Message

My Bids Screen (NEW)
  ├─ "मेरी लगाई गई बोलियाँ" Tab
  │  └─ List all bids placed by worker
  │     └─ Status: pending, accepted, rejected
  └─ Filter by status
```

### Contractor Flow (काम post करने वाले)
```
Post Job Screen (NEW/MODIFIED)
  ├─ Job Title
  ├─ Salary
  ├─ Location
  ├─ Duration
  ├─ Description
  └─ 🔘 "Bids की अनुमति दें" Toggle (NEW)
     └─ Save Job with allowBids flag

My Jobs Screen (NEW)
  └─ List all posted jobs
     ├─ Job Info
     ├─ Bid Count Badge
     └─ View Bids Button
        └─ JobBidsListScreen
           ├─ Pending Bids
           ├─ Accept/Reject Buttons
           └─ Status updates
```

---

## 📄 Screens to Create/Modify

### 1. **PostJobScreen.dart** (CREATE NEW)
```dart
Purpose: Create new job with bid settings

Fields:
- jobTitle (TextEditingController)
- salary (TextEditingController)
- location (TextEditingController)
- workersNeeded (TextEditingController)
- daysRequired (TextEditingController)
- description (TextEditingController)
- allowBids (Switch Toggle) ← NEW

Features:
✓ Form validation
✓ Save to JSON/database
✓ Show success message
✓ Navigate back to home
```

### 2. **MyJobsScreen.dart** (CREATE NEW)
```dart
Purpose: Contractor view all posted jobs

Displays:
- List of contractor's posted jobs
- For each job:
  ├─ Job title
  ├─ Salary
  ├─ Location
  ├─ Posted date
  ├─ 📊 Bid count badge
  ├─ Bid status (allowBids flag)
  └─ "View Bids" Button → JobBidsListScreen

Features:
✓ Load from SharedPreferences
✓ Filter by active/closed
✓ Delete job option
✓ Edit job option (optional)
```

### 3. **MyBidsScreen.dart** (CREATE NEW)
```dart
Purpose: Worker view all placed bids

Tabs:
- "मेरी बोलियाँ" (My Bids)
  ├─ All (pending + accepted + rejected)
  ├─ Pending (बोली का इंतज़ार)
  ├─ Accepted (✅ स्वीकृत)
  └─ Rejected (❌ अस्वीकृत)

For each bid:
├─ Job title
├─ Company name
├─ Bid amount
├─ Days required
├─ Status badge
└─ Timestamp

Features:
✓ Load from SharedPreferences
✓ Filter by status
✓ Search functionality
✓ Withdraw bid option (pending only)
```

### 4. **JobDetailsPage.dart** (MODIFY)
```dart
Current: Simple job details with "आवेदन करें" button

Changes:
IF (allowBids == true)
  └─ Show "बोली लगाएं" button
     └─ PlaceBidScreen
ELSE
  └─ Show "बोलियाँ बंद हैं" message
```

### 5. **PlaceBidScreen.dart** (ENABLE & MODIFY)
```dart
Already created, just needs:
✓ Remove LocaleProvider imports
✓ Verify no undefined properties
✓ Test with JobDetailsPage
```

### 6. **JobBidsListScreen.dart** (ENABLE & MODIFY)
```dart
Already created, just needs:
✓ Remove LocaleProvider imports
✓ Filter by job ID (new feature)
✓ Test with MyJobsScreen
```

---

## 🗄️ Data Storage (SharedPreferences)

```json
{
  "user_role": "Worker/Contractor",
  
  "user_jobs": [
    {
      "id": "uuid-1",
      "title": "Mobile App Development",
      "salary": "₹50,000",
      "location": "Delhi",
      "workersNeeded": "2",
      "daysRequired": "30",
      "description": "...",
      "allowBids": true,
      "createdDate": "2026-02-02",
      "status": "active"
    }
  ],
  
  "user_bids": [
    {
      "id": "uuid-bid-1",
      "jobId": "uuid-1",
      "jobTitle": "Mobile App Development",
      "workerName": "राज कुमार",
      "bidAmount": 45000,
      "daysRequired": 28,
      "message": "I can do this...",
      "status": "pending",
      "bidDate": "2026-02-02"
    }
  ]
}
```

---

## 📱 Navigation Updates

### Add to MainScreen / EntryPoint
```dart
BottomNavigationBar:
├─ Home (existing)
├─ Post Job (NEW) → PostJobScreen
├─ My Jobs (NEW) → MyJobsScreen (if Contractor)
├─ My Bids (NEW) → MyBidsScreen (if Worker)
├─ Messages
├─ Profile
```

---

## ✅ Implementation Checklist

### Phase 1: Foundation
- [ ] Create PostJobScreen.dart
- [ ] Modify JobDetailsPage to check allowBids flag
- [ ] Update storage model

### Phase 2: Worker Features
- [ ] Enable PlaceBidScreen.dart
- [ ] Create MyBidsScreen.dart
- [ ] Add navigation to bottom bar

### Phase 3: Contractor Features
- [ ] Enable JobBidsListScreen.dart
- [ ] Create MyJobsScreen.dart
- [ ] Add navigation to bottom bar

### Phase 4: Polish
- [ ] Error handling
- [ ] Validation
- [ ] Testing
- [ ] UI refinements

---

## 🎨 UI Components

### Bid Status Badges
```
Pending:   ⏳ Orange badge
Accepted:  ✅ Green badge
Rejected:  ❌ Red badge
```

### Toggle Switches
```
Allow Bids: 🔘 ON/OFF
Active Jobs: 🔘 ON/OFF
```

---

## 🔐 Validation Rules

**PostJobScreen:**
- ✓ All fields required
- ✓ Salary > 0
- ✓ Workers needed > 0
- ✓ Days required > 0

**PlaceBidScreen:**
- ✓ Bid amount > 0
- ✓ Days required > 0
- ✓ Cannot bid on own jobs
- ✓ One bid per worker per job (optional)

**JobBidsListScreen:**
- ✓ Only show bids for own jobs
- ✓ Can only accept/reject pending bids
- ✓ Cannot modify accepted/rejected

---

## 🚀 Future Enhancements

1. **Bid History**: Track all bid activities
2. **Payment Integration**: Handle payments
3. **Ratings**: Worker and Contractor ratings
4. **Negotiations**: Counter-bid feature
5. **Analytics**: Bid statistics for contractors
6. **Notifications**: Real-time bid updates

---

**Ready to start coding? Let's build! 💪**
