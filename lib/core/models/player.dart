import 'package:uuid/uuid.dart';

class Player {
  final String id;
  final String name;

  Player({required this.id, required this.name});

  Player copyWith({String? name}) => Player(id: id, name: name ?? this.name);

  factory Player.create(String name) => Player(id: const Uuid().v4(), name: name);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
  factory Player.fromJson(Map<String, dynamic> json) =>
      Player(id: json['id'] as String, name: json['name'] as String);
}
