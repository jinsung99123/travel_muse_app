import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travel_muse_app/core/validators.dart';

class EditBirthDate extends StatefulWidget {
  const EditBirthDate({
    super.key,
    required this.formKey,
    required this.controller,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;

  @override
  State<EditBirthDate> createState() => _EditBirthDateState();
}

class _EditBirthDateState extends State<EditBirthDate> {
  final _textFieldKey = GlobalKey<FormFieldState>();
  bool _showHelper = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '생년월일',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Form(
              key: widget.formKey,

              child: TextFormField(
                key: _textFieldKey,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: widget.controller,
                validator: Validators.validateBirthDate,
                onChanged: (_) {
                  final currentState = _textFieldKey.currentState;
                  final isValid = currentState?.validate() ?? false;
                  setState(() {
                    _showHelper = !isValid;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  helper:
                      _showHelper
                          ? const Text(
                            '주민등록상 생년월일 8자리를 입력해주세요',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF7C878C),
                            ),
                          )
                          : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
