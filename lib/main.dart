import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eid Mubarak Animation',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Montserrat',
        useMaterial3: true,
      ),
      home: const EidMubarakScreen(),
    );
  }
}

class EidMubarakScreen extends StatefulWidget {
  const EidMubarakScreen({Key? key}) : super(key: key);

  @override
  State<EidMubarakScreen> createState() => _EidMubarakScreenState();
}

class _EidMubarakScreenState extends State<EidMubarakScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _moonController;
  late AnimationController _textController;
  late AnimationController _glowController;
  late AnimationController _particleController;
  late AnimationController _crescentController;
  late AnimationController _mosqueController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _moonAnimation;
  late Animation<double> _moonScaleAnimation;
  late Animation<double> _textScaleAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _crescentRotateAnimation;
  late Animation<double> _mosqueAnimation;

  final List<StarParticle> _particles = [];
  final int _particleCount = 80; // Increased particle count
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    // Initialize particles with more variety
    for (int i = 0; i < _particleCount; i++) {
      _particles.add(StarParticle(
        x: _random.nextDouble() * 400,
        y: _random.nextDouble() * 800,
        size: _random.nextDouble() * 4 + 1,
        velocity: _random.nextDouble() * 1.5 + 0.5,
        angle: _random.nextDouble() * 2 * math.pi,
        color: _getRandomColor(),
        twinkleSpeed: _random.nextDouble() * 2 + 1,
      ));
    }

    // Initialize animation controllers
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15), // Longer, more subtle background animation
    )..repeat(reverse: true);

    _moonController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _crescentController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12), // Slower rotation
    )..repeat();

    _mosqueController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Setup animations
    _backgroundAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: _backgroundController, curve: Curves.easeInOut));

    _moonAnimation = Tween<double>(begin: -100, end: 0).animate(
        CurvedAnimation(parent: _moonController, curve: Curves.elasticOut));

    _moonScaleAnimation = Tween<double>(begin: 0.1, end: 1.0).animate(
        CurvedAnimation(parent: _moonController, curve: Curves.elasticOut));

    _textScaleAnimation = Tween<double>(begin: 0.1, end: 1.0).animate(
        CurvedAnimation(parent: _textController, curve: Curves.elasticOut));

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    _glowAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
        CurvedAnimation(parent: _glowController, curve: Curves.easeInOut));

    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _particleController, curve: Curves.linear));

    _crescentRotateAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
        CurvedAnimation(parent: _crescentController, curve: Curves.linear));

    _mosqueAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _mosqueController, curve: Curves.easeInOut));

    // Start animations with sequence
    Future.delayed(const Duration(milliseconds: 300), () {
      _moonController.forward();
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      _mosqueController.forward();
    });

    Future.delayed(const Duration(milliseconds: 1300), () {
      _textController.forward();
    });
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _moonController.dispose();
    _textController.dispose();
    _glowController.dispose();
    _particleController.dispose();
    _crescentController.dispose();
    _mosqueController.dispose();
    super.dispose();
  }

  Color _getRandomColor() {
    final colors = [
      const Color(0xFFFFD700), // Gold
      const Color(0xFFF5F5DC), // White/cream
      const Color(0xFF4CAF50).withOpacity(0.8), // Islamic green
      const Color(0xFFE3F2FD), // Light blue
      const Color(0xFFFFF9C4), // Light yellow
    ];
    return colors[_random.nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _backgroundController,
          _moonController,
          _textController,
          _glowController,
          _particleController,
          _crescentController,
          _mosqueController,
        ]),
        builder: (context, child) {
          // Update particles with twinkle effect
          for (var particle in _particles) {
            particle.update(_particleAnimation.value, _glowAnimation.value);
          }

          return Stack(
            children: [
              // Enhanced animated background with more subtle gradient
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.lerp(
                        const Color(0xFF0D1F3C),
                        const Color(0xFF0D2A54),
                        _backgroundAnimation.value,
                      )!,
                      Color.lerp(
                        const Color(0xFF1A3566),
                        const Color(0xFF281C61),
                        _backgroundAnimation.value,
                      )!,
                      Color.lerp(
                        const Color(0xFF2A1E5C),
                        const Color(0xFF3C1F7B),
                        _backgroundAnimation.value,
                      )!,
                    ],
                  ),
                ),
              ),

              // Enhanced stars and particles
              CustomPaint(
                size: Size(screenWidth, screenHeight),
                painter: StarParticlePainter(_particles, _glowAnimation.value),
              ),

              // Improved Mosque silhouette with animation
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AnimatedBuilder(
                  animation: _mosqueAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, (1 - _mosqueAnimation.value) * 50),
                      child: Opacity(
                        opacity: _mosqueAnimation.value,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            // Mosque glow
                            ClipPath(
                              clipper: EnhancedMosqueSilhouetteClipper(),
                              child: Container(
                                height: 220,
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    center: const Alignment(0, 0.3),
                                    radius: 1.0,
                                    colors: [
                                      Colors.indigo.withOpacity(0.1 * _glowAnimation.value),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Mosque outline
                            CustomPaint(
                              size: Size(screenWidth, 220),
                              painter: MosqueOutlinePainter(_glowAnimation.value),
                            ),
                            // Mosque solid
                            ClipPath(
                              clipper: EnhancedMosqueSilhouetteClipper(),
                              child: Container(
                                height: 220,
                                color: Colors.black.withOpacity(0.75),
                              ),
                            ),
                            // Mosque windows
                            Positioned(
                              bottom: 50,
                              left: 0,
                              right: 0,
                              child: CustomPaint(
                                size: Size(screenWidth, 60),
                                painter: MosqueWindowsPainter(_glowAnimation.value),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Enhanced animated moon
              Positioned(
                top: 80 + _moonAnimation.value,
                right: 40,
                child: Transform.scale(
                  scale: _moonScaleAnimation.value,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Moon outer glow
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(_glowAnimation.value * 0.2),
                              blurRadius: 40,
                              spreadRadius: 15,
                            ),
                          ],
                        ),
                      ),
                      // Moon inner glow
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white,
                              const Color(0xFFF5F5F5),
                              const Color(0xFFE0E0E0),
                            ],
                            stops: const [0.4, 0.8, 1.0],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(_glowAnimation.value * 0.4),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: CustomPaint(
                          painter: MoonDetailPainter(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Enhanced animated crescent
              Positioned(
                top: 180,
                left: 40,
                child: Transform.rotate(
                  angle: _crescentRotateAnimation.value,
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return RadialGradient(
                        center: Alignment.center,
                        radius: 0.5,
                        colors: [
                          const Color(0xFFFFD700),
                          const Color(0xFFFFD700).withOpacity(_glowAnimation.value * 0.8),
                        ],
                        stops: const [0.5, 1.0],
                      ).createShader(bounds);
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Crescent glow
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withOpacity(_glowAnimation.value * 0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                        ),
                        // Crescent shape
                        CustomPaint(
                          size: const Size(70, 70),
                          painter: EnhancedCrescentPainter(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Enhanced Islamic decoration
              Positioned(
                top: screenHeight * 0.3,
                left: 0,
                right: 0,
                child: Center(
                  child: Opacity(
                    opacity: _textFadeAnimation.value * 0.5,
                    child: CustomPaint(
                      size: const Size(320, 320),
                      painter: EnhancedIslamicPatternPainter(_glowAnimation.value),
                    ),
                  ),
                ),
              ),

              // Enhanced Eid Mubarak text
              Center(
                child: Transform.scale(
                  scale: _textScaleAnimation.value,
                  child: Opacity(
                    opacity: _textFadeAnimation.value,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.amber.shade100,
                                Colors.amber.shade300,
                                Colors.amber.shade500,
                                Colors.amber.shade700,
                              ],
                            ).createShader(bounds);
                          },
                          child: const Text(
                            'عيد مبارك',
                            style: TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: 64,
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.amber.shade300,
                                Colors.amber.shade700,
                                Colors.amber.shade400,
                                Colors.amber.shade800,
                              ],
                            ).createShader(bounds);
                          },
                          child: const Text(
                            'Eid Mubarak',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 46,
                              color: Colors.amber,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                              height: 1.1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.black.withOpacity(0.1),
                          ),
                          child: Opacity(
                            opacity: _textFadeAnimation.value * 0.9,
                            child: const Text(
                              'May Allah bless you with happiness and peace',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
// Enhanced Star particle class with twinkle effect
class StarParticle {
  double x;
  double y;
  double size;
  double velocity;
  double angle;
  Color color;
  double initialX;
  double initialY;
  double twinkleSpeed;
  double twinkleValue = 0;

  StarParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.velocity,
    required this.angle,
    required this.color,
    required this.twinkleSpeed,
  }) : initialX = x, initialY = y;

  void update(double animationValue, double glowValue) {
    // Movement
    x = initialX + math.cos(angle) * velocity * 80 * animationValue;
    y = initialY + math.sin(angle) * velocity * 80 * animationValue;

    // Reset to initial position when particles go too far
    if (x < -50 || y < -50 || x > 450 || y > 850) {
      x = initialX;
      y = initialY;
    }

    // Twinkle effect
    twinkleValue = (math.sin(animationValue * twinkleSpeed * 10) + 1) / 2;
  }
}

// Enhanced Star particle painter
class StarParticlePainter extends CustomPainter {
  final List<StarParticle> particles;
  final double glowValue;

  StarParticlePainter(this.particles, this.glowValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final opacity = 0.4 + (particle.twinkleValue * 0.6) * (0.7 + (glowValue * 0.3));
      final actualSize = particle.size * (0.8 + particle.twinkleValue * 0.4);

      final paint = Paint()
        ..color = particle.color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      // Draw star or circle based on size
      if (particle.size > 3) {
        drawStar(canvas, Offset(particle.x, particle.y), 5, actualSize, actualSize / 2, paint);

        // Add glow effect for larger stars
        final glowPaint = Paint()
          ..color = particle.color.withOpacity(opacity * 0.3)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(Offset(particle.x, particle.y), actualSize * 1.5, glowPaint);
      } else {
        canvas.drawCircle(Offset(particle.x, particle.y), actualSize, paint);
      }
    }
  }

  void drawStar(Canvas canvas, Offset center, int spikes, double outerRadius, double innerRadius, Paint paint) {
    final path = Path();
    final double rotation = math.pi / 2 * 3;
    final double x = center.dx;
    final double y = center.dy;
    final double step = math.pi / spikes;

    path.moveTo(x + math.cos(rotation) * outerRadius, y + math.sin(rotation) * outerRadius);

    for (int i = 0; i < spikes; i++) {
      path.lineTo(
        x + math.cos(rotation + step * i) * outerRadius,
        y + math.sin(rotation + step * i) * outerRadius,
      );
      path.lineTo(
        x + math.cos(rotation + step * i + step / 2) * innerRadius,
        y + math.sin(rotation + step * i + step / 2) * innerRadius,
      );
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Enhanced Crescent painter
class EnhancedCrescentPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.fill;

    // Create a crescent shape
    final path = Path();

    // First circle
    path.addOval(Rect.fromCircle(
      center: Offset(size.width * 0.5, size.height * 0.5),
      radius: size.width * 0.45,
    ));

    // Second circle (subtract)
    path.fillType = PathFillType.evenOdd;
    path.addOval(Rect.fromCircle(
      center: Offset(size.width * 0.65, size.height * 0.5),
      radius: size.width * 0.4,
    ));

    // Add some texture details
    canvas.drawPath(path, paint);

    // Add highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width * 0.3, size.height * 0.5),
        radius: size.width * 0.3,
      ),
      math.pi * 1.2,
      math.pi * 0.6,
      false,
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Enhanced Islamic pattern painter
class EnhancedIslamicPatternPainter extends CustomPainter {
  final double glowValue;

  EnhancedIslamicPatternPainter(this.glowValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amber.withOpacity(0.3 + (glowValue * 0.2))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 10;

    // Draw outer octagon
    drawRegularPolygon(canvas, center, radius, 8, paint);

    // Draw inner octagon
    drawRegularPolygon(canvas, center, radius * 0.8, 8, paint);

    // Draw inner star
    drawStar(canvas, center, 8, radius * 0.7, radius * 0.4, paint);

    // Draw central circle
    canvas.drawCircle(center, radius * 0.25, paint);

    // Draw radiating lines
    for (int i = 0; i < 16; i++) {
      final angle = i * math.pi / 8;
      final x1 = center.dx + math.cos(angle) * radius * 0.3;
      final y1 = center.dy + math.sin(angle) * radius * 0.3;
      // Continuing from where the code was cut off in the EnhancedIslamicPatternPainter class
      final x2 = center.dx + math.cos(angle) * radius * 0.9;
      final y2 = center.dy + math.sin(angle) * radius * 0.9;

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  void drawRegularPolygon(Canvas canvas, Offset center, double radius, int sides, Paint paint) {
    final path = Path();
    final angle = 2 * math.pi / sides;

    path.moveTo(
      center.dx + radius * math.cos(0),
      center.dy + radius * math.sin(0),
    );

    for (int i = 1; i <= sides; i++) {
      path.lineTo(
        center.dx + radius * math.cos(angle * i),
        center.dy + radius * math.sin(angle * i),
      );
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  void drawStar(Canvas canvas, Offset center, int points, double outerRadius, double innerRadius, Paint paint) {
    final path = Path();
    final angle = math.pi / points;

    path.moveTo(
      center.dx + outerRadius * math.cos(0),
      center.dy + outerRadius * math.sin(0),
    );

    for (int i = 1; i <= points * 2; i++) {
      final radius = i.isOdd ? innerRadius : outerRadius;
      path.lineTo(
        center.dx + radius * math.cos(angle * i),
        center.dy + radius * math.sin(angle * i),
      );
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Enhanced Mosque silhouette clipper
class EnhancedMosqueSilhouetteClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;

    // Base line
    path.moveTo(0, height);
    path.lineTo(width, height);

    // Right side
    path.lineTo(width, height * 0.5);

    // Small dome right side
    path.lineTo(width * 0.9, height * 0.5);
    path.quadraticBezierTo(width * 0.85, height * 0.35, width * 0.8, height * 0.5);

    // Small minaret right side
    path.lineTo(width * 0.75, height * 0.5);
    path.lineTo(width * 0.75, height * 0.3);
    path.lineTo(width * 0.72, height * 0.25);
    path.lineTo(width * 0.7, height * 0.3);
    path.lineTo(width * 0.7, height * 0.5);

    // Main dome
    path.lineTo(width * 0.65, height * 0.5);
    path.quadraticBezierTo(width * 0.5, height * 0.2, width * 0.35, height * 0.5);

    // Small minaret left side
    path.lineTo(width * 0.3, height * 0.5);
    path.lineTo(width * 0.3, height * 0.3);
    path.lineTo(width * 0.28, height * 0.25);
    path.lineTo(width * 0.25, height * 0.3);
    path.lineTo(width * 0.25, height * 0.5);

    // Small dome left side
    path.lineTo(width * 0.2, height * 0.5);
    path.quadraticBezierTo(width * 0.15, height * 0.35, width * 0.1, height * 0.5);

    // Left side
    path.lineTo(0, height * 0.5);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// Enhanced Mosque outline painter
class MosqueOutlinePainter extends CustomPainter {
  final double glowValue;

  MosqueOutlinePainter(this.glowValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amber.withOpacity(0.2 + (glowValue * 0.3))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    final width = size.width;
    final height = size.height;

    // Base line
    path.moveTo(0, height);
    path.lineTo(width, height);

    // Right side
    path.lineTo(width, height * 0.5);

    // Small dome right side
    path.lineTo(width * 0.9, height * 0.5);
    path.quadraticBezierTo(width * 0.85, height * 0.35, width * 0.8, height * 0.5);

    // Small minaret right side
    path.lineTo(width * 0.75, height * 0.5);
    path.lineTo(width * 0.75, height * 0.3);
    path.lineTo(width * 0.72, height * 0.25);
    path.lineTo(width * 0.7, height * 0.3);
    path.lineTo(width * 0.7, height * 0.5);

    // Main dome
    path.lineTo(width * 0.65, height * 0.5);
    path.quadraticBezierTo(width * 0.5, height * 0.2, width * 0.35, height * 0.5);

    // Small minaret left side
    path.lineTo(width * 0.3, height * 0.5);
    path.lineTo(width * 0.3, height * 0.3);
    path.lineTo(width * 0.28, height * 0.25);
    path.lineTo(width * 0.25, height * 0.3);
    path.lineTo(width * 0.25, height * 0.5);

    // Small dome left side
    path.lineTo(width * 0.2, height * 0.5);
    path.quadraticBezierTo(width * 0.15, height * 0.35, width * 0.1, height * 0.5);

    // Left side
    path.lineTo(0, height * 0.5);

    canvas.drawPath(path, paint);

    // Add window arches on the base
    drawMosqueArches(canvas, size, paint);
  }

  void drawMosqueArches(Canvas canvas, Size size, Paint paint) {
    final archWidth = size.width / 16;
    final archHeight = size.height * 0.1;
    final baseY = size.height;

    for (int i = 0; i < 15; i++) {
      final startX = archWidth * i + (archWidth * 0.5);
      final controlY = baseY - archHeight * 2;

      final path = Path();
      path.moveTo(startX, baseY);
      path.quadraticBezierTo(startX + archWidth / 2, controlY, startX + archWidth, baseY);

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Mosque windows painter
class MosqueWindowsPainter extends CustomPainter {
  final double glowValue;

  MosqueWindowsPainter(this.glowValue);

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Draw windows with glowing effect
    drawWindow(canvas, Rect.fromLTWH(width * 0.2, 0, width * 0.1, height * 0.6), glowValue);
    drawWindow(canvas, Rect.fromLTWH(width * 0.35, 0, width * 0.1, height * 0.6), glowValue);
    drawWindow(canvas, Rect.fromLTWH(width * 0.5 - width * 0.05, 0, width * 0.1, height * 0.6), glowValue);
    drawWindow(canvas, Rect.fromLTWH(width * 0.55, 0, width * 0.1, height * 0.6), glowValue);
    drawWindow(canvas, Rect.fromLTWH(width * 0.7, 0, width * 0.1, height * 0.6), glowValue);
  }

  void drawWindow(Canvas canvas, Rect rect, double glowValue) {
    // Window shape (rounded rectangle with top arch)
    final path = Path();
    final roundedRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(rect.left, rect.top + rect.height * 0.2, rect.width, rect.height * 0.8),
      Radius.circular(rect.width * 0.2),
    );

    path.addRRect(roundedRect);

    // Add arch top
    path.moveTo(rect.left, rect.top + rect.height * 0.2);
    path.quadraticBezierTo(
      rect.left + rect.width / 2,
      rect.top - rect.height * 0.1,
      rect.right,
      rect.top + rect.height * 0.2,
    );

    // Window fill with glow
    final gradient = RadialGradient(
      center: Alignment.center,
      radius: 0.8,
      colors: [
        Colors.amber.withOpacity(0.3 + glowValue * 0.3),
        Colors.amber.withOpacity(0.1),
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);

    // Window outline
    final outlinePaint = Paint()
      ..color = Colors.amber.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawPath(path, outlinePaint);

    // Window lattice
    drawWindowLattice(canvas, rect);
  }

  void drawWindowLattice(Canvas canvas, Rect rect) {
    final latticePaint = Paint()
      ..color = Colors.amber.withOpacity(0.6)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Vertical line
    canvas.drawLine(
      Offset(rect.left + rect.width / 2, rect.top + rect.height * 0.2),
      Offset(rect.left + rect.width / 2, rect.bottom),
      latticePaint,
    );

    // Horizontal line
    canvas.drawLine(
      Offset(rect.left, rect.top + rect.height * 0.5),
      Offset(rect.right, rect.top + rect.height * 0.5),
      latticePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Moon detail painter
class MoonDetailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    // Draw some craters
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.3), size.width * 0.08, paint);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.7), size.width * 0.1, paint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.5), size.width * 0.06, paint);

    // Highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width * 0.35, size.height * 0.35), size.width * 0.15, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}