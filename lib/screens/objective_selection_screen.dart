import 'package:flutter/material.dart';

class ObjectiveSelectionScreen extends StatefulWidget {
  const ObjectiveSelectionScreen({super.key});

  @override
  State<ObjectiveSelectionScreen> createState() =>
      _ObjectiveSelectionScreenState();
}

class _ObjectiveSelectionScreenState extends State<ObjectiveSelectionScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<ObjectiveCard> _objectives = [
    const ObjectiveCard(
      title: 'Melhorar seu Shape',
      description:
          'Tenho uma baixa quantidade de gordura corporal e preciso/quero ganhar mais massa muscular.',
      imagePath: 'assets/images/melhoraroseushape.png',
    ),
    const ObjectiveCard(
      title: 'Esbelto & Definido',
      description:
          'Sou \'magro com gordura\'. Pareço magro, mas não tenho definição. Quero ganhar massa muscular magra da maneira certa.',
      imagePath: 'assets/images/esbeltoedefinido.png',
    ),
    const ObjectiveCard(
      title: 'Perder peso',
      description:
          'Tenho uma certa quantidade de gordura corporal. Quero eliminar essa gordura e ganhar massa magra.',
      imagePath: 'assets/images/perderpeso.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _objectives.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _objectives[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ObjectiveCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const ObjectiveCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título e descrição inicial
            const Text(
              'Qual é seu objetivo?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Isso nos ajudará a escolher o melhor programa para você',
              style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Imagem do objetivo
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFCD65CE), Color(0xFF2B5AD5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Image.asset(imagePath, fit: BoxFit.cover, height: 250),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Título do objetivo
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF212121),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Descrição do objetivo
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Indicadores de página
            Builder(
              builder: (context) {
                final pageIndex = _getPageIndex(context);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: pageIndex == index ? 10 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color:
                            pageIndex == index
                                ? const Color(0xFF1976D2)
                                : Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),

            // Botão confirmar
            Container(
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
                  // Este botão não faz nada, conforme solicitado
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
                  'Confirmar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para obter o índice da página atual
  int _getPageIndex(BuildContext context) {
    final ObjectiveSelectionScreen? parent =
        context.findAncestorWidgetOfExactType<ObjectiveSelectionScreen>();
    if (parent == null) return 0;

    final state =
        context.findAncestorStateOfType<_ObjectiveSelectionScreenState>();
    return state?._currentPage ?? 0;
  }
}
