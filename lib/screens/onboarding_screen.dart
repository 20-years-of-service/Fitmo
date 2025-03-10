import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'profile_setup_screen.dart';
import 'welcome_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with WidgetsBindingObserver {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    const OnboardingPage(
      title: 'Defina seu objetivo',
      description:
          'Mesmo que tenha dificuldades em definir seu objetivo, nós podemos te ajudar!',
      imagePath: 'assets/images/definaseuobjetivo.png',
    ),
    const OnboardingPage(
      title: 'Sinta a Queimação!',
      description:
          'Continue queimando para alcançar seus objetivos. A dor é temporária, mas desistir agora deixará marcas para sempre.',
      imagePath: 'assets/images/sintaaqueimacao.png',
    ),
    const OnboardingPage(
      title: 'Alimente-se bem!',
      description:
          'Comece um estilo de vida mais saudável se alimentando bem e com cardápios variados.',
      imagePath: 'assets/images/alimentesebem.png',
    ),
    const OnboardingPage(
      title: 'Descanse bem',
      description:
          'Melhore a qualidade do seu sono, um sono de boa qualidade pode trazer um bom humor e energia pela manhã.',
      imagePath: 'assets/images/descansebem.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Adiciona observer para detectar mudanças no ciclo de vida do app
    WidgetsBinding.instance.addObserver(this);
    // Garantir que estamos em modo tela cheia
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
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          // Ícones claros para melhor visibilidade sobre o fundo colorido
          statusBarIconBrightness: Brightness.light,
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
              Brightness.dark, // iOS usa o inverso (dark = ícones claros)
        ),
      );
    }
  }

  void _goToNextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navegar para a tela de registro
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const SignupScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Forçar o modo tela cheia a cada build
    _forceFullScreenMode();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return _pages[index];
              },
            ),
          ),
          // SafeArea apenas para a navegação inferior
          SafeArea(
            top: false, // Não precisamos de padding no topo aqui
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dots indicadores de página
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => Container(
                        margin: const EdgeInsets.only(right: 6),
                        width: _currentPage == index ? 10 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? const Color(0xFF1976D2)
                              : Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  // Botão de próximo (só aparece na última tela)
                  _currentPage == _pages.length - 1
                      ? Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFCD65CE), Color(0xFF2B5AD5)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF8868CD).withOpacity(0.4),
                                blurRadius: 8,
                                spreadRadius: 1,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: _goToNextPage,
                          ),
                        )
                      : const SizedBox(width: 44),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    // Usamos LayoutBuilder para adaptar o layout baseado no espaço disponível
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculamos proporções em vez de usar valores fixos
        final double availableHeight = constraints.maxHeight;
        final double availableWidth = constraints.maxWidth;

        // Ajustamos proporcionalmente baseado na orientação e tamanho da tela
        final bool isPortrait = availableHeight > availableWidth;
        final double topContainerHeight = isPortrait
            ? availableHeight * 0.45 // 45% da altura em retrato
            : availableHeight * 0.55; // 55% da altura em paisagem

        // Obtém o tamanho da barra de status para estender o gradient corretamente
        final statusBarHeight = MediaQuery.of(context).padding.top;

        return Stack(
          children: [
            // Background que se estende por trás da status bar
            Positioned(
              top: -statusBarHeight, // Move para trás da barra de status
              left: 0,
              right: 0,
              height: topContainerHeight + statusBarHeight,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFCD65CE), Color(0xFF2B5AD5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(
                      availableWidth * 0.3,
                    ),
                    bottomRight: Radius.circular(availableWidth * 0.3),
                  ),
                ),
              ),
            ),
            // Conteúdo que respeita a área segura
            Column(
              children: [
                // Container para a imagem
                Container(
                  height: topContainerHeight,
                  width: availableWidth,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: statusBarHeight * 0.5),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                        height: topContainerHeight * 0.8,
                      ),
                    ),
                  ),
                ),

                // Parte inferior com texto - flexível para diferentes tamanhos de tela
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: availableWidth * 0.08,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: availableHeight * 0.03,
                        ),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: isPortrait
                                ? availableWidth * 0.06
                                : availableWidth * 0.04,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF212121),
                          ),
                        ),
                        SizedBox(height: availableHeight * 0.01),
                        Flexible(
                          child: Text(
                            description,
                            style: TextStyle(
                              fontSize: isPortrait
                                  ? availableWidth * 0.04
                                  : availableWidth * 0.03,
                              color: const Color(0xFF666666),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Garantir modo tela cheia
    _forceFullScreenMode();
  }

  void _forceFullScreenMode() {
    if (Platform.isAndroid) {
      // Android: edge-to-edge com barra de notificação visível
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top],
      );

      // Estilo da barra de notificações
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
        ),
      );
    } else {
      // iOS e outros: manual com barra de status visível
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.top],
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Forçar modo tela cheia a cada build
    _forceFullScreenMode();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30), // Espaçamento adequado sem SafeArea
                const Text(
                  'Olá 👋',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                ),
                const Text(
                  'Vamos criar sua conta?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 30),
                // Campo Primeiro Nome
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'Primeiro Nome',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, informe seu primeiro nome';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Campo Último Nome
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Último Nome',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, informe seu último nome';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Campo Email
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, informe seu email';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Por favor, informe um email válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Campo Senha
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, informe sua senha';
                    }
                    if (value.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                // Termos e condições
                Text(
                  'Criando sua conta você aceita nossos Termos de Privacidade e Termos de Uso',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 30),
                // Botão Criar
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Navegar para a tela de configuração de perfil
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ProfileSetupScreen(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Criar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Link para login
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Navegar para a tela de login
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: 'Já possui uma conta? ',
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              color: Color(0xFF2B5AD5),
                              fontWeight: FontWeight.bold,
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
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Garantir modo tela cheia
    _forceFullScreenMode();
  }

  void _forceFullScreenMode() {
    if (Platform.isAndroid) {
      // Android: edge-to-edge com barra de notificação visível
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top],
      );

      // Estilo da barra de notificações
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
        ),
      );
    } else {
      // iOS e outros: manual com barra de status visível
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.top],
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Forçar o modo tela cheia a cada build
    _forceFullScreenMode();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Olá de novo 👋',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121),
                        ),
                      ),
                      const Text(
                        'Seja bem vindo',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Campo Email
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, informe seu email';
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'Por favor, informe um email válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Campo Senha
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, informe sua senha';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      // Link Esqueceu sua senha
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            // Implementar recuperação de senha
                          },
                          child: const Text(
                            'Esqueceu sua senha?',
                            style: TextStyle(
                              color: Color(0xFF2B5AD5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Botão Entrar
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
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Extrai o nome de usuário do email (parte antes do @)
                              String userEmail = _emailController.text.trim();
                              String userName = userEmail.split('@').first;

                              // Navegue para a tela de boas-vindas
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      WelcomeScreen(userName: userName),
                                ),
                                (route) =>
                                    false, // Remove todas as telas anteriores da pilha
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Entrar',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Link para criar conta
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            // Voltar para a tela de registro
                            Navigator.of(context).pop();
                          },
                          child: RichText(
                            text: const TextSpan(
                              text: 'Não criou uma conta ainda? ',
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: 'Criar agora',
                                  style: TextStyle(
                                    color: Color(0xFF2B5AD5),
                                    fontWeight: FontWeight.bold,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
