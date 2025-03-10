import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'chest_workout_screen.dart';
import 'legs_workout_screen.dart';
import 'arms_workout_screen.dart';
import 'shoulder_workout_screen.dart';
import 'back_workout_screen.dart';
import 'glutes_workout_screen.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return LayoutBuilder(builder: (context, constraints) {
      final double availableWidth = constraints.maxWidth;
      final double contentPadding = availableWidth * 0.06;

      return FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: contentPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Cabeçalho "Treinos"
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    'Treinos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Título principal "O que vamos treinar?"
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 16),
                  child: Text(
                    'O que vamos treinar?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color:
                          isDarkMode ? Colors.white : const Color(0xFF212121),
                    ),
                  ),
                ),

                // Lista de treinos
                _buildWorkoutItem(
                  'Treino de Peito',
                  '${ChestWorkoutScreen.getExerciseCount()} Exercícios',
                  () => _navigateToWorkoutScreen(context, 'chest'),
                  isDarkMode,
                ),
                const SizedBox(height: 12),
                _buildWorkoutItem(
                  'Treino de Pernas',
                  '${LegsWorkoutScreen.getExerciseCount()} Exercícios',
                  () => _navigateToWorkoutScreen(context, 'legs'),
                  isDarkMode,
                ),
                const SizedBox(height: 12),
                _buildWorkoutItem(
                  'Treino de Braços',
                  '${ArmsWorkoutScreen.getExerciseCount()} Exercícios',
                  () => _navigateToWorkoutScreen(context, 'arms'),
                  isDarkMode,
                ),
                const SizedBox(height: 12),
                _buildWorkoutItem(
                  'Treino de Ombro',
                  '${ShoulderWorkoutScreen.getExerciseCount()} Exercícios',
                  () => _navigateToWorkoutScreen(context, 'shoulder'),
                  isDarkMode,
                ),
                const SizedBox(height: 12),
                _buildWorkoutItem(
                  'Treino de Costas',
                  '${BackWorkoutScreen.getExerciseCount()} Exercícios',
                  () => _navigateToWorkoutScreen(context, 'back'),
                  isDarkMode,
                ),
                const SizedBox(height: 12),
                _buildWorkoutItem(
                  'Treino de Glúteos',
                  '${GlutesWorkoutScreen.getExerciseCount()} Exercícios',
                  () => _navigateToWorkoutScreen(context, 'glutes'),
                  isDarkMode,
                ),

                // Espaço adicional para evitar que o conteúdo fique atrás da barra de navegação
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      );
    });
  }

  // Função para navegar para a tela de treino específica
  void _navigateToWorkoutScreen(BuildContext context, String workoutType) {
    // Determina qual tela mostrar baseado no tipo de treino
    Widget destinationScreen;

    switch (workoutType) {
      case 'chest':
        destinationScreen = const ChestWorkoutScreen();
        break;
      case 'legs':
        destinationScreen = const LegsWorkoutScreen();
        break;
      case 'arms':
        destinationScreen = const ArmsWorkoutScreen();
        break;
      case 'shoulder':
        destinationScreen = const ShoulderWorkoutScreen();
        break;
      case 'back':
        destinationScreen = const BackWorkoutScreen();
        break;
      case 'glutes':
        destinationScreen = const GlutesWorkoutScreen();
        break;
      default:
        // Caso o tipo de treino não seja reconhecido, mostra um diálogo
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Treino Selecionado'),
            content: Text(
                'Você selecionou o treino de $workoutType. Esta funcionalidade será implementada em breve.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
        return;
    }

    // Navega para a tela selecionada com animação personalizada
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            destinationScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Animação de fade
          var fadeAnimation = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
          );

          // Animação de slide de baixo para cima
          var slideAnimation = Tween<Offset>(
            begin: const Offset(0.0, 0.2),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutQuint,
            ),
          );

          // Animação de escala
          var scaleAnimation = Tween<double>(
            begin: 0.95,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
          );

          return FadeTransition(
            opacity: fadeAnimation,
            child: SlideTransition(
              position: slideAnimation,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }

  // Item de treino adaptado para o tema escuro
  Widget _buildWorkoutItem(
      String title, String subtitle, VoidCallback onTap, bool isDarkMode) {
    return GestureDetector(
      onTap: onTap, // O item inteiro é clicável
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDarkMode
              ? const Color(0xFF2C1E33) // Roxo escuro no modo escuro
              : const Color(0xFFF1E6F2), // Tom de roxo claro no modo claro
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Título e subtítulo
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey[400] : Colors.black54,
                    ),
                  ),
                ],
              ),

              // Botão "Ver mais" clicável
              Text(
                'Ver mais',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode
                      ? ThemeProvider.lightPurple
                      : const Color(0xFF6677CC),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
