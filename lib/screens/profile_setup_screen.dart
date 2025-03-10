import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'objective_selection_screen.dart';
import '../models/user_model.dart'; // Importar o modelo de usuário

class ProfileSetupScreen extends StatefulWidget {
  final String email; // Email do usuário registrado
  final String firstName; // Primeiro nome
  final String lastName; // Último nome
  final String password; // Senha (para criar o usuário)

  const ProfileSetupScreen({
    super.key,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
  });

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  // Variáveis para controlar a seleção dos campos
  String? _selectedGenero;
  final TextEditingController _idadeController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _idadeController.dispose();
    _pesoController.dispose();
    _alturaController.dispose();
    super.dispose();
  }

  // Método para validar e prosseguir
  void _proceedToObjectiveSelection() {
    // Verificar se todos os campos foram preenchidos
    if (_selectedGenero != null &&
        _idadeController.text.isNotEmpty &&
        _pesoController.text.isNotEmpty &&
        _alturaController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      // Criar usuário temporário com os dados coletados
      final tempUser = UserModel(
        firstName: widget.firstName,
        lastName: widget.lastName,
        email: widget.email,
        password: widget.password,
        gender: _selectedGenero,
        age: int.tryParse(_idadeController.text),
        weight: double.tryParse(_pesoController.text),
        height: double.tryParse(_alturaController.text),
      );

      // Navegar para a tela de seleção de objetivos
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ObjectiveSelectionScreen(tempUser: tempUser),
        ),
      ).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      // Mostrar erro
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, preencha todos os campos',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Parte superior com imagem e texto
                Container(
                  height: screenHeight * 0.35,
                  width: screenWidth,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Center(
                    child: Image.asset(
                      'assets/images/vamoscompletarseuperfil.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // Título e subtítulo
                const Text(
                  'Vamos completar seu perfil',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Não se esqueça de preencher todos os dados abaixo.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                ),
                const SizedBox(height: 30),

                // Campo de seleção de Gênero
                _buildSelectionField(
                  icon: Icons.person_outline,
                  label: 'Gênero',
                  value: _selectedGenero,
                  onPressed: () {
                    _showSelectionModal(
                      context: context,
                      title: 'Selecione seu gênero',
                      options: ['Masculino', 'Feminino', 'Outro'],
                      currentValue: _selectedGenero,
                      onSelect: (value) {
                        setState(() {
                          _selectedGenero = value;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Campo de Idade com teclado numérico
                _buildNumericField(
                  controller: _idadeController,
                  icon: Icons.cake_outlined,
                  label: 'Idade',
                  maxLength: 3,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe sua idade';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Informe um número válido';
                    }
                    int idade = int.parse(value);
                    if (idade <= 0 || idade > 120) {
                      return 'Idade inválida';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo de Peso com teclado numérico
                _buildNumericField(
                  controller: _pesoController,
                  icon: Icons.monitor_weight_outlined,
                  label: 'Peso',
                  maxLength: 5,
                  suffix: 'kg',
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,1}'),
                    ),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe seu peso';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Informe um número válido';
                    }
                    double peso = double.parse(value);
                    if (peso < 20 || peso > 300) {
                      return 'Peso inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo de Altura com teclado numérico
                _buildNumericField(
                  controller: _alturaController,
                  icon: Icons.height_outlined,
                  label: 'Altura',
                  maxLength: 3,
                  suffix: 'cm',
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe sua altura';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Informe um número válido';
                    }
                    int altura = int.parse(value);
                    if (altura < 100 || altura > 250) {
                      return 'Altura inválida';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                // Botão próximo
                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFCD65CE), Color(0xFF2B5AD5)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF8868CD).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _proceedToObjectiveSelection,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Próximo',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 20),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Método para construir um campo numérico com teclado numérico
  Widget _buildNumericField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    int? maxLength,
    String? suffix,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[600]),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: label,
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  counterText: '',
                ),
                style: const TextStyle(fontSize: 16),
                keyboardType: TextInputType.number,
                maxLength: maxLength,
                inputFormatters: inputFormatters,
                validator: validator,
              ),
            ),
            if (suffix != null)
              Text(
                suffix,
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }

  // Método para construir um campo de seleção
  Widget _buildSelectionField({
    required IconData icon,
    required String label,
    required String? value,
    String? suffix,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey[600]),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value ?? label,
                  style: TextStyle(
                    color: value != null ? Colors.black : Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ),
              if (value != null && suffix != null) ...[
                Text(
                  suffix,
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
                const SizedBox(width: 8),
              ],
              if (value == null)
                Icon(Icons.keyboard_arrow_down, color: Colors.grey[600])
              else
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFCD65CE), Color(0xFF2B5AD5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para mostrar o modal de seleção
  void _showSelectionModal({
    required BuildContext context,
    required String title,
    required List<String> options,
    required String? currentValue,
    required Function(String) onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final isSelected = option == currentValue;
                    return ListTile(
                      title: Text(option),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_circle,
                              color: Color(0xFF2B5AD5),
                            )
                          : null,
                      onTap: () {
                        onSelect(option);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
