import 'package:cloud_firestore/cloud_firestore.dart';

final class TimestampConverter {
  const TimestampConverter._();

  static DateTime fromFirestore(Timestamp timestamp) {
    return timestamp.toDate();
  }

  static Timestamp toFirestore(DateTime date) {
    return Timestamp.fromDate(date);
  }
}
