import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:quiet/material/flexible_app_bar.dart';
import 'package:quiet/material/tabs.dart';
import 'package:quiet/repository/netease.dart';

import 'artist.model.dart';

class ArtistHeader extends StatelessWidget {
  final Artist artist;

  const ArtistHeader({Key key, @required this.artist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 330,
      flexibleSpace: _ArtistFlexHeader(artist: artist),
      elevation: 0,
      forceElevated: false,
      bottom: RoundedTabBar(
        tabs: <Widget>[
          Tab(text: "Popular singles"),
          Tab(text: "Album${artist.albumSize}"),
          Tab(text: "Video${artist.mvSize}"),
          Tab(text: "Artist information"),
        ],
      ),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.share, color: Theme.of(context).primaryIconTheme.color), onPressed: null)
      ],
    );
  }
}

class _ArtistFlexHeader extends StatelessWidget {
  final Artist artist;

  const _ArtistFlexHeader({Key key, @required this.artist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).primaryTextTheme.body1,
      maxLines: 1,
      child: FlexibleDetailBar(
        background:
            FlexShadowBackground(child: Image(image: CachedImage(artist.picUrl), height: 300, fit: BoxFit.cover)),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            Spacer(),
            Text('${artist.name}' + (artist.alias.isEmpty ? '' : '(${artist.alias[0]})'),
                style: TextStyle(fontSize: 20)),
            Text('Number of songs:${artist.musicSize}'),
          ]),
        ),
        builder: (context, t) {
          return AppBar(
            title: Text(t > 0.5 ? artist.name : ''),
            backgroundColor: Colors.transparent,
            elevation: 0,
            titleSpacing: 0,
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.share),
                  tooltip: "Share it",
                  onPressed: () {
                    toast('Share it');
                  })
            ],
          );
        },
      ),
    );
  }
}
