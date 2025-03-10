import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'dart:ui'; // Importação para o ImageFilter
import '../widgets/workout_card.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int? selectedWorkoutIndex;
  String selectedPeriod = 'Semanal';
  int? selectedSpotIndex;

  final List<String> filterPeriods = [
    'Diário',
    'Semanal',
    'Mensal',
    'Anual',
  ];

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  // Header com textos e ícone
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Coluna com os textos
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Olá novamente,',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFADA4A5),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.userName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1D1617),
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                      // Ícone de notificações
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F8F8),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1D242A).withOpacity(0.18),
                              offset: const Offset(0, 0),
                              blurRadius: 40,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.notifications_none,
                          color: Color(0xFFADA4A5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Objetivo do dia
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFFF8AAB).withOpacity(0.2),
                          const Color(0xFF06509B).withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Objetivo do dia',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1D1617),
                          ),
                        ),
                        Container(
                          height: 32,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFFF8AAB),
                                Color(0xFF06509B),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Objetivo do dia marcado como concluído!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: const Text(
                              'Check',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Novo container
                  Container(
                    width: 315,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1D1617).withOpacity(0.07),
                          offset: const Offset(0, 10),
                          blurRadius: 40,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cabeçalho com título e seletor
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Progresso do treino',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1D1617),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [Color(0xFFFF8AAB), Color(0xFF06509B)],
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: PopupMenuButton<String>(
                                  offset: const Offset(0, 40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  color: Colors.white,
                                  elevation: 3,
                                  itemBuilder: (context) {
                                    return filterPeriods.map((period) {
                                      return PopupMenuItem<String>(
                                        value: period,
                                        child: Text(
                                          period,
                                          style: TextStyle(
                                            color: period == selectedPeriod
                                                ? const Color(0xFFFF8AAB)
                                                : const Color(0xFF1D1617),
                                            fontSize: 14,
                                            fontWeight: period == selectedPeriod
                                                ? FontWeight.w600
                                                : FontWeight.w400,
                                          ),
                                        ),
                                      );
                                    }).toList();
                                  },
                                  onSelected: (String value) {
                                    setState(() {
                                      selectedPeriod = value;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        selectedPeriod,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Gráfico
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: LineChart(
                              LineChartData(
                                minX: 0,
                                maxX: 6,
                                minY: 0,
                                maxY: 4,
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  horizontalInterval: 1,
                                  getDrawingHorizontalLine: (value) {
                                    return const FlLine(
                                      color: Color(0xFFF7F8F8),
                                      strokeWidth: 1,
                                    );
                                  },
                                ),
                                titlesData: FlTitlesData(
                                  leftTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 1,
                                      getTitlesWidget: (value, meta) {
                                        if (value == 0) return const SizedBox();
                                        return SideTitleWidget(
                                          axisSide: meta.axisSide,
                                          child: Text(
                                            '${(value * 25).toInt()}%',
                                            style: const TextStyle(
                                              color: Color(0xFFA4A9AD),
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        );
                                      },
                                      reservedSize: 32,
                                    ),
                                  ),
                                  bottomTitles: const AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: bottomTitleWidgets,
                                      reservedSize: 32,
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(show: false),
                                lineTouchData: LineTouchData(
                                  enabled: true,
                                  touchTooltipData: LineTouchTooltipData(
                                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                                      return touchedSpots.map((spot) {
                                        setState(() {
                                          selectedSpotIndex = spot.spotIndex;
                                        });
                                        final day = getDayName(spot.x.toInt());
                                        final value = '${(spot.y * 25).toInt()}%';
                                        return LineTooltipItem(
                                          day,
                                          const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            height: 1.5,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: '\n$value',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList();
                                    },
                                    tooltipBgColor: const Color(0xFFFF8AAB),
                                    tooltipRoundedRadius: 6,
                                    tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                                    return spotIndexes.map((spotIndex) {
                                      return const TouchedSpotIndicatorData(
                                        FlLine(
                                          color: Color(0xFFF7F8F8),
                                          strokeWidth: 18,
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0x8093A8FE), // 93A8FE com 50% de transparência
                                              Color(0x66FFFFFF), // FFFFFF com 40% de transparência
                                            ],
                                          ),
                                        ),
                                        FlDotData(show: true),
                                      );
                                    }).toList();
                                  },
                                  touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
                                    if (event is FlTapUpEvent || event is FlPanEndEvent || event is FlPointerExitEvent) {
                                      setState(() {
                                        selectedSpotIndex = null;
                                      });
                                    }
                                  },
                                  handleBuiltInTouches: true,
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: const [
                                      FlSpot(0, 1.5),
                                      FlSpot(1, 2.5),
                                      FlSpot(2, 2),
                                      FlSpot(3, 3),
                                      FlSpot(4, 2.5),
                                      FlSpot(5, 1.5),
                                      FlSpot(6, 3.5),
                                    ],
                                    isCurved: true,
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFFF8AAB), Color(0xFF06509B)],
                                    ),
                                    barWidth: 2,
                                    isStrokeCapRound: true,
                                    dotData: FlDotData(
                                      show: true,
                                      getDotPainter: (spot, percent, bar, index) {
                                        return _getGradientDotPainter(
                                          spot,
                                          percent,
                                          bar,
                                          index,
                                          selected: index == selectedSpotIndex,
                                        );
                                      },
                                    ),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(0xFFFF8AAB).withOpacity(0.2),
                                          const Color(0xFF06509B).withOpacity(0.2),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            // Container dos últimos treinos
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cabeçalho com título e "Ver mais"
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Último treino',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1D1617),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Ver mais',
                              style: TextStyle(
                                color: Color(0xFFADA4A5),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Lista de treinos com scroll
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            // Treino corpo inteiro
                            WorkoutCard(
                              imagePath: 'assets/images/ultimotreinocorpointeiro.png',
                              title: 'Treino corpo inteiro',
                              calories: 180,
                              duration: 45,
                              isSelected: selectedWorkoutIndex == 0,
                              onSelect: () {
                                setState(() {
                                  selectedWorkoutIndex = selectedWorkoutIndex == 0 ? null : 0;
                                });
                              },
                            ),
                            const SizedBox(height: 24),
                            // Treino de inferiores
                            WorkoutCard(
                              imagePath: 'assets/images/ultimotreinoinferiores.png',
                              title: 'Treino de inferiores',
                              calories: 180,
                              duration: 30,
                              isSelected: selectedWorkoutIndex == 1,
                              onSelect: () {
                                setState(() {
                                  selectedWorkoutIndex = selectedWorkoutIndex == 1 ? null : 1;
                                });
                              },
                            ),
                            const SizedBox(height: 24),
                            // Treino de abdôme
                            WorkoutCard(
                              imagePath: 'assets/images/ultimotreinoabdome.png',
                              title: 'Treino de abdôme',
                              calories: 180,
                              duration: 20,
                              isSelected: selectedWorkoutIndex == 2,
                              onSelect: () {
                                setState(() {
                                  selectedWorkoutIndex = selectedWorkoutIndex == 2 ? null : 2;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
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
                setState(() {
                  if (index == 0) {
                    // Já está na HomeScreen, não precisa fazer nada
                    return;
                  } else if (index == 1) {
                    // Navegar para a tela de Treinos
                    // TODO: Implementar navegação para tela de Treinos
                  } else if (index == 2) {
                    // Navegar para a tela de Perfil
                    // TODO: Implementar navegação para tela de Perfil
                  }
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

FlDotPainter _getGradientDotPainter(FlSpot spot, double xPercentage, LineChartBarData bar, int index, {bool selected = false}) {
  return FlDotCirclePainter(
    radius: selected ? 3 : 1.5,
    color: Colors.white,
    strokeWidth: selected ? 1.5 : 1,
    strokeColor: Color.lerp(
      const Color(0xFFFF8AAB),
      const Color(0xFF06509B),
      xPercentage,
    )!,
  );
}

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Color(0xFFA4A9AD),
    fontSize: 10,
    fontWeight: FontWeight.w400,
  );
  
  String text;
  switch (value.toInt()) {
    case 0:
      text = 'Seg';
      break;
    case 1:
      text = 'Ter';
      break;
    case 2:
      text = 'Qua';
      break;
    case 3:
      text = 'Qui';
      break;
    case 4:
      text = 'Sex';
      break;
    case 5:
      text = 'Sab';
      break;
    case 6:
      text = 'Dom';
      break;
    default:
      return Container();
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Text(text, style: style),
  );
}

String getDayName(int value) {
  switch (value) {
    case 0:
      return 'Seg, 28 Maio';
    case 1:
      return 'Ter, 29 Maio';
    case 2:
      return 'Qua, 30 Maio';
    case 3:
      return 'Qui, 31 Maio';
    case 4:
      return 'Sex, 1 Jun';
    case 5:
      return 'Sab, 2 Jun';
    case 6:
      return 'Dom, 3 Jun';
    default:
      return '';
  }
}
