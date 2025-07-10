import 'package:flutter/material.dart';
import 'package:travel_muse_app/models/home/home_place.dart';
import 'package:travel_muse_app/views/home/recommended_place/recommended_place_detail_sheet.dart';

class PlaceDetailBottomSheet {
  static void show(
    BuildContext context,
    HomePlace place, {
    bool showSelectButton = true,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, scrollController) {
            return RecommendedPlaceDetailSheet(
              place: place,
              scrollController: scrollController,
              showSelectButton: showSelectButton, 
            );
          },
        );
      },
    );
  }
}

