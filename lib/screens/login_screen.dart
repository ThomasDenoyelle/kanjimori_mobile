import 'package:flutter/material.dart';
import 'package:kanji_mobile/screens/home_screen.dart';
import '../services/auth_service.dart';

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
        MaterialPageRoute(builder: (context) => const HomeScreen())
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colors.primaryContainer,
              colors.secondaryContainer,
              colors.surface,
            ],
          ),
        ),
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

                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.white
                          ),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.30),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(12),                  
                          ),
                        )
                      ),

                      SizedBox(
                        height: 12,
                      ),

                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.key),
                          labelText: 'Mot de passe',
                          labelStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.white
                          ),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.30),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            }, 
                            icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off,
                            ) 
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(12),                  
                          ),
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