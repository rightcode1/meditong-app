import 'package:flutter/material.dart';
import 'package:mediport/core/layout/default_layout.dart';

class ExampleScreen extends StatefulWidget {
  static get routeName => 'example';

  const ExampleScreen({Key? key}) : super(key: key);

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {

  @override
  void initState() {
    super.initState();

    /// TODO: 초기 데이터를 가져온다.
    getInitialData();
  }

  Future<void> getInitialData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    // TODO: 데이터가 필요한 스크린은 항상 선로딩, 후렌더의 형태를 취한다.
    // pseudo-code
    // if
    //    no data's loaded
    // then
    //    render Loading Indicator.

    // TODO: 스크린은 최대한 깔끔하게, 컴포넌트를 최대한 분리하며 작성한다.
    return const DefaultLayout(
      child: Center(
        child: SizedBox(),
      ),
    );
  }
}
