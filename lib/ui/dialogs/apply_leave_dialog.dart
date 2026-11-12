import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/attendance_provider.dart';

class ApplyLeaveDialog extends StatefulWidget {
  const ApplyLeaveDialog({super.key});

  @override
  State<ApplyLeaveDialog> createState() => _ApplyLeaveDialogState();
}

class _ApplyLeaveDialogState extends State<ApplyLeaveDialog> {
  String _leaveType = 'PAID';
  final _reasonCtrl = TextEditingController();
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  DateTime _endDate = DateTime.now().add(const Duration(days: 3));

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Apply for Leave'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _leaveType,
              decoration: const InputDecoration(labelText: 'Leave Category'),
              items: const [
                DropdownMenuItem(value: 'PAID', child: Text('Paid Annual Leave')),
                DropdownMenuItem(value: 'CASUAL', child: Text('Casual Leave')),
                DropdownMenuItem(value: 'SICK', child: Text('Medical / Sick Leave')),
                DropdownMenuItem(value: 'MATERNITY', child: Text('Maternity / Paternity')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _leaveType = val);
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _reasonCtrl,
              decoration: const InputDecoration(labelText: 'Reason for Leave *'),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            Text('Duration: ${_endDate.difference(_startDate).inDays + 1} days', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
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
            if (_reasonCtrl.text.trim().isEmpty) return;
            context.read<AttendanceProvider>().applyLeave(
              type: _leaveType,
              start: _startDate,
              end: _endDate,
              reason: _reasonCtrl.text.trim(),
            );
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Leave application submitted to HR.')),
            );
          },
          child: const Text('Submit Application'),
        ),
      ],
    );
  }
}
