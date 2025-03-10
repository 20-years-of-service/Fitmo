import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ProfileViewScreen extends StatefulWidget {
  final String userEmail;

  const ProfileViewScreen({super.key, required this.userEmail});

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  UserModel? _user;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Inicializar o serviço de usuário
      await UserService.init();

      // Buscar os dados do usuário
      final user = UserService.getUserByEmail(widget.userEmail);

      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar dados: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seu Perfil'),
        backgroundColor: isDarkMode ? Color(0xFF2C2C2C) : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        elevation: 0,
      ),
      backgroundColor: isDarkMode ? Color(0xFF121212) : Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48),
                      SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _loadUserData,
                        child: Text('Tentar novamente'),
                      ),
                    ],
                  ),
                )
              : _user == null
                  ? Center(child: Text('Usuário não encontrado'))
                  : _buildUserProfile(),
    );
  }

  Widget _buildUserProfile() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        // Cabeçalho com avatar e nome
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor:
                    isDarkMode ? Colors.grey[800] : Colors.grey[200],
                child: Text(
                  _user!.firstName[0] + _user!.lastName[0],
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                '${_user!.firstName} ${_user!.lastName}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                _user!.email,
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 32),

        // Seção de informações pessoais
        _buildSection(
          title: 'Informações Pessoais',
          children: [
            _buildInfoItem(
              icon: Icons.person,
              title: 'Gênero',
              value: _user!.gender ?? 'Não informado',
            ),
            _buildInfoItem(
              icon: Icons.calendar_today,
              title: 'Idade',
              value:
                  _user!.age != null ? '${_user!.age} anos' : 'Não informada',
            ),
            _buildInfoItem(
              icon: Icons.monitor_weight_outlined,
              title: 'Peso',
              value: _user!.weight != null
                  ? '${_user!.weight} kg'
                  : 'Não informado',
            ),
            _buildInfoItem(
              icon: Icons.height,
              title: 'Altura',
              value: _user!.height != null
                  ? '${_user!.height} cm'
                  : 'Não informada',
            ),
          ],
        ),

        SizedBox(height: 24),

        // Seção de objetivos
        _buildSection(
          title: 'Objetivos de Fitness',
          children: [
            _buildInfoItem(
              icon: Icons.fitness_center,
              title: 'Objetivo Principal',
              value: _user!.objective ?? 'Não definido',
            ),
            if (_user!.secondaryObjectives != null &&
                _user!.secondaryObjectives!.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
                child: Text(
                  'Objetivos Secundários',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                ),
              ),
              ..._user!.secondaryObjectives!.map((obj) => Padding(
                    padding: const EdgeInsets.only(left: 32, top: 4, bottom: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            obj,
                            style: TextStyle(
                              color:
                                  isDarkMode ? Colors.white70 : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ],
        ),

        SizedBox(height: 40),

        // Botão para debug
        ElevatedButton(
          onPressed: _debugUserData,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[700],
          ),
          child: Text('Debug: Imprimir Dados'),
        ),
      ],
    );
  }

  // Método de debug para imprimir todos os dados do usuário no console
  void _debugUserData() {
    if (_user != null) {
      print('==== DADOS DO USUÁRIO ====');
      print('Nome: ${_user!.firstName} ${_user!.lastName}');
      print('Email: ${_user!.email}');
      print('Gênero: ${_user!.gender}');
      print('Idade: ${_user!.age}');
      print('Peso: ${_user!.weight}');
      print('Altura: ${_user!.height}');
      print('Objetivo: ${_user!.objective}');
      print('Objetivos secundários: ${_user!.secondaryObjectives}');
      print('==========================');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dados impressos no console de debug'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // Método auxiliar para construir uma seção com título
  Widget _buildSection(
      {required String title, required List<Widget> children}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  // Método auxiliar para construir um item de informação
  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.blueGrey[700] : Colors.blue[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: isDarkMode ? Colors.white70 : Colors.blue[700],
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
