class AuthTokens {
  final String accessToken;
  final String refreshToken;

  AuthTokens({required this.accessToken, required this.refreshToken});

  factory AuthTokens.fromJson(Map<String, dynamic> j) => AuthTokens(
    accessToken: j['accessToken'] ?? j['token'] ?? '',
    refreshToken: j['refreshToken'] ?? '',
  );

  Map<String, dynamic> toJson() =>
      {'accessToken': accessToken, 'refreshToken': refreshToken};
}
