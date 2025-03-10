import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  final String? userEmail; // Email do usuário logado

  const ProfileScreen({super.key, this.userEmail});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with WidgetsBindingObserver {
  // Estado para armazenar os dados do usuário
  UserModel? _userData;
  bool _isLoading = true;
  String? _errorMessage;

  // Dados padrão caso não consiga carregar
  String _userName = "Usuário";
  String _userGender = "Não informado";
  String _userAge = "0";
  String _userHeight = "0cm";
  String _userWeight = "0kg";
  String _userObjective = "Não definido";

  // Variáveis para o cálculo do IMC
  double? _imc;
  String _imcStatus = '';
  Color _imcStatusColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _forceFullScreenMode();
    _loadUserData();
  }

  // Método para carregar dados do usuário do Hive
  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Inicializar o Hive
      await UserService.init();

      // Buscar o usuário - usando o email do widget ou o último usuário se não fornecido
      UserModel? user;
      if (widget.userEmail != null) {
        user = UserService.getUserByEmail(widget.userEmail!);
      } else {
        // Aqui você pode implementar lógica para buscar o último usuário logado
        // Por enquanto, deixamos um placeholder para debugging
        final testEmail = "email@exemplo.com"; // Email de teste
        user = UserService.getUserByEmail(testEmail);
      }

      // Atualizar o estado com os dados do usuário
      setState(() {
        _userData = user;

        if (user != null) {
          _userName = "${user.firstName} ${user.lastName}";
          _userGender = user.gender ?? "Não informado";
          _userAge = user.age?.toString() ?? "0";
          _userHeight = user.height != null ? "${user.height}cm" : "0cm";
          _userWeight = user.weight != null ? "${user.weight}kg" : "0kg";
          _userObjective = user.objective ?? "Não definido";

          // Calcular IMC após carregar os dados
          _calculateIMC();
        }

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Erro ao carregar dados: ${e.toString()}";
        _isLoading = false;
      });
    }
  }

  // Método para calcular o IMC
  void _calculateIMC() {
    if (_userData?.height != null && _userData?.weight != null) {
      // IMC = peso (kg) / (altura (m) * altura (m))
      final double heightInMeters =
          _userData!.height! / 100; // Converte cm para metros
      final double weightInKg = _userData!.weight!;

      setState(() {
        _imc = weightInKg / (heightInMeters * heightInMeters);

        // Classificar o IMC
        if (_imc! < 18.5) {
          _imcStatus = 'Abaixo do peso';
          _imcStatusColor = Colors.blue;
        } else if (_imc! < 25) {
          _imcStatus = 'Peso normal';
          _imcStatusColor = Colors.green;
        } else if (_imc! < 30) {
          _imcStatus = 'Sobrepeso';
          _imcStatusColor = Colors.orange;
        } else {
          _imcStatus = 'Obesidade';
          _imcStatusColor = Colors.red;
        }
      });
    }
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

  // Novo método para mostrar o diálogo do IMC
  void _showIMCDialog(BuildContext context, bool isDarkMode) {
    // Valores para o gráfico de IMC
    final List<Map<String, dynamic>> imcCategories = [
      {'range': 'Abaixo do peso', 'min': 0, 'max': 18.5, 'color': Colors.blue},
      {'range': 'Peso normal', 'min': 18.5, 'max': 25, 'color': Colors.green},
      {'range': 'Sobrepeso', 'min': 25, 'max': 30, 'color': Colors.orange},
      {'range': 'Obesidade', 'min': 30, 'max': 40, 'color': Colors.red},
    ];

    // Controladores para edição de altura e peso
    final heightController =
        TextEditingController(text: _userData?.height?.toString() ?? '');
    final weightController =
        TextEditingController(text: _userData?.weight?.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
        title: Text(
          'Calculadora de IMC',
          style: TextStyle(
            color: isDarkMode ? Colors.white : const Color(0xFF212121),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Valor do IMC atual
              if (_imc != null) ...[
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Seu IMC',
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              isDarkMode ? Colors.grey[300] : Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _imcStatusColor.withOpacity(0.2),
                          border: Border.all(
                            color: _imcStatusColor,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _imc!.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: _imcStatusColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _imcStatus,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _imcStatusColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Descrição do IMC
              Text(
                'O IMC (Índice de Massa Corporal) é uma medida internacional usada para calcular se uma pessoa está no peso ideal.',
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 16),

              // Tabela de classificação
              Text(
                'Classificação:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : const Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 8),
              ...imcCategories
                  .map((category) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: category['color'],
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${category['range']}: ${category['min']} - ${category['max']}',
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.grey[300]
                                    : Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
              const SizedBox(height: 24),

              // Formulário para recalcular
              Text(
                'Recalcular IMC:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : const Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: heightController,
                decoration: InputDecoration(
                  labelText: 'Altura (cm)',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(
                    color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: weightController,
                decoration: InputDecoration(
                  labelText: 'Peso (kg)',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(
                    color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
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
          ElevatedButton(
            onPressed: () {
              try {
                final double height = double.parse(heightController.text);
                final double weight = double.parse(weightController.text);

                if (height <= 0 || weight <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Valores inválidos. Altura e peso devem ser maiores que zero.')),
                  );
                  return;
                }

                // Calcular o novo IMC
                final double heightInMeters = height / 100;
                final double newImc =
                    weight / (heightInMeters * heightInMeters);

                String status;
                Color statusColor;

                if (newImc < 18.5) {
                  status = 'Abaixo do peso';
                  statusColor = Colors.blue;
                } else if (newImc < 25) {
                  status = 'Peso normal';
                  statusColor = Colors.green;
                } else if (newImc < 30) {
                  status = 'Sobrepeso';
                  statusColor = Colors.orange;
                } else {
                  status = 'Obesidade';
                  statusColor = Colors.red;
                }

                Navigator.pop(context);

                // Mostrar resultado
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('Seu IMC: ${newImc.toStringAsFixed(1)} - $status'),
                    backgroundColor: statusColor,
                    duration: Duration(seconds: 5),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Erro ao calcular IMC. Verifique os valores informados.')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode
                  ? ThemeProvider.lightPurple
                  : const Color(0xFF6677CC),
              foregroundColor: Colors.white,
            ),
            child: Text('Calcular'),
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

    // Se estiver carregando, mostrar indicador de carregamento
    if (_isLoading) {
      return Scaffold(
        backgroundColor:
            isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
        body: SafeArea(
          child: Center(
            child: CircularProgressIndicator(
              color: isDarkMode
                  ? ThemeProvider.lightPurple
                  : const Color(0xFF6677CC),
            ),
          ),
        ),
      );
    }

    // Se ocorrer um erro, mostrar mensagem de erro
    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor:
            isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black87,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _loadUserData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode
                          ? ThemeProvider.lightPurple
                          : const Color(0xFF6677CC),
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

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
                        // Foto de perfil ou iniciais
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
                              child: _userData != null
                                  ? Text(
                                      "${_userData!.firstName[0]}${_userData!.lastName[0]}",
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode
                                            ? const Color(0xFF8899FF)
                                            : const Color(0xFF6677CC),
                                      ),
                                    )
                                  : Icon(
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
                          _userName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFF212121),
                          ),
                        ),
                        if (_userData != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              _userData!.email,
                              style: TextStyle(
                                fontSize: 14,
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),
                        // Botão de editar
                        ElevatedButton(
                          onPressed: () {
                            // Navegação para tela de edição de perfil
                            // Aqui você pode implementar a navegação para a tela de edição
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
                      _buildBioCard(_userHeight, isDarkMode,
                          icon: Icons.height),
                      _buildBioCard(_userWeight, isDarkMode,
                          icon: Icons.monitor_weight_outlined),
                      _buildBioCard('${_userAge}an', isDarkMode,
                          icon: Icons.calendar_today),
                    ],
                  ),

                  // Card IMC
                  if (_imc != null) ...[
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color:
                            isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () => _showIMCDialog(context, isDarkMode),
                        borderRadius: BorderRadius.circular(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: _imcStatusColor.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.scale,
                                    color: _imcStatusColor,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Seu IMC',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: isDarkMode
                                            ? Colors.white
                                            : const Color(0xFF212121),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${_imc!.toStringAsFixed(1)} - $_imcStatus',
                                      style: TextStyle(
                                        color: _imcStatusColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                  size: 16,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Toque para mais detalhes e para calcular novamente',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  // Objetivo de Fitness
                  const SizedBox(height: 24),
                  _buildObjectiveSection(isDarkMode),

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

  // Novo método para construir a seção de objetivo
  Widget _buildObjectiveSection(bool isDarkMode) {
    if (_userData == null || _userData!.objective == null) {
      return Container(); // Retorna um container vazio se não houver objetivo
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Objetivo de Fitness',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : const Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? ThemeProvider.lightPurple.withOpacity(0.2)
                          : const Color(0xFF6677CC).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.fitness_center,
                      color: isDarkMode
                          ? ThemeProvider.lightPurple
                          : const Color(0xFF6677CC),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _userData!.objective!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            isDarkMode ? Colors.white : const Color(0xFF212121),
                      ),
                    ),
                  ),
                ],
              ),
              if (_userData!.secondaryObjectives != null &&
                  _userData!.secondaryObjectives!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Objetivos secundários:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                ..._userData!.secondaryObjectives!.map((objective) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 18,
                            color: isDarkMode
                                ? ThemeProvider.lightPurple
                                : const Color(0xFF6677CC),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              objective,
                              style: TextStyle(
                                fontSize: 14,
                                color: isDarkMode
                                    ? Colors.grey[300]
                                    : Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // Método atualizado para incluir ícones nos cards biométricos
  Widget _buildBioCard(String text, bool isDarkMode, {IconData? icon}) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(
              icon,
              color: isDarkMode
                  ? ThemeProvider.lightPurple
                  : const Color(0xFF6677CC),
              size: 24,
            ),
          if (icon != null) const SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : const Color(0xFF212121),
            ),
          ),
        ],
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
