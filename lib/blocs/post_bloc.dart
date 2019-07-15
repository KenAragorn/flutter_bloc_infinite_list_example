import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import './bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_infinite_list_bloc/models/sample_model.dart';

/*
To recap, each bloc* will always expecting event and here, we only have fetch*
data event. Once we receive the Fetch event which is valid, then we will check
and convert it - such as:
i. Is the event is the valid event and whether it has reach max listing -> do what?
ii. Is the event is the valid event and whether the current state is firs time -> do what?
iii. Is the event is the valid event and whether has reach max -> do what?

This Bloc will accept PostEvent only as input and output only the PostState
 */
class PostBloc extends Bloc<PostEvent, PostState> {
  final http.Client httpClient;

  @override
  PostState get initialState => PostUninitialized();

  PostBloc({@required this.httpClient});
  @override
  Stream<PostState> transform(
      Stream<PostEvent> events,
      Stream<PostState> Function(PostEvent event) next,
      ) {
    return super.transform(
      (events as Observable<PostEvent>).debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }


  @override
  Stream<PostState> mapEventToState(
    PostEvent event,
  ) async* {
    if (event is Fetch && !_hasReachedMax(currentState)) {
      try {
        if (currentState is PostUninitialized) {
          //Means, this is the first state where no data yet
          final posts = await _fetchSampleDatas(0, 20);
          //Once loaded with data, we need to update the current state
          yield PostLoaded(posts: posts, hasReachedMax: false);
          return;
        }

        /*
      If the current state is loaded with data, then we know this is not the
      first time the UI is triggering for additional data.

      If the subsequent sample data return does not have value, we will update
      the state with newer data by adding the returned data with older data
      together.
       */
        if (currentState is PostLoaded) {
          final posts = await _fetchSampleDatas(
              (currentState as PostLoaded).posts.length, 20);
          yield posts.isEmpty
              ? (currentState as PostLoaded).copyWith(hasReachedMax: true)
              : PostLoaded(
            posts: (currentState as PostLoaded).posts + posts,
            hasReachedMax: false,
          );
        }
      } catch (_){
        //And for any error, we will update the state with Error state
        yield PostError();
      }
    }
  }

  //************************ PRIVATE METHODS AREA ******************************

  bool _hasReachedMax(PostState state) =>
      state is PostLoaded && state.hasReachedMax;

  Future<List<SampleModel>> _fetchSampleDatas(int startIndex, int limit) async {
    final response = await httpClient.get(
        'https://jsonplaceholder.typicode.com/posts?_start=$startIndex&_limit=$limit');
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((rawPost) {
        return SampleModel(
          id: rawPost['id'],
          title: rawPost['title'],
          body: rawPost['body'],
        );
      }).toList();
    } else {
      throw Exception('error fetching data');
    }
  }
}
