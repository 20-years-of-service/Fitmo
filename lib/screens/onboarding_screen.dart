import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'signup_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with WidgetsBindingObserver {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    const OnboardingPage(
      title: 'Defina seu objetivo',
      description:
          'Mesmo que tenha dificuldades em definir seu objetivo, nós podemos te ajudar!',
      imagePath: 'assets/images/definaseuobjetivo.png',
    ),
    const OnboardingPage(
      title: 'Sinta a Queimação!',
      description:
          'Continue queimando para alcançar seus objetivos. A dor é temporária, mas desistir agora deixará marcas para sempre.',
      imagePath: 'assets/images/sintaaqueimacao.png',
    ),
    const OnboardingPage(
      title: 'Alimente-se bem!',
      description:
          'Comece um estilo de vida mais saudável se alimentando bem e com cardápios variados.',
      imagePath: 'assets/images/alimentesebem.png',
    ),
    const OnboardingPage(
      title: 'Descanse bem',
      description:
          'Melhore a qualidade do seu sono, um sono de boa qualidade pode trazer um bom humor e energia pela manhã.',
      imagePath: 'assets/images/descansebem.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Adiciona observer para detectar mudanças no ciclo de vida do app
    WidgetsBinding.instance.addObserver(this);
    // Garantir que estamos em modo tela cheia
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
    _pageController.dispose();
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
          // Ícones claros para melhor visibilidade sobre o fundo colorido
          statusBarIconBrightness: Brightness.light,
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

  void _goToNextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navegar para a tela de registro
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const SignupScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Forçar o modo tela cheia a cada build
    _forceFullScreenMode();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return _pages[index];
              },
            ),
          ),
          // SafeArea apenas para a navegação inferior
          SafeArea(
            top: false, // Não precisamos de padding no topo aqui
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dots indicadores de página
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => Container(
                        margin: const EdgeInsets.only(right: 6),
                        width: _currentPage == index ? 10 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? const Color(0xFF1976D2)
                              : Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  // Botão de próximo (só aparece na última tela)
                  _currentPage == _pages.length - 1
                      ? Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFCD65CE), Color(0xFF2B5AD5)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF8868CD).withOpacity(0.4),
                                blurRadius: 8,
                                spreadRadius: 1,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: _goToNextPage,
                          ),
                        )
                      : const SizedBox(width: 44),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    // Usamos LayoutBuilder para adaptar o layout baseado no espaço disponível
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculamos proporções em vez de usar valores fixos
        final double availableHeight = constraints.maxHeight;
        final double availableWidth = constraints.maxWidth;

        // Ajustamos proporcionalmente baseado na orientação e tamanho da tela
        final bool isPortrait = availableHeight > availableWidth;
        final double topContainerHeight = isPortrait
            ? availableHeight * 0.45 // 45% da altura em retrato
            : availableHeight * 0.55; // 55% da altura em paisagem

        // Obtém o tamanho da barra de status para estender o gradient corretamente
        final statusBarHeight = MediaQuery.of(context).padding.top;

        return Stack(
          children: [
            // Background que se estende por trás da status bar
            Positioned(
              top: -statusBarHeight, // Move para trás da barra de status
              left: 0,
              right: 0,
              height: topContainerHeight + statusBarHeight,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFCD65CE), Color(0xFF2B5AD5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(
                      availableWidth * 0.3,
                    ),
                    bottomRight: Radius.circular(availableWidth * 0.3),
                  ),
                ),
              ),
            ),
            // Conteúdo que respeita a área segura
            Column(
              children: [
                // Container para a imagem
                Container(
                  height: topContainerHeight,
                  width: availableWidth,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: statusBarHeight * 0.5),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                        height: topContainerHeight * 0.8,
                      ),
                    ),
                  ),
                ),

                // Parte inferior com texto - flexível para diferentes tamanhos de tela
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: availableWidth * 0.08,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: availableHeight * 0.03,
                        ),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: isPortrait
                                ? availableWidth * 0.06
                                : availableWidth * 0.04,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF212121),
                          ),
                        ),
                        SizedBox(height: availableHeight * 0.01),
                        Flexible(
                          child: Text(
                            description,
                            style: TextStyle(
                              fontSize: isPortrait
                                  ? availableWidth * 0.04
                                  : availableWidth * 0.03,
                              color: const Color(0xFF666666),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
