import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PostEvent extends Equatable {
  PostEvent([List props = const []]) : super(props);
}

/*
Since we only allow single event which is fetching data from 3rd-party service,
hence there is only 1 event here called Fetch.
So, in flutter_bloc, our bloc* will be receiving event* and then convert
it to states. Each states has it own implementation.
 */
class Fetch extends PostEvent{
  @override
  String toString() {
    return "Fetch";
  }
}