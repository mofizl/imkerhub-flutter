import 'package:flutter/material.dart';
import '../models/models.dart';
import '../widgets/add_stand_modal.dart';

class StaendeScreen extends StatefulWidget {
  final List<Stand> staende;
  final VoidCallback onStaendeChanged;

  const StaendeScreen({
    Key? key,
    required this.staende,
    required this.onStaendeChanged,
  }) : super(key: key);

  @override
  _StaendeScreenState createState() => _StaendeScreenState();
}

class _StaendeScreenState extends State<StaendeScreen> {
  void _showAddStandModal() {
    showDialog(
      context: context,
      builder: (context) => AddStandModal(
        onStandAdded: (stand) {
          widget.onStaendeChanged();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Standorte'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddStandModal,
          ),
        ],
      ),
      body: widget.staende.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Noch keine Standorte',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Füge deinen ersten Standort hinzu',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: widget.staende.length,
              itemBuilder: (context, index) {
                final stand = widget.staende[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange.shade100,
                      child: Icon(
                        Icons.location_on,
                        color: Colors.orange.shade700,
                      ),
                    ),
                    title: Text(
                      stand.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(stand.adresse),
                        if (stand.veterinaryOffice != null) ...[
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.local_hospital,
                                size: 16,
                                color: Colors.green.shade600,
                              ),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  stand.veterinaryOffice!,
                                  style: TextStyle(
                                    color: Colors.green.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          // TODO: Implement edit functionality
                        } else if (value == 'delete') {
                          // TODO: Implement delete functionality
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 18),
                              SizedBox(width: 8),
                              Text('Bearbeiten'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Löschen', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddStandModal,
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }
}