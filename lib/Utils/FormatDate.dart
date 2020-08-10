import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
String unixTimeStampToDateTime(int millisecond) {
  var format = DateFormat('EEEE, dd MMMM yyyy HH:mm', 'id');
  var dateTimeString = format.format(DateTime.fromMillisecondsSinceEpoch(millisecond * 1000));

  return dateTimeString;
}

String unixTimeStampToDateTimeWithoutDay(int millisecond) {
  var format = DateFormat('dd MMMM yyyy HH:mm', 'id');
  var dateTimeString = format.format(DateTime.fromMillisecondsSinceEpoch(millisecond * 1000));

  return dateTimeString;
}

String unixTimeStampToDate(int millisecond) {
  var format = DateFormat.yMMMMEEEEd('id');
  var dateString = format.format(DateTime.fromMillisecondsSinceEpoch(millisecond * 1000));
  return dateString;
}

String unixTimeStampToDateWithoutDay(int millisecond) {
  var format = DateFormat.yMMMMd('id');
  var dateString = format.format(DateTime.fromMillisecondsSinceEpoch(millisecond * 1000));
  return dateString;
}

String unixTimeStampToDateWithoutMultiplication(int millisecond) {
  var format = DateFormat.yMMMMEEEEd('id');
  var dateString = format.format(DateTime.fromMillisecondsSinceEpoch(millisecond));
  return dateString;
}

String unixTimeStampToTimeAgo(int millisecond) {
  var format = DateFormat.yMMMMEEEEd('id');
  var dateString = format.format(DateTime.fromMillisecondsSinceEpoch(millisecond * 1000));
  Duration diff = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(millisecond * 1000));

  if (diff.inDays > 7) {
    return dateString;
  } else
  if (diff.inDays > 0) {
    return "${diff.inDays} hari yang lalu";
  } else
  if (diff.inHours > 0) {
    return "${diff.inHours} jam yang lalu";
  } else
  if (diff.inMinutes > 0) {
    return "${diff.inMinutes} menit yang lalu";
  } else {
    return "Baru saja";
  }
  
}
String formatTgl(DateTime dateTime) {
  return DateFormat('dd MMMM yyyy').format(dateTime);
}

String formatTglMysql(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd hh:mm').format(dateTime);
}
String formatTglFromUnix(int second){
  return DateFormat('dd MMM yyyy kk:mm').format(DateTime.fromMillisecondsSinceEpoch(second));
}

String timeUntil(int second) {
  timeago.setLocaleMessages('id', timeago.IdMessages());
  return timeago.format(DateTime.fromMillisecondsSinceEpoch(second), locale: 'id', allowFromNow: true);
}

List _longMonth = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
List _shortMonth = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];

String _convertToLocalMonth(int month, bool shortMonth) {
	if (shortMonth) return _shortMonth[month -1];
	return _longMonth[month - 1];
}

String tanggal(DateTime date, {bool shortMonth=false}) {
	return "${date.day} ${_convertToLocalMonth(date.month, shortMonth)} ${date.year}";
}

String tanggalDanJam(DateTime date, {bool shortMonth=false}) {
	return "${date.day} ${_convertToLocalMonth(date.month, shortMonth)} ${date.year} ${date.hour}:${date.minute}:${date.second}";
}