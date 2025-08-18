
class Volk {
  final String id;
  String name;
  String standort;
  DateTime erstellungsdatum;
  List<VoelkerKontrolle> kontrollen;
  String notizen;
  double volksstaerke;
  GesundheitsStatus gesundheitsStatus;
  KoeniginInfo koeniginInfo;
  String? veterinaryOffice;
  List<double> volksstaerkeHistory;

  Volk({
    required this.id,
    required this.name,
    required this.standort,
    required this.erstellungsdatum,
    this.kontrollen = const [],
    this.notizen = '',
    this.volksstaerke = 5.0,
    this.gesundheitsStatus = const GesundheitsStatus(),
    this.koeniginInfo = const KoeniginInfo(),
    this.veterinaryOffice,
    this.volksstaerkeHistory = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'standort': standort,
      'erstellungsdatum': erstellungsdatum.toIso8601String(),
      'kontrollen': kontrollen.map((k) => k.toJson()).toList(),
      'notizen': notizen,
      'volksstaerke': volksstaerke,
      'gesundheitsStatus': gesundheitsStatus.toJson(),
      'koeniginInfo': koeniginInfo.toJson(),
      'veterinaryOffice': veterinaryOffice,
      'volksstaerkeHistory': volksstaerkeHistory,
    };
  }

  factory Volk.fromJson(Map<String, dynamic> json) {
    return Volk(
      id: json['id'],
      name: json['name'],
      standort: json['standort'],
      erstellungsdatum: DateTime.parse(json['erstellungsdatum']),
      kontrollen: (json['kontrollen'] as List?)
              ?.map((k) => VoelkerKontrolle.fromJson(k))
              .toList() ??
          [],
      notizen: json['notizen'] ?? '',
      volksstaerke: (json['volksstaerke'] ?? 5.0).toDouble(),
      gesundheitsStatus: json['gesundheitsStatus'] != null
          ? GesundheitsStatus.fromJson(json['gesundheitsStatus'])
          : const GesundheitsStatus(),
      koeniginInfo: json['koeniginInfo'] != null
          ? KoeniginInfo.fromJson(json['koeniginInfo'])
          : const KoeniginInfo(),
      veterinaryOffice: json['veterinaryOffice'],
      volksstaerkeHistory: (json['volksstaerkeHistory'] as List?)?.cast<double>() ?? [],
    );
  }
}

class VoelkerKontrolle {
  final String id;
  final DateTime datum;
  final String notizen;
  final bool koeniginGesehen;
  final int wabenAnzahl;
  final String? audioPath;

  VoelkerKontrolle({
    required this.id,
    required this.datum,
    required this.notizen,
    this.koeniginGesehen = false,
    this.wabenAnzahl = 0,
    this.audioPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'datum': datum.toIso8601String(),
      'notizen': notizen,
      'koeniginGesehen': koeniginGesehen,
      'wabenAnzahl': wabenAnzahl,
      'audioPath': audioPath,
    };
  }

  factory VoelkerKontrolle.fromJson(Map<String, dynamic> json) {
    return VoelkerKontrolle(
      id: json['id'],
      datum: DateTime.parse(json['datum']),
      notizen: json['notizen'],
      koeniginGesehen: json['koeniginGesehen'] ?? false,
      wabenAnzahl: json['wabenAnzahl'] ?? 0,
      audioPath: json['audioPath'],
    );
  }
}

class GesundheitsStatus {
  final int score;
  final String status;
  final List<String> probleme;
  final String empfehlungen;

  const GesundheitsStatus({
    this.score = 85,
    this.status = 'Gut',
    this.probleme = const [],
    this.empfehlungen = 'Regelmäßige Kontrolle fortführen',
  });

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'status': status,
      'probleme': probleme,
      'empfehlungen': empfehlungen,
    };
  }

  factory GesundheitsStatus.fromJson(Map<String, dynamic> json) {
    return GesundheitsStatus(
      score: json['score'] ?? 85,
      status: json['status'] ?? 'Gut',
      probleme: (json['probleme'] as List?)?.cast<String>() ?? [],
      empfehlungen: json['empfehlungen'] ?? 'Regelmäßige Kontrolle fortführen',
    );
  }
}

class KoeniginInfo {
  final int alter;
  final String markierung;
  final String herkunft;
  final DateTime? letzteEiablage;

  const KoeniginInfo({
    this.alter = 2,
    this.markierung = 'Gelb',
    this.herkunft = 'Eigene Zucht',
    this.letzteEiablage,
  });

  Map<String, dynamic> toJson() {
    return {
      'alter': alter,
      'markierung': markierung,
      'herkunft': herkunft,
      'letzteEiablage': letzteEiablage?.toIso8601String(),
    };
  }

  factory KoeniginInfo.fromJson(Map<String, dynamic> json) {
    return KoeniginInfo(
      alter: json['alter'] ?? 2,
      markierung: json['markierung'] ?? 'Gelb',
      herkunft: json['herkunft'] ?? 'Eigene Zucht',
      letzteEiablage: json['letzteEiablage'] != null 
          ? DateTime.parse(json['letzteEiablage']) 
          : null,
    );
  }
}

class Stand {
  final String id;
  String name;
  String adresse;
  double? latitude;
  double? longitude;
  List<String> voelkerIds;
  String? veterinaryOffice;

  Stand({
    required this.id,
    required this.name,
    required this.adresse,
    this.latitude,
    this.longitude,
    this.voelkerIds = const [],
    this.veterinaryOffice,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'adresse': adresse,
      'latitude': latitude,
      'longitude': longitude,
      'voelkerIds': voelkerIds,
      'veterinaryOffice': veterinaryOffice,
    };
  }

  factory Stand.fromJson(Map<String, dynamic> json) {
    return Stand(
      id: json['id'],
      name: json['name'],
      adresse: json['adresse'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      voelkerIds: (json['voelkerIds'] as List?)?.cast<String>() ?? [],
      veterinaryOffice: json['veterinaryOffice'],
    );
  }
}