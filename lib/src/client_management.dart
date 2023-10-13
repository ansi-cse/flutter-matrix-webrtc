import 'package:hive_flutter/hive_flutter.dart';
import 'package:matrix/matrix.dart';
// ignore: depend_on_referenced_packages
import 'package:synchronized/synchronized.dart';

class ClientManagement {
  late Client _client;
  bool _isInitialized = false;
  final _lock = Lock();

  static final ClientManagement _instance = ClientManagement._internal();

  factory ClientManagement() => _instance;

  ClientManagement._internal();

  Client get client {
    return _client;
  }

  Future<bool> isClientInitialized() {
    return _lock.synchronized(() {
      return _isInitialized;
    });
  }

  Future<void> start(
      String? newToken,
      String? newRefreshToken,
      String? newDeviceID,
      String? newDeviceName,
      String? newUserID,
      String? newHomeserver,
      Function(String token, String refreshToken)? onSync) async {
    await _lock.synchronized(() async {
      if (!_isInitialized) {
        _client = await _createClient(
          newToken: newToken,
          newRefreshToken: newRefreshToken,
          newDeviceID: newDeviceID,
          newDeviceName: newDeviceName,
          newUserID: newUserID,
          newHomeserver: newHomeserver,
        );
        _isInitialized = true;
      }
    });
  }

  Future<void> stop() async {
    await _client.logout();
    _isInitialized = false;
  }

  Future<Client> _createClient(
      {String? newToken,
      String? newRefreshToken,
      String? newDeviceID,
      String? newDeviceName,
      String? newUserID,
      String? newHomeserver,
      Function(String token, String refreshToken)? onSync}) async {
    const String clientName = "Flutter WebRTC";

    final client = Client(
      clientName,
      databaseBuilder: (client) async {
        await Hive.initFlutter();
        // ignore: deprecated_member_use
        final db = FamedlySdkHiveDatabase(client.clientName);
        await db.open();
        return db;
      },
    );

    if (!client.isLogged()) {
      //case token expire
      client.checkHomeserver(Uri.parse(newHomeserver!));
      RefreshResponse ref = await client.refresh(newRefreshToken!);
      if (ref.accessToken != "" && ref.refreshToken != "") {
        client.init(
          newToken: ref.accessToken,
          newRefreshToken: ref.refreshToken,
          newDeviceID: newDeviceID,
          newDeviceName: newDeviceName,
          newUserID: newUserID,
        );
      }
    } else {
      //case login action
      await client.init(
        newToken: newToken,
        newRefreshToken: newRefreshToken,
        newDeviceID: newDeviceID,
        newDeviceName: newDeviceName,
        newUserID: newUserID,
        newHomeserver: Uri.parse(newHomeserver!),
      );
    }
    client.onSync.stream.listen((event) {
      onSync!(client.accessToken!, client.tokenRefresh!);
    });
    return client;
  }
}
