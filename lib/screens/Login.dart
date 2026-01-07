import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simulasi_ukk/models/model_warna.dart';
import 'package:simulasi_ukk/providers/auth_provider.dart';
import 'package:simulasi_ukk/screens/Dasboard.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 40,
              right: 40,
              top: 110,
              bottom: 40,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Image.asset('img/LogoAba.png', width: 130, height: 130),
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Text(
                            'Masuk',
                            style: TextStyle(
                              color: Warna().Putih,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'CircularStd',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
        
                  // Email field
                  Padding(
                    padding: const EdgeInsets.only(top: 45),
                    child: Text(
                      'Email',
                      style: TextStyle(
                        color: Warna().Putih,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'CircularStd',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.only(
                        left: 17.0,
                        right: 17.0,
                        top: 4,
                        bottom: 4,
                      ),
                      child: TextFormField(
                        controller: _emailController,
                        cursorColor: Warna().Putih,
                        style: TextStyle(
                          color: Warna().Putih,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'CircularStd',
                        ),
                        decoration: InputDecoration(
                          hintText: 'Masukkan Email Anda',
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
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Email tidak valid';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
        
                  // Password field
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      'Katasandi',
                      style: TextStyle(
                        color: Warna().Putih,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'CircularStd',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.only(
                        left: 17.0,
                        right: 17.0,
                        top: 4,
                        bottom: 4,
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        cursorColor: Warna().Putih,
                        style: TextStyle(
                          color: Warna().Putih,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'CircularStd',
                        ),
                        decoration: InputDecoration(
                          hintText: 'Masukkan Katasandi Anda',
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
                  ),
        
                  // Error message display
                  if (authProvider.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        authProvider.errorMessage!,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
        
                  SizedBox(height: 20),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: authProvider.isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    final success = await authProvider.login(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text,
                                    );
        
                                    if (success) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Dashboard(),
                                        ),
                                      );
                                    } else {
                                      // Error message is handled by the provider
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            authProvider.errorMessage ??
                                                'Login gagal',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Warna().Ijo,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                          ),
                          child: authProvider.isLoading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                )
                              : Text(
                                  'Masuk',
                                  style: TextStyle(
                                    fontFamily: 'CircularStd',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
        
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
