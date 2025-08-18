import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';

class KoeniginDetailCard extends StatelessWidget {
  final KoeniginInfo koeniginInfo;

  const KoeniginDetailCard({
    Key? key,
    required this.koeniginInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final markierungColor = _getMarkierungColor(koeniginInfo.markierung);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Königin Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            
            // Hauptinformationen
            Row(
              children: [
                // Königin Avatar
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: markierungColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: markierungColor,
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: markierungColor,
                  ),
                ),
                SizedBox(width: 20),
                
                // Basic Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Alter', '${koeniginInfo.alter} Jahre'),
                      _buildInfoRow('Markierung', koeniginInfo.markierung),
                      _buildInfoRow('Herkunft', koeniginInfo.herkunft),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            
            // Detaillierte Informationen
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detailinformationen',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 12),
                  
                  // Markierungsfarbe mit Jahr
                  Row(
                    children: [
                      Icon(Icons.palette, color: markierungColor),
                      SizedBox(width: 8),
                      Text('Markierungsfarbe: '),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: markierungColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: markierungColor),
                        ),
                        child: Text(
                          koeniginInfo.markierung,
                          style: TextStyle(
                            color: markierungColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '(${_getMarkierungsJahr()})',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  
                  // Leistungsindikatoren
                  Text(
                    'Leistungsbewertung',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  
                  _buildLeistungsbalken('Eiablage', _calculateEiablageScore(), Colors.orange),
                  SizedBox(height: 8),
                  _buildLeistungsbalken('Vitalität', _calculateVitalitaetScore(), Colors.green),
                  SizedBox(height: 8),
                  _buildLeistungsbalken('Friedfertigkeit', _calculateFriedfertigkeit(), Colors.blue),
                ],
              ),
            ),
            SizedBox(height: 16),
            
            // Letzte Eiablage
            if (koeniginInfo.letzteEiablage != null) ...[
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.event, color: Colors.green.shade700),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Letzte Eiablage',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade700,
                          ),
                        ),
                        Text(
                          DateFormat('dd.MM.yyyy').format(koeniginInfo.letzteEiablage!),
                          style: TextStyle(
                            color: Colors.green.shade800,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Text(
                      '${DateTime.now().difference(koeniginInfo.letzteEiablage!).inDays} Tage',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            // Zuchthinweise
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue.shade700),
                      SizedBox(width: 8),
                      Text(
                        'Zuchtinformationen',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    _getZuchthinweise(),
                    style: TextStyle(
                      color: Colors.blue.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeistungsbalken(String label, double wert, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            Text(
              '${(wert * 100).round()}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        LinearProgressIndicator(
          value: wert,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6,
        ),
      ],
    );
  }

  Color _getMarkierungColor(String markierung) {
    switch (markierung.toLowerCase()) {
      case 'gelb': return Colors.yellow.shade700;
      case 'blau': return Colors.blue.shade700;
      case 'rot': return Colors.red.shade600;
      case 'grün': return Colors.green.shade600;
      case 'weiß': return Colors.grey.shade700;
      default: return Colors.purple.shade700;
    }
  }

  String _getMarkierungsJahr() {
    final currentYear = DateTime.now().year;
    final koeniginJahr = currentYear - koeniginInfo.alter + 1;
    return koeniginJahr.toString();
  }

  double _calculateEiablageScore() {
    if (koeniginInfo.letzteEiablage == null) return 0.5;
    
    final daysSinceLastEgg = DateTime.now().difference(koeniginInfo.letzteEiablage!).inDays;
    if (daysSinceLastEgg <= 3) return 1.0;
    if (daysSinceLastEgg <= 7) return 0.8;
    if (daysSinceLastEgg <= 14) return 0.6;
    if (daysSinceLastEgg <= 30) return 0.4;
    return 0.2;
  }

  double _calculateVitalitaetScore() {
    // Basiert auf Alter - jüngere Königinnen sind vitaler
    if (koeniginInfo.alter <= 1) return 1.0;
    if (koeniginInfo.alter <= 2) return 0.9;
    if (koeniginInfo.alter <= 3) return 0.7;
    if (koeniginInfo.alter <= 4) return 0.5;
    return 0.3;
  }

  double _calculateFriedfertigkeit() {
    // Vereinfachte Bewertung basierend auf Herkunft
    if (koeniginInfo.herkunft.toLowerCase().contains('zucht')) return 0.9;
    if (koeniginInfo.herkunft.toLowerCase().contains('gekauft')) return 0.8;
    return 0.7;
  }

  String _getZuchthinweise() {
    final alter = koeniginInfo.alter;
    if (alter <= 1) {
      return 'Junge Königin - optimale Leistungsphase. Regelmäßige Kontrolle der Eiablage empfohlen.';
    } else if (alter <= 2) {
      return 'Königin in bester Leistungsphase. Ausgezeichnet für Zuchtmaterial geeignet.';
    } else if (alter <= 3) {
      return 'Erfahrene Königin. Leistung noch sehr gut, aber regelmäßige Überwachung empfohlen.';
    } else if (alter <= 4) {
      return 'Ältere Königin. Erneuerung in der nächsten Saison in Betracht ziehen.';
    } else {
      return 'Alte Königin. Dringend Erneuerung empfohlen - Leistung kann stark nachlassen.';
    }
  }
}