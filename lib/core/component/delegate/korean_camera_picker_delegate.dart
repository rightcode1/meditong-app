import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class KoreanCameraPickerDelegate extends CameraPickerTextDelegate {
  @override
  String get languageCode => 'ko';

  @override
  /// Confirm string for the confirm button.
  /// 确认按钮的字段
  String get confirm => '확인';

  @override
  /// Tips above the shooting button before shooting.
  /// 拍摄前确认按钮上方的提示文字
  String get shootingTips => '사진 촬영';

  @override
  /// Tips with recording above the shooting button before shooting.
  /// 拍摄前确认按钮上方的提示文字（带录像）
  String get shootingWithRecordingTips => '轻触拍照，长按摄像';

  @override
  /// Tips with only recording above the shooting button before shooting.
  /// 拍摄前确认按钮上方的提示文字（仅录像）
  String get shootingOnlyRecordingTips => '长按摄像';

  @override
  /// Tips with tap recording above the shooting button before shooting.
  /// 拍摄前确认按钮上方的提示文字（点击录像）
  String get shootingTapRecordingTips => '轻触摄像';

  @override
  /// Load failed string for item.
  /// 资源加载失败时的字段
  String get loadFailed => '로드 실패';

  @override
  /// Default loading string for the dialog.
  /// 加载中弹窗的默认文字
  String get loading => '로딩 중…';

  @override
  /// Saving string for the dialog.
  /// 保存中弹窗的默认文字
  String get saving => '저장 중…';

  @override
  /// Semantics fields.
  ///
  /// Fields below are only for semantics usage. For customizable these fields,
  /// head over to [EnglishCameraPickerTextDelegate] for better understanding.
  String get sActionManuallyFocusHint => '手动聚焦';

  @override
  String get sActionPreviewHint => '预览';

  @override
  String get sActionRecordHint => '录像';

  @override
  String get sActionShootHint => '拍照';

  @override
  String get sActionShootingButtonTooltip => '拍照按钮';

  @override
  String get sActionStopRecordingHint => '停止录像';
}