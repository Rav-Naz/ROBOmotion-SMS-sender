class Message {
  final String numer_telefonu;
  final String tresc;
  final int wiadomosc_id;
  final String czas_nadania;


  Message({
    required this.numer_telefonu,
    required this.tresc,
    required this.wiadomosc_id,
    required this.czas_nadania
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        numer_telefonu: json['numer_telefonu'] as String,
        tresc: json['tresc'] as String,
        wiadomosc_id: json['wiadomosc_id'] as int,
        czas_nadania: json['czas_nadania'] as String
    );
  }
}