 String formatTanggal(String expired) {
    List<String> parts = expired.split('-');
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }

  bool isExpired(String expired) {
    DateTime expiredDate = DateTime.parse(expired);
    DateTime now = DateTime.now();
    return expiredDate.isBefore(now);
  }