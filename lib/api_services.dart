import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_model.dart';

// GANTI dengan base URL API praktikum sebelumnya
const String baseUrl = 'https://jsonplaceholder.typicode.com';

// N = 206 (3 digit terakhir NIM 20250801206)
const int nimN = 206;
const int userId = 1000 + nimN; // 1206
const int adminId = 2000 + nimN; // 2206

class ApiService {
  final _headers = {'Content-Type': 'application/json'};

  // GET semua user
  Future<List<User>> getUsers() async {
    final res = await http.get(Uri.parse('$baseUrl/users'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => User.fromJson(e)).toList();
    }
    throw Exception('Gagal mengambil data User (${res.statusCode})');
  }

  // GET satu user
  Future<User> getUser(int id) async {
    final res = await http.get(Uri.parse('$baseUrl/users/$id'));
    if (res.statusCode == 200) return User.fromJson(jsonDecode(res.body));
    throw Exception('User $id tidak ditemukan (${res.statusCode})');
  }

  // POST user baru dengan ID dari NIM
  Future<User> createUser() async {
    final user = User(
      id: userId,
      name: 'Razky Ahmad Rivada',
      email: 'razky@example.com',
      city: 'BEKASI',
    );
    final res = await http.post(Uri.parse('$baseUrl/users'),
        headers: _headers, body: jsonEncode(user.toJson()));
    if (res.statusCode == 200 || res.statusCode == 201) {
      return User.fromJson(jsonDecode(res.body));
    }
    throw Exception('Gagal POST User (${res.statusCode})');
  }

  // PUT: perbarui nama & email
  Future<User> updateUser(int id, String name, String email) async {
    final body = {'id': id, 'name': name, 'email': email};
    final res = await http.put(Uri.parse('$baseUrl/users/$id'),
        headers: _headers, body: jsonEncode(body));
    if (res.statusCode == 200) return User.fromJson(jsonDecode(res.body));
    throw Exception('Gagal PUT User (${res.statusCode})');
  }

  // PATCH: tambah teks " - Flutter Developer" pada nama
  Future<User> patchUserName(int id) async {
    final current = await getUser(id);
    final res = await http.patch(Uri.parse('$baseUrl/users/$id'),
        headers: _headers,
        body: jsonEncode({'name': '${current.name} - Flutter Developer'}));
    if (res.statusCode == 200) return User.fromJson(jsonDecode(res.body));
    throw Exception('Gagal PATCH User (${res.statusCode})');
  }

  // DELETE user
  Future<void> deleteUser(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/users/$id'));
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Gagal DELETE User (${res.statusCode})');
    }
  }
}