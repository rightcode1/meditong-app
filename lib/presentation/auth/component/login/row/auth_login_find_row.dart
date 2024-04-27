import 'package:mediport/core/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 기본 형태의 아이디 찾기 및 비밀번호 찾기 텍스트 버튼 Row, 형태에 맞게 재정의하여 사용한다.
class AuthLoginFindRow extends StatelessWidget {
  const AuthLoginFindRow({
    Key? key,
    required this.onFindIdBtnClicked,
    required this.onFindPasswordBtnClicked,
  }) : super(key: key);
  
  final VoidCallback onFindIdBtnClicked;
  final VoidCallback onFindPasswordBtnClicked;

  @override
  Widget build(BuildContext context) {
    final TextStyle btnTextStyle = TextStyle(
      color: AppColor.cyan700,
      fontSize: 14.0.sp,
      fontWeight: FontWeight.w600,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: onFindIdBtnClicked,
            child: Text(
              '아이디 찾기',
              style: btnTextStyle,
            )),
        const Text(
          '|',
          style: TextStyle(color: AppColor.grey400),
        ),
        TextButton(
          onPressed: onFindPasswordBtnClicked,
            child: Text(
              '비밀번호 변경',
              style: btnTextStyle,
            )),
      ],
    );
  }
}
