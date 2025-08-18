import 'package:flutter/material.dart';
import '../models/models.dart';

class GesundheitsStatusPanel extends StatelessWidget {
  final GesundheitsStatus gesundheitsStatus;

  const GesundheitsStatusPanel({
    Key? key,
    required this.gesundheitsStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final score = gesundheitsStatus.score.clamp(0, 100);
    final color = _getHealthColor(score);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gesundheitsstatus',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            
            // Score Display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${score}%',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      gesundheitsStatus.status,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Icon(
                    _getHealthIcon(score),
                    color: color,
                    size: 32,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            
            // Progress Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gesundheitswert',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                LinearProgressIndicator(
                  value: score / 100,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 8,
                ),
              ],
            ),
            SizedBox(height: 16),
            
            // Probleme
            if (gesundheitsStatus.probleme.isNotEmpty) ...[
              Text(
                'Erkannte Probleme',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.red.shade700,
                ),
              ),
              SizedBox(height: 8),
              ...gesundheitsStatus.probleme.map((problem) => Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red.shade600, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        problem,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),
                  ],
                ),
              )).toList(),
              SizedBox(height: 16),
            ],
            
            // Empfehlungen
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
                      Icon(Icons.lightbulb, color: Colors.blue.shade700, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Empfehlungen',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    gesundheitsStatus.empfehlungen,
                    style: TextStyle(
                      color: Colors.blue.shade800,
                    ),
                  ),
                ],
              ),
            ),
            
            // Gesundheitskategorien
            SizedBox(height: 16),
            _buildHealthCategories(score),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthCategories(int score) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bewertungskategorien',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildCategoryItem('Ausgezeichnet', 90, 100, Colors.green.shade700),
            _buildCategoryItem('Gut', 70, 89, Colors.green.shade500),
            _buildCategoryItem('Befriedigend', 50, 69, Colors.orange.shade600),
            _buildCategoryItem('Problematisch', 0, 49, Colors.red.shade600),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryItem(String label, int min, int max, Color color) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          '$min-$max%',
          style: TextStyle(
            fontSize: 8,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Color _getHealthColor(int score) {
    if (score >= 80) return Colors.green.shade600;
    if (score >= 60) return Colors.green.shade400;
    if (score >= 40) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  IconData _getHealthIcon(int score) {
    if (score >= 80) return Icons.favorite;
    if (score >= 60) return Icons.favorite_border;
    if (score >= 40) return Icons.warning;
    return Icons.error;
  }
}