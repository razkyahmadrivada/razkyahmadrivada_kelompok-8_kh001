import 'dart:convert';
import 'package:http/http.dart' as http;
import 'admin.dart';
import 'api_services.dart' show baseUrl;

class AdminService {
  // GET semua admin
  Future<List<Admin>> getAdmins() async {
    final res = await http.get(Uri.parse('$baseUrl/admins'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Admin.fromJson(e)).toList();
    }
    throw Exception('Gagal mengambil data Admin (${res.statusCode})');
  }

  // GET satu admin berdasarkan ID
  Future<Admin> getAdmin(int id) async {
    final res = await http.get(Uri.parse('$baseUrl/admins/$id'));
    if (res.statusCode == 200) return Admin.fromJson(jsonDecode(res.body));
    throw Exception('Admin $id tidak ditemukan (${res.statusCode})');
  }

  // DELETE admin berdasarkan ID
  Future<void> deleteAdmin(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/admins/$id'));
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Gagal DELETE Admin (${res.statusCode})');
    }
  }
}