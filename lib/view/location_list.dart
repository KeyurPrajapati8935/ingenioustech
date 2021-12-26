import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ingenioustechlab/base/consatnt/constant.dart';
import 'package:ingenioustechlab/bloc/post_bloc.dart';
import 'package:ingenioustechlab/view/details_page.dart';
import 'package:ingenioustechlab/widgets/bottom_loader.dart';
import 'package:ingenioustechlab/widgets/post_list_item.dart';

class LocationListPage extends StatefulWidget {

  const LocationListPage({Key? key}) : super(key: key);

  @override
  _LocationListPageState createState() => _LocationListPageState();
}

class _LocationListPageState extends State<LocationListPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        switch (state.status) {
          case PostStatus.failure:
            return const Center(child: Text(Constant.kFailedToFetchData));
          case PostStatus.success:
            if (state.posts.isEmpty) {
              return const Center(child: Text(Constant.kNoDataFound));
            }
            return ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return index >= state.posts.length
                    ? BottomLoader()
                    : GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsPage(model : state.posts[index]),
                      ),
                    );
                  },
                    child: PostListItem(model: state.posts[index]));
              },
              itemCount: state.hasReachedMax
                  ? state.posts.length
                  : state.posts.length + 1,
              controller: _scrollController,
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  height: 2,
                  color: Colors.black,
                );
              },
            );
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<PostBloc>().add(PostFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
