import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simulasi_ukk/models/model_warna.dart';
import 'package:simulasi_ukk/models/user_model.dart';
import 'package:simulasi_ukk/providers/auth_provider.dart';
import 'package:simulasi_ukk/providers/database_provider.dart';
import 'package:simulasi_ukk/Widgets/custom_appbar.dart';
import 'package:simulasi_ukk/screens/Login.dart';
import 'package:simulasi_ukk/services/supabase_service.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final SupabaseService _supabaseService = SupabaseService();

  // Controllers for the add/edit user form
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // For editing users
  UserModel? _editingUser;

  @override
  void initState() {
    super.initState();
    // Fetch users when the screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final databaseProvider = Provider.of<DatabaseProvider>(
        context,
        listen: false,
      );
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Only fetch users for admin
      if (authProvider.user?.role == 'admin') {
        databaseProvider.getUsers();
      }
    });
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final databaseProvider = Provider.of<DatabaseProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: Warna().bgUtama,
      appBar: CustomAppBar(title: 'Settings', showBackButton: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Profile'),
            SizedBox(height: 16),
            _profileCard(user),
            SizedBox(height: 24),
            _sectionTitle('About Company'),
            SizedBox(height: 16),
            _aboutCard(),
            SizedBox(height: 24),

            // User Management Section (Admin only)
            if (user?.role == 'admin') ...[
              _sectionTitle('User Management'),
              SizedBox(height: 16),

              // Add/Edit User Form
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
                          _editingUser == null ? 'Tambah User' : 'Edit User',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Warna().Ijo,
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _namaController,
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
                            Expanded(
                              child: ElevatedButton(
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
                                        // Add new user
                                        await _addUser(
                                          context,
                                          authProvider,
                                          databaseProvider,
                                          _namaController.text,
                                          _emailController.text,
                                          _passwordController.text,
                                          _roleController.text.isEmpty
                                              ? 'pegawai'
                                              : _roleController.text,
                                        );
                                      } else {
                                        // Update existing user
                                        final updatedUser = UserModel(
                                          id: _editingUser!.id,
                                          name: _namaController.text,
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
                              
                                        if (!mounted) return;
                                        _showResultDialog(
                                          context,
                                          'Berhasil',
                                          'User berhasil diupdate!',
                                          true,
                                        );
                              
                                        // Clear form and exit edit mode
                                        setState(() {
                                          _editingUser = null;
                                          _clearForm();
                                        });
                                      }
                              
                                      // Refresh user list
                                      await databaseProvider.getUsers();
                                    } catch (e) {
                                      if (!mounted) return;
                                      _showResultDialog(
                                        context,
                                        'Gagal',
                                        'Gagal ${_editingUser == null ? 'menambahkan' : 'mengupdate'} user: $e',
                                        false,
                                      );
                                    }
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    _editingUser == null
                                        ? 'Tambah User'
                                        : 'Update',
                                    style: TextStyle(color: Warna().Putih, fontSize: 14, fontFamily: 'CircularStd', fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            if (_editingUser != null)
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shadowColor: Colors.transparent,
                                    backgroundColor: Warna().MerahGelap,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _editingUser = null;
                                      _clearForm();
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      'Batal',
                                      style: TextStyle(color: Warna().Putih, fontSize: 14, fontFamily: 'CircularStd', fontWeight: FontWeight.w500),
                                    ),
                                  ),
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

              // User List
              Text(
                'Daftar Users',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'CircularStd'),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Belum ada data user.',
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  await provider.getUsers();
                                } catch (e) {
                                  if (!mounted) return;
                                  _showResultDialog(
                                    context,
                                    'Gagal',
                                    'Gagal memuat users: $e',
                                    false,
                                  );
                                }
                              },
                              child: Text('Refresh Data'),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: provider.users.length,
                      itemBuilder: (context, index) {
                        final user = provider.users[index];
                        return Card(
                          elevation: 0,
                          margin: EdgeInsets.symmetric(vertical: 4),
                          color: Warna().Putih,
                          child: ListTile(
                            title: Text(user.name, style: TextStyle(fontFamily: 'CircularStd')),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user.email, style: TextStyle(fontFamily: 'CircularStd')),
                                Text('Role: ${user.role ?? 'pegawai'}', style: TextStyle(fontFamily: 'CircularStd')),
                                if (user.createdAt != null)
                                  Text(
                                    'Dibuat: ${user.createdAt.toString().split(' ').first}',
                                    style: TextStyle(fontFamily: 'CircularStd'),
                                  ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    setState(() {
                                      _editingUser = user;
                                      _namaController.text = user.name;
                                      _emailController.text = user.email;
                                      _roleController.text = user.role ?? '';
                                      // Clear password when editing
                                      _passwordController.clear();
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
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
                                                Navigator.pop(context, false),
                                            child: Text('Batal'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: Text('Hapus'),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm == true) {
                                      try {
                                        await databaseProvider.deleteUser(
                                          user.id,
                                        );

                                        if (!mounted) return;
                                        _showResultDialog(
                                          context,
                                          'Berhasil',
                                          'User berhasil dihapus!',
                                          true,
                                        );
                                      } catch (e) {
                                        if (!mounted) return;
                                        _showResultDialog(
                                          context,
                                          'Gagal',
                                          'Gagal menghapus user: $e',
                                          false,
                                        );
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
            ] else if (user != null) ...[
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
                    'Hanya user dengan role "admin" yang dapat mengelola user.',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],

            // Refresh Data Button
            if (user?.role == 'admin')
              Center(
                child: ElevatedButton(
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
                      if (!mounted) return;
                      _showResultDialog(
                        context,
                        'Berhasil',
                        'Data berhasil di-refresh!',
                        true,
                      );
                    } catch (e) {
                      if (!mounted) return;
                      _showResultDialog(
                        context,
                        'Gagal',
                        'Gagal memuat users: $e',
                        false,
                      );
                    }
                  },
                  child: Text(
                    'Refresh Data',
                    style: TextStyle(color: Warna().Putih),
                  ),
                ),
              ),
            SizedBox(height: 20),

            // Existing buttons
            _fullWidthButton(
              'Logout',
              Colors.redAccent,
              () => _confirmLogout(context, authProvider),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to clear form
  void _clearForm() {
    _namaController.clear();
    _emailController.clear();
    _passwordController.clear();
    _roleController.clear();
  }

  // Helper method to add user
  Future<void> _addUser(
    BuildContext context,
    AuthProvider authProvider,
    DatabaseProvider databaseProvider,
    String name,
    String email,
    String password,
    String role,
  ) async {
    try {
      final supabase = _supabaseService.supabase;
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'nama': name, 'role': role},
      );

      if (response.user != null) {
        // Try to update users table (best-effort)
        try {
          await supabase
              .from('users')
              .update({'nama': name, 'role': role})
              .eq('id', response.user!.id);
        } catch (e) {
          debugPrint('DB update non-critical: $e');
        }

        if (!mounted) return;
        _showResultDialog(
          context,
          'Berhasil',
          'User berhasil ditambahkan!',
          true,
        );

        // Clear form
        _clearForm();
      } else {
        if (!mounted) return;
        _showResultDialog(context, 'Gagal', 'Gagal membuat akun', false);
      }
    } catch (e) {
      debugPrint('Error creating user: $e');
      if (!mounted) return;
      String errorMessage = 'Terjadi kesalahan saat membuat akun';

      final lower = e.toString().toLowerCase();
      if (lower.contains('email')) {
        errorMessage = 'Email sudah digunakan atau tidak valid';
      } else if (lower.contains('password')) {
        errorMessage = 'Password tidak memenuhi syarat';
      } else if (lower.contains('network')) {
        errorMessage = 'Masalah koneksi internet';
      }

      _showResultDialog(context, 'Gagal', errorMessage, false);
    }
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        fontFamily: "CircularStd",
        fontWeight: FontWeight.bold,
        color: Warna().Hitam,
      ),
    );
  }

  Widget _profileCard(user) {
    return Container(
      decoration: BoxDecoration(
        color: Warna().Putih,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _avatar(user),
          SizedBox(height: 16),
          _buildUserInfoRow('Name', user?.name ?? '-'),
          SizedBox(height: 8),
          _buildUserInfoRow('Email', user?.email ?? '-'),
          SizedBox(height: 8),
          _buildUserInfoRow('Role', user?.role ?? '-'),
        ],
      ),
    );
  }

  Widget _avatar(user) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(color: Warna().Ijo, shape: BoxShape.circle),
      child: Center(
        child: Text(
          user?.name?.isNotEmpty == true
              ? user!.name.substring(0, 1).toUpperCase()
              : '?',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Warna().Putih,
          ),
        ),
      ),
    );
  }

  Widget _aboutCard() {
    return Container(
      decoration: BoxDecoration(
        color: Warna().Putih,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Simulasi UKK',
            style: TextStyle(
              fontSize: 18,
              fontFamily: "CircularStd",
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Aplikasi ini merupakan simulasi ujian kompetensi keahlian untuk bidang Rekayasa Perangkat Lunak. Aplikasi ini dibuat untuk memenuhi standar kompetensi yang ditetapkan.',
            style: TextStyle(
              fontSize: 14,
              fontFamily: "CircularStd",
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Version 1.0.0',
            style: TextStyle(
              fontSize: 12,
              fontFamily: "CircularStd",
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fullWidthButton(String label, Color bgColor, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.transparent,
          backgroundColor: bgColor,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Warna().Putih,
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: "CircularStd",
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
        Text(': '),
        Expanded(
          child: Text(value, style: TextStyle(fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }

  void _confirmLogout(BuildContext context, AuthProvider authProvider) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          backgroundColor: Warna().Putih,
          title: Row(
            children: [
              Icon(Icons.crisis_alert_sharp, color: Warna().Oren),
              SizedBox(width: 10),
              Text(
                'Konfirmasi Logout',
                style: TextStyle(
                  fontFamily: "CircularStd",
                  fontWeight: FontWeight.w400,
                  color: Warna().Hitam,
                ),
              ),
            ],
          ),
          content: Text(
            'Apakah Anda yakin ingin logout?',
            style: TextStyle(
              fontFamily: "CircularStd",
              fontWeight: FontWeight.w400,
              color: Warna().Hitam,
            ),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(Warna().Merah),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Batal',
                style: TextStyle(
                  fontFamily: "CircularStd",
                  fontWeight: FontWeight.w400,
                  color: Warna().Putih,
                ),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(Warna().Ijo),
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // close dialog first

                try {
                  await authProvider.logout();
                } catch (e) {
                  // Logging only; do not rethrow to avoid debugger pause on exceptions
                  debugPrint('Logout error (ignored): $e');
                }

                if (!mounted) return;

                // Use pushAndRemoveUntil to clear the navigation stack
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => Login()),
                  (route) => false,
                );
              },
              child: Text(
                'Logout',
                style: TextStyle(
                  fontFamily: "CircularStd",
                  fontWeight: FontWeight.w400,
                  color: Warna().Putih,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ignore: unused_element
  void _showAddUserDialog(BuildContext context, AuthProvider authProvider) {
    // clear controllers before showing
    _namaController.clear();
    _emailController.clear();
    _passwordController.clear();
    String? selectedRole;

    final formKey = GlobalKey<FormState>();
    final supabase = _supabaseService.supabase;

    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              backgroundColor: Warna().Putih,
              title: Text(
                'Tambah User Baru',
                style: TextStyle(
                  fontFamily: "CircularStd",
                  fontWeight: FontWeight.bold,
                  color: Warna().Hitam,
                ),
              ),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Nama'),
                      SizedBox(height: 5),
                      _inputContainer(
                        child: TextFormField(
                          controller: _namaController,
                          cursorColor: Warna().Ijo,
                          style: TextStyle(
                            color: Warna().Hitam,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'CircularStd',
                          ),
                          decoration: InputDecoration(
                            hintText: 'Masukkan Nama',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'CircularStd',
                            ),
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nama tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      _label('Email'),
                      SizedBox(height: 5),
                      _inputContainer(
                        child: TextFormField(
                          controller: _emailController,
                          cursorColor: Warna().Ijo,
                          style: TextStyle(
                            color: Warna().Hitam,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'CircularStd',
                          ),
                          decoration: InputDecoration(
                            hintText: 'Masukkan Email',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'CircularStd',
                            ),
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email tidak boleh kosong';
                            }
                            if (!RegExp(
                              r'^[^@]+@[^@]+\.[^@]+',
                            ).hasMatch(value)) {
                              return 'Email tidak valid';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      _label('Katasandi'),
                      SizedBox(height: 5),
                      _inputContainer(
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          cursorColor: Warna().Ijo,
                          style: TextStyle(
                            color: Warna().Hitam,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'CircularStd',
                          ),
                          decoration: InputDecoration(
                            hintText: 'Masukkan Katasandi',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'CircularStd',
                            ),
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Kata sandi tidak boleh kosong';
                            }
                            if (value.length < 6) {
                              return 'Kata sandi minimal 6 karakter';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      _label('Role'),
                      SizedBox(height: 5),
                      _inputContainer(
                        child: DropdownButtonFormField<String>(
                          value: selectedRole,
                          dropdownColor: Warna().Putih,
                          hint: Text(
                            'Pilih Role',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'CircularStd',
                            ),
                          ),
                          decoration: InputDecoration(border: InputBorder.none),
                          style: TextStyle(
                            color: Warna().Hitam,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'CircularStd',
                          ),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Warna().Hitam,
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'admin',
                              child: Text('Admin'),
                            ),
                            DropdownMenuItem(
                              value: 'pegawai',
                              child: Text('Pegawai'),
                            ),
                          ],
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedRole = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Role harus dipilih';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      Colors.grey[300],
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(
                    'Batal',
                    style: TextStyle(
                      fontFamily: "CircularStd",
                      fontWeight: FontWeight.w400,
                      color: Warna().Hitam,
                    ),
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Warna().Ijo),
                  ),
                  onPressed: () async {
                    if (!(formKey.currentState?.validate() ?? false)) return;

                    Navigator.of(dialogContext).pop();

                    // Create user safely
                    try {
                      final response = await supabase.auth.signUp(
                        email: _emailController.text.trim(),
                        password: _passwordController.text,
                        data: {
                          'nama': _namaController.text.trim(),
                          'role': selectedRole ?? 'pegawai',
                        },
                      );

                      if (response.user != null) {
                        // try to update users table (best-effort)
                        try {
                          await supabase
                              .from('users')
                              .update({
                                'nama': _namaController.text.trim(),
                                'role': selectedRole ?? 'pegawai',
                              })
                              .eq('id', response.user!.id);
                        } catch (e) {
                          debugPrint('DB update non-critical: $e');
                        }

                        if (!mounted) return;

                        _showResultDialog(
                          context,
                          'Berhasil',
                          'Akun berhasil dibuat',
                          true,
                        );
                      } else {
                        if (!mounted) return;
                        _showResultDialog(
                          context,
                          'Gagal',
                          'Gagal membuat akun',
                          false,
                        );
                      }
                    } catch (e) {
                      debugPrint('Error creating user: $e');
                      if (!mounted) return;
                      String errorMessage =
                          'Terjadi kesalahan saat membuat akun';

                      final lower = e.toString().toLowerCase();
                      if (lower.contains('email')) {
                        errorMessage = 'Email sudah digunakan atau tidak valid';
                      } else if (lower.contains('password')) {
                        errorMessage = 'Password tidak memenuhi syarat';
                      } else if (lower.contains('network')) {
                        errorMessage = 'Masalah koneksi internet';
                      }

                      _showResultDialog(context, 'Gagal', errorMessage, false);
                    }
                  },
                  child: Text(
                    'Tambah',
                    style: TextStyle(
                      fontFamily: "CircularStd",
                      fontWeight: FontWeight.w400,
                      color: Warna().Putih,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Warna().Hitam,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: 'CircularStd',
      ),
    );
  }

  Widget _inputContainer({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Warna().bgUtama,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.only(left: 17.0, right: 17.0, top: 4, bottom: 4),
        child: child,
      ),
    );
  }

  void _showResultDialog(
    BuildContext context,
    String title,
    String message,
    bool isSuccess,
  ) {
    // Use a more robust approach with Scaffold context
    Future.delayed(Duration.zero, () {
      try {
        // Try to show dialog with Scaffold context which is more stable
        final scaffoldContext = Scaffold.of(context).context;
        if (scaffoldContext.mounted) {
          showDialog<void>(
            context: scaffoldContext,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                backgroundColor: Warna().Putih,
                title: Row(
                  children: [
                    Icon(
                      isSuccess ? Icons.check_circle : Icons.error,
                      color: isSuccess ? Colors.green : Colors.red,
                    ),
                    SizedBox(width: 10),
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: "CircularStd",
                        fontWeight: FontWeight.w400,
                        color: Warna().Hitam,
                      ),
                    ),
                  ],
                ),
                content: Text(
                  message,
                  style: TextStyle(
                    fontFamily: "CircularStd",
                    fontWeight: FontWeight.w400,
                    color: Warna().Hitam,
                  ),
                ),
                actions: [
                  TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(Warna().Ijo),
                    ),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                        fontFamily: "CircularStd",
                        fontWeight: FontWeight.w400,
                        color: Warna().Putih,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        debugPrint('Error showing result dialog: $e');

        // Fallback to showing a snackbar with ScaffoldMessenger
        try {
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: isSuccess ? Colors.green : Colors.red,
            ),
          );
        } catch (e2) {
          debugPrint('Error showing snackbar: $e2');

          // Last resort: try to show snackbar with Scaffold context
          Future.delayed(Duration(milliseconds: 100), () {
            try {
              final scaffoldContext = Scaffold.of(context).context;
              if (scaffoldContext.mounted) {
                ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: isSuccess ? Colors.green : Colors.red,
                  ),
                );
              }
            } catch (e3) {
              debugPrint(
                'Error showing delayed snackbar with scaffold context: $e3',
              );
            }
          });
        }
      }
    });
  }
}
