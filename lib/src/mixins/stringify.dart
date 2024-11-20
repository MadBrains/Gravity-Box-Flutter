/// A mixin that adds a [toString] method to any class that
/// mixed with it. The [toString] method will return a string
/// in the format of '$runtimeType $mappedFields.toString()'
/// where [mappedFields] is a map of the object's fields.
mixin Stringify {
  /// A map of the object's fields.
  ///
  /// The keys are the fields names and the values are the fields values.
  ///
  /// The default implementation returns an empty map.
  /// You should override this method to return a map of the object's fields.
  Map<String, dynamic> get mappedFields => <String, dynamic>{};

  @override
  String toString() => '$runtimeType ${mappedFields.toString()}';
}
