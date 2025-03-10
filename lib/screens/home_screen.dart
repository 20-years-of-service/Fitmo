import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'dart:ui'; // Importação para o ImageFilter

class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Forçar modo tela cheia
    _forceFullScreenMode();
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

  // Função atualizada para garantir o modo com barra de notificação visível
  void _forceFullScreenMode() {
    if (Platform.isAndroid) {
      // Usa edge-to-edge com barra de notificação visível
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top], // Mantém a barra de status visível
      );

      // Define estilo da barra de notificação
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness
              .light, // Ícones claros para melhor visibilidade sobre o fundo colorido
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

      // Também ajustamos os ícones para iOS
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness:
              Brightness.dark, // iOS usa o inverso (dark = ícones claros)
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Forçar modo tela cheia
    _forceFullScreenMode();

    return Scaffold(
      // Corpo da tela com AppBar personalizada
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double availableHeight = constraints.maxHeight;
          final double availableWidth = constraints.maxWidth;
          final bool isPortrait = availableHeight > availableWidth;

          return Stack(
            children: [
              // Fundo gradiente que se estende por trás da barra de notificações
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).padding.top +
                    (isPortrait
                        ? availableHeight * 0.08
                        : availableHeight * 0.12),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFCD65CE), Color(0xFF2B5AD5)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
              // Conteúdo que respeita a área segura
              SafeArea(
                child: Column(
                  children: [
                    // AppBar personalizada responsiva
                    Container(
                      height: isPortrait
                          ? availableHeight * 0.08
                          : availableHeight * 0.12,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFCD65CE), Color(0xFF2B5AD5)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: availableWidth * 0.04),
                        child: Row(
                          children: [
                            Text(
                              'Fitmo',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: isPortrait
                                    ? availableWidth * 0.06
                                    : availableWidth * 0.04,
                              ),
                            ),
                            const Spacer(),
                            // Ícones na AppBar
                            IconButton(
                              icon: Icon(
                                Icons.notifications_outlined,
                                color: Colors.white,
                                size: isPortrait
                                    ? availableWidth * 0.07
                                    : availableWidth * 0.05,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Conteúdo da tela - adaptativo para diferentes tamanhos
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: availableWidth * 0.06),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fitness_center,
                              size: isPortrait
                                  ? availableWidth * 0.2
                                  : availableWidth * 0.15,
                              color: Color(0xFF2B5AD5),
                            ),
                            SizedBox(height: availableHeight * 0.04),
                            Text(
                              'Bem-vindo à tela inicial, ${widget.userName}!',
                              style: TextStyle(
                                fontSize: isPortrait
                                    ? availableWidth * 0.06
                                    : availableWidth * 0.04,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF212121),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: availableHeight * 0.02),
                            Text(
                              'Aqui será o dashboard principal do aplicativo.',
                              style: TextStyle(
                                fontSize: isPortrait
                                    ? availableWidth * 0.045
                                    : availableWidth * 0.035,
                                color: Color(0xFF666666),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      extendBody:
          true, // Permite que o conteúdo passe por baixo da BottomNavigationBar
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          // Adiciona um efeito de blur sob a barra de navegação para melhor contraste
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Theme(
            data: Theme.of(context).copyWith(
              // Ajusta o tema da barra de navegação para ser mais legível
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                selectedItemColor: Color(0xFFCD65CE),
                unselectedItemColor: Colors.grey,
                selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            child: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Início',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: 'Treinos',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Perfil',
                ),
              ],
              currentIndex: 0,
              onTap: (index) {
                // Implementar navegação para outras telas aqui
              },
            ),
          ),
        ),
      ),
    );
  }
}
