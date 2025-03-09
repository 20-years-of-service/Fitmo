import 'package:flutter/material.dart';

class ObjectiveScreen extends StatelessWidget {
  const ObjectiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Parte superior com gradiente e ilustração
            Container(
              height: screenHeight * 0.45,
              width: screenWidth,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFCD65CE), Color(0xFF2B5AD5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(150),
                  bottomRight: Radius.circular(150),
                ),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/definaseuobjetivo.png',
                  fit: BoxFit.cover,
                  height: screenHeight * 0.35,
                ),
              ),
            ),

            // Parte inferior com texto e botões
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      'Defina seu objetivo',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Mesmo que tenha dificuldades em definir seu objetivo, nós podemos te ajudar!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                        height: 1.4,
                      ),
                    ),
                    const Spacer(),

                    // Indicadores de página e botão de próximo
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Dots indicadores de página
                          Row(
                            children: List.generate(
                              4,
                              (index) => Container(
                                margin: const EdgeInsets.only(right: 6),
                                width: index == 0 ? 10 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color:
                                      index == 0
                                          ? const Color(0xFF1976D2)
                                          : Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),

                          // Botão de próximo
                          Container(
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
                                  color: const Color(
                                    0xFF8868CD,
                                  ).withOpacity(0.4),
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
                              onPressed: () {
                                // Ao pressionar, aplicar uma animação de escala para feedback visual
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Próxima tela será implementada!',
                                    ),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Color(0xFF1976D2),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
