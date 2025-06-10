import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/core/validators.dart';
import 'package:travel_muse_app/viewmodels/edit_nickname_view_model.dart';
import 'package:travel_muse_app/views/widgets/check_duplicate_button.dart';

class EditNickname extends ConsumerWidget {
  const EditNickname({
    super.key,
    required this.formKey,
    required this.controller,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(editNicknameViewModelProvider);
    final showAsError = state.isValid == false || state.isDuplicate == true;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '닉네임',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              height: 56,
              child: Row(
                children: [
                  Expanded(
                    child: Form(
                      key: formKey,
                      child: TextFormField(
                        controller: controller,
                        validator: Validators.validateNickname,
                        onChanged: (value) {
                          ref
                              .read(editNicknameViewModelProvider.notifier)
                              .checkInputChanged(value);
                        },
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 16,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          isDense: true,
                          hintText: '닉네임', // TODO: 유저 기존 닉네임 연결, 없을 시 표시 X
                          errorText: null,
                          helperText: null,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  DuplicateCheckButton(state: state),
                ],
              ),
            ),
          ),
          SizedBox(
            child: Text(
              state.message ?? '',
              style: TextStyle(color: showAsError ? Colors.red : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
