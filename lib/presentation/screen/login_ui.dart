import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/login/login_bloc.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> with SingleTickerProviderStateMixin {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            // Navigate to home screen with access_token using go_router
            context.go('/home', extra: state.accessToken);
          }
        },
        builder: (context, state) {
          return Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 24),
                    TextField(
                      controller: loginController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: false,
                    ),
                    SizedBox(height: 24),
                    state is LoginLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              BlocProvider.of<LoginBloc>(context).add(
                                LoginButtonPressed(
                                  username: loginController.text,
                                  password: passwordController.text,
                                ),
                              );
                            },
                            child: Text('Login'),
                          ),
                    if (state is LoginFailure)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          state.error,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      backgroundColor: Colors.blue[50],
    );
  }
}
