import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/storage_service.dart';
import '../widgets/volk_card.dart';
import '../widgets/add_volk_modal.dart';
import '../widgets/add_stand_modal.dart';
import '../screens/staende_screen.dart';
import '../screens/volk_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Volk> voelker = [];
  List<Stand> staende = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final loadedVoelker = await StorageService.loadVoelker();
      final loadedStaende = await StorageService.loadStaende();
      
      // Add sample data if empty
      if (loadedVoelker.isEmpty && loadedStaende.isEmpty) {
        await _addSampleData();
        final newVoelker = await StorageService.loadVoelker();
        final newStaende = await StorageService.loadStaende();
        setState(() {
          voelker = newVoelker;
          staende = newStaende;
          isLoading = false;
        });
      } else {
        setState(() {
          voelker = loadedVoelker;
          staende = loadedStaende;
          isLoading = false;
        });
      }
    } catch (e) {
      // print('Error loading data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _addSampleData() async {
    // Sample Stands
    final sampleStand = Stand(
      id: 'stand_1',
      name: 'Heimatstand',
      adresse: 'Musterstraße 123, 12345 Musterstadt',
      latitude: 52.5200,
      longitude: 13.4050,
    );
    await StorageService.addStand(sampleStand);

    // Sample Völker
    final sampleVolk1 = Volk(
      id: 'volk_1',
      name: 'Volk 1',
      standort: 'Heimatstand',
      erstellungsdatum: DateTime.now().subtract(Duration(days: 30)),
      volksstaerke: 7.5,
      volksstaerkeHistory: [5.0, 6.0, 6.5, 7.0, 7.5],
      kontrollen: [
        VoelkerKontrolle(
          id: 'kontrolle_1',
          datum: DateTime.now().subtract(Duration(days: 7)),
          notizen: 'Königin gesehen, 8 Waben besetzt',
          koeniginGesehen: true,
          wabenAnzahl: 8,
        ),
      ],
      gesundheitsStatus: GesundheitsStatus(
        score: 90,
        status: 'Sehr Gut',
        empfehlungen: 'Weiter so! Regelmäßige Kontrolle beibehalten.',
      ),
      koeniginInfo: KoeniginInfo(
        alter: 2,
        markierung: 'Blau',
        herkunft: 'Eigene Zucht',
        letzteEiablage: DateTime.now().subtract(Duration(days: 3)),
      ),
    );

    final sampleVolk2 = Volk(
      id: 'volk_2',
      name: 'Volk 2',
      standort: 'Heimatstand',
      erstellungsdatum: DateTime.now().subtract(Duration(days: 45)),
      volksstaerke: 6.0,
      volksstaerkeHistory: [4.0, 4.5, 5.0, 5.5, 6.0],
      gesundheitsStatus: GesundheitsStatus(
        score: 75,
        status: 'Gut',
        probleme: ['Leichte Milbenbelastung'],
        empfehlungen: 'Milbenbehandlung in Betracht ziehen',
      ),
    );

    await StorageService.addVolk(sampleVolk1);
    await StorageService.addVolk(sampleVolk2);
  }

  void _showAddVolgModal() {
    showDialog(
      context: context,
      builder: (context) => AddVolkModal(
        staende: staende,
        onVolkAdded: (volk) async {
          await StorageService.addVolk(volk);
          _loadData();
        },
      ),
    );
  }

  void _showAddStandModal() {
    showDialog(
      context: context,
      builder: (context) => AddStandModal(
        onStandAdded: (stand) async {
          await StorageService.addStand(stand);
          _loadData();
        },
      ),
    );
  }

  void _navigateToStaende() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StaendeScreen(
          staende: staende,
          onStaendeChanged: _loadData,
        ),
      ),
    );
  }

  void _navigateToVolkDetail(Volk volk) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VolkDetailScreen(
          volk: volk,
          onVolkUpdated: _loadData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('ImkerHub'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.location_on),
            onPressed: _navigateToStaende,
            tooltip: 'Standorte verwalten',
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header mit Statistiken
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Völker', '${voelker.length}', Icons.hive),
                  Container(width: 1, height: 40, color: Colors.orange.shade300),
                  _buildStatItem('Standorte', '${staende.length}', Icons.location_on),
                  Container(width: 1, height: 40, color: Colors.orange.shade300),
                  _buildStatItem('Kontrollen', '${voelker.fold(0, (sum, v) => sum + v.kontrollen.length)}', Icons.check_circle),
                ],
              ),
            ),
            SizedBox(height: 24),
            
            // Völker Sektion
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Meine Völker',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    TextButton.icon(
                      icon: Icon(Icons.location_on, size: 18),
                      label: Text('Standorte'),
                      onPressed: _navigateToStaende,
                    ),
                    SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: Icon(Icons.add),
                      label: Text('Volk'),
                      onPressed: _showAddVolgModal,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            
            // Völker Liste
            Expanded(
              child: voelker.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.hive,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Noch keine Völker',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Füge dein erstes Volk hinzu',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: voelker.length,
                      itemBuilder: (context, index) {
                        final volk = voelker[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: VolkCard(
                            volk: volk,
                            onTap: () => _navigateToVolkDetail(volk),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddVolgModal,
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.orange.shade700, size: 24),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.orange.shade700,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}