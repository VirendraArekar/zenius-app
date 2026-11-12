import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/crm_provider.dart';

class CreateLeadDialog extends StatefulWidget {
  const CreateLeadDialog({super.key});

  @override
  State<CreateLeadDialog> createState() => _CreateLeadDialogState();
}

class _CreateLeadDialogState extends State<CreateLeadDialog> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _valueCtrl = TextEditingController();
  String _source = 'WEBSITE';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Enterprise Lead'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Full Name *'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _companyCtrl,
              decoration: const InputDecoration(labelText: 'Company / Organization'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: 'Email Address'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _valueCtrl,
              decoration: const InputDecoration(labelText: 'Estimated Value (\$)'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameCtrl.text.trim().isEmpty) return;
            context.read<CrmProvider>().createLead({
              'fullName': _nameCtrl.text.trim(),
              'companyName': _companyCtrl.text.trim().isNotEmpty ? _companyCtrl.text.trim() : null,
              'email': _emailCtrl.text.trim().isNotEmpty ? _emailCtrl.text.trim() : null,
              'estimatedValue': double.tryParse(_valueCtrl.text.trim()),
              'source': _source,
            });
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Lead created and auto-scored.')),
            );
          },
          child: const Text('Save Lead'),
        ),
      ],
    );
  }
}
