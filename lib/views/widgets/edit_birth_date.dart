import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/viewmodels/edit_birth_date_view_model.dart';

class EditBirthDate extends ConsumerWidget {
  const EditBirthDate({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(editBirthDateViewModelProvider);

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
            child: SizedBox(
              height: 56,
              child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],

                onChanged: (value) {
                  ref
                      .read(editBirthDateViewModelProvider.notifier)
                      .checkInputChanged(value);
                },
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  isDense: true,
                  errorText: null,
                  helperText: null,
                ),
              ),
            ),
          ),
          state.message != null
              ? SizedBox(
                child: Text(
                  state.message ?? '',
                  style: TextStyle(color: Colors.red),
                ),
              )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
