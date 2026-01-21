import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth.dart';
import 'db.dart';
import 'realtime.dart';
import 'storage.dart';

class Dots {
  // Config
  static const String baseUrl = 'https://api.dots.net.tr';
  static const String realtimeUrl = 'https://realtime.dots.net.tr';
  static const String storageUrl = 'https://storage.dots.net.tr';

  final String projectId;
  final String apiKey;

  // Modules
  late final DotsAuth auth;
  late final DotsRealtime realtime;
  late final DotsStorage storage;

  String? _currentUserToken;

  Dots(this.projectId, this.apiKey) {
    auth = DotsAuth(this);
    realtime = DotsRealtime(this);
    storage = DotsStorage(this);
    realtime.init();
  }

  /// Sets the user session token internally
  void setSession(String token) {
    _currentUserToken = token;
    print("🔓 Dots: Session set.");
  }

  /// Clears the session
  void clearSession() {
    _currentUserToken = null;
    print("🔒 Dots: Session cleared.");
  }

  /// Accessor for current token (Internal use)
  String? get currentUserToken => _currentUserToken;

  /// Helper to generate headers
  Map<String, String> authHeaders({bool useAnon = false}) {
    final token =
        (useAnon || _currentUserToken == null) ? apiKey : _currentUserToken!;
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'Prefer': 'return=representation',
      'X-Project-ID': projectId,
    };
  }

  /// Database Query Builder Entry Point
  DotsQueryBuilder from(String table) {
    return DotsQueryBuilder(this, table);
  }

  /// RPC (Remote Procedure Call)
  Future<dynamic> rpc(String fn, [Map<String, dynamic>? params]) async {
    final response = await http.post(
      Uri.parse('$baseUrl/rpc/$fn'),
      headers: authHeaders(),
      body: params != null ? jsonEncode(params) : '{}',
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      throw DotsException('RPC Error', response.statusCode, response.body);
    }
  }
}

class DotsException implements Exception {
  final String message;
  final int statusCode;
  final String details;

  DotsException(this.message, this.statusCode, this.details);

  @override
  String toString() => 'DotsException: $message ($statusCode): $details';
}
