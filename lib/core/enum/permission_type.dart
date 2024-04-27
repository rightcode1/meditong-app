import 'package:permission_handler/permission_handler.dart';

/// 앱 내에서 사용하는 권한 타입
enum PermissionType {
  /// AOS: T 이상 저장소(갤러리 등) 접근 허용 여부
  /// IOS: Documents 및 Download 폴더 접근 허용 여부 (IOS 에서는 사용 배제)
  storage(Permission.storage),

  /// AOS: T 이하 저장소 접근 허용 여부 (AOS 에서는 사용 배제)
  /// IOS: IOS 14+ 읽기 및 쓰기
  photos(Permission.photos);

  // camera(Permission.camera);

  const PermissionType(this.type);


  final Permission type;
}
