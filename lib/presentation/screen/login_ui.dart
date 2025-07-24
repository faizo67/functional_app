import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/login/login_bloc.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> with TickerProviderStateMixin {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Animation Controllers
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _shakeController;
  late AnimationController _backgroundController;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shakeAnimation;
  late Animation<Color?> _backgroundColorAnimation;
  late Animation<double> _rotateAnimation;

  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();

    // Main animation controller for entrance
    _mainController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );

    // Pulse animation for welcome text
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );

    // Shake animation for errors
    _shakeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    // Background gradient animation
    _backgroundController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );

    // Setup animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Interval(0.4, 1.0, curve: Curves.bounceOut),
      ),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    _backgroundColorAnimation = ColorTween(
      begin: Colors.blue[100],
      end: Colors.purple[100],
    ).animate(_backgroundController);

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * 3.14159,
    ).animate(_backgroundController);

    // Start animations
    _mainController.forward();
    _pulseController.repeat(reverse: true);
    _backgroundController.repeat();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _shakeController.dispose();
    _backgroundController.dispose();
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _triggerShakeAnimation() {
    _shakeController.forward().then((_) => _shakeController.reset());
  }

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required int animationIndex,
    bool isPassword = false,
  }) {
    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: _mainController,
                curve: Interval(
                  0.3 + (animationIndex * 0.1),
                  0.9 + (animationIndex * 0.1),
                  curve: Curves.easeOut,
                ),
              ),
            ),
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                CurvedAnimation(
                  parent: _mainController,
                  curve: Interval(
                    0.4 + (animationIndex * 0.1),
                    1.0,
                    curve: Curves.bounceOut,
                  ),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller,
                  obscureText: isPassword && !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: label,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: AnimatedRotation(
                      turns: _rotateAnimation.value / (2 * 3.14159),
                      duration: Duration(milliseconds: 300),
                      child: Icon(icon, color: Colors.blueAccent),
                    ),
                    suffixIcon: isPassword
                        ? IconButton(
                            icon: AnimatedSwitcher(
                              duration: Duration(milliseconds: 300),
                              child: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                key: ValueKey(_isPasswordVisible),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          )
                        : null,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedButton(LoginState state) {
    return AnimatedBuilder(
      animation: Listenable.merge([_mainController, _shakeController]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            _shakeAnimation.value *
                10 *
                (1 - 2 * (_shakeAnimation.value % 0.5)).sign,
            _slideAnimation.value,
          ),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: _mainController,
                curve: Interval(0.7, 1.0, curve: Curves.easeOut),
              ),
            ),
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(
                  parent: _mainController,
                  curve: Interval(0.8, 1.0, curve: Curves.elasticOut),
                ),
              ),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: state is LoginLoading
                        ? [Colors.grey[400]!, Colors.grey[500]!]
                        : [Colors.blueAccent, Colors.blue[700]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: state is LoginLoading
                    ? SizedBox(
                        height: 48,
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          minimumSize: Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
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
                        child: AnimatedDefaultTextStyle(
                          duration: Duration(milliseconds: 200),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          child: Text('Login'),
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: AnimatedBuilder(
        animation: _backgroundColorAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _backgroundColorAnimation.value ?? Colors.blue[100]!,
                  Colors.blue[50]!,
                  Colors.white,
                ],
              ),
            ),
            child: BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is LoginSuccess) {
                  // Navigate to home screen with access_token using go_router
                  context.go('/home', extra: state.accessToken);
                } else if (state is LoginFailure) {
                  _triggerShakeAnimation();
                }
              },
              builder: (context, state) {
                return SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(24),
                      child: AnimatedBuilder(
                        animation: _scaleAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Container(
                              constraints: BoxConstraints(maxWidth: 400),
                              padding: EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Animated Welcome Text
                                  AnimatedBuilder(
                                    animation: _pulseAnimation,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: _pulseAnimation.value,
                                        child: FadeTransition(
                                          opacity: _fadeAnimation,
                                          child: ShaderMask(
                                            shaderCallback: (bounds) =>
                                                LinearGradient(
                                                  colors: [
                                                    Colors.blueAccent,
                                                    Colors.purple,
                                                  ],
                                                ).createShader(bounds),
                                            child: Text(
                                              'Welcome Back!',
                                              style: TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),

                                  SizedBox(height: 8),

                                  // Subtitle
                                  FadeTransition(
                                    opacity: Tween<double>(begin: 0.0, end: 1.0)
                                        .animate(
                                          CurvedAnimation(
                                            parent: _mainController,
                                            curve: Interval(
                                              0.2,
                                              0.7,
                                              curve: Curves.easeOut,
                                            ),
                                          ),
                                        ),
                                    child: Text(
                                      'Sign in to continue',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 32),

                                  // Username Field
                                  _buildAnimatedTextField(
                                    controller: loginController,
                                    label: 'Username',
                                    icon: Icons.person_outline,
                                    animationIndex: 0,
                                  ),

                                  SizedBox(height: 20),

                                  // Password Field
                                  _buildAnimatedTextField(
                                    controller: passwordController,
                                    label: 'Password',
                                    icon: Icons.lock_outline,
                                    animationIndex: 1,
                                    isPassword: true,
                                  ),

                                  SizedBox(height: 32),

                                  // Login Button
                                  _buildAnimatedButton(state),

                                  // Error Message
                                  if (state is LoginFailure)
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      margin: EdgeInsets.only(top: 20),
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.red[50],
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.red[200]!,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.error_outline,
                                            color: Colors.red[600],
                                            size: 20,
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              state.error,
                                              style: TextStyle(
                                                color: Colors.red[700],
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
