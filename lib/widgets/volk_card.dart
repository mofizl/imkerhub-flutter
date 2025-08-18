import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';

class VolkCard extends StatelessWidget {
  final Volk volk;
  final VoidCallback onTap;

  const VolkCard({
    Key? key,
    required this.volk,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final letzteKontrolle = volk.kontrollen.isNotEmpty
        ? volk.kontrollen.last
        : null;
    
    final gesundheitsColor = _getGesundheitsColor(volk.gesundheitsStatus.score);
    final volksstaerkePercent = (volk.volksstaerke / 10.0 * 100).clamp(0, 100);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          volk.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          volk.standort,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: gesundheitsColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: gesundheitsColor.withOpacity(0.3)),
                    ),
                    child: Text(
                      volk.gesundheitsStatus.status,
                      style: TextStyle(
                        color: gesundheitsColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              
              // Volksstärke Anzeige
              Row(
                children: [
                  Icon(Icons.trending_up, color: Colors.orange.shade700, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Volksstärke: ${volk.volksstaerke.toStringAsFixed(1)}/10',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(height: 8),
              LinearProgressIndicator(
                value: volksstaerkePercent / 100,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(
                  volksstaerkePercent >= 70 ? Colors.green :
                  volksstaerkePercent >= 40 ? Colors.orange : Colors.red,
                ),
              ),
              SizedBox(height: 16),
              
              // Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatChip(
                    Icons.health_and_safety,
                    '${volk.gesundheitsStatus.score}%',
                    gesundheitsColor,
                  ),
                  _buildStatChip(
                    Icons.calendar_today,
                    letzteKontrolle != null 
                        ? DateFormat('dd.MM').format(letzteKontrolle.datum)
                        : 'Keine',
                    Colors.blue.shade700,
                  ),
                  _buildStatChip(
                    Icons.check_circle,
                    '${volk.kontrollen.length}',
                    Colors.green.shade700,
                  ),
                  if (volk.koeniginInfo.markierung.isNotEmpty)
                    _buildStatChip(
                      Icons.person,
                      volk.koeniginInfo.markierung,
                      _getKoeniginColor(volk.koeniginInfo.markierung),
                    ),
                ],
              ),
              
              // Letzte Kontrolle Info
              if (letzteKontrolle != null) ...[
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.notes, size: 16, color: Colors.grey.shade600),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          letzteKontrolle.notizen.isEmpty 
                              ? 'Kontrolle vom ${DateFormat('dd.MM.yyyy').format(letzteKontrolle.datum)}'
                              : letzteKontrolle.notizen,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (letzteKontrolle.koeniginGesehen)
                        Icon(Icons.visibility, size: 16, color: Colors.green),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getGesundheitsColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  Color _getKoeniginColor(String markierung) {
    switch (markierung.toLowerCase()) {
      case 'gelb': return Colors.yellow.shade700;
      case 'blau': return Colors.blue.shade700;
      case 'rot': return Colors.red.shade700;
      case 'grün': return Colors.green.shade700;
      case 'weiß': return Colors.grey.shade700;
      default: return Colors.purple.shade700;
    }
  }
}