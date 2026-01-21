import 'package:socket_io_client/socket_io_client.dart' as io;
import 'dots_client.dart';

class DotsRealtime {
  final Dots _client;
  io.Socket? _socket;

  DotsRealtime(this._client);

  void init() {
    _socket = io.io(
        Dots.realtimeUrl,
        io.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());

    _socket!.onConnect((_) {
      print('🟢 Dots: Realtime connected (${_client.projectId})');
      _socket!.emit('subscribe', _client.projectId);
    });
  }

  void connect() {
    _socket?.connect();
  }

  void disconnect() {
    _socket?.disconnect();
  }

  /// Listen for database changes
  void listen(Function(dynamic) callback) {
    _socket?.on('db-change', (data) => callback(data));
  }
}
