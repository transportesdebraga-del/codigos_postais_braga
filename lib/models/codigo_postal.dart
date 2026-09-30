class CodigoPostal {
  final String morada;
  final String codigoPostal;
  final String freguesia;

  CodigoPostal({
    required this.morada,
    required this.codigoPostal,
    required this.freguesia,
  });

  factory CodigoPostal.fromJson(Map<String, dynamic> json) {
    return CodigoPostal(
      morada: json['morada'] as String,
      codigoPostal: json['codigo_postal'] as String,
      freguesia: json['freguesia'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'morada': morada,
      'codigo_postal': codigoPostal,
      'freguesia': freguesia,
    };
  }
}
