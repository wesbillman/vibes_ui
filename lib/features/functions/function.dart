class FunctionModel {
  final String name;
  final String signature;
  final String description;
  final String definition;

  FunctionModel({
    required this.name,
    required this.signature,
    required this.description,
    required this.definition,
  });

  factory FunctionModel.fromJson(Map<String, dynamic> json) {
    return FunctionModel(
      name: json['name'],
      signature: json['signature'],
      description: json['description'],
      definition: json['definition'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'signature': signature,
      'description': description,
      'definition': definition,
    };
  }
}
