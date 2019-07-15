import 'package:equatable/equatable.dart';

class SampleModel extends Equatable {
  int id;
  String title;
  String body;

  SampleModel({this.id, this.title, this.body}) : super([id, title, body]);

  @override
  String toString() {
    return 'Post { id: $id }';
  }
}
