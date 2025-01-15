import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DateFormater{

  static  String formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }
}