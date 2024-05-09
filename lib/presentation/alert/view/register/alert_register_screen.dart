import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediport/core/component/buttons/common_button.dart';
import 'package:mediport/core/component/text_fields/common_form_text_field.dart';
import 'package:mediport/core/constant/app_color.dart';
import 'package:mediport/core/layout/default_layout.dart';
import 'package:mediport/core/util/toast_utils.dart';
import 'package:mediport/service/alert/alert_providers.dart';

class AlertRegisterScreen extends ConsumerStatefulWidget {
  const AlertRegisterScreen({super.key});

  @override
  ConsumerState<AlertRegisterScreen> createState() => _AlertRegisterScreenState();
}

class _AlertRegisterScreenState extends ConsumerState<AlertRegisterScreen> {
  final TextEditingController _keywordController = TextEditingController();

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alertList = ref.watch(alertProvider);
    return DefaultLayout(
      showAppBar: true,
      showClose: true,
      title: '키워드 등록',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /* 키워드 입력란 */
          CommonForm.create(
            controller: _keywordController,
            hintText: '키워드를 입력해주세요.',
            suffixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.0.w, vertical: 6.0.h),
              child: CommonButton(
                backgroundColor: _keywordController.text.isEmpty ? AppColor.grey500 : AppColor.lightPrimary,
                textColor: _keywordController.text.isEmpty ? AppColor.cyan700 : AppColor.primary,
                text: '등록',
                onPressed: () async {
                  if (_keywordController.text.isEmpty) {
                    ToastUtils.showToast(context, toastText: '키워드를 입력해주세요.');
                    return;
                  }

                  FocusManager.instance.primaryFocus?.unfocus();

                  final result = await ref.read(alertProvider.notifier).register(keyword: _keywordController.text);
                  if (!context.mounted) return;

                  if (result) {
                    _keywordController.clear();
                    ToastUtils.showToast(context, toastText: '키워드가 등록되었습니다.');
                  } else {
                    ToastUtils.showToast(context, toastText: '키워드 등록에 실패하였습니다.');
                  }
                },
              ),
            ),
            onChanged: (controller) => setState(() {}),
          ),
          /* 등록한 키워드 */
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.only(top: 8.0.h),
              itemBuilder: (context, index) {
                final eachAlert = alertList.value![index];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      eachAlert.content,
                      style: TextStyle(fontSize: 14.0.sp, fontWeight: FontWeight.w500),
                    ),
                    IconButton(
                      onPressed: () async {
                        final result = await ref.read(alertProvider.notifier).remove(alertId: eachAlert.id);
                        if (!context.mounted) return;

                        if (result) {
                          ToastUtils.showToast(context, toastText: '키워드가 삭제되었습니다.');
                        } else {
                          ToastUtils.showToast(context, toastText: '키워드 삭제에 실패하였습니다.');
                        }
                      },
                      icon: const Icon(Icons.close, color: AppColor.cyan700),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => const SizedBox(),
              itemCount: alertList.value!.length,
            ),
          ),
        ],
      ),
    );
  }
}
