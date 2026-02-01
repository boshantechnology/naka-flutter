# Google Maps API Key Setup Guide

## How to Get Your Google Maps API Key

### Step 1: Go to Google Cloud Console
1. Visit https://console.cloud.google.com/
2. Sign in with your Google account (create one if needed)

### Step 2: Create a New Project
1. Click on the project dropdown at the top
2. Click "NEW PROJECT"
3. Enter project name: "Naka App Maps"
4. Click "CREATE"

### Step 3: Enable Google Maps APIs
1. In the search bar, search for "Maps SDK for Android"
2. Click on it and click "ENABLE"
3. Search for "Maps SDK for iOS" and enable it too

### Step 4: Create API Key
1. Go to "Credentials" in the left menu
2. Click "Create Credentials" → "API Key"
3. Your new API key will be displayed
4. Copy this key

### Step 5: Add API Key to Your Project

#### For Android:
1. Open: `android/app/src/main/AndroidManifest.xml`
2. Find this line:
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="AIzaSyDummy_Replace_With_Your_Actual_API_Key_From_Google_Cloud_Console" />
```
3. Replace `AIzaSyDummy_Replace_With_Your_Actual_API_Key_From_Google_Cloud_Console` with your API key
4. Save the file

#### For iOS (Optional):
1. Open: `ios/Runner/GeneratedPluginRegistrant.m`
2. Add your API key in the appropriate location (iOS setup is similar)

### Step 6: Test
1. Run: `flutter clean`
2. Run: `flutter pub get`
3. Run: `flutter run` on Android emulator/device

## API Key Format
Your API key will look like:
```
AIzaSyD1234567890abcdefghijklmnopqrstuvwxyz
```

## Security Note
- Keep your API key safe
- In production, restrict it to your app package name and signing certificate

## If You Get "Quota Exceeded" Error
1. Go to Google Cloud Console
2. Click on Quotas in the left menu
3. Find "Maps SDK for Android" 
4. Click on it and increase the quota

Your Google Maps API key has been added to AndroidManifest.xml! 🗺️
Now just add your actual API key and run the app!
