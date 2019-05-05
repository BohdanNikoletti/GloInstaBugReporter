import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:glo_insta_bug_reporter/src/controllers/board_picker.dart';

abstract class GloReportableWidgetState<T extends StatefulWidget>
    extends State<T> {
  static GlobalKey previewContainer = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: RepaintBoundary(
        key: previewContainer,
        child: buildRootWidget(context),
      ),
      onTap: () {
        _getScreenShotImage(context);
      },
    );
  }

  Widget buildRootWidget(BuildContext context);

  Future<void> _getScreenShotImage(BuildContext context) async {
    final ui.Image image = await _capturePng();
    Navigator.push(
      context,
      MaterialPageRoute<BoardPicker>(
          builder: (BuildContext context) => BoardPicker(
                title: 'Board Picker',
                image: image,
              )),
    );
  }

  Future<ui.Image> _capturePng() async {
    final RenderRepaintBoundary boundary =
        previewContainer.currentContext.findRenderObject();
    final ui.Image image = await boundary.toImage();
    return image;
  }
}
