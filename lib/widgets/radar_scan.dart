import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class RadarPage extends StatelessWidget {
  final double latitude;
  final double longitude;
  RadarPage({this.latitude = 1000, this.longitude=11.96679});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned.fill(
              left: 0,
              right: 0,
              child: Center(
                child: Stack(children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width/5*4)),
                      child: Align(
                        alignment: Alignment.center,
                        child: latitude == 1000 ? Container() : GoogleMap(
                            scrollGesturesEnabled: false,
                            myLocationButtonEnabled: false,
                            initialCameraPosition: CameraPosition(
                                target: LatLng(latitude, longitude), zoom: 15),
                          ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: RadarView(),
                  ),
                  Positioned(
                    child: Center(
                      child: Container(
                        height: 100.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            image: DecorationImage(
                                image: AssetImage('assets/images/hittapa_logo.png')),
                            shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            )
          ],
        ));
  }
}

class RadarView extends StatefulWidget {
  @override
  _RadarViewState createState() => _RadarViewState();
}

class _RadarViewState extends State<RadarView>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    _animation = Tween(begin: .0, end: pi * 2).animate(_controller);
    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: RadarPainter(_animation.value),
        );
      },
    );
  }
}

class RadarPainter extends CustomPainter {
  final double angle;

  Paint _bgPaint = Paint()
    ..color = Color(0xFF657795)
    ..strokeWidth = 1.5
    ..style = PaintingStyle.stroke;

  Paint _paint = Paint()..style = PaintingStyle.fill;

  int circleCount = 0;

  RadarPainter(this.angle);

  @override
  void paint(Canvas canvas, Size size) {
    var radius = min(size.width / 2, size.height / 2);

    // canvas.drawLine(Offset(size.width / 2, size.height / 2 - radius),
    //     Offset(size.width / 2, size.height / 2 + radius), _bgPaint);
    // canvas.drawLine(Offset(size.width / 2 - radius, size.height / 2),
    //     Offset(size.width / 2 + radius, size.height / 2), _bgPaint);

    for (var i = 1; i <= circleCount; ++i) {
      canvas.drawCircle(Offset(size.width / 2, size.height / 2),
          radius, _bgPaint);
    }

    _paint.shader = ui.Gradient.sweep(
        Offset(size.width / 2, size.height /2 ),
        [Colors.grey.withOpacity(.1), Colors.grey.withOpacity(.9)],
        [.0, 1.0],
        TileMode.clamp,
        .0,
        pi );

    canvas.save();
    double r = sqrt(pow(size.width, 2) + pow(size.height, 2));
    double startAngle = atan(size.height / size.width);
    Point p0 = Point(r * cos(startAngle), r * sin(startAngle));
    Point px = Point(r * cos(angle + startAngle), r * sin(angle + startAngle));
    canvas.translate((p0.x - px.x) / 2, (p0.y - px.y) / 2);
    canvas.rotate(angle);

    canvas.drawArc(
        Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius),
        0,
        pi / 5 * 4,
        true,
        _paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


