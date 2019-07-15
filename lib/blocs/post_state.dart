import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter_infinite_list_bloc/models/sample_model.dart';

@immutable
abstract class PostState extends Equatable {
  PostState([List props = const []]) : super(props);
}

//This is the inner class state for waiting for data to be loaded first time - to inform the UI layer
class PostUninitialized extends PostState {
  @override
  String toString() => 'PostUninitialized';
}

//This is the inner class state for when there is an error getting data - to inform the UI layer
class PostError extends PostState {
  @override
  String toString() => 'PostError';
}

//This is the inner class state that when the data is loaded and ready for the UI later
class PostLoaded extends PostState {
  final List<SampleModel> posts; //will be the List<SampleModel> which will be displayed
  final bool hasReachedMax; //will tell the presentation layer whether or not it has reach the maximum number of posts

  PostLoaded({
    this.posts,
    this.hasReachedMax,
  }) : super([posts, hasReachedMax]);

  @override
  String toString() =>
      'PostLoaded { posts: ${posts.length}, hasReachedMax: $hasReachedMax }';

  /*
  This is convenient for us to copy an instance of PostLoaded later
   */
  PostLoaded copyWith({
    List<SampleModel> posts,
    bool hasReachedMax,
  }) {
    return PostLoaded(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}
