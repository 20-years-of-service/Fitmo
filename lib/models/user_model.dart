import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel extends HiveObject {
  @HiveField(0)
  String firstName;

  @HiveField(1)
  String lastName;

  @HiveField(2)
  String email;

  @HiveField(3)
  String password;

  // Campos adicionais de perfil
  @HiveField(4)
  String? gender; // Gênero (Masculino, Feminino, Outro)

  @HiveField(5)
  int? age; // Idade em anos

  @HiveField(6)
  double? weight; // Peso em kg

  @HiveField(7)
  double? height; // Altura em cm

  @HiveField(8)
  String? objective; // Objetivo principal (ex: Perder peso, Ganhar massa, etc.)

  @HiveField(9)
  List<String>? secondaryObjectives; // Objetivos secundários

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.gender,
    this.age,
    this.weight,
    this.height,
    this.objective,
    this.secondaryObjectives,
  });

  // Método para atualizar dados do usuário
  void updateUserInfo({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? gender,
    int? age,
    double? weight,
    double? height,
    String? objective,
    List<String>? secondaryObjectives,
  }) {
    if (firstName != null) this.firstName = firstName;
    if (lastName != null) this.lastName = lastName;
    if (email != null) this.email = email;
    if (password != null) this.password = password;
    if (gender != null) this.gender = gender;
    if (age != null) this.age = age;
    if (weight != null) this.weight = weight;
    if (height != null) this.height = height;
    if (objective != null) this.objective = objective;
    if (secondaryObjectives != null)
      this.secondaryObjectives = secondaryObjectives;
    save(); // Salva automaticamente as alterações no Hive
  }
}
