# Dummy app

A Flutter application for recording audio and taking photos.

## Features

### Audio Recording
- Start/Stop recording with visual feedback
- Real-time timer display (MM:SS format)
- Animated audio waveform visualization during recording
- Audio playback functionality
- Automatic file saving

### Photo Capture
- Start/Stop camera with visual feedback
- Live camera preview
- Capture photo functionality
- Photo display and preview
- Automatic file saving

## Setup

### Prerequisites
- Flutter SDK installed
- Android Studio or VS Code with Flutter extensions
- Android device or emulator for testing

### Installation

1. Navigate to the project directory:
```bash
cd c:\Git\dummy_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Packages Used

- `record` (^5.1.2) - Audio recording
- `audioplayers` (^6.1.0) - Audio playback
- `permission_handler` (^11.3.1) - Runtime permissions
- `path_provider` (^2.1.4) - File system paths
- `camera` (^0.11.0+2) - Camera access (for future photo feature)

## Permissions

### Android
The following permissions are configured in `AndroidManifest.xml`:
- RECORD_AUDIO - For audio recording
- CAMERA - For photo capture
- WRITE_EXTERNAL_STORAGE - For saving files
- READ_EXTERNAL_STORAGE - For reading files

### iOS
Add the following to `ios/Runner/Info.plist`:
```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access to record audio</string>
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to take photos</string>
```

## Project Structure

```
lib/
├── main.dart           # Main app with navigation
├── pages/
│   ├── audio_page.dart # Audio recording page
│   └── photo_page.dart # Photo capture page
```

## Usage

1. Launch the app
2. Use the left navigation rail to switch between pages
3. On the Audio page:
   - Click "Start Recording" to begin
   - Watch the timer and waveform animation
   - Click "Stop Recording" to finish
   - Click "Play Recording" to listen to your audio
4. On the Photo page:
   - Click "Start Camera" to activate your camera
   - View the live camera preview
   - Click "Capture Photo" to take a picture
   - View your captured photo below
   - Click "Stop Camera" when finished

## Comparison with React App

This Flutter app replicates the React web app functionality:
- ✅ Left navigation menu (NavigationRail in Flutter)
- ✅ Audio recording with start/stop
- ✅ Recording timer (MM:SS format)
- ✅ Audio waveform visualization
- ✅ Audio playback
- ✅ Photo capture with camera preview
- ✅ Photo display and saving

## Notes

- Audio files are saved in the app's documents directory
- The waveform visualization uses amplitude data from the microphone
- Permissions are requested at runtime when needed
