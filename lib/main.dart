import 'package:flutter/material.dart';
import 'admin.dart';
import 'user_model.dart';
import 'admin_services.dart';
import 'api_services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Praktikum Sesi 8',
    theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
    home: const HomePage(),
  );
}

void showMsg(BuildContext c, String m) =>
    ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(m)));

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final api = ApiService();
  final adminSvc = AdminService();
  late Future<List<User>> users;
  late Future<List<Admin>> admins;

  @override
  void initState() {
    super.initState();
    reload();
  }

  void reload() {
    users = api.getUsers();
    admins = adminSvc.getAdmins();
  }

  Future<void> run(Future<dynamic> Function() action, String ok) async {
    try {
      await action();
      if (mounted) showMsg(context, ok);
    } catch (e) {
      if (mounted) showMsg(context, '$e');
    }
    setState(reload);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User & Admin'),
          actions: [
            IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => setState(reload)),
          ],
          bottom: const TabBar(tabs: [Tab(text: 'User'), Tab(text: 'Admin')]),
        ),
        body: TabBarView(children: [userTab(), adminTab()]),
      ),
    );
  }

  Widget userTab() {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(8),
        child: Wrap(spacing: 8, children: [
          FilledButton(
              onPressed: () =>
                  run(api.createUser, 'POST User $userId berhasil'),
              child: const Text('POST')),
          FilledButton(
              onPressed: () => run(
                      () => api.updateUser(userId, 'Razky Ahmad Rivada Updated',
                      'razky.updated@example.com'),
                  'PUT User $userId berhasil'),
              child: const Text('PUT')),
          FilledButton(
              onPressed: () => run(() => api.patchUserName(userId),
                  'PATCH User $userId berhasil'),
              child: const Text('PATCH')),
          FilledButton(
              onPressed: () => run(() => api.deleteUser(userId),
                  'DELETE User $userId berhasil'),
              child: const Text('DELETE')),
          FilledButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const UserDetailPage(id: userId))),
              child: Text('Detail $userId')),
        ]),
      ),
      Expanded(
        child: FutureBuilder<List<User>>(
          future: users,
          builder: (c, s) {
            if (s.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (s.hasError) return Center(child: Text('${s.error}'));
            final list = s.data!;
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (c, i) => ListTile(
                leading: CircleAvatar(child: Text('${list[i].id}')),
                title: Text(list[i].name),
                subtitle: Text('ID ${list[i].id} • ${list[i].email}'),
                onTap: () => Navigator.push(
                    c,
                    MaterialPageRoute(
                        builder: (_) => UserDetailPage(id: list[i].id))),
              ),
            );
          },
        ),
      ),
    ]);
  }

  Widget adminTab() {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(8),
        child: Wrap(spacing: 8, children: [
          FilledButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AdminDetailPage(id: adminId))),
              child: Text('Detail Admin $adminId')),
          FilledButton(
              onPressed: () => run(() => adminSvc.deleteAdmin(adminId),
                  'Admin $adminId dihapus'),
              child: Text('DELETE Admin $adminId')),
        ]),
      ),
      Expanded(
        child: FutureBuilder<List<Admin>>(
          future: admins,
          builder: (c, s) {
            if (s.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (s.hasError) return Center(child: Text('${s.error}'));
            final list = s.data!;
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (c, i) => ListTile(
                leading: const CircleAvatar(
                    child: Icon(Icons.admin_panel_settings)),
                title: Text(list[i].name),
                subtitle: Text('ID ${list[i].id} • ${list[i].department}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => run(() => adminSvc.deleteAdmin(list[i].id),
                      'Admin ${list[i].id} dihapus'),
                ),
                onTap: () async {
                  await Navigator.push(
                      c,
                      MaterialPageRoute(
                          builder: (_) => AdminDetailPage(id: list[i].id)));
                  setState(reload);
                },
              ),
            );
          },
        ),
      ),
    ]);
  }
}

class UserDetailPage extends StatelessWidget {
  final int id;
  const UserDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail User $id')),
      body: FutureBuilder<User>(
        future: ApiService().getUser(id),
        builder: (c, s) {
          if (s.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (s.hasError) return Center(child: Text('${s.error}'));
          final u = s.data!;
          return ListView(padding: const EdgeInsets.all(16), children: [
            ListTile(title: const Text('ID'), subtitle: Text('${u.id}')),
            ListTile(title: const Text('Nama'), subtitle: Text(u.name)),
            ListTile(title: const Text('Email'), subtitle: Text(u.email)),
            ListTile(title: const Text('Kota'), subtitle: Text(u.city)),
          ]);
        },
      ),
    );
  }
}

class AdminDetailPage extends StatelessWidget {
  final int id;
  const AdminDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Admin $id')),
      body: FutureBuilder<Admin>(
        future: AdminService().getAdmin(id),
        builder: (c, s) {
          if (s.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (s.hasError) return Center(child: Text('${s.error}'));
          final a = s.data!;
          return ListView(padding: const EdgeInsets.all(16), children: [
            ListTile(title: const Text('ID'), subtitle: Text('${a.id}')),
            ListTile(title: const Text('Nama'), subtitle: Text(a.name)),
            ListTile(title: const Text('Email'), subtitle: Text(a.email)),
            ListTile(
                title: const Text('Department'), subtitle: Text(a.department)),
            const SizedBox(height: 16),
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              icon: const Icon(Icons.delete),
              label: Text('Hapus Admin $id'),
              onPressed: () async {
                try {
                  await AdminService().deleteAdmin(id);
                  if (c.mounted) {
                    showMsg(c, 'Admin $id berhasil dihapus');
                    Navigator.pop(c);
                  }
                } catch (e) {
                  if (c.mounted) showMsg(c, '$e');
                }
              },
            ),
          ]);
        },
      ),
    );
  }
}