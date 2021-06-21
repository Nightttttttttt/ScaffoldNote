import 'package:flutter/cupertino.dart';

class CircularTabIndicator extends Decoration {
  final BoxPainter _painter;
  final Color color;
  final double radius;

  CircularTabIndicator(this.color, this.radius)
      : _painter = CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([onChanged]) {
    return _painter;
  }
}

class CirclePainter extends BoxPainter {
  final Color color;
  final double radius;
  final Paint _paint;

  CirclePainter(this.color, this.radius)
      : _paint = Paint()
          ..color = color;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset = offset + Offset(cfg.size.width / 2, cfg.size.height - radius - 20);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}
