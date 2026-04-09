// lib/screens/splash/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/auth_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';
import '../../utils/responsive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
      ),
    );

    _scaleAnim = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _taglineFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _animController.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2800));
    final loggedIn = await AuthService().isLoggedIn();
    Get.offAllNamed(loggedIn ? AppRoutes.dashboard : AppRoutes.login);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: Stack(
          children: [
            // Soft background orbs — scale with screen
            Positioned(
              top: -100,
              right: -80,
              child: _Orb(
                  size: r.width * 0.65,
                  color: AppColors.secondary.withOpacity(0.07)),
            ),
            Positioned(
              bottom: -80,
              left: -60,
              child: _Orb(
                  size: r.width * 0.55,
                  color: AppColors.accent.withOpacity(0.07)),
            ),

            Center(
              child: AnimatedBuilder(
                animation: _animController,
                builder: (context, _) {
                  return Opacity(
                    opacity: _fadeAnim.value,
                    child: Transform.scale(
                      scale: _scaleAnim.value,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo
                          Container(
                            width: r.logoSize + 24,
                            height: r.logoSize + 24,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.secondary,
                                  AppColors.accent
                                ],
                              ),
                              borderRadius: BorderRadius.circular(
                                  (r.logoSize + 24) * 0.27),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppColors.secondary.withOpacity(0.35),
                                  blurRadius: 36,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'V',
                                style: TextStyle(
                                  fontFamily: 'Sora',
                                  fontSize: (r.logoSize + 24) * 0.47,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.background,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          Text(
                            'VIDYEN',
                            style: TextStyle(
                              fontFamily: 'Sora',
                              fontSize: r.appNameSize + 8,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              letterSpacing: 9,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Opacity(
                            opacity: _taglineFade.value,
                            child: Text(
                              'C O N F E R E N C E   P O R T A L',
                              style: TextStyle(
                                fontFamily: 'Sora',
                                fontSize: r.sp(11),
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                                letterSpacing: 3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  const _Orb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}