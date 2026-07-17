import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/group_member_entity.dart';
import '../../domain/entities/settlement_entity.dart';
import '../../domain/usecases/settlement_usecases.dart';
import '../providers/split_providers.dart';

class NewPaymentScreen extends ConsumerStatefulWidget {
  final int groupId;

  const NewPaymentScreen({super.key, required this.groupId});

  @override
  ConsumerState<NewPaymentScreen> createState() => _NewPaymentScreenState();
}

class _NewPaymentScreenState extends ConsumerState<NewPaymentScreen> {
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  int? _payerId;
  int? _receiverId;
  DateTime _paymentDate = DateTime.now();
  bool _isSaving = false;

  bool get _isValid {
    final amount = double.tryParse(_amountController.text) ?? 0;
    return amount > 0 && _payerId != null && _receiverId != null && _payerId != _receiverId;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_isValid) return;
    setState(() => _isSaving = true);

    final settlement = Settlement(
      groupId: widget.groupId,
      payerId: _payerId!,
      receiverId: _receiverId!,
      amount: double.parse(_amountController.text),
      settlementDate: _paymentDate,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      createdAt: DateTime.now(),
    );

    await GetIt.instance<CreateSettlement>()(settlement);
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(memberListProvider(widget.groupId));

    return membersAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(appBar: AppBar(), body: Center(child: Text('Error: $e'))),
      data: (members) {
        final validMembers = members.where((m) => m.localId != null).toList();
        final payer = validMembers.where((m) => m.localId == _payerId).firstOrNull;
        final receiver = validMembers.where((m) => m.localId == _receiverId).firstOrNull;

        return Scaffold(
          appBar: AppBar(
            title: const Text('New Payment'),
            actions: [
              TextButton(
                onPressed: _isSaving || !_isValid ? null : _save,
                child: _isSaving
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Save', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildMemberSelector('Who paid?', payer, Icons.arrow_upward, Colors.orange, validMembers.where((m) => m.localId != _receiverId).toList(), (m) => setState(() => _payerId = m.localId)),
                        const SizedBox(height: 16),
                        const Icon(Icons.arrow_downward, color: Colors.grey),
                        const SizedBox(height: 16),
                        _buildMemberSelector('Who received?', receiver, Icons.arrow_downward, Colors.green, validMembers.where((m) => m.localId != _payerId).toList(), (m) => setState(() => _receiverId = m.localId)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(labelText: 'Amount (₹)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.currency_rupee)),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16),
                Row(children: [const Text('Date: '), TextButton(onPressed: () async {
                  final picked = await showDatePicker(context: context, initialDate: _paymentDate, firstDate: DateTime(2020), lastDate: DateTime.now());
                  if (picked != null) setState(() => _paymentDate = picked);
                }, child: Text(DateFormat.yMMMd().format(_paymentDate)))]),
                const SizedBox(height: 12),
                TextField(
                  controller: _notesController,
                  decoration: const InputDecoration(labelText: 'Notes (optional)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.notes)),
                  maxLines: 2,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isSaving || !_isValid ? null : _save,
                    style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                    child: const Text('Record Payment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMemberSelector(String label, GroupMember? selected, IconData icon, Color color, List<GroupMember> members, Function(GroupMember) onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        const SizedBox(height: 8),
        if (selected != null)
          Card(
            color: color.withAlpha(20),
            child: ListTile(
              leading: CircleAvatar(backgroundColor: Color(selected.avatarColor), child: Text(selected.name.isNotEmpty ? selected.name[0].toUpperCase() : '?', style: const TextStyle(color: Colors.white))),
              title: Text(selected.name, style: const TextStyle(fontWeight: FontWeight.w600)),
              trailing: IconButton(icon: const Icon(Icons.close), onPressed: () => onSelect(selected)),
            ),
          )
        else
          OutlinedButton.icon(
            onPressed: () => _showMemberPicker(members, onSelect),
            icon: Icon(icon),
            label: const Text('Select Member'),
            style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
          ),
      ],
    );
  }

  void _showMemberPicker(List<GroupMember> members, Function(GroupMember) onSelect) {
    final searchController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) {
          var query = '';
          final filtered = query.isEmpty ? members : members.where((m) => m.name.toLowerCase().contains(query.toLowerCase())).toList();
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 12),
                TextField(
                  controller: searchController,
                  decoration: const InputDecoration(hintText: 'Search members...', prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
                  onChanged: (v) => setSheetState(() => query = v),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final m = filtered[index];
                      return ListTile(
                        leading: CircleAvatar(backgroundColor: Color(m.avatarColor), child: Text(m.name.isNotEmpty ? m.name[0].toUpperCase() : '?', style: const TextStyle(color: Colors.white))),
                        title: Text(m.name),
                        onTap: () {
                          onSelect(m);
                          Navigator.pop(ctx);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
