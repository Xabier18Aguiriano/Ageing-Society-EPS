import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../state/app_state.dart';
import '../../../theme/app_theme.dart';

class FamilyConnectionScreen extends StatelessWidget {
  static const route = '/family';
  const FamilyConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final contacts = app.familyContacts;

    return Scaffold(
      appBar: AppBar(title: const Text('Family connection')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('CONNECTED FAMILY', style: TextStyle(fontWeight: FontWeight.w900, color: AppTheme.blue)),
                const SizedBox(height: 6),
                const Text('People who receive updates about your activity', style: TextStyle(color: AppTheme.muted)),
                const SizedBox(height: 18),

                Expanded(
                  child: contacts.isEmpty
                      ? const Center(child: Text('No family members added yet', style: TextStyle(color: AppTheme.muted)))
                      : ListView.separated(
                          itemCount: contacts.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, i) {
                            final c = contacts[i];
                            return _FamilyCard(contact: c);
                          },
                        ),
                ),

                const SizedBox(height: 12),
                SizedBox(
                  height: 54,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.person_add),
                    label: const Text('ADD FAMILY MEMBER', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () => _showAddContactDialog(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddContactDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add family member'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(hintText: 'Name')),
            const SizedBox(height: 10),
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(hintText: 'Phone number'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(child: const Text('Cancel'), onPressed: () => Navigator.pop(context)),
          ElevatedButton(
            child: const Text('Add'),
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) return;
              context.read<AppState>().addFamilyContact(name: nameCtrl.text.trim(), phone: phoneCtrl.text.trim());
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class _FamilyCard extends StatelessWidget {
  final dynamic contact;
  const _FamilyCard({required this.contact});

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const Icon(Icons.person, color: AppTheme.blue),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contact.name, style: const TextStyle(fontWeight: FontWeight.w900)),
                Text(contact.phone, style: const TextStyle(color: AppTheme.muted)),
              ],
            ),
          ),
          Switch(
            value: contact.notificationsEnabled,
            onChanged: (_) => app.toggleNotifications(contact.id),
          ),
          IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => app.removeFamilyContact(contact.id)),
        ],
      ),
    );
  }
}