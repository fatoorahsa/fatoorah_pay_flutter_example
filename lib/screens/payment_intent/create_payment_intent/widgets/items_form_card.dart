import 'package:flutter/material.dart';

/// Items Form Card Widget
/// 
/// Card for adding new payment items
class ItemsFormCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController quantityController;
  final TextEditingController amountController;
  final VoidCallback onAdd;

  const ItemsFormCard({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.quantityController,
    required this.amountController,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Items',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Item Name (Optional)',
                hintText: 'Leave empty if not needed',
              ),
              controller: nameController,
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Item Description (Optional)',
                hintText: 'Leave empty if not needed',
              ),
              controller: descriptionController,
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Item Quantity'),
              controller: quantityController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Item Amount (in cents)',
              ),
              controller: amountController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: onAdd,
              child: const Text('Add Item'),
            ),
          ],
        ),
      ),
    );
  }
}

