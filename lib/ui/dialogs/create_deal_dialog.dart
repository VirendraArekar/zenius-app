import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/crm_provider.dart';

class CreateDealDialog extends StatefulWidget {
  const CreateDealDialog({super.key});

  @override
  State<CreateDealDialog> createState() => _CreateDealDialogState();
}

class _CreateDealDialogState extends State<CreateDealDialog> {
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _accountCtrl = TextEditingController();
  String _stage = 'Qualification';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Opportunity'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Deal Title *'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _amountCtrl,
              decoration: const InputDecoration(labelText: 'Deal Amount (\$) *'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _accountCtrl,
              decoration: const InputDecoration(labelText: 'Account Name'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _stage,
              decoration: const InputDecoration(labelText: 'Pipeline Stage'),
              items: const [
                DropdownMenuItem(value: 'Qualification', child: Text('Qualification')),
                DropdownMenuItem(value: 'Proposal', child: Text('Proposal')),
                DropdownMenuItem(value: 'Negotiation', child: Text('Negotiation')),
                DropdownMenuItem(value: 'Closed Won', child: Text('Closed Won')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _stage = val);
              },
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
            if (_titleCtrl.text.trim().isEmpty) return;
            context.read<CrmProvider>().createDeal({
              'title': _titleCtrl.text.trim(),
              'amount': double.tryParse(_amountCtrl.text.trim()) ?? 10000.0,
              'accountName': _accountCtrl.text.trim().isNotEmpty ? _accountCtrl.text.trim() : null,
              'stageName': _stage,
            });
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Deal added to pipeline.')),
            );
          },
          child: const Text('Save Deal'),
        ),
      ],
    );
  }
}
