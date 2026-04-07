import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../services/local_storage_service.dart';
import '../../data/network/api_client.dart';
import '../../core/errors/app_exception.dart';

class PremiumOpeningAnimation extends StatefulWidget {
  const PremiumOpeningAnimation({Key? key}) : super(key: key);

  @override
  State<PremiumOpeningAnimation> createState() =>
      _PremiumOpeningAnimationState();
}

class _PremiumOpeningAnimationState extends State<PremiumOpeningAnimation>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _particleController;
  late AnimationController _textController;
  late AnimationController _taglineController;
  late AnimationController _exitController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _glowAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _textOpacity;
  late Animation<double> _taglineOpacity;
  late Animation<double> _exitScale;
  late Animation<double> _exitOpacity;

  String _displayedText = '';
  final String _fullText = 'Magic Idea';
  int _charIndex = 0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startSequence();
  }

  void _setupAnimations() {
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.easeInOut),
    );
    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_particleController);
    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeIn),
    );
    _exitScale = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _exitController, curve: Curves.easeIn));
    _exitOpacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _exitController, curve: Curves.easeIn));
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    _textController.forward();
    _startTypewriter();

    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    _taglineController.forward();

    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    _exitController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    // Stop all controllers before navigating to prevent mouse_tracker assertion
    _particleController.stop();
    _logoController.stop();
    _textController.stop();
    _taglineController.stop();
    _exitController.stop();

    final nextRoute = await _resolveInitialRoute();
    if (!mounted) return;

    Navigator.pushReplacementNamed(context, nextRoute);
  }

  Future<String> _resolveInitialRoute() async {
    final token = await LocalStorageService.loadToken();
    final hasToken = token != null && token.trim().isNotEmpty;

    if (!hasToken) {
      return AppRoutes.ideaGenerationOnboardingScreen;
    }

    try {
      // Quick token validation for smoother app relaunches.
      await HttpApiClient().get('/auth/profile');
      return AppRoutes.mainShellScreen;
    } on AuthException {
      await LocalStorageService.deleteToken();
      await LocalStorageService.clearAll();
      return AppRoutes.ideaGenerationOnboardingScreen;
    } on NetworkException {
      // If backend is unreachable, keep user in-app and rely on local cache.
      return AppRoutes.mainShellScreen;
    } catch (_) {
      return AppRoutes.mainShellScreen;
    }
  }

  void _startTypewriter() {
    Future.doWhile(() async {
      if (!mounted || _charIndex >= _fullText.length) return false;
      await Future.delayed(const Duration(milliseconds: 80));
      if (mounted) {
        setState(() {
          _charIndex++;
          _displayedText = _fullText.substring(0, _charIndex);
        });
      }
      return _charIndex < _fullText.length;
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _particleController.dispose();
    _textController.dispose();
    _taglineController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _logoController,
          _particleController,
          _textController,
          _taglineController,
          _exitController,
        ]),
        builder: (context, child) {
          return FadeTransition(
            opacity: _exitOpacity,
            child: ScaleTransition(
              scale: _exitScale,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0D0221),
                      Color(0xFF1A0A3C),
                      Color(0xFF0A1628),
                      Color(0xFF060D1F),
                    ],
                    stops: [0.0, 0.35, 0.7, 1.0],
                  ),
                ),
                child: Stack(
                  children: [
                    // Animated particles
                    ..._buildParticles(),
                    // Radial glow behind logo
                    Center(
                      child: Opacity(
                        opacity: _logoOpacity.value * _glowAnimation.value,
                        child: Container(
                          width: 220.0,
                          height: 220.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF7C3AED,
                                ).withAlpha((0.35 * _glowAnimation.value * 255).round()),
                                blurRadius: 80,
                                spreadRadius: 40,
                              ),
                              BoxShadow(
                                color: const Color(
                                  0xFFD4AF37,
                                ).withAlpha((0.2 * _glowAnimation.value * 255).round()),
                                blurRadius: 60,
                                spreadRadius: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Main content
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo
                          ScaleTransition(
                            scale: _logoScale,
                            child: FadeTransition(
                              opacity: _logoOpacity,
                              child: _buildLogo(),
                            ),
                          ),
                          const SizedBox(height: 28),
                          // App name with typewriter
                          FadeTransition(
                            opacity: _textOpacity,
                            child: ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  Color(0xFFD4AF37),
                                  Color(0xFFFBD060),
                                  Color(0xFFFFE082),
                                ],
                              ).createShader(bounds),
                              child: Text(
                                _displayedText,
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Tagline
                          FadeTransition(
                            opacity: _taglineOpacity,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildSparkle(),
                                const SizedBox(width: 6),
                                const Text(
                                  'Powered by AI',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Poppins',
                                    color: Color(0xB3FFFFFF),
                                    letterSpacing: 2.0,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                _buildSparkle(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4C1D95), Color(0xFF7C3AED), Color(0xFF2563EB)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withAlpha(153),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glassmorphism inner ring
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withAlpha(38), width: 1),
            ),
          ),
          // Lightbulb icon with golden gradient
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFE082), Color(0xFFD4AF37)],
            ).createShader(bounds),
            child: const Icon(
              Icons.lightbulb_rounded,
              size: 52,
              color: Colors.white,
            ),
          ),
          // AI circuit dots
          ..._buildCircuitDots(),
        ],
      ),
    );
  }

  List<Widget> _buildCircuitDots() {
    final positions = [
      const Offset(12, 20),
      const Offset(88, 20),
      const Offset(12, 80),
      const Offset(88, 80),
    ];
    return positions
        .map(
          (pos) => Positioned(
            left: pos.dx,
            top: pos.dy,
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFD4AF37).withAlpha(204),
              ),
            ),
          ),
        )
        .toList();
  }

  List<Widget> _buildParticles() {
    final random = math.Random(42);
    final screenSize = MediaQuery.of(context).size;
    return List.generate(18, (i) {
      final angle = (i / 18) * 2 * math.pi;
      final radius = 140.0 + random.nextDouble() * 80;
      final progress = (_particleAnimation.value + i / 18) % 1.0;
      final currentRadius = radius * (0.3 + progress * 0.7);
      final cx = screenSize.width / 2 + math.cos(angle) * currentRadius;
      final cy = screenSize.height / 2 + math.sin(angle) * currentRadius;
      final opacity = (1.0 - progress) * 0.7 * _logoOpacity.value;
      final size = 3.0 + random.nextDouble() * 3;

      return Positioned(
        left: cx - size / 2,
        top: cy - size / 2,
        child: Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i % 3 == 0
                  ? const Color(0xFFD4AF37)
                  : i % 3 == 1
                  ? const Color(0xFF7C3AED)
                  : const Color(0xFF60A5FA),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSparkle() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _particleController.value * 2 * math.pi,
          child: const Icon(
            Icons.auto_awesome,
            size: 12,
            color: Color(0xFFD4AF37),
          ),
        );
      },
    );
  }
}
