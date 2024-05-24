import 'package:chat_app/common/utils/app_colors.dart';
import 'package:chat_app/components/widgets/loader/custom_loader.dart';
import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    required this.isLoading,
    this.color = AppColor.loadingBackground,
    this.progressIndicator = const CustomLoader(),
    this.opacity = 0.5,
  });

  final bool isLoading;
  final Color color;
  final Widget progressIndicator;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isLoading,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(opacity),
        ),
        child: progressIndicator,
      ),
    );
  }
}
