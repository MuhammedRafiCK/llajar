import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchForm extends StatefulWidget {
  const SearchForm({super.key});

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropoffController = TextEditingController();
  DateTime _pickupDate = DateTime.now();
  DateTime _dropoffDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _pickupTime = const TimeOfDay(hour: 10, minute: 0);
  TimeOfDay _dropoffTime = const TimeOfDay(hour: 10, minute: 0);
  bool _sameAsPickup = true;
  bool _aarpMember = false;
  bool _hasDiscountCode = false;
  String _selectedBrand = '';

  final List<Map<String, String>> _brands = [
    {
      'name': 'Sixt',
      'logo': 'https://ext.same-assets.com/1648771861/2614900179.jpeg',
    },
    {
      'name': 'Budget',
      'logo': 'https://ext.same-assets.com/1648771861/150394296.jpeg',
    },
    {
      'name': 'Avis',
      'logo': 'https://ext.same-assets.com/1648771861/743153087.jpeg',
    },
    {
      'name': 'Dollar',
      'logo': 'https://ext.same-assets.com/1648771861/1633037354.jpeg',
    },
    {
      'name': 'Thrifty',
      'logo': 'https://ext.same-assets.com/1648771861/1183845373.jpeg',
    },
    {
      'name': 'Alamo',
      'logo': 'https://ext.same-assets.com/1648771861/2313134952.jpeg',
    },
    {
      'name': 'Enterprise',
      'logo': 'https://ext.same-assets.com/1648771861/982074713.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 1024;
    final bool isTablet = MediaQuery.of(context).size.width > 600;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const NetworkImage(
            'https://ext.same-assets.com/1648771861/1937561815.jpeg',
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.darken,
          ),
        ),
      ),
      child: Container(
        color: Colors.black.withOpacity(0.2),
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 80 : (isTablet ? 40 : 16),
          vertical: 60,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cheap Car Rentals',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isDesktop)
                    _buildDesktopForm()
                  else if (isTablet)
                    _buildTabletForm()
                  else
                    _buildMobileForm(),
                  const SizedBox(height: 16),
                  _buildAdditionalOptions(),
                  const SizedBox(height: 24),
                  _buildBrandSelection(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFaa5936),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        'Search',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopForm() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildLocationField(
            'Pick-up',
            _pickupController,
            Icons.location_on,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: _buildLocationField(
            'Drop-off',
            _dropoffController,
            Icons.location_on,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(child: _buildDateField('Pick-up date', _pickupDate, true)),
        const SizedBox(width: 16),
        Expanded(child: _buildTimeField('Pick-up time', _pickupTime, true)),
        const SizedBox(width: 16),
        Expanded(child: _buildDateField('Drop-off date', _dropoffDate, false)),
        const SizedBox(width: 16),
        Expanded(child: _buildTimeField('Drop-off time', _dropoffTime, false)),
      ],
    );
  }

  Widget _buildTabletForm() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildLocationField(
                'Pick-up',
                _pickupController,
                Icons.location_on,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildLocationField(
                'Drop-off',
                _dropoffController,
                Icons.location_on,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildDateField('Pick-up date', _pickupDate, true)),
            const SizedBox(width: 16),
            Expanded(child: _buildTimeField('Pick-up time', _pickupTime, true)),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDateField('Drop-off date', _dropoffDate, false),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTimeField('Drop-off time', _dropoffTime, false),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileForm() {
    return Column(
      children: [
        _buildLocationField('Pick-up', _pickupController, Icons.location_on),
        const SizedBox(height: 16),
        _buildLocationField('Drop-off', _dropoffController, Icons.location_on),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildDateField('Pick-up date', _pickupDate, true)),
            const SizedBox(width: 16),
            Expanded(child: _buildTimeField('Pick-up time', _pickupTime, true)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDateField('Drop-off date', _dropoffDate, false),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTimeField('Drop-off time', _dropoffTime, false),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2c4c62),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF96a8ad)),
            hintText: 'Enter location',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFC8D1D5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFC8D1D5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFF2c4c62)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(String label, DateTime date, bool isPickup) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2c4c62),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (picked != null) {
              setState(() {
                if (isPickup) {
                  _pickupDate = picked;
                } else {
                  _dropoffDate = picked;
                }
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFC8D1D5)),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.calendar_month, color: Color(0xFF96a8ad)),
                const SizedBox(width: 8),
                Text(DateFormat('MMM dd, yyyy').format(date)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField(String label, TimeOfDay time, bool isPickup) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2c4c62),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: time,
            );
            if (picked != null) {
              setState(() {
                if (isPickup) {
                  _pickupTime = picked;
                } else {
                  _dropoffTime = picked;
                }
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFC8D1D5)),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.access_time, color: Color(0xFF96a8ad)),
                const SizedBox(width: 8),
                Text(time.format(context)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalOptions() {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              value: _sameAsPickup,
              onChanged: (value) {
                setState(() {
                  _sameAsPickup = value ?? false;
                });
              },
            ),
            const Text('Same as pick-up'),
          ],
        ),
        Row(
          children: [
            Checkbox(
              value: _aarpMember,
              onChanged: (value) {
                setState(() {
                  _aarpMember = value ?? false;
                });
              },
            ),
            const Text('Include AARP member rates'),
          ],
        ),
        Row(
          children: [
            Checkbox(
              value: _hasDiscountCode,
              onChanged: (value) {
                setState(() {
                  _hasDiscountCode = value ?? false;
                });
              },
            ),
            const Text('I have a discount code'),
          ],
        ),
      ],
    );
  }

  Widget _buildBrandSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Preferred brand',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2c4c62),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: _brands.map((brand) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedBrand = _selectedBrand == brand['name']
                      ? ''
                      : brand['name']!;
                });
              },
              child: Container(
                width: 120,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _selectedBrand == brand['name']
                        ? const Color(0xFF2c4c62)
                        : const Color(0xFFC8D1D5),
                    width: _selectedBrand == brand['name'] ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    brand['logo']!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        padding: const EdgeInsets.all(8),
                        child: Center(
                          child: Text(
                            brand['name']!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
