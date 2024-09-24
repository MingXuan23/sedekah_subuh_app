import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class Derma {
  final int id;
  //final int donationTypeId;
  final String donationType;
  final String dermaName;
  final String dermaUrl;

  Derma(
      {required this.id,
      required this.donationType,
      required this.dermaName,
      required this.dermaUrl});

  factory Derma.fromJson(Map<String, dynamic> json, String donationType) {
    return Derma(
        id: int.tryParse(json['donation_id'].toString()) ?? 0,
        donationType: donationType,
        dermaName: json['donation_name'] ?? '',
        dermaUrl: json['donation_url'] ?? '');
  }

  toJson() {
    return {'donation_id': id, 'donation_name': dermaName, 'donation_url': dermaUrl};
  }

  static List<Derma> processDermaList(Map<String, dynamic> data) {
    List<Derma> list = [];
    var values = data['data'];
    for (var v in values) {
      var dermas = (v['donations'] as List)
          .map((d) => Derma.fromJson(d, v['donation_type']))
          .toList();
      list.addAll(dermas);
    }
    return list;
  }

  static Future<void> saveDermaHistory(Derma derma) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var history = pref.getString('derma_history');

    if (history == null) {
      List<Derma> list = [derma];
      pref.setString('derma_history', jsonEncode(list.map((e) => e.toJson()).toList()));
    } else {
      List<Derma> list = (jsonDecode(history) as List).map((e)=> Derma.fromJson(e, "History")).toList();
      list.removeWhere((e)=>e.id == derma.id);
      while (list.length >= 5) {
        list.removeLast();
      }
      list.insert(0,derma);
     
      pref.setString('derma_history', jsonEncode(list.map((e) => e.toJson()).toList()));
    }
  }

  static Future<List<Derma>> getDermaHistory() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      var history = pref.getString('derma_history');
      if (history == null) {
        return [];
      }

      List<Derma> list = (jsonDecode(history) as List).map((e)=> Derma.fromJson(e, "History")).toList();
      return list;
    } catch (e) {
      return [];
    }
  }
}
