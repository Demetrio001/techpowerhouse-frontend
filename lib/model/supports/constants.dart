class Constants {
  static const String appName = "TechPowerHouse";

  static const String addressStoreServer = "http://localhost:8081";
  static const String addressAuthenticationServer = "http://localhost:8080";

  static const String realm = "techpowerhouse";
  static const String clientId = "springboot-keycloak";
  static const String requestLogin = "/realms/techpowerhouse/protocol/openid-connect/token";
  static const String requestLogout = "/realms/techpowerhouse/protocol/openid-connect/logout";

}