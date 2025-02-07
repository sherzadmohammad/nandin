import 'package:flutter/material.dart';

class GenderSelectionWidget extends StatefulWidget {
  final String selectedGender;
  final ValueChanged<String> onGenderChanged;

  const GenderSelectionWidget({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  State<GenderSelectionWidget> createState() => _GenderSelectionWidgetState();
}

class _GenderSelectionWidgetState extends State<GenderSelectionWidget> {
  late String _selectedGender;

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.selectedGender;
  }

  void _onSelectGender(String gender) {
    setState(() {
      _selectedGender = gender;
    });
    widget.onGenderChanged(gender); // Notify parent widget
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _onSelectGender('Female'),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.1,
                  color: _selectedGender == 'Female'
                      ? const Color(0xFF262526)
                      : const Color(0xFFCBD5E1),
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.female),
                  SizedBox(width: 8.0),
                  Text('Female', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16), // Space between options
        Expanded(
          child: GestureDetector(
            onTap: () => _onSelectGender('Male'),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.1,
                  color: _selectedGender == 'Male'
                      ? const Color(0xFF262526)
                      : const Color(0xFFCBD5E1),
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.male),
                  SizedBox(width: 8.0),
                  Text('Male', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
