import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:glo_insta_bug_reporter/src/controllers/ticket_creator.dart';
import 'package:glo_insta_bug_reporter/src/models/glo_board.dart';
import 'package:glo_insta_bug_reporter/src/models/glo_column.dart';
import 'package:glo_insta_bug_reporter/src/services/authorization_service.dart';
import 'package:glo_insta_bug_reporter/src/services/network_service.dart';
import 'package:glo_insta_bug_reporter/src/services/token_storage_service.dart';

class BoardPicker extends StatefulWidget {
  const BoardPicker({Key key, this.title, this.image}) : super(key: key);

  final String title;
  final ui.Image image;
  @override
  _BoardPickerState createState() => _BoardPickerState();
}

enum LoadingState { willFetch, fetching, error, fetchFinished, allFetched }

class _BoardPickerState extends State<BoardPicker> {
  final AuthorizationService _authorizationService = AuthorizationService();
  final List<GloBoard> _boards = <GloBoard>[];
  final ScrollController _scrollController = ScrollController();
  final int _pageSize = 50;
  final int _refreshPaddingHeight = 100;

  LoadingState _currentState = LoadingState.willFetch;
  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_currentState) {
      case LoadingState.fetchFinished:
      case LoadingState.allFetched:
        return ListView.builder(
            controller: _scrollController,
            itemBuilder: (BuildContext context, int index) =>
                _buildBoardView(_boards[index]),
            itemCount: _boards.length);
      case LoadingState.error:
        return const Text('Unexpected Error');
      case LoadingState.willFetch:
      case LoadingState.fetching:
        return const Center(
          child: CircularProgressIndicator(),
        );
    }
    assert(false);
    return null;
  }

  @override
  void initState() {
    super.initState();
    _authorizationService.onSignedIn = _getMoreData;
    _login(context);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - _refreshPaddingHeight) {
        if (_currentState != LoadingState.allFetched) {
          setState(() {
            _currentState = LoadingState.willFetch;
          });
          _getMoreData();
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Widget _buildBoardView(GloBoard board) {
    return Card(
      elevation: 4,
      semanticContainer: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              '${board.name}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          const Divider(
            height: 1,
            color: Colors.black45,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: _buildColumnsGridFor(board),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnsGridFor(GloBoard board) {
    return GridView.count(
      padding: const EdgeInsets.all(8),
      crossAxisCount: 2,
      childAspectRatio: 4,
      shrinkWrap: true,
      children: () {
        return board.columns.map((GloColumn column) {
          return InkResponse(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${column.name}',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: Theme.of(context).textTheme.headline,
                  ),
                ),
              ),
            ),
            onTap: () {
              ConfigStorageService()
                  .setConfig(Config(boardId: board.id, columnId: column.id));
              Navigator.push(
                context,
                MaterialPageRoute<TicketCreator>(
                    builder: (BuildContext context) => TicketCreator(
                          title: 'Ticket for ${column.name} on ${board.name}',
                          image: widget.image,
                          boardId: board.id,
                          columnId: column.id,
                        )),
              );
            },
          );
        }).toList(growable: false);
      }(),
    );
  }

  Future<void> _getMoreData() async {
    if (_currentState != LoadingState.willFetch) {
      return;
    }
    setState(() => _currentState = LoadingState.fetching);
    final int sentPage = _currentPage;
    final List<GloBoard> newEntries = (await _loadItems())
        .where((GloBoard board) =>
            !_boards.contains(board) && board.columns.isNotEmpty)
        .toList(growable: false);
    if (newEntries.isEmpty) {
      setState(() => _currentState = LoadingState.allFetched);
      return;
    }
    if (_currentPage != sentPage) {
      setState(() => _currentState = LoadingState.willFetch);
      return;
    }
    setState(() {
      _boards.addAll(newEntries);
      _currentState = LoadingState.fetchFinished;
      _currentPage += 1;
    });
  }

  Future<List<GloBoard>> _loadItems() {
    return getBoards(page: _currentPage, perPage: _pageSize);
  }

  Future<void> _login(BuildContext context) async {
    _authorizationService.login(context);
  }
}
