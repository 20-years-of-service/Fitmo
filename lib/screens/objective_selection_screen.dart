import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'welcome_screen.dart';

class ObjectiveSelectionScreen extends StatefulWidget {
  const ObjectiveSelectionScreen({super.key});

  @override
  State<ObjectiveSelectionScreen> createState() =>
      _ObjectiveSelectionScreenState();
}

class _ObjectiveSelectionScreenState extends State<ObjectiveSelectionScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;
  late List<Animation<double>> _dotAnimations;

  final List<ObjectiveCard> _objectives = [
    const ObjectiveCard(
      title: 'Melhorar seu Shape',
      description:
          'Tenho uma baixa quantidade de gordura corporal e preciso/quero ganhar mais massa muscular.',
      imagePath: 'assets/images/melhoraroseushape.png',
    ),
    const ObjectiveCard(
      title: 'Esbelto & Definido',
      description:
          'Sou \'magro com gordura\'. Pareço magro, mas não tenho definição. Quero ganhar massa muscular magra da maneira certa.',
      imagePath: 'assets/images/esbeltoedefinido.png',
    ),
    const ObjectiveCard(
      title: 'Perder peso',
      description:
          'Tenho uma certa quantidade de gordura corporal. Quero eliminar essa gordura e ganhar massa magra.',
      imagePath: 'assets/images/perderpeso.png',
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Garantir modo tela cheia
    _forceFullScreen();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _dotAnimations = List.generate(
      _objectives.length,
      (index) => Tween<double>(begin: 0.8, end: 1.2).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index / _objectives.length,
            (index + 1) / _objectives.length,
            curve: Curves.easeInOut,
          ),
        ),
      ),
    );
  }

  void _forceFullScreen() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Forçar modo tela cheia a cada build
    _forceFullScreen();

    return Scaffold(
      backgroundColor: Color(0xFFFFF5F5),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double availableHeight = constraints.maxHeight;
            final double availableWidth = constraints.maxWidth;
            final bool isPortrait = availableHeight > availableWidth;
            // Define tamanhos responsivos
            final double headerPaddingTop = availableHeight * 0.04;
            final double headerPaddingBottom = availableHeight * 0.02;
            final double titleFontSize =
                isPortrait ? availableWidth * 0.06 : availableWidth * 0.04;
            final double subtitleFontSize =
                isPortrait ? availableWidth * 0.04 : availableWidth * 0.03;
            final double buttonHeight = availableHeight * 0.07;

            return Column(
              children: [
                // Cabeçalho
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    availableWidth * 0.04,
                    headerPaddingTop,
                    availableWidth * 0.04,
                    headerPaddingBottom,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Qual é seu objetivo?',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: availableHeight * 0.01),
                      Text(
                        'Isso nos ajudará a escolher o melhor programa para você',
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: Color(0xFF666666),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                // Cartões deslizáveis - Expandimos para ocupar espaço disponível
                Expanded(
                  flex: 9,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _objectives.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                      // Ativar animação das bolinhas
                      _animationController.reset();
                      _animationController.forward();
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: availableWidth * 0.04,
                          vertical: availableHeight * 0.01,
                        ),
                        child: _objectives[index],
                      );
                    },
                  ),
                ),

                // Indicadores de página (bolinhas) fora do cartão
                Padding(
                  padding: EdgeInsets.only(bottom: availableHeight * 0.02),
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_objectives.length, (index) {
                          final isCurrentPage = _currentPage == index;
                          final scale =
                              isCurrentPage ? _dotAnimations[index].value : 1.0;
                          final dotSize = isCurrentPage
                              ? availableWidth * 0.025
                              : availableWidth * 0.02;

                          return Transform.scale(
                            scale: scale,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: availableWidth * 0.01,
                              ),
                              width: dotSize,
                              height: dotSize,
                              decoration: BoxDecoration(
                                color: isCurrentPage
                                    ? const Color(0xFF1976D2)
                                    : Colors.grey.withOpacity(0.3),
                                borderRadius:
                                    BorderRadius.circular(dotSize / 2),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),

                // Botão confirmar
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    availableWidth * 0.04,
                    0,
                    availableWidth * 0.04,
                    availableHeight * 0.04,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: buttonHeight,
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
                        // Navegar para a tela de boas-vindas
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const WelcomeScreen(
                              userName:
                                  '{Usuario}', // Este valor pode ser substituído pelo nome real do usuário
                            ),
                          ),
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
                        'Confirmar',
                        style: TextStyle(
                          fontSize: availableWidth * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ObjectiveCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const ObjectiveCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableHeight = constraints.maxHeight;
        final double availableWidth = constraints.maxWidth;
        final bool isPortrait = availableHeight > availableWidth;

        final titleFontSize =
            isPortrait ? availableWidth * 0.05 : availableWidth * 0.035;
        final descriptionFontSize =
            isPortrait ? availableWidth * 0.035 : availableWidth * 0.025;

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(availableWidth * 0.05),
          ),
          child: Padding(
            padding: EdgeInsets.all(availableWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Imagem do objetivo
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFCD65CE), Color(0xFF2B5AD5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(
                        availableWidth * 0.05,
                      ),
                    ),
                    child: Center(
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                        height: availableHeight * 0.5,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: availableHeight * 0.03),

                // Título do objetivo
                Text(
                  title,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF212121),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: availableHeight * 0.02),

                // Descrição do objetivo
                Text(
                  description,
                  style: TextStyle(
                    fontSize: descriptionFontSize,
                    color: Color(0xFF666666),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
