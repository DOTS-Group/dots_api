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
// Sign Up
await dots.auth.signUp(email: 'test@demo.com', password: '123');

// Sign In
final session = await dots.auth.signIn(email: 'test@demo.com', password: '123');

// Get Current User Token
final token = dots.currentUserToken;

// Sign Out
dots.auth.signOut();
```

### Database
You can perform CRUD operations on your tables using the `from()` method.

```dart
// Select (Get all rows)
final users = await dots.from('users').select();

// Insert (Add a new row)
await dots.from('users').insert({
  'username': 'john_doe',
  'status': 'active'
});

// Update (Update specific row)
await dots.from('users').update(
  {'status': 'inactive'},
  idColumn: 'id',
  idValue: 1
);

// Delete (Remove a row)
await dots.from('users').delete(
  idColumn: 'id',
  idValue: 1
);
```

### Storage
```dart
// Upload
await dots.storage.from('images').upload('avatar.png', File('path/to/file'));
// Get URL
final url = dots.storage.from('images').getPublicUrl('avatar.png');
```

### Realtime
```dart
// Listen to events
dots.realtime.listen((data) {
  print('Realtime Update: $data');
});
```

---

# 🇹🇷 Türkçe Dokümantasyon

## Genel Bakış
Bu depo, backend API tanımlarını ve resmi **Dots BaaS Flutter SDK**'sını içerir.

Flutter İstemcisi, Dots Platformu için temiz ve hızlı bir arayüz sağlar ve şunları destekler:
- **Kimlik Doğrulama** (Kayıt Ol, Giriş Yap, JWT işlemleri)
- **Veritabanı** (PostgREST sorguları: Seçme, Ekleme, Güncelleme, Silme)
- **Gerçek Zamanlı (Realtime)** (Socket.io olay dinleme)
- **Depolama** (S3 uyumlu dosya yükleme/indirme)

## Başlangıç (Flutter)

1. `pubspec.yaml` dosyasına bağımlılığı ekleyin:
   ```yaml
   dependencies:
     dots_baas_flutter: ^1.0.0
   ```
2. İstemciyi başlatın:
   ```dart
   final dots = Dots('PROJE_ID', 'API_ANAHTARI');
   ```

## Kullanım Örnekleri

### Kimlik Doğrulama (Auth)
```dart
// Kayıt Ol
await dots.auth.signUp(email: 'test@demo.com', password: '123');

// Giriş Yap
final session = await dots.auth.signIn(email: 'test@demo.com', password: '123');

// Mevcut Kullanıcı Token'ını Al
final token = dots.currentUserToken;

// Çıkış Yap
dots.auth.signOut();
```

### Veritabanı (Database)
`from()` metodunu kullanarak tablolarınız üzerinde CRUD işlemleri gerçekleştirebilirsiniz.

```dart
// Veri Çekme (Select)
final users = await dots.from('users').select();

// Veri Ekleme (Insert)
await dots.from('users').insert({
  'username': 'ahmet_yilmaz',
  'status': 'aktif'
});

// Güncelleme (Update)
await dots.from('users').update(
  {'status': 'pasif'}, 
  idColumn: 'id', 
  idValue: 1
);

// Silme (Delete)
await dots.from('users').delete(
  idColumn: 'id', 
  idValue: 1
);
```

### Depolama (Storage)
```dart
// Dosya Yükleme
await dots.storage.from('images').upload('avatar.png', File('dosya/yolu'));
// URL Alma
final url = dots.storage.from('images').getPublicUrl('avatar.png');
```

### Gerçek Zamanlı (Realtime)
```dart
// Olayları Dinle
dots.realtime.listen((data) {
  print('Gerçek Zamanlı Güncelleme: $data');
});
```
