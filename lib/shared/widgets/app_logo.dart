import 'package:flutter/material.dart';

enum AppLogoSize { small, medium, large }

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = AppLogoSize.medium,
    this.width,
    this.height,
  });

  final AppLogoSize size;
  final double? width;
  final double? height;

  double _getDefaultSize() {
    switch (size) {
      case AppLogoSize.small:
        return 48;
      case AppLogoSize.medium:
        return 80;
      case AppLogoSize.large:
        return 160;
    }
  }

  @override
  Widget build(BuildContext context) {
    final logoSize = width ?? height ?? _getDefaultSize();

    return Image.asset(
      'assets/TsuperLogo.png',
      width: width ?? logoSize,
      height: height ?? logoSize,
      fit: BoxFit.contain,
    );
  }
}
