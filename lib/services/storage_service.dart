import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/models.dart';

class StorageService {
  static const String _voelkerKey = 'voelker';
  static const String _staendeKey = 'staende';

  static Future<List<Volk>> loadVoelker() async {
    final prefs = await SharedPreferences.getInstance();
    final voelkerJson = prefs.getString(_voelkerKey);
    if (voelkerJson == null) return [];

    final List<dynamic> voelkerList = json.decode(voelkerJson);
    return voelkerList.map((v) => Volk.fromJson(v)).toList();
  }

  static Future<void> saveVoelker(List<Volk> voelker) async {
    final prefs = await SharedPreferences.getInstance();
    final voelkerJson = json.encode(voelker.map((v) => v.toJson()).toList());
    await prefs.setString(_voelkerKey, voelkerJson);
  }

  static Future<List<Stand>> loadStaende() async {
    final prefs = await SharedPreferences.getInstance();
    final staendeJson = prefs.getString(_staendeKey);
    if (staendeJson == null) return [];

    final List<dynamic> staendeList = json.decode(staendeJson);
    return staendeList.map((s) => Stand.fromJson(s)).toList();
  }

  static Future<void> saveStaende(List<Stand> staende) async {
    final prefs = await SharedPreferences.getInstance();
    final staendeJson = json.encode(staende.map((s) => s.toJson()).toList());
    await prefs.setString(_staendeKey, staendeJson);
  }

  static Future<void> addVolk(Volk volk) async {
    final voelker = await loadVoelker();
    voelker.add(volk);
    await saveVoelker(voelker);
  }

  static Future<void> updateVolk(Volk updatedVolk) async {
    final voelker = await loadVoelker();
    final index = voelker.indexWhere((v) => v.id == updatedVolk.id);
    if (index != -1) {
      voelker[index] = updatedVolk;
      await saveVoelker(voelker);
    }
  }

  static Future<void> deleteVolk(String volkId) async {
    final voelker = await loadVoelker();
    voelker.removeWhere((v) => v.id == volkId);
    await saveVoelker(voelker);
  }

  static Future<void> addStand(Stand stand) async {
    final staende = await loadStaende();
    staende.add(stand);
    await saveStaende(staende);
  }

  static Future<void> updateStand(Stand updatedStand) async {
    final staende = await loadStaende();
    final index = staende.indexWhere((s) => s.id == updatedStand.id);
    if (index != -1) {
      staende[index] = updatedStand;
      await saveStaende(staende);
    }
  }

  static Future<void> deleteStand(String standId) async {
    final staende = await loadStaende();
    staende.removeWhere((s) => s.id == standId);
    await saveStaende(staende);
  }
}