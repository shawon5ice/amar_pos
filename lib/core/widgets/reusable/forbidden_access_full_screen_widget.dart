import 'package:amar_pos/core/constants/app_assets.dart';
import 'package:flutter/material.dart';

class ForbiddenAccessFullScreenWidget extends StatelessWidget {
  const ForbiddenAccessFullScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Image.asset(AppAssets.accessDeniedBG), heightFactor: 200,);
  }
}
