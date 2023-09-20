import 'dart:ui';

class GradientPair{
  final Color first;
  final Color second;

  GradientPair(this.first, this.second);
}

class GradientColors{
  static List<GradientPair> gradients = [
    new GradientPair(Color(0xFF4CB8C4),Color(0xFF3CD3AD)),
    new GradientPair(Color(0xFFFDC830),Color(0xFFF37335)),
    new GradientPair(Color(0xFFad5389),Color(0xFF3c1053)),
    new GradientPair(Color(0xFFe9d362),Color(0xFF333333)),
    new GradientPair(Color(0xFFfc00ff),Color(0xFF00dbde)),
    new GradientPair(Color(0xFF396afc),Color(0xFF2948ff)),
  ];

}