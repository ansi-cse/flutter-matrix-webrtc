class OttAuthInfo {
  OttAuthInfo(
      {this.accessToken,
      this.refreshToken,
      this.server,
      this.deviceId,
      this.userId,
      this.expiresInMs});

  String? accessToken;
  String? refreshToken;
  String? server;
  String? deviceId;
  String? userId;
  int? expiresInMs;

  factory OttAuthInfo.fromJson(Map<String, dynamic> json) => OttAuthInfo(
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
        server: json['server'],
        deviceId: json['deviceId'],
        userId: json['userId'],
        expiresInMs: json['expiresInMs'],
      );

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'server': server,
        'deviceId': deviceId,
        'userId': userId,
        'expiresInMs': expiresInMs,
      };
}
