import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:glo_insta_bug_reporter/src/models/card_description.dart';
import 'package:glo_insta_bug_reporter/src/models/glo_card.dart';
import 'package:glo_insta_bug_reporter/src/models/attachment.dart';
import 'package:glo_insta_bug_reporter/src/services/network_service.dart';
import 'package:glo_insta_bug_reporter/src/controllers/screen_shot_editor.dart';

class TicketCreator extends StatefulWidget {
  const TicketCreator({Key key, this.title, this.image, this.boardId, this.columnId})
      : super(key: key);
  final String title;
  final ui.Image image;
  final String boardId;
  final String columnId;

  @override
  _TicketCreatorState createState() => _TicketCreatorState(image);
}

class _TicketCreatorState extends State<TicketCreator> {
  _TicketCreatorState(this._image) : super();
  Uint8List _imgBytes = Uint8List.fromList(<int>[]);
  ui.Image _image;
  static const String _defaultDescriptionText = 'I\'ve found a bug here';
  static const String _defaultTaskTitleText ='UI bug';

  String _descriptionText = _defaultDescriptionText;
  String _taskTitleText = _defaultTaskTitleText;

  static const int uiItemsCount = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: uiItemsCount,
          itemBuilder: (BuildContext context, int index) => _buildListItem(index)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createAndSendTask();
        },
        tooltip: 'Send report',
        child: const Icon(Icons.send),
      ),
    );
  }

  Future<void> createAndSendTask() async {
    final GloCard newCard = GloCard(
        boardId: widget.boardId, columnId: widget.columnId, name: _taskTitleText);
    final GloCard createdCard = await create(newCard, widget.boardId);
    final Attachment attachment = await upload(
        boardId: widget.boardId, cardId: createdCard.id, image: _image);
    createdCard.description =
        CardDescription(text: '[$_descriptionText](${attachment.url}).');
    await updateCard(createdCard, widget.boardId);
    Navigator.removeRouteBelow(context, ModalRoute.of(context));
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Widget _buildListItem(int index) {
    assert(index < uiItemsCount);
    switch (index) {
      case 0:
        return ListTile(
          leading: Icon(Icons.speaker_notes, color: Colors.grey[500]),
          title: TextField(
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Task description',
            ),
            onChanged:  (String value) {
              if(value.isEmpty) {
                _descriptionText = _defaultDescriptionText;
              }
              _descriptionText = value;
            },
          ),
        );
      case 1:
        return _buildScreenPreviewItem();
    }
    assert(false);
    return null;
  }

  Widget _buildScreenPreviewItem() {
    return ListTile(
      onTap: () {
        _navigateAndEditScreenShot(context);
      },
      leading: _imgBytes.isEmpty
          ? const Icon(Icons.image)
          : Hero(
              tag: 'editing_image',
              child: Image.memory(
                _imgBytes,
                height: 32,
                width: 32,
              ),
            ),
      title: TextField(
        maxLines: 1,
        decoration: InputDecoration(
          hintText: 'Task title',
        ),
        onChanged: (String value) {
          if(value.isEmpty) {
            _taskTitleText = _defaultTaskTitleText;
          }
          _taskTitleText = value;
        },
      ),
    );
  }

  Future<void> _navigateAndEditScreenShot(BuildContext context) async {
    final ui.Image result = await Navigator.push(
        context,
        PageRouteBuilder<ui.Image>(
            pageBuilder: (BuildContext context, Animation<double> anim1,
                Animation<double> anim2) => ScreenShotEditor(
                  image: _image,
                ),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            }));
    if (result == null) {
      return;
    }
    _image = result;
    _loadImage();
  }

  Future<void> _loadImage() async {
    final ByteData byteData = await _image.toByteData(format: ui.ImageByteFormat.png);
    setState(() {
      _imgBytes = byteData.buffer.asUint8List();
    });
  }
}
