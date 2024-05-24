import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String convertTimeStampToTime(Timestamp? timestamp) {
  if (timestamp != null) {
    // Convert Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();

// Format DateTime to desired string format
    String formattedTime = DateFormat.jm().format(dateTime);
    return formattedTime;
  } else {
    return '';
  }
}

// "2022-01-15T01:00:00+01:00" to "15 Jan 2022"
String getDateString(String? dateString) {
  if (dateString != null) {
    final dateTime = DateTime.parse(dateString);
    final formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
    return formattedDate;
  } else {
    return '';
  }
}
