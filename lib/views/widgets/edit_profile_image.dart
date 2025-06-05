import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/viewmodels/profile_view_model.dart';

class EditProfileImage extends ConsumerStatefulWidget {
  const EditProfileImage({super.key, required this.size});
  final double size;

  @override
  ConsumerState<EditProfileImage> createState() => _EditProfileImageState();
}

class _EditProfileImageState extends ConsumerState<EditProfileImage> {
  bool _fetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_fetched) {
      ref.read(profileViewModelProvider.notifier).fetchProfileImageUrl();
      _fetched = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileViewModel = ref.read(profileViewModelProvider.notifier);
    final imageUrl = ref.watch(profileViewModelProvider).profileImageUrl;

    return GestureDetector(
      onTap: () async {
        await profileViewModel.updateProfileImage();
      },
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 1 / 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(500),
                child: Image.network(
                  imageUrl ?? 'https://picsum.photos/id/1/300/400',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
