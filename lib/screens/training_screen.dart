import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'dart:ui'; // Importação para o ImageFilter

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> with WidgetsBindingObserver {
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
      // Corpo da tela com AppBar personalizada
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double availableHeight = constraints.maxHeight;
          final double availableWidth = constraints.maxWidth;
          final bool isPortrait = availableHeight > availableWidth;

          // Tamanhos responsivos para diferentes proporções de tela
          final double appBarHeight =
              isPortrait ? availableHeight * 0.08 : availableHeight * 0.12;
          final double appBarPadding = availableWidth * 0.04;
          final double appBarFontSize =
              isPortrait ? availableWidth * 0.06 : availableWidth * 0.04;
          final double iconSize =
              isPortrait ? availableWidth * 0.07 : availableWidth * 0.05;
          final double contentPadding = availableWidth * 0.06;

          return Column(
            children: [
              // AppBar personalizada responsiva
              Container(
                height: appBarHeight,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFCD65CE), Color(0xFF2B5AD5)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: appBarPadding),
                  child: Row(
                    children: [
                      Text(
                        'Treinos',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: appBarFontSize,
                        ),
                      ),
                      const Spacer(),
                      // Ícones na AppBar
                      IconButton(
                        icon: Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                          size: iconSize,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
              // Conteúdo vazio da tela - será preenchido posteriormente
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: contentPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'O que vamos treinar?',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView(
                          children: [
                            _buildTrainingCard(
                              title: 'Treino de Peito',
                              exercises: '12 Exercícios',
                              duration: '40mins',
                              onTap: () {
                                // Será implementado posteriormente
                              },
                            ),
                            _buildTrainingCard(
                              title: 'Treino de Pernas',
                              exercises: '14 Exercícios',
                              duration: '45mins',
                              onTap: () {
                                // Será implementado posteriormente
                              },
                            ),
                            _buildTrainingCard(
                              title: 'Treino de Braços',
                              exercises: '10 Exercícios',
                              duration: '35mins',
                              onTap: () {
                                // Será implementado posteriormente
                              },
                            ),
                            _buildTrainingCard(
                              title: 'Treino de Ombro',
                              exercises: '8 Exercícios',
                              duration: '30mins',
                              onTap: () {
                                // Será implementado posteriormente
                              },
                            ),
                            _buildTrainingCard(
                              title: 'Treino de Costas',
                              exercises: '11 Exercícios',
                              duration: '40mins',
                              onTap: () {
                                // Será implementado posteriormente
                              },
                            ),
                            _buildTrainingCard(
                              title: 'Treino de Glúteos',
                              exercises: '12 Exercícios',
                              duration: '35mins',
                              onTap: () {
                                // Será implementado posteriormente
                              },
                            ),
                            // Adiciona um espaço no final da lista para não sobrepor com a barra de navegação
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      extendBody: true, // Permite que o conteúdo passe por baixo da BottomNavigationBar
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          // Adiciona um efeito de blur sob a barra de navegação para melhor contraste
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Theme(
            data: Theme.of(context).copyWith(
              // Ajusta o tema da barra de navegação para ser mais legível
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                selectedItemColor: const Color(0xFFCD65CE),
                unselectedItemColor: Colors.grey,
                selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
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
              currentIndex: 1, // Indica que estamos na página de treinos
              onTap: (index) {
                if (index == 0) {
                  // Navegar para a tela inicial
                  Navigator.pop(context);
                }
                // Para o índice 1 não fazemos nada, pois já estamos na tela de treinos
                // Implementar navegação para a tela de perfil quando o índice for 2
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrainingCard({
    required String title,
    required String exercises,
    required String duration,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  const Color(0xFFCD65CE).withOpacity(0.15),
                  const Color(0xFF2B5AD5).withOpacity(0.15),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF212121),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$exercises | $duration',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: onTap,
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF2B5AD5),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: const Text(
                      'Ver mais',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 