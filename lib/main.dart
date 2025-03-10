import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'screens/onboarding_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Solução mais agressiva para tela cheia
  _setupFullScreen();

  runApp(const MyApp());
}

// Configura tela cheia com abordagens específicas por plataforma
void _setupFullScreen() {
  // Força orientação retrato
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configura estilo das barras do sistema - deixando a barra de notificação visível
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Barra de status transparente
      statusBarIconBrightness:
          Brightness.dark, // Ícones escuros para melhor visibilidade
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Configuração para mostrar a barra de notificações
  if (Platform.isAndroid) {
    // Usamos edgeToEdge com overlay para status bar
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      // Mantém a barra de status visível
      overlays: [SystemUiOverlay.top],
    );
  } else {
    // Para iOS e outras plataformas
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitmo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF4081),
          secondary: const Color(0xFF006064),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
      ),
      builder: (context, child) {
        // Removemos a configuração que poderia remover o padding superior
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarDividerColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
          child: child!,
        );
      },
      home: const SplashScreen(),
    );
  }
}

// Tela de splash para garantir que iniciamos em tela cheia
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Força a tela cheia ao iniciar
    _forceFullScreenMode();

    // Navegar para a tela inicial após um pequeno atraso
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Reforça a tela cheia quando o app volta ao primeiro plano
    if (state == AppLifecycleState.resumed) {
      _forceFullScreenMode();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _forceFullScreenMode() {
    if (Platform.isAndroid) {
      // Use abordagens diferentes para Android
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top], // Mantém a barra de status visível
      );

      // Garante que a barra inferior seja transparente e a superior visível
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
      );
    } else {
      // iOS e outros
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.top], // Mantém a barra de status visível
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Aplica novamente a tela cheia em cada rebuild
    _forceFullScreenMode();

    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child:
                    Image.asset('assets/images/logo.png', fit: BoxFit.contain),
              ),
              const SizedBox(height: 16),
              const Text(
                'Fitmo',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Cada saúde no seu ritmo',
                style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Forçar tela com barra de notificação visível
    _forceFullScreen();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
      ),
    );

    // Iniciar a animação após a construção do widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Reforça as configurações quando o app volta ao primeiro plano
    if (state == AppLifecycleState.resumed) {
      _forceFullScreen();
    }
  }

  void _forceFullScreen() {
    if (Platform.isAndroid) {
      // Android: edgeToEdge com barra de status visível
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top],
      );

      // Estilo da barra de notificações
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
        ),
      );
    } else {
      // iOS e outros: manual com barra de status visível
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.top],
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Forçar tela com barra de notificação visível a cada build
    _forceFullScreen();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Hero(
                          tag: 'fitmo_logo',
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Fitmo',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Cada saúde no seu ritmo',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9C27B0), Color(0xFF1976D2)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navegar para a tela de onboarding
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const OnboardingScreen(),
                          transitionsBuilder: (
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ) {
                            var curve = Curves.easeInOutCubic;

                            var fadeAnimation = Tween<double>(
                              begin: 0.0,
                              end: 1.0,
                            ).animate(
                              CurvedAnimation(parent: animation, curve: curve),
                            );

                            var slideAnimation = Tween<Offset>(
                              begin: const Offset(0.0, 0.3),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(parent: animation, curve: curve),
                            );

                            return FadeTransition(
                              opacity: fadeAnimation,
                              child: SlideTransition(
                                position: slideAnimation,
                                child: child,
                              ),
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 700),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text(
                      'Começar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
