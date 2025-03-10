import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'dart:ui';
import 'workout_screen.dart';
import 'settings_screen.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'profile_screen.dart';
import 'music_player_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final String? userEmail;

  const HomeScreen({
    super.key,
    required this.userName,
    this.userEmail,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _selectedIndex = 0;

  // Lista de widgets para as abas
  late final List<Widget> _screens;

  // Controlador para animações entre telas
  final PageController _pageController = PageController();

  // Dados para o gráfico (simulação)
  final List<double> _graphPoints = [
    0.3,
    0.5,
    0.4,
    0.7,
    0.5,
    0.8,
    0.6,
    0.9,
    0.7
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Inicializa a lista de telas com a tela de treinos separada
    _screens = [
      _buildHomeContent(),
      const WorkoutScreen(), // Usando a nova tela de treinos
      const MusicPlayerScreen(), // Adicionando a tela do player de música
      const SettingsScreen(), // Adicionando a tela de configurações
      ProfileScreen(userEmail: widget.userEmail),
    ];
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

      // Também ajustamos os ícones para iOS
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness:
              Brightness.light, // iOS usa o inverso (light = ícones escuros)
        ),
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
      backgroundColor:
          isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double availableHeight = constraints.maxHeight;
            final double availableWidth = constraints.maxWidth;
            final bool isPortrait = availableHeight > availableWidth;

            // Tamanhos responsivos
            final double cardPadding = availableWidth * 0.05;
            final double contentPadding = availableWidth * 0.06;
            final double avatarSize =
                isPortrait ? availableWidth * 0.12 : availableWidth * 0.08;
            final double titleFontSize = isPortrait ? 18.0 : 16.0;
            final double subtitleFontSize = isPortrait ? 14.0 : 12.0;
            final double iconSize = isPortrait ? 26.0 : 22.0;

            return Stack(
              children: [
                // PageView para permitir animações de deslizamento entre abas
                PageView(
                  controller: _pageController,
                  physics:
                      const NeverScrollableScrollPhysics(), // Desabilita o deslizamento manual
                  onPageChanged: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  children: _screens,
                ),

                // Barra de navegação na parte inferior
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: availableWidth * 0.95,
                      height: 60,
                      decoration: BoxDecoration(
                        color:
                            isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(isDarkMode ? 0.3 : 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildNavItem(
                              0, Icons.home, 'Início', true, isDarkMode),
                          _buildNavItem(1, Icons.calendar_today, 'Treinos',
                              true, isDarkMode),
                          _buildNavItem(
                              2, Icons.music_note, 'Música', true, isDarkMode),
                          _buildNavItem(
                              3, Icons.settings, 'Ajustes', true, isDarkMode),
                          _buildNavItem(
                              4, Icons.person, 'Perfil', true, isDarkMode),
                        ],
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

  // Conteúdo da tela Home - Atualizado para suportar tema escuro
  Widget _buildHomeContent() {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, _) {
      final isDarkMode = themeProvider.isDarkMode;

      return LayoutBuilder(builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;
        final double contentPadding = availableWidth * 0.06;
        final double cardPadding = availableWidth * 0.05;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: contentPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Cabeçalho "Início"
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    'Início',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Cartão do usuário
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Olá novamente!',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.grey[400] : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.userName,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Cartão de Progresso do Treino
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título e botão
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progresso do treino',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDarkMode
                                    ? Colors.white
                                    : const Color(0xFF212121),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isDarkMode
                                      ? [
                                          ThemeProvider.lightPurple,
                                          ThemeProvider.primaryPurple
                                        ]
                                      : [
                                          ThemeProvider.primaryPurple,
                                          ThemeProvider.darkPurple
                                        ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                children: [
                                  Text(
                                    'Semanal',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Icon(Icons.keyboard_arrow_down,
                                      color: Colors.white, size: 16),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Barra de porcentagem
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Row(
                          children: [
                            Text('0%',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? const Color(0xFF2A2A2A)
                                      : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: FractionallySizedBox(
                                  widthFactor: 0.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          ThemeProvider.secondaryPink,
                                          ThemeProvider.lightPink
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('+0%',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.green)),
                          ],
                        ),
                      ),

                      // Gráfico
                      SizedBox(
                        height: 120,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                          child: Center(
                            child: Text(
                              'Você ainda não possui progresso registrado',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Porcentagens do gráfico
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('0%',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey)),
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: (isDarkMode
                                            ? ThemeProvider.lightPurple
                                            : ThemeProvider.primaryPurple)
                                        .withOpacity(0.7),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text('-40%',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: isDarkMode
                                            ? Colors.grey[400]
                                            : Colors.grey)),
                              ],
                            ),
                            Text('50%',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Seção Histórico de Treinos
                Text(
                  'Histórico de Treinos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : const Color(0xFF212121),
                  ),
                ),

                const SizedBox(height: 16),

                // Mensagem de que não há treinos ainda
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.fitness_center,
                        size: 50,
                        color: isDarkMode
                            ? Colors.grey[600]
                            : Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhum treino realizado ainda',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode
                              ? Colors.white
                              : const Color(0xFF212121),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Comece sua jornada fitness hoje mesmo! Escolha um treino e dê o primeiro passo.',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode
                              ? Colors.grey[400]
                              : Colors.grey.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDarkMode
                                ? [
                                    ThemeProvider.lightPurple,
                                    ThemeProvider.primaryPurple
                                  ]
                                : [
                                    ThemeProvider.primaryPurple,
                                    ThemeProvider.darkPurple
                                  ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Iniciar Primeiro Treino',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Espaço adicional para evitar que o conteúdo fique atrás da barra de navegação
                const SizedBox(height: 80),
              ],
            ),
          ),
        );
      });
    });
  }

  // Construir item de navegação com possibilidade de desabilitar - Adaptado para tema
  Widget _buildNavItem(
      int index, IconData icon, String label, bool enabled, bool isDarkMode) {
    final isSelected = _selectedIndex == index;
    final Color activeColor =
        isDarkMode ? const Color(0xFF8899FF) : const Color(0xFF6677CC);
    final Color inactiveColor = isDarkMode ? Colors.grey[600]! : Colors.grey;

    // Removemos o disabledColor já que agora todos os itens são habilitados
    final color = isSelected ? activeColor : inactiveColor;

    // Item de música (índice 2) com estilo especial quando selecionado
    if (index == 2) {
      return InkWell(
        onTap: () {
          setState(() {
            _selectedIndex = index;
            // Adiciona animação ao trocar de aba
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? activeColor : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : color,
                size: 24,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      );
    }

    // Outros itens com estilo padrão
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          // Adiciona animação ao trocar de aba
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // Item de treino
  Widget _buildWorkoutItem(String title, String subtitle, double progress,
      Color color, String image) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Imagem do treino
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.fitness_center, color: color);
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Informações do treino
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Barra de progresso
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Checkbox circular
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Pintor personalizado para o gráfico
class GraphPainter extends CustomPainter {
  final List<double> points;

  GraphPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = const Color(0xFF6677CC).withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final Paint fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF6677CC).withOpacity(0.2),
          const Color(0xFF6677CC).withOpacity(0.05),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final double spacing = size.width / (points.length - 1);
    final double maxValue = 1.0;

    final Path linePath = Path();
    final Path fillPath = Path();

    // Caminho para a linha
    for (int i = 0; i < points.length; i++) {
      final double x = i * spacing;
      final double y = size.height - (points[i] / maxValue * size.height);

      if (i == 0) {
        linePath.moveTo(x, y);
        fillPath.moveTo(x, y);
      } else {
        final double prevX = (i - 1) * spacing;
        final double prevY =
            size.height - (points[i - 1] / maxValue * size.height);

        // Ponto de controle para curva suave
        final double cpX1 = prevX + (x - prevX) / 2;

        linePath.cubicTo(cpX1, prevY, cpX1, y, x, y);
        fillPath.cubicTo(cpX1, prevY, cpX1, y, x, y);
      }
    }

    // Caminho para o preenchimento
    final double lastX = (points.length - 1) * spacing;
    fillPath.lineTo(lastX, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    // Desenha os caminhos
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(linePath, linePaint);

    // Ponto destacado (no valor mais alto)
    int highestIndex = 0;
    double highestValue = points[0];
    for (int i = 1; i < points.length; i++) {
      if (points[i] > highestValue) {
        highestValue = points[i];
        highestIndex = i;
      }
    }

    final double hx = highestIndex * spacing;
    final double hy = size.height - (highestValue / maxValue * size.height);

    // Desenha o retângulo destacado
    final Paint highlightPaint = Paint()
      ..color = const Color(0xFF6677CC).withOpacity(0.2)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(hx - 10, 0, 20, size.height),
      highlightPaint,
    );

    // Desenha o ponto destacado
    final Paint dotPaint = Paint()
      ..color = const Color(0xFF6677CC)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(hx, hy), 5, dotPaint);
  }

  @override
  bool shouldRepaint(GraphPainter oldDelegate) => true;
}
