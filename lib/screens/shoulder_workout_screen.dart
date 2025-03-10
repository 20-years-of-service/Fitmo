import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ShoulderWorkoutScreen extends StatefulWidget {
  const ShoulderWorkoutScreen({super.key});

  // Lista estática de exercícios para o treino de ombro
  static final List<Map<String, dynamic>> exercises = [
    {
      'name': 'Elevação Lateral Sentado com Halteres',
      'sets': '4x10',
      'weight': '0',
      'type': 'strength'
    },
    {
      'name': 'Elevação Frontal Sentado com Halteres',
      'sets': '4x10',
      'weight': '0',
      'type': 'strength'
    },
    {
      'name': 'Desenvolvimento Máquina',
      'sets': '4x10',
      'weight': '0',
      'type': 'strength'
    },
    {
      'name': 'Desenvolvimento com Halteres Sentado',
      'sets': '4x10',
      'weight': '0',
      'type': 'strength'
    },
    {
      'name': 'Elevação Frontal na Polia com Corda',
      'sets': '4x10',
      'weight': '0',
      'type': 'strength'
    },
    {
      'name': 'Encolhimento de Ombros com Halteres',
      'sets': '4x20',
      'weight': '0',
      'type': 'strength'
    },
    {
      'name': 'Abdominal Supra no Banco Declinado',
      'sets': '4x20',
      'weight': '0',
      'type': 'strength'
    },
    {
      'name': 'Cardio: Simulador de Escada',
      'time': '20',
      'unit': 'min',
      'type': 'cardio'
    },
  ];

  // Método estático para obter o número de exercícios
  static int getExerciseCount() {
    return exercises.length > 0 ? exercises.length : 0;
  }

  @override
  State<ShoulderWorkoutScreen> createState() => _ShoulderWorkoutScreenState();
}

class _ShoulderWorkoutScreenState extends State<ShoulderWorkoutScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Inicializa o controlador de animação
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Animação de fade in
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Animação de slide de baixo para cima
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutQuint,
      ),
    );

    // Forçar modo tela cheia
    _forceFullScreenMode();

    // Inicia a animação após um pequeno delay
    Future.delayed(const Duration(milliseconds: 100), () {
      _animationController.forward();
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
    _animationController.dispose();
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
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      final isDarkMode = themeProvider.isDarkMode;

      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              isDarkMode ? Brightness.light : Brightness.dark,
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

    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.white,
      // Corpo da tela com AppBar personalizada
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double availableHeight = constraints.maxHeight;
          final double availableWidth = constraints.maxWidth;
          final bool isPortrait = availableHeight > availableWidth;

          // Tamanhos responsivos para diferentes proporções de tela
          final double appBarHeight =
              isPortrait ? availableHeight * 0.12 : availableHeight * 0.16;
          final double appBarPadding = availableWidth * 0.05;
          final double appBarFontSize =
              isPortrait ? availableWidth * 0.06 : availableWidth * 0.04;
          final double iconSize =
              isPortrait ? availableWidth * 0.07 : availableWidth * 0.05;
          final double contentPadding = availableWidth * 0.04;

          return Column(
            children: [
              // AppBar personalizada responsiva
              Container(
                height: appBarHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDarkMode
                        ? [
                            ThemeProvider.lightPurple,
                            ThemeProvider.primaryPurple
                          ]
                        : [const Color(0xFFCD65CE), const Color(0xFF2B5AD5)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      right: appBarPadding, left: appBarPadding * 0.5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: appBarPadding * 0.65),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: iconSize,
                              ),
                              onPressed: () {
                                // Adiciona animação ao voltar
                                _animationController.reverse().then((_) {
                                  Navigator.pop(context);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: appBarPadding * 0.3),
                      Padding(
                        padding: EdgeInsets.only(bottom: appBarPadding),
                        child: Text(
                          'Treino de Ombro',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: appBarFontSize,
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
              // Conteúdo da tela com animações
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: contentPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            'Exercícios',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF212121),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Botão de iniciar treino
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ElevatedButton(
                              onPressed: () {
                                // Mostrar diálogo de perguntas
                                _showWorkoutQuestionsDialog(context);
                              },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                backgroundColor: isDarkMode
                                    ? ThemeProvider.lightPurple
                                    : const Color(0xFF6677CC),
                                foregroundColor: Colors.white,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Iniciar Treino',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount:
                                  ShoulderWorkoutScreen.exercises.length +
                                      1, // +1 para o espaço final
                              itemBuilder: (context, index) {
                                // Adiciona um espaço no final da lista
                                if (index ==
                                    ShoulderWorkoutScreen.exercises.length) {
                                  return const SizedBox(height: 20);
                                }

                                final exercise =
                                    ShoulderWorkoutScreen.exercises[index];
                                // Animação com delay sequencial para cada item
                                return AnimatedBuilder(
                                  animation: _animationController,
                                  builder: (context, child) {
                                    final double itemDelay = index * 0.1;
                                    final double start = itemDelay;
                                    final double end = start + 0.4;

                                    final double opacity = Interval(
                                            start.clamp(0.0, 1.0),
                                            end.clamp(0.0, 1.0),
                                            curve: Curves.easeInOut)
                                        .transform(_animationController.value);

                                    final double slideValue = Interval(
                                            start.clamp(0.0, 1.0),
                                            end.clamp(0.0, 1.0),
                                            curve: Curves.easeOutQuint)
                                        .transform(_animationController.value);

                                    return Transform.translate(
                                      offset: Offset(0, 20 * (1 - slideValue)),
                                      child: Opacity(
                                        opacity: opacity,
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: exercise['type'] == 'cardio'
                                      ? _buildCardioExerciseCard(
                                          name: exercise['name'],
                                          time: exercise['time'],
                                          unit: exercise['unit'],
                                          onTap: () {},
                                          isDarkMode: isDarkMode)
                                      : _buildExerciseCard(
                                          name: exercise['name'],
                                          sets: exercise['sets'],
                                          weight: exercise['weight'],
                                          onTap: () {},
                                          isDarkMode: isDarkMode),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildExerciseCard({
    required String name,
    required String sets,
    required String weight,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Imagem do exercício (usado um círculo cinza como placeholder)
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? const Color(0xFF2C2C2C)
                          : const Color(0xFFEEEEEE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.fitness_center,
                        color: isDarkMode
                            ? Colors.grey[400]
                            : const Color(0xFF666666),
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Nome do exercício
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color:
                            isDarkMode ? Colors.white : const Color(0xFF212121),
                      ),
                    ),
                  ),
                  // Detalhes do exercício
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Séries: $sets',
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardioExerciseCard({
    required String name,
    required String time,
    required String unit,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Imagem do exercício (usado um círculo cinza como placeholder)
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? const Color(0xFF2C2C2C)
                          : const Color(0xFFEEEEEE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.timer,
                        color: isDarkMode
                            ? Colors.grey[400]
                            : const Color(0xFF666666),
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Nome do exercício
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color:
                            isDarkMode ? Colors.white : const Color(0xFF212121),
                      ),
                    ),
                  ),
                  // Detalhes do exercício
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Tempo: $time $unit',
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showWorkoutQuestionsDialog(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;

    // Mostrar mensagem que a função está em desenvolvimento
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor:
            isDarkMode ? const Color(0xFF2C2C2C) : const Color(0xFF6677CC),
        content: Text(
          'Função em Desenvolvimento.',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
