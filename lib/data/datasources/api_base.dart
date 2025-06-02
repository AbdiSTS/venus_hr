class ApiBase {
  static const String appName = 'com.example.nusantara_ess';
  static const String version = 'v1.8';
  static const String baseUrl =
      'https://api.sinergiteknologi.co.id/ApiVenusHR/api/mobile';
  static const String hostServer = 'IMPLEMENTSERVER';
  static const String dbName = 'VenusHR13';

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

  String dateHoliday() {
    return "$baseUrl/getDateHoliday";
  }

  String monthlyPeriode() {
    return "$baseUrl/getMonthlyPeriode";
  }

  String getNumberAbsen() {
    return "$baseUrl/getNumberAbsen";
  }

  String postAbsen() {
    return "$baseUrl/postDataAbsen";
  }

  String postPermission() {
    return "$baseUrl/postDataPermission";
  }
  
  String postOvertime() {
    return "$baseUrl/postOvertime";
  }

  String postDataLeave() {
    return "$baseUrl/postDataLeave";
  }

  String postImgAttendance() {
    return "$baseUrl/postImgAttendance";
  }

  String getRangeDate() {
    return "$baseUrl/getRangeDate";
  }

  String getApproverRequest() {
    return "$baseUrl/getApprover";
  }

  String getAutoNumberPermission() {
    return "$baseUrl/getAutoNumberPermission";
  }

  String getAutoNumberLeave() {
    return "$baseUrl/getAutoNumberLeave";
  }

  String getListAttendanceLog() {
    return "$baseUrl/getListAttendanceLog";
  }

  String getLeaveType() {
    return "$baseUrl/getLeaveType";
  }

  String getListMyRequest() {
    return "$baseUrl/getListMyRequest";
  }

  String getListApproveRequest() {
    return "$baseUrl/getListApproveRequest";
  }
  
  String getListHRReqHistory() {
    return "$baseUrl/getListHRReqHistory";
  }

  String updateRequest(String? typeUpdate) {
    return "$baseUrl/${typeUpdate}";
  }

  String deleteRequest() {
    return "$baseUrl/deleteRequest";
  }
  
  String getOvertimeType() {
    return "$baseUrl/getOvertimeType";
  }
}
