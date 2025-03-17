import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class Bill {
  final String name;
  final double amount;
  final DateTime dueDate;
  final bool isSubscription;

  Bill(
      {required this.name,
      required this.amount,
      required this.dueDate,
      this.isSubscription = false});
}

class BillsPage extends StatefulWidget {
  const BillsPage({Key? key}) : super(key: key);

  @override
  _BillsPageState createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage> {
  final List<Bill> _bills = [];
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isSubscription = false;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _addBill() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _bills.add(Bill(
          name: _nameController.text,
          amount: double.parse(_amountController.text),
          dueDate: _selectedDate,
          isSubscription: _isSubscription,
        ));
        _nameController.clear();
        _amountController.clear();
        _selectedDate = DateTime.now();
        _isSubscription = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF6750A4),
            onPrimary: Colors.white,
            onSurface: Color(0xFF6750A4),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      appBar: AppBar(
        title: Text('Bills & Subscriptions',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFF6750A4),
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Finances',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1D1B20),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _bills.isEmpty ? _buildEmptyState() : _buildBillsList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddBillDialog(context),
        backgroundColor: const Color(0xFF6750A4),
        icon: const Icon(Icons.add),
        label: Text('Add Bill',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFEADDFF),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(Icons.receipt_long,
                size: 60, color: Color(0xFF6750A4)),
          ),
          const SizedBox(height: 24),
          Text(
            'No bills or subscriptions yet',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF49454F),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first one with the + button',
            style: GoogleFonts.poppins(
                fontSize: 14, color: const Color(0xFF79747E)),
          ),
        ],
      ),
    );
  }

  Widget _buildBillsList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: _bills.length,
      itemBuilder: (context, index) {
        final bill = _bills[index];
        return _BillCard(
          bill: bill,
          onDelete: () => setState(() => _bills.removeAt(index)),
        );
      },
    );
  }

  void _showAddBillDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Add New Bill',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                  controller: _nameController,
                  label: 'Name',
                  icon: Icons.label_outline,
                  validator: (value) =>
                      (value?.isEmpty ?? true) ? 'Please enter a name' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _amountController,
                  label: 'Amount',
                  icon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Please enter an amount';
                    if (double.tryParse(value!) == null)
                      return 'Please enter a valid number';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: _getInputDecoration(
                        label: 'Due Date', icon: Icons.calendar_today),
                    child: Text(
                        DateFormat('MMM dd, yyyy').format(_selectedDate),
                        style: GoogleFonts.poppins()),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE8DEF8)),
                  ),
                  child: SwitchListTile(
                    title: Text(
                      'Recurring Subscription',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                    value: _isSubscription,
                    activeColor: Colors.white,
                    activeTrackColor: const Color(0xFF6750A4),
                    inactiveTrackColor: Colors.grey[300],
                    onChanged: (bool value) =>
                        setState(() => _isSubscription = value),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('CANCEL',
                  style: GoogleFonts.poppins(color: const Color(0xFF6750A4))),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _addBill();
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6750A4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
              child: Text('ADD',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      style: GoogleFonts.poppins(),
      decoration: _getInputDecoration(label: label, icon: icon),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  InputDecoration _getInputDecoration(
      {required String label, required IconData icon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.poppins(color: const Color(0xFF6750A4)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE8DEF8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF6750A4), width: 2.0),
      ),
      prefixIcon: Icon(icon, color: const Color(0xFF6750A4)),
      filled: true,
      fillColor: Colors.white,
    );
  }
}

class _BillCard extends StatelessWidget {
  final Bill bill;
  final VoidCallback onDelete;

  const _BillCard({Key? key, required this.bill, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isPastDue = bill.dueDate.isBefore(DateTime.now());
    final dateString = DateFormat('MMM dd, yyyy').format(bill.dueDate);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: bill.isSubscription
                ? const Color(0xFFEADDFF)
                : const Color(0xFFE8DEF8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(bill.isSubscription ? Icons.repeat : Icons.receipt,
              color: const Color(0xFF6750A4), size: 26),
        ),
        title: Text(
          bill.name,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: const Color(0xFF1D1B20)),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today,
                    size: 14, color: isPastDue ? Colors.red : Colors.grey),
                const SizedBox(width: 4),
                Text(
                  dateString,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: isPastDue ? Colors.red : Colors.grey[700],
                    fontWeight: isPastDue ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              bill.isSubscription
                  ? 'Recurring Subscription'
                  : 'One-time Payment',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700]),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${bill.amount.toStringAsFixed(2)}',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: const Color(0xFF6750A4),
              ),
            ),
            IconButton(
              icon:
                  const Icon(Icons.delete_outline, color: Colors.red, size: 20),
              onPressed: onDelete,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}
