import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:io' show Platform;
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'dart:math' as math;
import 'package:permission_handler/permission_handler.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  // Audio player
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  // Animations
  late AnimationController _animationController;

  // Music data - Isso seria substituído por fontes reais de música
  final List<Map<String, dynamic>> _playlist = [
    {
      'title': 'Energia Total',
      'artist': 'FitBeats',
      'duration': const Duration(minutes: 3, seconds: 45),
      'albumArt': 'assets/images/album1.jpg',
      'url': 'https://example.com/song1.mp3',
    },
    {
      'title': 'Motivação Máxima',
      'artist': 'Workout Kings',
      'duration': const Duration(minutes: 4, seconds: 12),
      'albumArt': 'assets/images/album2.jpg',
      'url': 'https://example.com/song2.mp3',
    },
    {
      'title': 'Cardio Power',
      'artist': 'Training Beats',
      'duration': const Duration(minutes: 3, seconds: 29),
      'albumArt': 'assets/images/album3.jpg',
      'url': 'https://example.com/song3.mp3',
    },
    {
      'title': 'Força e Resistência',
      'artist': 'FitBeats',
      'duration': const Duration(minutes: 4, seconds: 55),
      'albumArt': 'assets/images/album4.jpg',
      'url': 'https://example.com/song4.mp3',
    },
    {
      'title': 'Na Batida do Treino',
      'artist': 'Power Gym',
      'duration': const Duration(minutes: 3, seconds: 17),
      'albumArt': 'assets/images/album5.jpg',
      'url': 'https://example.com/song5.mp3',
    },
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _forceFullScreenMode();

    // Inicializa o controlador de animação
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10), // Uma rotação a cada 10 segundos
    );

    // Configura o player de áudio
    _initAudioPlayer();

    // Solicitar permissões
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    // No Android e iOS precisamos de permissões diferentes
    if (Platform.isAndroid) {
      await [
        Permission.storage,
        Permission.mediaLibrary,
      ].request();
    } else if (Platform.isIOS) {
      await Permission.mediaLibrary.request();
    }
  }

  Future<void> _initAudioPlayer() async {
    // Ouvir atualizações de estado do player
    _audioPlayer.playerStateStream.listen((state) {
      if (state.playing != _isPlaying) {
        setState(() {
          _isPlaying = state.playing;
        });
      }

      if (state.processingState == ProcessingState.completed) {
        _nextSong();
      }
    });

    // Ouvir mudanças na duração
    _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        setState(() {
          _duration = duration;
        });
      }
    });

    // Ouvir mudanças na posição
    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _position = position;
      });
    });

    // Carregar uma URL de demonstração (em um app real, isso seria uma música real)
    try {
      // Em um app real, aqui usaríamos URLs de músicas reais ou arquivos locais
      await _audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3')),
      );
    } catch (e) {
      print("Erro ao carregar áudio: $e");
    }
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
      _animationController.stop();
    } else {
      _audioPlayer.play();
      _animationController.repeat();
    }
  }

  void _previousSong() {
    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
      } else {
        _currentIndex = _playlist.length - 1;
      }
    });
    // Em um app real, aqui carregaríamos a música anterior
    _position = Duration.zero;
    _audioPlayer.seek(Duration.zero);
  }

  void _nextSong() {
    setState(() {
      if (_currentIndex < _playlist.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
    });
    // Em um app real, aqui carregaríamos a próxima música
    _position = Duration.zero;
    _audioPlayer.seek(Duration.zero);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _forceFullScreenMode();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animationController.dispose();
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final Map<String, dynamic> currentSong = _playlist[_currentIndex];

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double availableWidth = constraints.maxWidth;
            final double contentPadding = availableWidth * 0.06;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: contentPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Cabeçalho
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          'Música para Treinar',
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
                          Icons.playlist_play,
                          color: isDarkMode
                              ? Colors.white
                              : const Color(0xFF212121),
                          size: 30,
                        ),
                        onPressed: () {
                          // Mostrar lista de reprodução
                          _showPlaylist(context, isDarkMode);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Álbum rotativo
                  Expanded(
                    flex: 4,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: availableWidth * 0.65,
                            height: availableWidth * 0.65,
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? const Color(0xFF2C2C2C)
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: isDarkMode
                                      ? Colors.black.withOpacity(0.5)
                                      : Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: AnimatedBuilder(
                              animation: _animationController,
                              builder: (_, child) {
                                return Transform.rotate(
                                  angle:
                                      _animationController.value * 2 * math.pi,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      color: isDarkMode
                                          ? ThemeProvider.lightPurple
                                          : const Color(0xFF6677CC),
                                      child: Center(
                                        child: Icon(
                                          Icons.music_note,
                                          size: 100,
                                          color: Colors.white.withOpacity(0.7),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Informações da música
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentSong['title'],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFF212121),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentSong['artist'],
                          style: TextStyle(
                            fontSize: 16,
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Barra de progresso
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 4,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6),
                            overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 14),
                            activeTrackColor: isDarkMode
                                ? ThemeProvider.lightPurple
                                : const Color(0xFF6677CC),
                            inactiveTrackColor: isDarkMode
                                ? Colors.grey[800]
                                : Colors.grey[300],
                            thumbColor: isDarkMode
                                ? ThemeProvider.lightPurple
                                : const Color(0xFF6677CC),
                            overlayColor: (isDarkMode
                                    ? ThemeProvider.lightPurple
                                    : const Color(0xFF6677CC))
                                .withOpacity(0.2),
                          ),
                          child: Slider(
                            value: _position.inSeconds.toDouble(),
                            max: _duration.inSeconds.toDouble(),
                            min: 0,
                            onChanged: (value) {
                              setState(() {
                                _audioPlayer
                                    .seek(Duration(seconds: value.toInt()));
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(_position),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                              ),
                              Text(
                                _formatDuration(_duration),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Controles de reprodução
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Botão anterior
                        IconButton(
                          icon: Icon(
                            Icons.skip_previous,
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFF212121),
                            size: 36,
                          ),
                          onPressed: _previousSong,
                        ),
                        const SizedBox(width: 20),
                        // Botão play/pause
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? ThemeProvider.lightPurple
                                : const Color(0xFF6677CC),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (isDarkMode
                                        ? ThemeProvider.lightPurple
                                        : const Color(0xFF6677CC))
                                    .withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 40,
                            ),
                            onPressed: _togglePlayPause,
                          ),
                        ),
                        const SizedBox(width: 20),
                        // Botão próximo
                        IconButton(
                          icon: Icon(
                            Icons.skip_next,
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFF212121),
                            size: 36,
                          ),
                          onPressed: _nextSong,
                        ),
                      ],
                    ),
                  ),

                  // Botões de controle adicionais - Agora com padding maior para evitar sobreposição
                  Padding(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildControlButton(
                          icon: Icons.shuffle,
                          label: 'Aleatório',
                          isDarkMode: isDarkMode,
                          onTap: () {
                            // Implementar embaralhamento
                          },
                        ),
                        _buildControlButton(
                          icon: Icons.repeat,
                          label: 'Repetir',
                          isDarkMode: isDarkMode,
                          onTap: () {
                            // Implementar repetição
                          },
                        ),
                        _buildControlButton(
                          icon: Icons.favorite_border,
                          label: 'Favoritos',
                          isDarkMode: isDarkMode,
                          onTap: () {
                            // Implementar favoritos
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              icon,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              size: 20,
            ),
            onPressed: onTap,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _showPlaylist(BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
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
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lista de Reprodução',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            isDarkMode ? Colors.white : const Color(0xFF212121),
                      ),
                    ),
                    Text(
                      '${_playlist.length} músicas',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _playlist.length,
                  physics: const BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  itemBuilder: (context, index) {
                    final song = _playlist[index];
                    final isPlaying = index == _currentIndex && _isPlaying;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: index == _currentIndex
                            ? (isDarkMode
                                ? const Color(0xFF2C2C2C)
                                : const Color(0xFFE8EAFF))
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? const Color(0xFF3C3C3C)
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Icon(
                              isPlaying
                                  ? Icons.pause_circle_filled
                                  : Icons.music_note,
                              color: isDarkMode
                                  ? ThemeProvider.lightPurple
                                  : const Color(0xFF6677CC),
                              size: isPlaying ? 32 : 24,
                            ),
                          ),
                        ),
                        title: Text(
                          song['title'],
                          style: TextStyle(
                            fontWeight: index == _currentIndex
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFF212121),
                          ),
                        ),
                        subtitle: Text(
                          song['artist'],
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                          ),
                        ),
                        trailing: Text(
                          _formatDuration(song['duration']),
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                          ),
                        ),
                        onTap: () {
                          // Em um app real, aqui carregaríamos a música selecionada
                          setState(() {
                            _currentIndex = index;
                            _position = Duration.zero;
                          });
                          Navigator.pop(context);
                          _audioPlayer.seek(Duration.zero);
                          if (!_isPlaying) {
                            _togglePlayPause();
                          }
                        },
                      ),
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
