// lib/platform_constraints/post_web/upload.dart
export 'upload_stub.dart'
    if (dart.library.html) 'upload_web.dart';
