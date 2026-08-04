import 'package:flutter/material.dart';
import 'package:kanji_mobile/screens/home_screen.dart';
import 'package:kanji_mobile/screens/main_screen.dart';
import 'package:kanji_mobile/widgets/common/gradient_background.dart';
import '../services/auth_service.dart';

import 'package:kanji_mobile/widgets/common/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() { 
      _isLoading = true; 
      });

    final success = await _authService.login(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (success) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const MainScreen())
        );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email ou mot de passe incorrect'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      Text(
                        'KanjiMori',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '漢字森',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ),

                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          CustomTextField(
                            controller: _emailController,
                            label: "Email",
                            icon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                          ),

                          SizedBox(
                            height: 12,
                          ),

                          CustomTextField(
                            controller: _passwordController,
                            label: "Mot de passe",
                            icon: Icons.key,
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword 
                                  ? Icons.visibility 
                                  : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),

                          SizedBox(
                            height: 12,
                          ),

                          _isLoading ? CircularProgressIndicator() : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary, 
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)
                                )
                              ),
                            icon: Icon(
                              Icons.login,
                              color: Colors.white,
                              ),
                            onPressed: _login,
                            label: Text(
                              'Se connecter',
                              style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  )
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}