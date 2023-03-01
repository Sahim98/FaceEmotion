// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;




class Pagination extends StatefulWidget {
  const Pagination({Key? key}) : super(key: key);

  @override
  State<Pagination> createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  final _baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  int _page = 0;

  final int _limit = 5;

  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;

  bool _isLoadMoreRunning = false;

  List _posts = [];

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300
    ) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });

      _page += 1; // Increase _page by 1

      try {
        final res =
        await http.get(Uri.parse("$_baseUrl?_page=$_page&_limit=$_limit"));

        final List fetchedPosts = json.decode(res.body);
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            _posts.addAll(fetchedPosts);
          });
        } else {

          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }


      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      final res =
      await http.get(Uri.parse("$_baseUrl?_page=$_page&_limit=$_limit"));
      setState(() {
        _posts = json.decode(res.body);
      });
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
      }
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  late ScrollController _controller;
  @override
  void initState() {
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
        body:_isFirstLoadRunning?const Center(
          child: CircularProgressIndicator( ),
        ):Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _posts.length,
                controller: _controller,
                itemBuilder: (_, index) => Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 10),
                  child: ListTile(
                    title: Text(_posts[index]['title']),
                    subtitle: Text(_posts[index]['body']),
                  ),
                ),
              ),
            ),
            if (_isLoadMoreRunning == true)
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 40),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),

            if (_hasNextPage == false)
              Container(
                padding: const EdgeInsets.only(top: 30, bottom: 40),
                color: Colors.amber,
                child: const Center(
                  child: Text('You have fetched all of the content'),
                ),
              ),
          ],
        )
    );
  }
}