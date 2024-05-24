import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../common/utils/app_colors.dart';
//import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SpinKitThreeInOut(
      duration: const Duration(milliseconds: 400),
      delay: const Duration(milliseconds: 0),
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index.isEven ? AppColor.primaryGreen : AppColor.fillAsh,
          ),
        );
      },
    );
  }
}
