# 📱 올바른코드 플러터 보일러플레이트

프로젝트 구성 시, 반복된 작업 및 반드시 필요한 필수 파일들이 포함된 보일러플레이트 패키지입니다.
<br/>
해당 프로젝트는 자사 플랫폼인 `학원나우` 를 기반으로 개발되었습니다.

## 💽 Installation
```
# Git Clone
https://github.com/rightcode1/ppl_app.git
```

```
# 의존성 패키지 다운로드
flutter pub get
```

```
# 파일 Generate
flutter pub run build_runner watch --delete-conflicting-outputs
```

## ❗️ 주의해주세요!
- `auth/component/login/column/auth_login_button_column.dart` 내 `TODO: 실 로직 작성 시, 하기 로직 제거` 로 표기된 `GoRouterUtils.moveToExpectedRouteAfterSingingIn(context, ref);` 코드를 제거하고, 하단 주석처리 된 코드의 주석을 해제 후 사용해주세요.

- 현 보일러플레이트 패키지 내의 model 및 repository 는 기본 형태로만 정의되어있습니다. API 명세서에 맞게 재정의가 필요할 수 있습니다.

- `common/constant/data.dart` 내 `baseHostV1` 상수를 서버 호스트에 맞게 정의 후 사용해주세요.

- 다수의 컴포넌트는 상황에 따라 반드시 재정의 및 수정되어야합니다.
<br/><br/>
## 🛠️ 환경
- **FVM 3.19.4**
- **AOS minSdkVersion 23**
- **AOS compileSdkVersion 34**
<br/><br/>
## 📂 프로젝트 구성
- **`core`**: 플러터 앱의 전역적인 설정, 유틸함수, 공용 Provider, 상수 등이 포함된 디렉토리입니다. 특히, 라우팅의 경우 `authProvider` 에 의존합니다.
- **`domain`**: `model`, `repository` 등이 포함된 서버와의 통신을 위한 클래스가 정의된 디렉토리입니다.
- **`service`**: 비즈니스 로직이 정의된 디렉토리입니다. `Provider` 를 통해 상태를 관리하며, `Repository` 를 통해 서버와의 통신을 담당합니다.
- **`presentation`**: 화면을 구성하는 컴포넌트가 정의된 디렉토리입니다. `Screen` 은 각 화면을 구성하는 컴포넌트를 정의하며, `Component` 는 `Screen` 에서 사용되는 컴포넌트를 정의합니다.
- **`main.dart`**: 앱의 엔트리포인트입니다.
- **`app.dart`**: `RivderPod`, `ScreenUtils`, `Intl`, `GoRouter` 가 적용되는 최상단 파일입니다.
<br/><br/>
## 💡 포함된 패키지 (Decument Deprecated, 실제 Pubspec.yaml 을 확인해주세요.)
> [2024.04.04.] 하기 항목은 더 이상 유효하지 않습니다.<br/>대략적인 참고용으로만 열람해주세요.
#### 해당 패키지 목록은 필요에 따라, 혹은 Deprecated 등의 사유로 예고 없이 버전이 변경될 수 있습니다.
### 빌드 패키지

- `badges`: ^3.0.2 # 뱃지 컴포넌트를 위한 패키지

- `cached_network_image`: ^3.2.3 # 네트워크에서 가져온 이미지를 캐싱할 수 있는 패키지, 이미지 로드 동안 보여줄 스켈레톤 등의 임시 컴포넌트를 함께 지정할 수 있다.
- `debounce_throttle`: ^2.0.0 # 전통적인 Debounce, Throttle 을 구현하기 위한 패키지
- `dio`: ^4.0.6 # HTTP Communicating 라이브러리, Web 환경에서의 Axios, Ajax 와 상응한다.
- `easy_debounce`: ^2.0.3 # Debounce and Throttle 을 보다 간편하게 구현할 수 있는 패키지 (경우에 따라 상단 debounce_throttle 패키지를 통해 구현하거나, 해당 패키지를 통해 구현하면 된다.)
- `equatable`: ^2.0.5 # 객체 사이의 등가성을 간편하게 확인할 수 있는 패키지
- `form_builder_validators`: ^8.5.0 # flutter_form_builder 와 함께 사용되며, TextField 등의 값을 간편히 검증할 수 있는 패키지 (값 범위, 정규식, 필수 여부 등)
- `flutter_riverpod`: ^2.2.0 # 상태 관리 패키지 (전통적인 BloC, Provider 등을 대체한다.)
- `flutter_form_builder`: ^7.8.0 # 기존 플러터에서 제공하는 FormBuilder 를 대체하는 패키지 (패키지 내의 TextField, Slider 등은 onChange 를 통해 상태를 구현하지 않아도 자동으로 해당 패키지에 의해 관리된다.)
- `flutter_screenutil`: ^5.6.1 # 프로젝트 엔트리포인트에서 지정한 기기의 Default Size 에 맞춰 크기가 다른 기기에서도 너비, 높이를 dynamic 하게 자동으로 변경하여 주는 패키지
- `flutter_secure_storage`: ^8.0.0 # 플러터 저장소, SharedPreferences 보다 더 보안성이 높은 패키지로 보인다.
- `flutter_staggered_grid_view`: ^0.6.2 # 기존 전통적인 GridView 를 대체하는 패키지, 기존에는 GridView 내의 아이템의 크기를 제어해주는 등의 추가 로직이 필요하였으나, 해당 패키지는 자동으로 크기를 맞춰 GridView 를 구성해준다.
- `fluttertoast`: ^8.2.1 # 플러터 토스트 패키지
- `go_router`: ^6.2.0 # 기존 플러터 라우팅을 대체하는 라우팅 패키지
- `retrofit`: '>=3.0.0 <4.0.0' # HTTP Communicating 추상화 라이브러리, 주로 Repository 구성 시 활용된다.
- `logger`: any  #for logging purpose
- `json_annotation`: ^4.8.0 # 직렬화/역직렬화를 위한 어노테이션이 포함된 패키지, 주로 From model to json, From json to model 간의 직렬화/역직렬화를 위해 사용된다.
- `intl`: ^0.17.0 # 다국어지원 패키지, DateFormatting 등의 기능을 지원한다.
- `skeletons`: ^0.0.3 # 스켈레톤 패키지, 기본으로 제공해주는 스켈레톤 컴포넌트들이 있으며, 사용자가 직접 스켈레톤의 형식을 간편히 컴포넌트의 형태로 지정하여 사용할 수 있다.
- `uuid`: ^3.0.7 # UUID 패키지
- `carousel_slider`: ^4.2.1 # 캐러셀 패키지
- `wechat_assets_picker`: ^8.4.0 # Wechat 이미지/영상 Picker
- `shared_preferences`: ^2.0.18 # Web 에서의 Cookie 에 상응하는 메모리 데이터 저장 패키지
- `flutter_isolate`: ^2.0.4 # Main Thread 이외에 Background 로직 동작을 위해 필요한 패키지
- `permission_handler`: ^10.2.0 # 앱의 허가(활동, 카메라 등) 등을 대행하는 패키지
- `path_provider`: ^2.0.13 # Path 등을 보다 간편하게 관리할 수 있는 패키지, JS 계열의 path 에 상응
- uni_links: ^0.5.1 # 딥링크
- change_app_package_name: ^1.1.0 # 패키지명 변경을 위해 사용 (보일러플레이트->앱이름)
- percent_indicator: ^4.2.3 # 퍼센트 인디케이터
- infinite_scroll_pagination: ^4.0.0 # 무한 스크롤
- table_calendar: ^3.0.8 # 캘린더
- url_launcher: ^6.1.12 # 외부 URL 오픈 등
- photo_view: ^0.14.0 # 이미지 뷰어
- webview_flutter: ^4.2.4 # 웹뷰
- flutter_naver_login: ^1.8.0 # 네이버 로그인
- kakao_flutter_sdk: ^1.5.0 # 카카오 로그인
- sign_in_with_apple: ^5.0.0 # 애플 로그인

### 개발용 패키지
- `riverpod_generator`: ^1.2.0 # RiverPod 을 generate 하기 위한 패키지
- riverpod_lint: ^2.0.4
- custom_lint: ^0.5.3

- riverpod_generator: ^2.3.2 # RiverPod 을 generate 하기 위한 패키지
- retrofit_generator: ^7.0.8 # Retrofit 을 generate 하기 위한 패키지
- build_runner: '>=2.3.0 <4.0.0' # g.dart 파일 Generate 를 위한 패키지
- json_serializable: ^6.6.1 # 직렬화/역직렬화 코어 패키지
<br/><br/>
## 📃 Change Logs
- **2023.03.28.**: 최초 커밋
- **2023.06.08.**: 기종 별 상관 없이 Text Factor 1.0 으로 고정
- **2023.07.26.**: Default Root Tab 추가, 다수의 컴포넌트 추가, 다수의 유틸 추가, 컴포넌트 및 유틸 데모 페이지 개발, ScreenUtils 기준 사이즈 360x720 으로 변경 등
- **2023.09.11.**: 플러터 **3.13.0** 버전 업데이트 및 다수 패키지 버전 메이저 업데이트, 다수 컴포넌트 추가 및 SNS 로그인, 아이디/비밀번호 찾기, 각종 헬퍼 함수 추가
- **2023.10.16.**: `MainActivity.kt` 누락 파일 추가 및 버전 체크 로직 추가
- **2023.11.15.**: 플러터 버전 **3.13.5** 업데이트 및 내부 로직/컴포넌트 다수 업데이트
### 2024.04.04. Breaking Changes
- 플러터 버전 3.19.4 업데이트 및 안드로이드 관련 내부 로직 최신화 (build.gradle migration)
- 의존성 패키지 최신화 및 의존성 최신화에 따른 compileSDKVersion 34로 상향
- 앱 비폐쇄형 처리 및 관련 라우팅 로직 전체수정
- 프로젝트 아키텍처 3-Layered Arch. 로 변경 (디렉토리 별 Package by Feature and Package by Layer 혼용)
- 앱 엔트리 포인트 분리 (main.dart / app.dart)
- 라우팅 로직 ShellRoute 로 마이그레이션 (기존 StatefulShellRoute 에서 변경)
- 라우팅 로직 유틸화 (로그인 필요 페이지 접근 시, 로그인 이후 원래 이동해야했던 타겟 페이지로 이동 등 자동화)
- 최신 Navigation Bar 적용
- 버전 로직 최신 버전으로 업데이트 (웰카 기준)
- SNS On/Off 로직 최신 버전으로 업데이트 (웰카 기준)
- FCM 로직 추가 (푸시 클릭 시 적절한 페이지 이동 처리 및 App Terminated, Fore/Background 환경 내 푸시 동작 처리)
- Firebase Dynamic Link 로직 추가
- DefaultLayout 내 일부 헬퍼 프로퍼티 추가 (centerTitle, floating button 등)
- 로딩 시, 화면 전체 Loading Dimmer 추가 (Optional)
- 스플래시 스크린 내 방문자 증가 로직 추가
- 토스트 컨테이너 최적화 (리팩토링)
- User 관련 프로바이더 리팩토링
- 이미지 캐러셀 컴포넌트 추가 및 리팩토링
- 바텀 시트 유틸 리팩토링 (바텀 시트 내 컨텐츠의 높이에 따른 동적 높이를 지니도록 변경 및 공용 로직 분리 등)
- 칩 컨테이너 리팩토링 (이제 Chip 컨테이너는 내부에 위젯을 렌더링 할 수 있음)
- 네이티브를 사용하는 AddImageElement 추가
- 반응형 텍스트 크기에 대하여, 최신 Text Scaler 프로퍼티로 변경
- 폴드 기기 감지 헬퍼 메소드 추가
- 상세 이미지(전체 화면) 내 파일 다운로드 로직 추가

<br/><br/>
<s>
## 📝 참고하면 좋을 내용 (Document Deprecated)
#### Form 을 관리하는 방법에 대한 프로토타입을 정의한 글입니다. `최애캐시` 프로젝트에서 처음으로 도입한 방법이며 하기 글은 초기 도입 당시 PR 에 작성한 내용입니다.
#### 따라서, `최애캐시` 에서 사용된 로직에 대해서 설명하고 있으며, 해당 내용은 본 보일러플레이트에서도 사용되고 있는 Form 관리 방식입니다. 절대적인 방법은 아니며, 각자의 개인 방식에 따라 적절히 다른 방식으로 구현하여 사용해도 무방합니다.

----------------------

**[회원가입 FormBuilder 적용에 따른 상태 관리 프로토타입]**
- 기존 프로젝트에서는 각 `Form` 에 대하여 form data 를 관리하는 `Provider` 를 직접 정의하여 관리하였으나, `FormBuilder` 패키지를 사용할 경우, **하위 `TextFormField` 의 값을 자동으로 `Map` 로 변환하여 대신 관리해준다.**
- 이러한 특징을 활용하여 새롭게 Form data 를 전반적으로 관리할 수 있는 방법에 대한 프로토타입을 정의하였다. 이와 관련된 시나리오는 하기와 같다.

**1)  각 폼에 대한 폼키는 `GlobalKey` 를 통해 전역적으로 관리된다.**
```dart
// common/constant/form_key.dart

// 전역적으로 각 FormBuilder 의 Form 에 대한 키를 관리하는 상수 변수들을 정의한다.

/// 회원가입 시 입력받는 사용자 정보 폼 키
final signUpFormKey = GlobalKey<FormBuilderState>();
```
전역적으로 `FormBuilder` 를 사용하는 폼 키를 관리하며, 앱 내의 어디서든 해당 키를 통해 현재 Form 값을 가져올 수 있다.

**2) API 호출과 관련된 역할을 하는 Form 과 연관된 Provider(ex. `auth_social_login_provider.dart`) 는 가능한 모델 직렬화/역직렬화와 서버 전송 비즈니스 로직만을 담당하도록 한다.**

- 기존 프로젝트에서 사용한 Form Data 를 관리하기 위한 Provider 는 이제 서버와의 통신을 위한 비즈니스 로직이 정의될 수 있도록 한다.

- 하기 예제에서 `auth_social_login_provider.dart` 는 실제 API 인 `POST /v1/auth/social/login` 에 해당하는 비즈니스 로직을 정의하기 위한 provider 이다. 따라서, 서버에 Body 로 보내기 위한 `AuthReqSocialLogin` 모델을 상태로서 관리한다.
- 이때, `toModel()` 은 `FormBuilder` 를 통해 관리되고 있는 `Map` 형태의 폼 상태를 `Repository` 에서 `Body` 로 전송하기 위한 `Model` 형태로 상태를 재정의하는 메소드를 의미한다. (해당 부분은 Spring 에서 DTO 클래스 내에서 `toEntity()` 를 통해 불변성을 지닌 엔티티로의 변환 작업에서 영감을 얻음.)
- 즉, 기존 3-layers architecture 에서는 application layer -> business layer 일 때의 데이터 전달은 DTO 를 통해 이루어지고, business layer -> repository layer 에서는 Entity 를 통해 Data source 에 접근 하는 방식을 주로 채택한다. 이러한 방식을 동일하게 적용하여 플러터에서`FormBuilder` 에서 관리하는 폼 데이터를 `Map` 형태의 DTO 로 보고, 실제로 API 호출을 담당하는 `repository` 에서 사용되는 Req/Res Model 을 불변성을 지닌 Entity 처럼 관리하려는 의도이다. 즉, `Entity` 에서의 불변성과 마찬가지로 `FormBuilder` 으로부터 변환된 `Model` 객체는 직접적으로 값을 변경할 수 없어야한다.

```dart
// auth_social_login_provider.dart

/// Auth API 에서 소셜 로그인을 수행하기 위한 모델을 관리하는 Provider
/// 주된 역할은 회원가입 폼인 signUpFormKey 를 Body 로 만들어서 관리하는 역할을 한다.
class AuthSocialLoginStateNotifier extends StateNotifier<AuthReqSocialLogin> {
  AuthSocialLoginStateNotifier(): super(AuthReqSocialLogin(loginId: '', password: '', provider: ''));

  /// 현재 회원가입 폼을 모델로 변환한다.
  void toModel() {
    final formState = signUpFormKey.currentState!.value;
    state = AuthReqSocialLogin.fromJson(formState);
  }

  /// 현재 관리되고 있는 모델을 서버로 전송한다.
  void sendToServer() {
  }
}
```

**3) `Form` 이 필요한 스크린에서는 눈에 보이는 `Visible Form` 과 눈에 보이지 않는 `Invisible Form` 이 존재할 수 있다.**
- 상기한 Visible Form, Invisible Form 이 필요한 이유는 마지막에 설명한다.
- `FormBuilder` 패키지에서는 `FormBuilderTextFormField` 와 같은 위젯의 `name` 프로퍼티를 활용하여 자동으로 상태값을 관리한다. 예를 들어, `name: 'title'` 으로 `FormBuilderTextFormField` 를 정의하였을 때, 실제 `FormBuilder` 내의 state 는 `{'title': 'example title'}` 과 같이 관리된다.
- 이는 최종적으로 서버 요청을 위해 필요한 Model 내의 멤버 변수명과 `FormBuilderTextFormField` 와 같은 위젯의 `name` 프로퍼티의 이름은 동일해야한다는 의미이다. 왜냐하면, 해당 Form data 는 `Map` 형태의 DTO 로 가정하기 때문에 실제 Model 로 변환할 때 `name` 프로퍼티와 Model 의 변수명이 동일해야하기 때문이다.
- 그러나, 특정 스크린 내에서 `FormBuilder` 를 정의하여 `TextFormField` 와 같은 위젯으로 Form 을 관리한다고 하더라도, 필연적으로 실제 모델에 담아서 보내야하는 데이터와 일치하지 않는 경우가 반드시 존재한다. 예를 들어, 회원가입을 위해 필요한 API 인 `POST /v1/auth/social/login` 에 담아서 보내야하는 Body 는 다음과 같이 정의되어야한다.

```
{
  "loginId": "string",
  "password": "string",
  "provider": "string",
  "tel": "string",
  "name": "string",
  "nickname": "string",
  "recommendCode": "string"
}
```

그러나, 실제 앱 상에서의 스크린에서는 `loginId`, `password`, `provider` 와 같은 값을 사용자로부터 직접 전달받지 않는다. 즉, 해당 프로퍼티들은 눈에 보이지 않는 상태에서도 `FormBuilder` 를 통해 관리되고 있어야한다는 의미이다.

이러한 문제점을 극복하기 위해 `Invisible Form` 을 도입한다. 해당 Form 은 `FormBuilder` 내에서 다른 `Visible Form` 과 동일하게 관리되는 `TextFormField` 이나, 눈에 보이지 않는 위젯이다. 해당 위젯은 다음과 같이 정의될 수 있다.

```dart
Visibility(
    visible: false,
    maintainState: true,
    child: FormBuilderTextField(
      name: 'loginId',
      initialValue: loginId,
    ),
  ),
```

`Visiblility` 내의 `visible` 속성을 통해 위젯을 숨기면서, 해당 위젯의  state 는 그대로 유지하기 위한 `maintainState` 를 통해 `FormBuilder` 가 해당 필드를 관리할 수 있도록 정의한다. 물론, 숨겨진 위젯은 사용자가 직접 작성할 수 없는 항목이므로 값을 개발자가 정의하여 넣어주어야 한다. 이는 웹 프론트엔드 개발에서 숨겨진 Form 데이터를 관리할 때 사용하는 `<input type="hidden" />` 과 동일하다.
</s>