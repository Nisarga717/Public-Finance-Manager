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

  // Primary color constant for consistency
  final Color _primaryColor = const Color(0xFF6750A4);
  final Color _secondaryColor = const Color(0xFFEADDFF);
  final Color _accentColor =
      const Color(0xFFFF7043); // Accent color for buttons

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
          colorScheme: ColorScheme.light(
            primary: _primaryColor,
            onPrimary: Colors.white,
            onSurface: _primaryColor,
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
        backgroundColor: _primaryColor,
        elevation: 2, // Added elevation for depth
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Finances',
                  style: GoogleFonts.poppins(
                    fontSize: 24, // Increased font size
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1D1B20),
                  ),
                ),
                // Add a more visible month filter button
                ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _secondaryColor,
                    foregroundColor: _primaryColor,
                    elevation: 3,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.filter_list, size: 18),
                  label: Text(
                    'Filter',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _bills.isEmpty ? _buildEmptyState() : _buildBillsList(),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 60, // Increased height
        width: 180, // Wider button
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: _accentColor.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 4),
              spreadRadius: 2,
            ),
          ],
          borderRadius: BorderRadius.circular(30),
        ),
        child: FloatingActionButton.extended(
          onPressed: () => _showAddBillDialog(context),
          backgroundColor: _accentColor,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add, size: 28),
          label: Text('ADD BILL',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                letterSpacing: 0.5,
              )),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: _secondaryColor,
              borderRadius: BorderRadius.circular(70),
              boxShadow: [
                BoxShadow(
                  color: _primaryColor.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(Icons.receipt_long, size: 70, color: _primaryColor),
          ),
          const SizedBox(height: 28),
          Text(
            'No bills or subscriptions yet',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF49454F),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Add your first one with the button below',
            style: GoogleFonts.poppins(
                fontSize: 16, color: const Color(0xFF79747E)),
          ),
          const SizedBox(height: 40),
          // Much more visible "Add First Bill" button in empty state
          Container(
            width: 260,
            height: 60,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: _accentColor.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () => _showAddBillDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              icon: const Icon(Icons.add, size: 28),
              label: Text(
                'Add Your First Bill',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
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
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
          accentColor: _accentColor,
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
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Add New Bill',
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20),
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
                // Make date selector appear more button-like
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE8DEF8)),
                  ),
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () => _selectDate(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 12),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, color: _primaryColor),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Due Date',
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  DateFormat('MMM dd, yyyy')
                                      .format(_selectedDate),
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: _secondaryColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Icon(Icons.edit_calendar,
                                  size: 16, color: _primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                    activeTrackColor: _accentColor,
                    inactiveTrackColor: Colors.grey[300],
                    onChanged: (bool value) =>
                        setState(() => _isSubscription = value),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            // Make buttons in dialog more visible
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text('CANCEL',
                        style: GoogleFonts.poppins(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _addBill();
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accentColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 2,
                    ),
                    child: Text('ADD',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        )),
                  ),
                ),
              ],
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
      labelStyle: GoogleFonts.poppins(color: _primaryColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE8DEF8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _primaryColor, width: 2.0),
      ),
      prefixIcon: Icon(icon, color: _primaryColor),
      filled: true,
      fillColor: Colors.white,
    );
  }
}

class _BillCard extends StatelessWidget {
  final Bill bill;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final VoidCallback onDelete;

  const _BillCard({
    Key? key,
    required this.bill,
    required this.onDelete,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
  }) : super(key: key);

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
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: bill.isSubscription
                        ? secondaryColor
                        : const Color(0xFFE8DEF8),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.15),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                      bill.isSubscription ? Icons.repeat : Icons.receipt,
                      color: primaryColor,
                      size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bill.name,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1D1B20),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 14,
                              color: isPastDue ? Colors.red : Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            dateString,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: isPastDue ? Colors.red : Colors.grey[700],
                              fontWeight: isPastDue
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '\$${bill.amount.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: bill.isSubscription
                          ? secondaryColor.withOpacity(0.3)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      bill.isSubscription
                          ? 'Recurring Subscription'
                          : 'One-time Payment',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: bill.isSubscription
                            ? primaryColor
                            : Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // More visible delete button
                ElevatedButton.icon(
                  onPressed: onDelete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[50],
                    foregroundColor: Colors.red,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  icon: const Icon(Icons.delete_outline, size: 20),
                  label: Text(
                    'Remove',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
