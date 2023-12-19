import 'package:finkin_credential/res/app_color/app_color.dart';
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
            Radio(
              value: true,
              activeColor: AppColor.primary,
              groupValue: _isUserSelected,
              onChanged: (value) {
                setState(() {
                  _isUserSelected = value as bool;
                });
                widget.onUserTypeChanged(_isUserSelected);
              },
            ),
            const Text(
              'User',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
        Row(
          children: [
            Radio(
              value: false,
              activeColor: AppColor.primary,
              groupValue: _isUserSelected,
              onChanged: (value) {
                setState(() {
                  _isUserSelected = value as bool;
                });
                widget.onUserTypeChanged(_isUserSelected);
              },
            ),
            Text(
              'Agent',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ],
    );
  }
}
