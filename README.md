# Dots BaaS API & Flutter SDK

## Overview
This repository contains the backend API definitions and the official **Dots BaaS Flutter SDK**.

The Flutter Client provides a clean and fast interface for the Dots Platform, supporting:
- **Authentication** (Sign Up, Sign In, JWT handling)
- **Database** (PostgREST queries: Select, Insert, Update, Delete)
- **Realtime** (Socket.io event listening)
- **Storage** (S3-compatible file uploads/downloads)

## Getting Started (Flutter)

1. Add dependency to `pubspec.yaml`:
   ```yaml
   dependencies:
     dots_baas_flutter: ^1.0.0
   ```
2. Initialize the client:
   ```dart
   final dots = Dots('YOUR_PROJECT_ID', 'YOUR_API_KEY');
   ```

## Usage Examples

### Auth
```dart
await dots.auth.signUp(email: 'test@demo.com', password: '123');
final session = await dots.auth.signIn(email: 'test@demo.com', password: '123');
```

### Storage
```dart
// Upload
await dots.storage.from('images').upload('avatar.png', File('path/to/file'));
// Get URL
final url = dots.storage.from('images').getPublicUrl('avatar.png');
```
