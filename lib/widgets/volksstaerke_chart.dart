import 'package:flutter/material.dart';
import 'dart:math';

class VolksstaerkeChart extends StatelessWidget {
  final double volksstaerke;
  final double maxWert;
  final List<double> history;

  const VolksstaerkeChart({
    Key? key,
    required this.volksstaerke,
    this.maxWert = 10,
    this.history = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final safeVolksstaerke = max(0.0, min(maxWert, volksstaerke));
    final safeMaxWert = max(1.0, maxWert);
    final prozent = (safeVolksstaerke / safeMaxWert * 100).clamp(0.0, 100.0);
    
    final trend = _calculateTrend();
    final trendColor = trend > 0 ? Colors.green : trend < 0 ? Colors.red : Colors.grey;
    final trendIcon = trend > 0 ? Icons.trending_up : trend < 0 ? Icons.trending_down : Icons.trending_flat;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Volksstärke',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            
            // Hauptanzeige
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${safeVolksstaerke.toStringAsFixed(1)}/${safeMaxWert.toStringAsFixed(1)}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: _getVolksstaerkeColor(prozent),
                      ),
                    ),
                    Text(
                      '${prozent.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 100,
                  height: 100,
                  child: CustomPaint(
                    painter: CircularProgressPainter(
                      progress: prozent / 100.0,
                      color: _getVolksstaerkeColor(prozent),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            
            // Trend Anzeige
            if (history.length >= 2) ...[
              Row(
                children: [
                  Icon(trendIcon, color: trendColor, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Trend: ${trend > 0 ? '+' : ''}${trend.toStringAsFixed(1)}',
                    style: TextStyle(
                      color: trendColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
            
            // Verlaufsdiagramm
            if (history.isNotEmpty) ...[
              Text(
                'Verlauf',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 12),
              Container(
                height: 80,
                child: CustomPaint(
                  size: Size(double.infinity, 80),
                  painter: LineChartPainter(
                    data: history,
                    maxValue: safeMaxWert.toDouble(),
                    color: _getVolksstaerkeColor(prozent),
                  ),
                ),
              ),
            ],
            
            // Status Bewertung
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getVolksstaerkeColor(prozent).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getVolksstaerkeColor(prozent).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getStatusIcon(prozent),
                    color: _getVolksstaerkeColor(prozent),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _getStatusText(prozent),
                      style: TextStyle(
                        color: _getVolksstaerkeColor(prozent),
                        fontWeight: FontWeight.w600,
                      ),
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

  double _calculateTrend() {
    if (history.length < 2) return 0;
    return volksstaerke - history[history.length - 2];
  }

  Color _getVolksstaerkeColor(double prozent) {
    if (prozent >= 70) return Colors.green;
    if (prozent >= 40) return Colors.orange;
    return Colors.red;
  }

  IconData _getStatusIcon(double prozent) {
    if (prozent >= 70) return Icons.check_circle;
    if (prozent >= 40) return Icons.warning;
    return Icons.error;
  }

  String _getStatusText(double prozent) {
    if (prozent >= 80) return 'Sehr starkes Volk';
    if (prozent >= 60) return 'Starkes Volk';
    if (prozent >= 40) return 'Mittleres Volk';
    if (prozent >= 20) return 'Schwaches Volk';
    return 'Sehr schwaches Volk - Maßnahmen erforderlich';
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  CircularProgressPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 8;

    // Background circle
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class LineChartPainter extends CustomPainter {
  final List<double> data;
  final double maxValue;
  final Color color;

  LineChartPainter({
    required this.data,
    required this.maxValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final points = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - (data[i] / maxValue) * size.height;
      points.add(Offset(x, y));

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Draw line
    canvas.drawPath(path, paint);

    // Draw points
    for (final point in points) {
      canvas.drawCircle(point, 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}