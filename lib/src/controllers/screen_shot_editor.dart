import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:glo_insta_bug_reporter/src/rectangle_painter.dart';

class ScreenShotEditor extends StatefulWidget {
  const ScreenShotEditor({Key key, this.image}) : super(key: key);
  final ui.Image image;
  @override
  _ScreenShotEditorState createState() => _ScreenShotEditorState();
}

class _ScreenShotEditorState extends State<ScreenShotEditor> {
  static final GlobalKey _globalKey = GlobalKey();
  List<Offset> _points = <Offset>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Editing',
          style: TextStyle(
            color: Colors.black38,
          ),
        ),
        leading: IconButton(
            icon: const Icon(Icons.close),
            color: Colors.black38,
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: screenView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _savePressed();
        },
        tooltip: 'Save changes',
        child: const Icon(Icons.save),
      ),
    );
  }

  Widget screenView() {
    return Container(
      child:GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          setState(() {
            final RenderBox object = context.findRenderObject();
            final Offset _localPosition =
                object.globalToLocal(details.globalPosition);
            _points = List<Offset>.from(_points)..add(_localPosition);
          });
        },
        onPanEnd: (DragEndDetails details) => _points.add(null),
        child: Hero(
          tag: 'editing_image',
          child: RepaintBoundary(
              key: _globalKey,
              child: CustomPaint(
                isComplex: true,
                size: Size(widget.image.width.toDouble(),
                    widget.image.height.toDouble()),
                painter: RectanglePainter(widget.image, _points),
              )),
        ),
      ),
    );
  }

  Future<ui.Image> _capturePng() async {
    final RenderRepaintBoundary boundary =
        _globalKey.currentContext.findRenderObject();
    final ui.Image image = await boundary.toImage();
    return image;
  }

  Future<void> _savePressed() async {
    final ui.Image editedImage = await _capturePng();
    Navigator.pop(context, editedImage);
  }
}
