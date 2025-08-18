import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/models.dart';
import '../services/storage_service.dart';
import '../widgets/volksstaerke_chart.dart';
import '../widgets/gesundheits_status_panel.dart';
import '../widgets/koenigin_detail_card.dart';

class VolkDetailScreen extends StatefulWidget {
  final Volk volk;
  final VoidCallback onVolkUpdated;

  const VolkDetailScreen({
    Key? key,
    required this.volk,
    required this.onVolkUpdated,
  }) : super(key: key);

  @override
  _VolkDetailScreenState createState() => _VolkDetailScreenState();
}

class _VolkDetailScreenState extends State<VolkDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Volk _currentVolk;
  
  // Voice Recording
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _speechListening = false;
  String _speechWords = '';

  @override
  void initState() {
    super.initState();
    _currentVolk = widget.volk;
    _tabController = TabController(length: 4, vsync: this);
    _initSpeech();
  }

  void _initSpeech() async {
    var status = await Permission.microphone.request();
    if (status == PermissionStatus.granted) {
      _speechEnabled = await _speechToText.initialize();
      setState(() {});
    }
  }

  void _startListening() async {
    if (_speechEnabled) {
      await _speechToText.listen(
        onResult: (result) {
          setState(() {
            _speechWords = result.recognizedWords;
          });
        },
        listenFor: Duration(seconds: 30),
      );
      setState(() {
        _speechListening = true;
      });
    }
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _speechListening = false;
    });
  }

  void _addKontrolle() {
    showDialog(
      context: context,
      builder: (context) => _AddKontrolleDialog(
        volk: _currentVolk,
        speechText: _speechWords,
        onKontrolleAdded: (kontrolle) async {
          setState(() {
            _currentVolk.kontrollen.add(kontrolle);
            _speechWords = '';
          });
          await StorageService.updateVolk(_currentVolk);
          widget.onVolkUpdated();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentVolk.name),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Übersicht'),
            Tab(text: 'Analytics'),
            Tab(text: 'Königin'),
            Tab(text: 'Kontrollen'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUebersichtTab(),
          _buildAnalyticsTab(),
          _buildKoeniginTab(),
          _buildKontrollenTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _speechListening ? _stopListening : _startListening,
        icon: Icon(_speechListening ? Icons.mic : Icons.mic_none),
        label: Text(_speechListening ? 'Stop' : 'Sprache'),
        backgroundColor: _speechListening ? Colors.red : Colors.orange,
      ),
    );
  }

  Widget _buildUebersichtTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Grundinfo Card
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Grundinformationen',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 12),
                  _buildInfoRow('Name', _currentVolk.name),
                  _buildInfoRow('Standort', _currentVolk.standort),
                  _buildInfoRow(
                    'Erstellt am',
                    DateFormat('dd.MM.yyyy').format(_currentVolk.erstellungsdatum),
                  ),
                  _buildInfoRow(
                    'Volksstärke',
                    '${_currentVolk.volksstaerke.toStringAsFixed(1)}/10',
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          
          // Gesundheitsstatus
          GesundheitsStatusPanel(
            gesundheitsStatus: _currentVolk.gesundheitsStatus,
          ),
          SizedBox(height: 16),
          
          // Letzte Kontrolle
          if (_currentVolk.kontrollen.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Letzte Kontrolle',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 12),
                    _buildKontrolleInfo(_currentVolk.kontrollen.last),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
          
          // Aktionen
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.add),
                  label: Text('Kontrolle'),
                  onPressed: _addKontrolle,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  icon: Icon(Icons.edit),
                  label: Text('Bearbeiten'),
                  onPressed: () {
                    // TODO: Implement edit functionality
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Volksstärke Entwicklung',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16),
          VolksstaerkeChart(
            volksstaerke: _currentVolk.volksstaerke,
            maxWert: 10,
            history: _currentVolk.volksstaerkeHistory,
          ),
          SizedBox(height: 24),
          
          GesundheitsStatusPanel(
            gesundheitsStatus: _currentVolk.gesundheitsStatus,
          ),
        ],
      ),
    );
  }

  Widget _buildKoeniginTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          KoeniginDetailCard(
            koeniginInfo: _currentVolk.koeniginInfo,
          ),
        ],
      ),
    );
  }

  Widget _buildKontrollenTab() {
    return _currentVolk.kontrollen.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('Noch keine Kontrollen'),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _addKontrolle,
                  child: Text('Erste Kontrolle hinzufügen'),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: _currentVolk.kontrollen.length,
            itemBuilder: (context, index) {
              final kontrolle = _currentVolk.kontrollen.reversed.toList()[index];
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: _buildKontrolleInfo(kontrolle),
                ),
              );
            },
          );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildKontrolleInfo(VoelkerKontrolle kontrolle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('dd.MM.yyyy HH:mm').format(kontrolle.datum),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            if (kontrolle.koeniginGesehen)
              Chip(
                label: Text('Königin gesehen'),
                backgroundColor: Colors.green.shade100,
                labelStyle: TextStyle(color: Colors.green.shade700),
              ),
          ],
        ),
        if (kontrolle.wabenAnzahl > 0) ...[
          SizedBox(height: 8),
          Text('Waben: ${kontrolle.wabenAnzahl}'),
        ],
        if (kontrolle.notizen.isNotEmpty) ...[
          SizedBox(height: 8),
          Text(kontrolle.notizen),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _speechToText.stop();
    super.dispose();
  }
}

class _AddKontrolleDialog extends StatefulWidget {
  final Volk volk;
  final String speechText;
  final Function(VoelkerKontrolle) onKontrolleAdded;

  const _AddKontrolleDialog({
    required this.volk,
    required this.speechText,
    required this.onKontrolleAdded,
  });

  @override
  _AddKontrolleDialogState createState() => _AddKontrolleDialogState();
}

class _AddKontrolleDialogState extends State<_AddKontrolleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _notizenController = TextEditingController();
  bool _koeniginGesehen = false;
  int _wabenAnzahl = 0;

  @override
  void initState() {
    super.initState();
    if (widget.speechText.isNotEmpty) {
      _notizenController.text = widget.speechText;
      _parseSprachtext(widget.speechText);
    }
  }

  void _parseSprachtext(String text) {
    final lowerText = text.toLowerCase();
    if (lowerText.contains('königin gesehen') || lowerText.contains('königin da')) {
      _koeniginGesehen = true;
    }
    
    final wabenMatch = RegExp(r'(\d+)\s*waben?').firstMatch(lowerText);
    if (wabenMatch != null) {
      _wabenAnzahl = int.tryParse(wabenMatch.group(1) ?? '0') ?? 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Neue Kontrolle'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _notizenController,
                decoration: InputDecoration(
                  labelText: 'Notizen',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              SizedBox(height: 16),
              
              CheckboxListTile(
                title: Text('Königin gesehen'),
                value: _koeniginGesehen,
                onChanged: (value) {
                  setState(() {
                    _koeniginGesehen = value ?? false;
                  });
                },
              ),
              
              Row(
                children: [
                  Text('Waben: '),
                  Expanded(
                    child: Slider(
                      value: _wabenAnzahl.toDouble(),
                      min: 0,
                      max: 20,
                      divisions: 20,
                      label: _wabenAnzahl.toString(),
                      onChanged: (value) {
                        setState(() {
                          _wabenAnzahl = value.round();
                        });
                      },
                    ),
                  ),
                  Text('$_wabenAnzahl'),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Abbrechen'),
        ),
        ElevatedButton(
          onPressed: _saveKontrolle,
          child: Text('Speichern'),
        ),
      ],
    );
  }

  void _saveKontrolle() {
    final kontrolle = VoelkerKontrolle(
      id: 'kontrolle_${DateTime.now().millisecondsSinceEpoch}',
      datum: DateTime.now(),
      notizen: _notizenController.text,
      koeniginGesehen: _koeniginGesehen,
      wabenAnzahl: _wabenAnzahl,
    );

    widget.onKontrolleAdded(kontrolle);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _notizenController.dispose();
    super.dispose();
  }
}