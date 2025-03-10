import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  final String userName;
  final String? userEmail;

  const WelcomeScreen({
    super.key,
    required this.userName,
    this.userEmail,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Forçar tela cheia
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
    // Forçar modo tela cheia
    _forceFullScreenMode();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double availableHeight = constraints.maxHeight;
            final double availableWidth = constraints.maxWidth;
            final bool isPortrait = availableHeight > availableWidth;

            // Calculamos tamanhos responsivos baseados na tela
            final double horizontalPadding = availableWidth * 0.06;
            final double titleFontSize =
                isPortrait ? availableWidth * 0.07 : availableWidth * 0.05;
            final double subtitleFontSize =
                isPortrait ? availableWidth * 0.045 : availableWidth * 0.035;
            final double buttonHeight =
                isPortrait ? availableHeight * 0.07 : availableHeight * 0.1;
            final double buttonFontSize =
                isPortrait ? availableWidth * 0.05 : availableWidth * 0.04;
            final double bottomSpacing = availableHeight * 0.04;

            return Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Imagem central com tamanho responsivo
                  Expanded(
                    flex: 6,
                    child: Center(
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: isPortrait
                              ? availableHeight * 0.4
                              : availableHeight * 0.6,
                          maxWidth: availableWidth * 0.8,
                        ),
                        child: Image.asset(
                          'assets/images/sejabemvindo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  // Espaçamento flexível
                  SizedBox(height: availableHeight * 0.02),

                  // Seção de texto centralizada
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Título com nome do usuário
                      Text(
                        'Bem vindo, ${widget.userName}',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: availableHeight * 0.02),
                      // Subtítulo
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: availableWidth * 0.8,
                        ),
                        child: Text(
                          'Agora está tudo pronto. Vamos alcançar seus objetivos juntos!',
                          style: TextStyle(
                            fontSize: subtitleFontSize,
                            color: Color(0xFF666666),
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),

                  // Espaçamento flexível
                  SizedBox(height: availableHeight * 0.04),

                  // Botão "Tela inicial" responsivo
                  Container(
                    width: double.infinity,
                    height: buttonHeight,
                    constraints: BoxConstraints(maxWidth: availableWidth * 0.8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFCD65CE), Color(0xFF2B5AD5)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(buttonHeight / 2),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8868CD).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // Navegar para a tela inicial do app
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(
                              userName: widget.userName,
                              userEmail: widget.userEmail,
                            ),
                          ),
                          (route) =>
                              false, // Remove todas as telas anteriores da pilha
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(buttonHeight / 2),
                        ),
                      ),
                      child: Text(
                        'Tela inicial',
                        style: TextStyle(
                          fontSize: buttonFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Espaço inferior para equilíbrio
                  SizedBox(height: bottomSpacing),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
