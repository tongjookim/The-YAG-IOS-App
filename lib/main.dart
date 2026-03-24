import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

void main() {
  // 플러터 엔진이 초기화되었는지 확인 (웹뷰 등 네이티브 기능 사용 시 필수)
  WidgetsFlutterBinding.ensureInitialized();

  // 상태표시줄 스타일 설정 (흰색 글자로 바꾸고 싶을 때)
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // 안드로이드용
    statusBarIconBrightness: Brightness.light, // 안드로이드용
    statusBarBrightness: Brightness.dark, // iOS용 (글자를 흰색으로)
  ));

  runApp(const MaterialApp(
    home: WebViewApp(),
    debugShowCheckedModeBanner: false, // 오른쪽 상단 디버그 띠 제거
  ));
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    // 웹뷰 컨트롤러 설정
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // JS 허용 (구글 등 대부분 사이트 필수)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (String url) {
          // 페이지 로딩 완료 시 쿠키가 자동으로 저장되지만, 
          // 필요하다면 여기서 추가적인 쿠키 조작이 가능합니다.
        },
      ),
    )
      ..loadRequest(Uri.parse('https://www.theyag.kr')); // 보여주고 싶은 주소

    if (controller.platform is WebKitWebViewController) {
      (controller.platform as WebKitWebViewController)
          .setAllowsBackForwardNavigationGestures(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    // 상단바(AppBar)를 없앴으므로, body를 SafeArea로 감쌉니다.
    body: SafeArea(
      child: WebViewWidget(controller: controller),
    ),
  );
  }
}