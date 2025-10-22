# Mock Data System for Brivida Development

## Overview

The Brivida app includes a comprehensive mock data system that provides realistic test data during development. This system is **completely invisible in production** builds and only operates in debug/development mode.

## Features

### 🎭 Mock Data Types
- **Jobs**: 3 realistic cleaning jobs (house, office, vacation rental)
- **Leads**: 4 interconnected leads for pro users to accept/reject
- **Calendar Events**: 4 scheduled appointments matching accepted leads
- **Pro Profiles**: 3 professional cleaner profiles with different specialties

### 🔧 Debug Controls
- **Debug Panel**: Floating bug icon (top-right) opens mock data controls
- **Reinitialize**: Recreate all mock data with fresh IDs
- **Clear All**: Remove all mock data from Firestore
- **Environment Info**: Shows current environment and debug status

### 🛡️ Safety Features
- **Environment Detection**: Only works when `Environment.isDevelopment == true`
- **Debug Mode Only**: Requires `kDebugMode == true` to be visible
- **Data Flagging**: All mock data has `isMockData: true` flag for filtering
- **Clean Production**: Zero mock data interference in production builds

## Usage

### Development Workflow

1. **Start App**: Mock data automatically initializes on app startup
2. **View Data**: Navigate to Jobs, Leads, or Calendar to see mock entries
3. **Test Flows**: Accept leads, view calendar events, manage bookings
4. **Debug Panel**: Tap the red bug icon to access mock data controls
5. **Refresh Data**: Use "Reinitialize" to get fresh mock data with new IDs

### Mock Data Relationships

```
Mock Job #1 → Mock Lead #1 → Mock Calendar Event #1
Mock Job #2 → Mock Lead #2 → Mock Calendar Event #2
Mock Job #3 → Mock Lead #3 → Mock Calendar Event #3
             Mock Lead #4 (pending, no calendar event yet)
```

### Environment Requirements

Mock data only appears when **ALL** conditions are met:
- `Environment.isDevelopment == true`
- `kDebugMode == true` (Flutter debug build)
- Firebase emulator or development project

## Implementation Details

### File Structure
```
lib/core/
├── services/
│   ├── mock_data_service.dart          # Core mock data creation
│   └── app_initialization_service.dart  # App startup with mock data
├── widgets/
│   └── mock_data_debug_widget.dart     # Debug UI panel
└── config/
    └── environment.dart                # Environment detection

features/
├── jobs/data/jobs_repo.dart           # Jobs with mock filtering
├── leads/data/leads_repo.dart         # Leads with mock filtering
└── calendar/data/calendar_repo.dart   # Calendar with mock filtering
```

### Data Filtering
Each repository automatically filters mock data based on environment:

```dart
// Development: Shows real + mock data
// Production: Shows only real data
if (Environment.isDevelopment) {
  // Include mock data in streams
}
```

### Mock Data Structure

#### Jobs
- **House Cleaning**: 120m² home, €80 budget
- **Office Cleaning**: 200m² office space, €150 budget  
- **Vacation Rental**: 80m² apartment, €60 budget

#### Leads
- Connected to mock jobs with realistic pro responses
- Different states: pending, accepted, completed
- Proper timestamps and pro profile references

#### Calendar Events
- Scheduled appointments for accepted leads
- Realistic time slots and durations
- Proper job and lead references

#### Pro Profiles
- **Maria Silva**: House specialist, premium pricing
- **Hans Mueller**: Office expert, competitive rates
- **Sophie Laurent**: Eco-friendly focus, mid-range

## Testing

### Manual Testing
1. Build in debug mode: `flutter run --debug`
2. Check mock data visibility in Jobs/Leads/Calendar
3. Test accepting leads and calendar scheduling
4. Use debug panel to reinitialize/clear data

### Automated Testing
```bash
flutter test test/mock_data_test.dart
```

### Production Verification
1. Build release mode: `flutter build apk --release`
2. Verify NO mock data appears
3. Verify NO debug panel appears
4. Test only real data flows work

## Troubleshooting

### Mock Data Not Appearing
- Check `Environment.isDevelopment` returns `true`
- Verify running in debug mode (`flutter run --debug`)
- Check Firebase connection and auth state
- Look for error logs in debug console

### Debug Panel Not Visible
- Confirm `kDebugMode == true`
- Verify `Environment.isDevelopment == true`
- Check if floating action button is hidden behind other UI

### Data Conflicts
- Use "Clear All" in debug panel to remove mock data
- Restart app to reinitialize fresh mock data
- Check Firestore rules allow mock data operations

## Security Notes

### Production Safety
- Mock data creation is **impossible** in production builds
- Environment detection prevents accidental mock data
- Firestore rules can optionally block `isMockData: true` writes in production

### Development Security
- Mock data includes realistic but fake personal information
- No real customer data is used in mock entries
- All mock users have `mock_` prefix in IDs

## Future Enhancements

### Planned Features
- **Scenario Presets**: Different mock data scenarios (busy day, conflicts, etc.)
- **User Targeting**: Mock data for specific user types (customer vs pro)
- **Time Controls**: Mock data for different time periods (past, future)
- **A/B Testing**: Multiple mock data variants for testing

### Integration Opportunities
- **Onboarding Tours**: Use mock data for guided app tutorials
- **Screenshot Generation**: Consistent data for app store screenshots
- **Demo Mode**: Show mock data to potential customers/investors

---

## Quick Start Checklist

✅ **Setup Complete**: Mock data system is fully implemented  
✅ **Debug Panel**: Red bug icon provides mock data controls  
✅ **Data Relationships**: Jobs → Leads → Calendar events are connected  
✅ **Environment Safety**: Only works in debug/development mode  
✅ **Production Clean**: Zero impact on production builds  

**Ready to test!** Run the app in debug mode and explore the mock data system.