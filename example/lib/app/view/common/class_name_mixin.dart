//
///
mixin ClassNameMixin on Object {
  ///
  String get className {
    if (_className == null) {
      final name = '$this';
      final hash = name.indexOf('#');
      if (hash > 0) {
        _className = name.substring(0, hash);
      } else {
        final parts = name.split(' ');
        _className = parts.last;
      }
    }
    return _className!;
  }

  set className(String? name) =>
      _className ??= name?.isEmpty ?? true ? null : name;

  String? _className;
}
