import 'package:flutter/material.dart';
import 'package:quiet/pages/collection/albums.dart';
import 'package:quiet/pages/collection/articles.dart';
import 'package:quiet/pages/collection/artists.dart';
import 'package:quiet/pages/collection/videos.dart';
import 'package:quiet/part/part.dart';

///我的收藏页面
class MyCollectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('My collection'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Album'),
              Tab(text: 'Singer'),
              Tab(text: 'Video'),
              Tab(text: 'Column'),
            ],
            indicator:
                UnderlineTabIndicator(insets: EdgeInsets.only(bottom: 4)),
            indicatorSize: TabBarIndicatorSize.label,
          ),
        ),
        body: BoxWithBottomPlayerController(
          TabBarView(children: [
            CollectionAlbums(),
            CollectionArtists(),
            CollectionVideos(),
            CollectionArticles(),
          ]),
        ),
      ),
    );
  }
}
