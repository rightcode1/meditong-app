import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef BoolCallback = Function(bool val);

class MoreToggleButton extends StatefulWidget {
  final String buttonText;
  final BoolCallback boolCallback;
  final bool isMore;

  const MoreToggleButton({
    required this.buttonText,
    required this.boolCallback,
    required this.isMore,
    Key? key,
  }) : super(key: key);

  @override
  State<MoreToggleButton> createState() => _MoreToggleButtonState();
}

class _MoreToggleButtonState extends State<MoreToggleButton> {
  late bool isMore;
  @override
  void initState() {
    super.initState();
    isMore = widget.isMore;
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isMore = !isMore;
        });
        widget.boolCallback(isMore);
        // ToastUtils.showToast(context, toastText: '더보기 구현 필요');
      },
      child: SizedBox(
        height: 50.0.h,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${widget.buttonText} ${widget.isMore ? '접기' : '더보기'}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0.sp,
                ),
              ),
              SizedBox(
                width: 2.0.w,
              ),
              Image.asset(
                widget.isMore ? 'assets/icons/common/arrow_up_grey@3x.png' : 'assets/icons/common/arrow_down_grey@3x.png',
                width: 17.0.h,
                height: 17.0.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
