class AppConfig {
  const AppConfig._();

  static const googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue:
        '144298619830-kujkq8kbh84gmff7a5q1bl2p7uqgu6cf.apps.googleusercontent.com',
  );
}
