import 'package:flutter/material.dart';
import '../models/models.dart';

class AddVolkModal extends StatefulWidget {
  final List<Stand> staende;
  final Function(Volk) onVolkAdded;

  const AddVolkModal({
    Key? key,
    required this.staende,
    required this.onVolkAdded,
  }) : super(key: key);

  @override
  _AddVolkModalState createState() => _AddVolkModalState();
}

class _AddVolkModalState extends State<AddVolkModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notizenController = TextEditingController();
  
  String? _selectedStandort;
  double _volksstaerke = 5.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Neues Volk hinzufügen'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Volkname',
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
              
              DropdownButtonFormField<String>(
                value: _selectedStandort,
                decoration: InputDecoration(
                  labelText: 'Standort',
                  border: OutlineInputBorder(),
                ),
                items: widget.staende.map((stand) {
                  return DropdownMenuItem(
                    value: stand.name,
                    child: Text(stand.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStandort = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte wählen Sie einen Standort';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              Text(
                'Volksstärke: ${_volksstaerke.toStringAsFixed(1)}/10',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Slider(
                value: _volksstaerke,
                min: 1.0,
                max: 10.0,
                divisions: 18,
                onChanged: (value) {
                  setState(() {
                    _volksstaerke = value;
                  });
                },
              ),
              SizedBox(height: 16),
              
              TextFormField(
                controller: _notizenController,
                decoration: InputDecoration(
                  labelText: 'Notizen (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
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
          onPressed: _saveVolk,
          child: Text('Speichern'),
        ),
      ],
    );
  }

  void _saveVolk() {
    if (_formKey.currentState!.validate()) {
      final volk = Volk(
        id: 'volk_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text,
        standort: _selectedStandort!,
        erstellungsdatum: DateTime.now(),
        volksstaerke: _volksstaerke,
        notizen: _notizenController.text,
        volksstaerkeHistory: [_volksstaerke],
      );

      widget.onVolkAdded(volk);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notizenController.dispose();
    super.dispose();
  }
}