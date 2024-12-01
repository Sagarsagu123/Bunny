import 'package:flutter/material.dart';
import 'package:flutter_demo/core/utils/image_constant.dart';
import 'package:flutter_demo/core/utils/size_utils.dart';
import 'package:flutter_demo/widgets/app_bar/appbar_image.dart';

class CustomAppBar1 extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final Widget? leading;
  final bool logoAsset;
  final String? backButtonAsset;

  const CustomAppBar1({
    this.showBackButton = true,
    this.leading,
    this.logoAsset = true,
    this.backButtonAsset,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          : leading,
      title: logoAsset
          ? AppbarImage(
              height: getVerticalSize(
                65,
              ),
              width: getHorizontalSize(
                160,
              ),
              imagePath: ImageConstant.imgBunnylogorgbfc)
          : null,
    );

    // You can customize the app bar further if needed
    // For example, you can add actions, additional icons, etc.
  }

  @override
  Size get preferredSize => const Size.fromHeight(100.0); // Set the desired height
}
