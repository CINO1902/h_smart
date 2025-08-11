# Smart Token Refresh Observer System

## Overview
This system implements a smart observer that continuously monitors JWT access token age and automatically refreshes tokens before they expire (13 minutes), even while the user is actively using the app.

## Key Features
- **Continuous Monitoring**: Observes token age in real-time while app is active
- **Smart Scheduling**: Calculates exact time until token expiry and schedules refresh accordingly
- **Proactive Refresh**: Refreshes tokens 30 seconds before expiry to prevent interruptions
- **Background Monitoring**: Continues monitoring even when user is actively using the app

## Components

### 1. TokenRefreshService (Singleton)
**Location**: `lib/core/service/token_refresh_service.dart`

**Key Methods**:
- `startTokenRefresh(container)`: Starts the smart token observer
- `stopTokenRefresh()`: Stops all token monitoring
- `_startTokenObserver()`: Core observer logic that monitors token age
- `_scheduleTokenRefresh()`: Schedules refresh based on token creation time
- `_performTokenRefresh()`: Executes the actual token refresh

### 2. AuthController (Updated)
**Location**: `lib/features/auth/presentation/controller/auth_controller.dart`

**Key Methods**:
- `startTokenRefreshObserver()`: Starts the smart observer
- `stopTokenRefreshObserver()`: Stops the observer
- `setContainer()`: Sets the Riverpod container for dependency injection
- `reactivateAccessToken()`: Performs the actual token refresh API call

### 3. Main App Integration
**Location**: `lib/main.dart`

**Features**:
- Initializes ProviderContainer for dependency injection
- Sets up AuthController with container reference
- Starts token observer if valid tokens exist

## How It Works

### Smart Observer Logic
1. **Token Age Calculation**: Reads `token_created_at` from SharedPreferences
2. **Time Until Expiry**: Calculates remaining time until 13-minute expiry
3. **Smart Scheduling**: Sets timer for (remaining_time - 30_seconds) to refresh proactively
4. **Continuous Monitoring**: Checks token age every 30 seconds as a safety net
5. **Automatic Refresh**: Triggers refresh and reschedules for the new token

### Lifecycle Integration
1. **On App Start**: Initializes observer if valid tokens exist
2. **On Login**: Starts observer after successful authentication
3. **On Token Refresh**: Updates `token_created_at` and reschedules observer
4. **On Logout**: Stops observer and cleans up all timers

## Configuration Constants
```dart
static const Duration _tokenLifetime = Duration(minutes: 13);
static const Duration _refreshBeforeExpiry = Duration(seconds: 30);
static const Duration _observerCheckInterval = Duration(seconds: 30);
```

## Error Handling
- **Network Errors**: Implements retry logic with exponential backoff
- **Invalid Tokens**: Automatically logs out user
- **Observer Failures**: Graceful degradation with fallback monitoring
- **Automatic Navigation**: Users are automatically redirected to login screen after logout

## Benefits Over Previous System
1. **Precise Timing**: Refreshes exactly when needed, not on fixed intervals
2. **Active Monitoring**: Works while user is actively using the app
3. **Resource Efficient**: Only one timer running at optimal intervals
4. **Proactive**: Prevents token expiration interruptions
5. **Robust**: Multiple safety nets and error handling

## Implementation Details

### Token Observer Flow
```
1. Check if tokens exist in SharedPreferences
2. Calculate token age from token_created_at
3. If token is fresh (< 12.5 minutes):
   - Schedule refresh for (13 minutes - current_age - 30 seconds)
4. If token is near expiry (> 12.5 minutes):
   - Refresh immediately
5. After successful refresh:
   - Update token_created_at
   - Restart observer for new token
6. Start safety timer that checks every 30 seconds
```

### Integration Points
- **App Initialization**: `main.dart` creates container and initializes observer
- **Login Flow**: Observer starts after successful authentication
- **Logout Flow**: Observer stops and cleans up resources
- **Background/Foreground**: Continues monitoring regardless of app state

## Testing
To test the smart observer:
1. Log in to the app
2. Check console logs for "Starting token refresh observer"
3. Monitor logs for scheduled refresh times
4. Verify proactive refresh occurs before 13-minute mark
5. Test app background/foreground scenarios

## Security Considerations
- Refresh tokens stored securely in SharedPreferences
- Failed refresh attempts immediately log out user
- Prevents multiple refresh attempts simultaneously
- Proactive refresh prevents token expiration vulnerabilities
- Immediate Logout: Users with invalid tokens are immediately logged out and redirected
- Session Security: No "zombie sessions" with invalid tokens

## Troubleshooting

### Common Issues
1. **Observer not starting**: Check if valid tokens exist in SharedPreferences
2. **Multiple timers**: Ensure previous timers are stopped before starting new ones
3. **Container not set**: Verify ProviderContainer is passed to AuthController

### Debug Logging
The system provides comprehensive logging:
- Observer start/stop events
- Token age calculations
- Scheduled refresh times
- Refresh attempts and results
- Error conditions and recovery

## Migration from Previous System
The new system replaces the old timer-based approach:
- **Old**: Fixed 13-minute intervals regardless of token age
- **New**: Smart scheduling based on actual token creation time
- **Benefit**: Prevents token expiration during active app usage