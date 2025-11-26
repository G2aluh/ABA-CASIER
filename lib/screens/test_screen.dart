import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simulasi_ukk/models/model_warna.dart';
import 'package:simulasi_ukk/models/user_model.dart';
import 'package:simulasi_ukk/providers/auth_provider.dart';
import 'package:simulasi_ukk/providers/database_provider.dart';
import 'package:simulasi_ukk/screens/Login.dart';
import 'package:simulasi_ukk/services/auth_service.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _roleController = TextEditingController();

  UserModel? _editingUser;
  // ignore: unused_field
  bool _isUpdating = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final databaseProvider = Provider.of<DatabaseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tes Koneksi Supabase'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tes Auth',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('User Auth: ${authProvider.isAuthenticated}'),
              if (authProvider.user != null) ...[
                Text('User ID: ${authProvider.user!.id}'),
                Text('User Name: ${authProvider.user!.name}'),
                Text('User Email: ${authProvider.user!.email}'),
                Text('User Role: ${authProvider.user!.role}'),
              ],
              SizedBox(height: 20),

              // Check if user is admin
              if (authProvider.user?.role == 'admin') ...[
                // Form for adding users (admin only)
                Card(
                  color: Warna().Putih,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Warna().Ijo, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _editingUser == null
                                ? 'Tambah User (Admin Only)'
                                : 'Edit User (Admin Only)',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Warna().Ijo,
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Nama',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email tidak boleh kosong';
                              }
                              if (!value.contains('@')) {
                                return 'Email tidak valid';
                              }
                              return null;
                            },
                          ),
                          if (_editingUser == null) ...[
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (_editingUser == null &&
                                    (value == null || value.isEmpty)) {
                                  return 'Password tidak boleh kosong';
                                }
                                if (value != null &&
                                    value.isNotEmpty &&
                                    value.length < 6) {
                                  return 'Password minimal 6 karakter';
                                }
                                return null;
                              },
                            ),
                          ],
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _roleController,
                            decoration: InputDecoration(
                              labelText: 'Role',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shadowColor: Colors.transparent,
                                  backgroundColor: Warna().Ijo,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      if (_editingUser == null) {
                                        // Use the auth service to register new user (like registration)
                                        final authService = AuthService();
                                        await authService.register(
                                          name: _nameController.text,
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                          role: _roleController.text.isEmpty
                                              ? 'pegawai'
                                              : _roleController.text,
                                        );

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'User berhasil ditambahkan!',
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );

                                        // Clear form
                                        _nameController.clear();
                                        _emailController.clear();
                                        _passwordController.clear();
                                        _roleController.clear();
                                      } else {
                                        // Update existing user using the database provider
                                        final updatedUser = UserModel(
                                          id: _editingUser!.id,
                                          name: _nameController.text,
                                          email: _emailController.text,
                                          role: _roleController.text.isEmpty
                                              ? 'pegawai'
                                              : _roleController.text,
                                          createdAt: _editingUser!.createdAt,
                                          updatedAt: DateTime.now(),
                                        );

                                        await databaseProvider.updateUser(
                                          updatedUser,
                                        );

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'User berhasil diupdate!',
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );

                                        // Clear form and exit edit mode
                                        setState(() {
                                          _editingUser = null;
                                          _nameController.clear();
                                          _emailController.clear();
                                          _passwordController.clear();
                                          _roleController.clear();
                                        });
                                      }

                                      // Refresh user list
                                      await databaseProvider.getUsers();
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Gagal ${_editingUser == null ? 'menambahkan' : 'mengupdate'} user: $e',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: Text(
                                  _editingUser == null
                                      ? 'Tambah User'
                                      : 'Update User',
                                  style: TextStyle(color: Warna().Putih),
                                ),
                              ),
                              if (_editingUser != null)
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shadowColor: Colors.transparent,
                                    backgroundColor: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _editingUser = null;
                                      _nameController.clear();
                                      _emailController.clear();
                                      _passwordController.clear();
                                      _roleController.clear();
                                    });
                                  },
                                  child: Text(
                                    'Batal',
                                    style: TextStyle(color: Warna().Putih),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ] else if (authProvider.user != null) ...[
                // Non-admin user message
                Card(
                  color: Warna().Putih,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.orange, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Hanya user dengan role "admin" yang dapat menambahkan/edit user baru.',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],

              // Buttons for testing database connection and CRUD operations
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      backgroundColor: Warna().Ijo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      try {
                        // Test database connection by fetching users
                        await databaseProvider.getUsers();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Database Berhasil Diakses. Menemukan ${databaseProvider.users.length} User.',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Database Gagal Diakses: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Tes Koneksi Database',
                      style: TextStyle(color: Warna().Putih),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      try {
                        await databaseProvider.getUsers();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Gagal memuat users: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Refresh Data',
                      style: TextStyle(color: Warna().Putih),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Display users list
              Text(
                'Daftar Users',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                height: 300,
                child: Consumer<DatabaseProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (provider.users.isEmpty) {
                      return Center(
                        child: Text(
                          'Belum ada data user. Tekan "Refresh Data" untuk memuat.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: provider.users.length,
                      itemBuilder: (context, index) {
                        final user = provider.users[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          color: Warna().Putih,
                          child: ListTile(
                            title: Text(user.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user.email),
                                Text('Role: ${user.role ?? 'pegawai'}'),
                                if (user.createdAt != null)
                                  Text(
                                    'Dibuat: ${user.createdAt.toString().split(' ').first}',
                                  ),
                              ],
                            ),
                            trailing: authProvider.user?.role == 'admin'
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _editingUser = user;
                                            _nameController.text = user.name;
                                            _emailController.text = user.email;
                                            _roleController.text =
                                                user.role ?? '';
                                          });
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () async {
                                          // Confirm deletion
                                          final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text('Konfirmasi Hapus'),
                                              content: Text(
                                                'Apakah Anda yakin ingin menghapus user ${user.name}?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                        context,
                                                        false,
                                                      ),
                                                  child: Text('Batal'),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                        context,
                                                        true,
                                                      ),
                                                  child: Text('Hapus'),
                                                ),
                                              ],
                                            ),
                                          );

                                          if (confirm == true) {
                                            try {
                                              // Delete user using the database provider
                                              await databaseProvider.deleteUser(
                                                user.id,
                                              );

                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'User berhasil dihapus!',
                                                  ),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                            } catch (e) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Gagal menghapus user: $e',
                                                  ),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              SizedBox(height: 20),

              // Logout button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.transparent,
                    backgroundColor: Warna().Merah,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    authProvider.logout();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                      (route) => false,
                    );
                  },
                  child: Text('Keluar', style: TextStyle(color: Warna().Putih)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
