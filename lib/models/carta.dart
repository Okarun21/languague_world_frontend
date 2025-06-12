class Carta {
  final String idCarta;
  final String tipo; 
  final String valor; 
  final int posicion;
  final String parejaId;

  Carta({
    required this.idCarta,
    required this.tipo,
    required this.valor,
    required this.posicion,
    required this.parejaId,
  });

  factory Carta.fromJson(Map<String, dynamic> json) {
    return Carta(
      idCarta: json['id_carta'],
      tipo: json['tipo'],
      valor: json['valor'],
      posicion: json['posicion'],
      parejaId: json['pareja_id'],
    );
  }
}
