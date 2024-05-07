import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediport/core/component/buttons/common_button.dart';
import 'package:mediport/core/component/label/common_label.dart';
import 'package:mediport/core/component/text_fields/common_form_text_field.dart';
import 'package:mediport/core/layout/default_layout.dart';
import 'package:mediport/core/util/toast_utils.dart';

import '../../../service/inquiry/inquiry_providers.dart';
import '../model/inquiry_form_model.dart';
import '../provider/inquiry_form_provider.dart';

class InquiryRegisterScreen extends ConsumerStatefulWidget {
  const InquiryRegisterScreen({super.key});

  @override
  ConsumerState<InquiryRegisterScreen> createState() => _InquiryRegisterScreenState();
}

class _InquiryRegisterScreenState extends ConsumerState<InquiryRegisterScreen> {
  final FocusNode _contentFocusNode = FocusNode();

  bool _isRegisterLoading = false;

  @override
  void dispose() {
    _contentFocusNode.dispose();
    super.dispose();
  }

  Widget bottomButton({required InquiryFormModel formState}) {
    return SizedBox(
      width: double.infinity,
      height: 50.0.h,
      child: CommonButton(
        isActive: !_isRegisterLoading && formState.isAllValidated,
        isLoading: _isRegisterLoading,
        text: '문의 등록하기',
        onPressed: () async {
          FocusManager.instance.primaryFocus?.unfocus();
          setState(() {
            _isRegisterLoading = true;
          });

          final result = await ref.read(inquiryRegisterProvider.future);
          if (!context.mounted) return;

          if (result) {
            ToastUtils.showToast(context, toastText: '문의가 등록되었습니다.');
            context.pop(true);

            return;
          }

          setState(() {
            _isRegisterLoading = false;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(inquiryFormProvider);
    return DefaultLayout(
      showAppBar: true,
      showBack: true,
      title: '1:1 문의 등록',
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: MediaQuery.viewPaddingOf(context).bottom + 20.0.h),
        child: bottomButton(formState: formState),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              CommonLabel(
                label: '제목',
                fontWeight: FontWeight.w700,
                child: CommonForm.create(
                  name: 'title',
                  hintText: '제목을 입력해주세요.',
                  onChanged: (controller) => ref.read(inquiryFormProvider.notifier).changeTitle(controller.text),
                ),
              ),
              SizedBox(height: 40.0.h),
              CommonLabel(
                label: '내용',
                fontWeight: FontWeight.w700,
                child: CommonForm.create(
                  name: 'content',
                  minLines: 10,
                  maxLines: 10,
                  hintText: '내용을 입력해주세요.',
                  onChanged: (controller) => ref.read(inquiryFormProvider.notifier).changeContent(controller.text),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
