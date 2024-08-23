import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:moli/utils/const_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/extensions.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  const WebViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ToolBarWidget(title: Get.arguments),
          Expanded(
            child: WebViewWidget(
              controller: WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..setBackgroundColor(context.colorScheme.surface)
                ..loadRequest(
                  Uri.parse(
                    Get.arguments == AppLocalizations.of(context)!.termsOfUse
                        ? ConstRes.termsOfUseUrl
                        : ConstRes.privacyPolicyUrl,
                  ),
                ),
            ),
          ),
        ],
      ),
    );
  }
}
