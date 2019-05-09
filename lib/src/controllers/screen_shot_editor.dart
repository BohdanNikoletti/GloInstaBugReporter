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

enum _CurrentState { saving, done }

class _ScreenShotEditorState extends State<ScreenShotEditor> {
  static final GlobalKey _globalKey = GlobalKey();
  double _controlsOpacity = 1;
  final Duration _controlsAppearDuration = Duration(milliseconds: 750);
  List<Offset> _points = <Offset>[];
  _CurrentState _currentState = _CurrentState.done;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenView(),
      floatingActionButton: AnimatedOpacity(
        duration: _controlsAppearDuration,
        opacity: _controlsOpacity,
        child: FloatingActionButton(
          onPressed: () {
            if (_currentState != _CurrentState.done) {
              return;
            }
            _savePressed();
          },
          tooltip: 'Save changes',
          child: () {
            switch (_currentState) {
              case _CurrentState.done:
                return const Icon(Icons.save);
              case _CurrentState.saving:
                return const CircularProgressIndicator(
                  backgroundColor: Colors.white,
                );
            }
          }(),
        ),
      ),
    );
  }

  Widget screenView() {
    return Stack(
      fit: StackFit.passthrough,
      alignment: AlignmentDirectional.topStart,
      children: <Widget>[
        Hero(
            tag: 'editing_image',
            child: Container(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _controlsOpacity = _controlsOpacity == 0 ? 1 : 0;
                  });
                },
                onPanUpdate: (DragUpdateDetails details) {
                  setState(() {
                    final RenderBox object = context.findRenderObject();
                    final Offset _localPosition =
                        object.globalToLocal(details.globalPosition);
                    _points = List<Offset>.from(_points)..add(_localPosition);
                  });
                },
                onPanEnd: (DragEndDetails details) => _points.add(null),
                child: RepaintBoundary(
                    key: _globalKey,
                    child: CustomPaint(
                      isComplex: true,
                      size: Size(widget.image.width.toDouble(),
                          widget.image.height.toDouble()),
                      painter: RectanglePainter(widget.image, _points),
                    )),
              ),
            )),
        Positioned(
            left: 20.0,
            top: 20.0,
            child: AnimatedOpacity(
              duration: _controlsAppearDuration,
              opacity: _controlsOpacity,
              child: Material(
                elevation: 10.0,
                color: Colors.transparent,
                shape: CircleBorder(),
                child: IconButton(
                    iconSize: 16,
                    icon: const Icon(Icons.close),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
            )),
      ],
    );
  }

  Future<ui.Image> _capturePng() async {
    final RenderRepaintBoundary boundary =
        _globalKey.currentContext.findRenderObject();
    final ui.Image image = await boundary.toImage();
    return image;
  }

  Future<void> _savePressed() async {
    setState(() {
      _currentState = _CurrentState.saving;
    });
    final ui.Image editedImage = await _capturePng();
    setState(() {
      _currentState = _CurrentState.done;
    });
    Navigator.pop(context, editedImage);
  }
}
