import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/veterinary_service.dart';

class AddStandModal extends StatefulWidget {
  final Function(Stand) onStandAdded;

  const AddStandModal({
    Key? key,
    required this.onStandAdded,
  }) : super(key: key);

  @override
  _AddStandModalState createState() => _AddStandModalState();
}

class _AddStandModalState extends State<AddStandModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _adresseController = TextEditingController();
  
  bool _isLoadingLocation = false;
  String? _veterinaryOffice;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Neuen Standort hinzufügen'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Standortname',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte geben Sie einen Namen ein';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              TextFormField(
                controller: _adresseController,
                decoration: InputDecoration(
                  labelText: 'Adresse',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte geben Sie eine Adresse ein';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: _isLoadingLocation 
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(Icons.my_location),
                      label: Text('GPS verwenden'),
                      onPressed: _isLoadingLocation ? null : _useCurrentLocation,
                    ),
                  ),
                ],
              ),
              
              if (_veterinaryOffice != null) ...[
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.local_hospital, color: Colors.green.shade700),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Zuständiges Veterinäramt:',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              _veterinaryOffice!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
          onPressed: _saveStand,
          child: Text('Speichern'),
        ),
      ],
    );
  }

  Future<void> _useCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final position = await VeterinaryService.getCurrentPosition();
      if (position != null) {
        final veterinaryOffice = await VeterinaryService.findNearestVeterinaryOffice(
          position.latitude,
          position.longitude,
        );
        
        setState(() {
          _veterinaryOffice = veterinaryOffice;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('GPS Position erfasst'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('GPS Position konnte nicht ermittelt werden'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Abrufen der Position: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      _isLoadingLocation = false;
    });
  }

  void _saveStand() {
    if (_formKey.currentState!.validate()) {
      final stand = Stand(
        id: 'stand_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text,
        adresse: _adresseController.text,
        veterinaryOffice: _veterinaryOffice,
      );

      widget.onStandAdded(stand);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _adresseController.dispose();
    super.dispose();
  }
}