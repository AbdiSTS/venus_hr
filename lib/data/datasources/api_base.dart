class ApiBase {
  static const String appName = 'com.example.venushr_10_dipo_mobile';
  static const String version = 'v1.8';
  static const String baseUrl =
      'https://api.sinergiteknologi.co.id/ApiVenusHR/api/mobile/';
  static const String hostServer = 'MARSSERVER';
  static const String dbName = 'VenusHR10_Dipo';

  String login() {
    return '$baseUrl/loginUser';
  }

  String cekToken() {
    return '$baseUrl/verifyToken';
  }

  String leaveSaldo() {
    return "$baseUrl/getListDataLeaveSaldo";
  }
  
  String assigmentLocation() {
    return "$baseUrl/getDataMAssignMentLocation";
  }
}
