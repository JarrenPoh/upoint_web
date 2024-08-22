class IceBlock {
  double x;
  double y;
  double width;
  double height;

  IceBlock({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });
}

class IceShard {
  double x;
  double y;
  double vx;
  double vy;
  double size;
  double opacity;

  IceShard({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.opacity,
  });
}
