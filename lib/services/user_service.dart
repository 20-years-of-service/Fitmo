import 'package:hive/hive.dart';
import '../models/user_model.dart';

class UserService {
  static const String _userBoxName = 'users';

  // Referência à caixa Hive para usuários
  static Box<UserModel>? _userBox;

  // Inicializa o serviço, abrindo a box do Hive
  static Future<void> init() async {
    if (_userBox == null || !_userBox!.isOpen) {
      // Registra o adaptador antes de abrir a box
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(UserModelAdapter());
      }

      _userBox = await Hive.openBox<UserModel>(_userBoxName);
    }
  }

  // Registra um novo usuário com campos básicos
  static Future<bool> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? gender,
    int? age,
    double? weight,
    double? height,
    String? objective,
    List<String>? secondaryObjectives,
  }) async {
    await init();

    // Verifica se já existe um usuário com este email
    if (getUserByEmail(email) != null) {
      return false; // Email já está em uso
    }

    // Cria o novo usuário
    final user = UserModel(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      gender: gender,
      age: age,
      weight: weight,
      height: height,
      objective: objective,
      secondaryObjectives: secondaryObjectives,
    );

    // Salva no Hive usando o email como chave
    await _userBox!.put(email, user);
    return true;
  }

  // Atualiza o perfil do usuário com informações adicionais
  static Future<bool> updateUserProfile({
    required String email,
    String? gender,
    int? age,
    double? weight,
    double? height,
    String? objective,
    List<String>? secondaryObjectives,
  }) async {
    await init();

    // Busca o usuário pelo email
    final user = getUserByEmail(email);

    if (user == null) {
      return false; // Usuário não encontrado
    }

    // Atualiza os dados do usuário
    user.updateUserInfo(
      gender: gender,
      age: age,
      weight: weight,
      height: height,
      objective: objective,
      secondaryObjectives: secondaryObjectives,
    );

    return true;
  }

  // Verifica credenciais de login
  static Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    await init();

    // Busca o usuário pelo email
    final user = getUserByEmail(email);

    // Verifica se o usuário existe e a senha está correta
    if (user != null && user.password == password) {
      return user;
    }

    return null; // Credenciais inválidas
  }

  // Busca um usuário pelo email
  static UserModel? getUserByEmail(String email) {
    if (_userBox == null || !_userBox!.isOpen) {
      return null;
    }

    return _userBox!.get(email);
  }

  // Fecha a box quando o aplicativo é encerrado
  static Future<void> close() async {
    if (_userBox != null && _userBox!.isOpen) {
      await _userBox!.close();
    }
  }
}
