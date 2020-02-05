import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:quiet/model/playlist_detail.dart';
import 'package:quiet/repository/netease.dart';
import 'package:quiet/part/part.dart';

///page for playlist edit
class PlaylistEditPage extends StatefulWidget {
  final PlaylistDetail playlist;

  const PlaylistEditPage(this.playlist, {Key key}) : super(key: key);

  @override
  _PlaylistEditPageState createState() => _PlaylistEditPageState();
}

class _PlaylistEditPageState extends State<PlaylistEditPage> {
  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context)
        .textTheme
        .body1
        .copyWith(fontSize: 15, shadows: [Shadow(offset: Offset(0.3, 0.3), color: Colors.black87)]);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text("Edit playlist information"),
      ),
      body: Builder(builder: (context) {
        return Column(
          children: <Widget>[
            SizedBox(height: 8),
            InkWell(
              onTap: () {
                showSimpleNotification(Text("Not implemented"), background: Theme.of(context).errorColor);
              },
              child: Container(
                height: 72,
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: <Widget>[
                    Expanded(child: Text("Change cover", style: style)),
                    Image(image: CachedImage(widget.playlist.coverUrl), height: 56, width: 56)
                  ],
                ),
              ),
            ),
            Divider(height: 0, indent: 8),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return _PlaylistNameEditPage(widget.playlist);
                }));
              },
              child: Container(
                height: 56,
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: <Widget>[Expanded(child: Text("name", style: style)), Text(widget.playlist.name)],
                ),
              ),
            ),
            Divider(height: 0, indent: 8),
            InkWell(
              onTap: () {
                showSimpleNotification(Text("Not implemented"), background: Theme.of(context).errorColor);
              },
              child: Container(
                height: 56,
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: <Widget>[
                    Expanded(child: Text("label", style: style)),
                    Text("Function is not implemented", style: Theme.of(context).textTheme.caption)
                  ],
                ),
              ),
            ),
            Divider(height: 0, indent: 8),
            InkWell(
              onTap: () {
                showSimpleNotification(Text("Not implemented"), background: Theme.of(context).errorColor);
              },
              child: Container(
                height: 56,
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: <Widget>[Expanded(child: Text("description", style: style)), Text(widget.playlist.name)],
                ),
              ),
            ),
            Divider(height: 0, indent: 8),
          ],
        );
      }),
    );
  }
}

class _PlaylistNameEditPage extends StatefulWidget {
  final PlaylistDetail playlist;

  _PlaylistNameEditPage(this.playlist, {Key key}) : super(key: key);

  @override
  _PlaylistNameEditPageState createState() {
    return new _PlaylistNameEditPageState();
  }
}

class _PlaylistNameEditPageState extends State<_PlaylistNameEditPage> {
  String error;

  TextEditingController _controller;

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.playlist.name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text("Playlist name"),
        actions: <Widget>[
          FlatButton(
              onPressed: () async {
                _focusNode.unfocus();
                final name = widget.playlist.name;
                widget.playlist.name = _controller.text;
                try {
                  bool succeed = await showLoaderOverlay(context, neteaseRepository.updatePlaylist(widget.playlist));
                  if (succeed) {
                    Navigator.pop(context, true);
                  } else {
                    setState(() {
                      widget.playlist.name = name;
                      error = "fail to edit";
                    });
                  }
                } catch (msg) {
                  setState(() {
                    widget.playlist.name = name;
                    error = msg;
                  });
                }
              },
              child: Text("Save"),
              textColor: Theme.of(context).primaryTextTheme.body1.color)
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _controller,
              maxLength: 40,
              autofocus: true,
              focusNode: _focusNode,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                  hintText: "Edit playlist name",
                  errorText: error,
                  suffixIcon: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        _controller.text = "";
                      })),
              validator: (v) {
                if (v.isEmpty) {
                  return "Song name cannot be empty";
                }
                return null;
              },
            )
          ],
        ),
      ),
    );
  }
}
