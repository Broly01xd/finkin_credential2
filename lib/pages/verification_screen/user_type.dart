import 'package:flutter/material.dart';

class UserTypeSelector extends StatefulWidget {
  final bool isUserSelected;
  final ValueChanged<bool> onUserTypeChanged;

  const UserTypeSelector({
    Key? key,
    required this.isUserSelected,
    required this.onUserTypeChanged,
  }) : super(key: key);

  @override
  _UserTypeSelectorState createState() => _UserTypeSelectorState();
}

class _UserTypeSelectorState extends State<UserTypeSelector> {
  late bool _isUserSelected;

  @override
  void initState() {
    super.initState();
    _isUserSelected = widget.isUserSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Checkbox(
              value: _isUserSelected,
              onChanged: (value) {
                setState(() {
                  _isUserSelected = value ?? false;
                });
                widget.onUserTypeChanged(_isUserSelected);
              },
            ),
            Text('User'),
          ],
        ),
        Row(
          children: [
            Checkbox(
              value: !_isUserSelected,
              onChanged: (value) {
                setState(() {
                  _isUserSelected = !(value ?? true);
                });
                widget.onUserTypeChanged(!_isUserSelected);
              },
            ),
            Text('Agent'),
          ],
        ),
      ],
    );
  }
}
