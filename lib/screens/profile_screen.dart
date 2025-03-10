import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with WidgetsBindingObserver {
  // Dados simulados do usuário - em um app real, estes viriam de um banco de dados ou API
  final String userName = "Stephanie Leite";
  final String userAge = "22";
  final String userHeight = "165cm";
  final String userWeight = "65kg";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _forceFullScreenMode();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
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
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top],
      );

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
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.top],
      );

      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
        ),
      );
    }
  }

  void _showOptionsMenu(BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              // Linha indicadora
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[600] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 24),
              // Opção Resetar aplicativo
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.red,
                  ),
                ),
                title: const Text(
                  'Resetar aplicativo',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Implementar lógica para resetar o aplicativo
                  _showConfirmationDialog(
                    context,
                    'Resetar aplicativo',
                    'Tem certeza que deseja resetar o aplicativo? Todos os dados não salvos serão perdidos.',
                    isDarkMode,
                  );
                },
              ),
              // Opção Apagar conta
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                  ),
                ),
                title: const Text(
                  'Apagar conta',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Implementar lógica para apagar a conta
                  _showConfirmationDialog(
                    context,
                    'Apagar conta',
                    'Tem certeza que deseja apagar sua conta? Esta ação não pode ser desfeita e todos os seus dados serão perdidos permanentemente.',
                    isDarkMode,
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void _showConfirmationDialog(
      BuildContext context, String title, String message, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
        title: Text(
          title,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Aqui implementaria a ação de resetar ou apagar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Ação confirmada: $title'),
                  backgroundColor: isDarkMode
                      ? const Color(0xFF2C2C2C)
                      : Colors.red.shade700,
                ),
              );
            },
            child: const Text(
              'Confirmar',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _forceFullScreenMode();
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final double availableWidth = constraints.maxWidth;
          final double contentPadding = availableWidth * 0.06;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: contentPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Cabeçalho com título e botão de opções
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          'Perfil',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFF212121),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.more_horiz,
                          color: isDarkMode
                              ? Colors.white
                              : const Color(0xFF212121),
                          size: 26,
                        ),
                        onPressed: () {
                          // Mostrar menu de opções
                          _showOptionsMenu(context, isDarkMode);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Foto e informações do perfil
                  Center(
                    child: Column(
                      children: [
                        // Foto de perfil
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDarkMode
                                ? const Color(0xFF2C2C2C)
                                : Colors.grey.shade200,
                            border: Border.all(
                              color: isDarkMode
                                  ? const Color(0xFF8899FF)
                                  : const Color(0xFF6677CC),
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: Center(
                              child: Icon(
                                Icons.person,
                                size: 40,
                                color: isDarkMode
                                    ? const Color(0xFF8899FF)
                                    : const Color(0xFF6677CC),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Nome do usuário
                        Text(
                          userName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFF212121),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Idade
                        Text(
                          'de',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode ? Colors.grey[400] : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Botão de editar
                        ElevatedButton(
                          onPressed: () {
                            // Navegação para tela de edição de perfil
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDarkMode
                                ? ThemeProvider.lightPurple
                                : const Color(0xFF6677CC),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 8),
                          ),
                          child: const Text(
                            'Editar',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Cards com informações biométricas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildBioCard(userHeight, isDarkMode),
                      _buildBioCard(userWeight, isDarkMode),
                      _buildBioCard('${userAge}an', isDarkMode),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Seção "Conta"
                  Text(
                    'Conta',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color:
                          isDarkMode ? Colors.white : const Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildProfileItem(
                    'Dados pessoais',
                    Icons.person_outline,
                    isDarkMode,
                    () {},
                    description:
                        'Edite seus dados cadastrais e informações pessoais',
                  ),
                  _buildProfileItem(
                    'Histórico de atividades',
                    Icons.history,
                    isDarkMode,
                    () {},
                    description:
                        'Visualize seu histórico de treinos e exercícios',
                  ),
                  _buildProfileItem(
                    'Progresso do treino',
                    Icons.bar_chart,
                    isDarkMode,
                    () {},
                    description: 'Acompanhe sua evolução e conquistas',
                  ),

                  const SizedBox(height: 24),

                  // Seção "Outros"
                  Text(
                    'Outros',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color:
                          isDarkMode ? Colors.white : const Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildProfileItem(
                    'Contate-nos',
                    Icons.email_outlined,
                    isDarkMode,
                    () {},
                    description: 'Entre em contato com nossa equipe de suporte',
                  ),
                  _buildProfileItem(
                    'Política de Privacidade',
                    Icons.shield_outlined,
                    isDarkMode,
                    () {},
                    description:
                        'Como seus dados são utilizados pelo aplicativo',
                  ),

                  // Espaço adicional para evitar que o conteúdo fique atrás da barra de navegação
                  const SizedBox(height: 80),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBioCard(String value, bool isDarkMode) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : const Color(0xFF212121),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem(
      String title, IconData icon, bool isDarkMode, VoidCallback onTap,
      {String description = ''}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? const Color(0xFF2C2C2C)
                      : Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isDarkMode
                      ? const Color(0xFF8899FF)
                      : const Color(0xFF6677CC),
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color:
                            isDarkMode ? Colors.white : const Color(0xFF212121),
                      ),
                    ),
                    if (description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
