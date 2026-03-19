import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import

class PrimIosProfileWebpage extends StatefulWidget {
  final Uri uri;
  final String token;
  const PrimIosProfileWebpage({
    super.key,
    required this.token,
    required this.uri,
  });

  @override
  State<PrimIosProfileWebpage> createState() => _PrimIosProfileWebpageState();
}

class _PrimIosProfileWebpageState extends State<PrimIosProfileWebpage> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        widget.uri,
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    // Colors chosen to mimic standard iOS Safari themes
    final Color safariBgColor = Colors.grey.shade100;
    final Color safariIconColor = Colors.blue.shade600;

    return Scaffold(
      backgroundColor: safariBgColor,
      appBar: AppBar(
        backgroundColor: safariBgColor,
        elevation: 0,
        leadingWidth: 80,
        // The standard iOS "Done" button to close the browser
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Tutup',
            style: TextStyle(
              color: safariIconColor,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // Optional: You can put a title or domain name here
        title: const Text(
          'Profil',
          style: TextStyle(color: Colors.black87, fontSize: 17),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(
              color: Colors.grey.shade300, height: 0.5), // Subtle divider
        ),
      ),
      body: SafeArea(
        child: WebViewWidget(controller: _controller),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: safariBgColor,
            border: Border(
              top: BorderSide(color: Colors.grey.shade300, width: 0.5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Back Button
              IconButton(
                icon: Icon(Icons.arrow_back_ios, color: safariIconColor),
                onPressed: () async {
                  if (await _controller.canGoBack()) {
                    _controller.goBack();
                  }
                },
              ),
              // Forward Button
              IconButton(
                icon: Icon(Icons.arrow_forward_ios, color: safariIconColor),
                onPressed: () async {
                  if (await _controller.canGoForward()) {
                    _controller.goForward();
                  }
                },
              ),

              // NEW: Open in External Safari Button
              IconButton(
                icon: Icon(Icons.open_in_browser,
                    color: safariIconColor), // standard open in browser icon
                onPressed: () async {
                  // Get the current URL the user is actually viewing
                  final currentUrlStr = await _controller.currentUrl();
                  if (currentUrlStr != null) {
                    final Uri currentUri = Uri.parse(currentUrlStr);
                    // Launch externally to force the native Safari app
                    if (await canLaunchUrl(currentUri)) {
                      await launchUrl(
                        currentUri,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  }
                },
              ),

              // Refresh Button
              IconButton(
                icon: Icon(Icons.refresh, color: safariIconColor),
                onPressed: () {
                  _controller.reload();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
