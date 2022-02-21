class Model {
  final int? id;
  final String? model;
  final DateTime? dateTime;

  Model({this.id, this.model, this.dateTime});
  Map<String, dynamic> toMap() {
    return ({
      'id': id,
      'model': model,
      'creationDate': dateTime.toString(),
    });
  }
}
