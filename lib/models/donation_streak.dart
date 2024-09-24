import 'dart:ffi';

class DonationStreak {
  final int currentStreak;
  final bool streakToday;
  final String type;
  final int totalStreak;
  final int streakDays;

  static DonationStreak? primMedal;
  static DonationStreak? sedekahSubuh;
  static double prim_point = 0;
  static int donationToday=0;

  DonationStreak(
      {required this.currentStreak,
      required this.streakToday,
      required this.type,
      required this.totalStreak,
      required this.streakDays});

  factory DonationStreak.fromJson(
      Map<String, dynamic> json, String type, int days) {
    return DonationStreak(
        currentStreak: json['current_streak'],
        streakToday: json['streak_today']==1,
        type: type,
        totalStreak: json['prim_medal'],
        streakDays: days);
  }
}
