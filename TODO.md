# SkillLink Gap Analysis Implementation Plan

## Approved Phases (UI Freeze: No .aspx/CSS changes)

### Phase 1: Database Schema Alignment [COMPLETE]
- [ ] Align/rename tables (Services1 → Services)
- [ ] Add PortfolioImages table
- [ ] Add PaymentStatus to Bookings/Orders
- [ ] Update BasePage.cs with new DB helpers (e.g., HasRated, SendNotification stub)

### Phase 2: Mock Payment Integration [COMPLETE]
- [ ] Booking.aspx.cs: Add 'Paid' status trigger after form submit
- [ ] Admin.aspx.cs: Real commission calc on 'Paid' orders
- [ ] Test transaction flow (Pending → Paid → Completed)

### Phase 4: Reviews/Verification [COMPLETE]
- [ ] Enforce reviews only post-'Completed' status
- [ ] Home.aspx.cs: Add price min/max, rating filters

### Phase 5: Functional Shells [COMPLETE]
- [ ] Chat.aspx.cs: Implement DB-driven messaging (GetMessages, SendMessage)
- [ ] ForgotPassword.aspx.cs: Add email reset logic (mock SMTP)

## Skip: Phase 3 (Notifications)

**Next Step**: Complete Phase 1 → Mark as done → Phase 2

**Testing**: After each phase: Local run, DB verify inserts, Azure deploy test.

