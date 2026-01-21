import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dots_client.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';

class DotsStorage {
  final Dots _client;

  DotsStorage(this._client);

  /// Access a specific bucket
  DotsStorageBucket from(String bucketId) {
    return DotsStorageBucket(_client, bucketId);
  }

  /// List all buckets
  Future<List<dynamic>> listBuckets() async {
    final response = await http.get(
      Uri.parse('${Dots.storageUrl}/bucket'),
      headers: _client.authHeaders(),
    );
    return _handleResponse(response);
  }

  /// Create a new bucket
  Future<dynamic> createBucket(String id, {bool public = false}) async {
    final response = await http.post(
      Uri.parse('${Dots.storageUrl}/bucket'),
      headers: _client.authHeaders(),
      body: jsonEncode({'id': id, 'name': id, 'public': public}),
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw DotsException('Storage Error', response.statusCode, response.body);
    }
  }
}

class DotsStorageBucket {
  final Dots _client;
  final String _bucketId;

  DotsStorageBucket(this._client, this._bucketId);

  /// Upload a file
  Future<dynamic> upload(String path, File file) async {
    final uri = Uri.parse('${Dots.storageUrl}/object/$_bucketId/$path');
    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll(_client.authHeaders())
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: MediaType('application', 'octet-stream'),
      ));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw DotsException(
          'Storage Upload Error', response.statusCode, response.body);
    }
  }

  /// Get public URL for a file
  String getPublicUrl(String path) {
    // Clean path to avoid double slashes
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return '${Dots.storageUrl}/object/public/$_bucketId/$cleanPath';
  }

  /// List files in a folder
  Future<List<dynamic>> list(
      {String? path, int limit = 100, int offset = 0}) async {
    final body = {
      'prefix': path ?? '',
      'limit': limit,
      'offset': offset,
      'sortBy': {'column': 'name', 'order': 'asc'},
    };

    final response = await http.post(
      Uri.parse('${Dots.storageUrl}/object/list/$_bucketId'),
      headers: _client.authHeaders(),
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw DotsException(
          'Storage List Error', response.statusCode, response.body);
    }
  }

  /// Delete files
  Future<dynamic> remove(List<String> paths) async {
    final response = await http.delete(
      Uri.parse('${Dots.storageUrl}/object/$_bucketId'),
      headers: _client.authHeaders(),
      body: jsonEncode({'prefixes': paths}),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw DotsException(
          'Storage Delete Error', response.statusCode, response.body);
    }
  }
}
