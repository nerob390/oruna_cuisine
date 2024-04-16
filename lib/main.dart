import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true),
    home: const WebViewApp(),
  ));
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({Key? key}) : super(key: key);

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  String _appBarTitle = 'Home'; // Initial title
  bool isLoading = true;
  late WebViewController _controller;
  final List<String> _urls = [
    "https://www.orunacuisine.co.uk/",
    "https://orunacuisine.co.uk/onlineorder/onlineorder.php",
    "https://www.orunacuisine.co.uk/book-a-table/",
    "https://www.orunacuisine.co.uk/contact-us/",
    "https://www.orunacuisine.co.uk/contact-us/",
  ];

  void _onItemTapped(int index) {
    if (index == 3) {
      // Assuming "Call Now" is at index 3
      _makePhoneCall("01630 658 121");
    } else {
      setState(() {
        _selectedIndex = index;
        _pageController.jumpToPage(index);
        _updateAppBarTitle(index);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Enable JavaScript in the webview
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  final List<String> _appBarTitles = [
    'Home',
    'Order',
    'Reserve',
    'Call Now',
    'Contact',
  ];

  void _updateAppBarTitle(int index) {
    setState(() {
      _appBarTitle = _appBarTitles[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await _controller.canGoBack()) {
          _controller.goBack();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF730f02),
          title: Text(
            _appBarTitle,
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          // onPageChanged: (int index) {
          //   setState(() {
          //     _selectedIndex = index;
          //   });
          // },
          children: [
            _buildWebView(_urls[0]), // Home
            _buildWebView(_urls[1]), // Order
            _buildWebView(_urls[2]), // Reserve
            _buildWebView(_urls[3]), // Reserve
            _buildWebView(_urls[4]), // Contact
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Order',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              label: 'Reserve',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.phone),
              label: 'Call Now',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.contact_mail),
              label: 'Contact',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color(0xFF730f02), // Active color
          unselectedItemColor: Colors.grey, // Inactive color
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }

  Widget _buildWebView(String url) {
    return Stack(
      children: [
        WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            _controller = controller;
          },
          userAgent:
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.190 Safari/537.36', // Set user agent to mimic Chrome
          navigationDelegate: (NavigationRequest request) {
            // Add your navigation delegate logic here
            // if (request.url.startsWith('http://')) {
            //   final secureUrl = request.url.replaceFirst('http://', 'https://');
            //   _launchURL(secureUrl);
            //   return NavigationDecision.navigate;
            // }
            if (request.url.startsWith('tel:')) {
              _handleTelLink(request.url);
              return NavigationDecision.prevent;
            } else if (request.url.startsWith('mailto:')) {
              _handleMailtoLink(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;

            // return NavigationDecision.navigate;
            // // Allow navigation only if the URL matches "example.com"
            // if (request.url.startsWith("https://example.com")) {
            //   return NavigationDecision.navigate;
            // } else {
            //   // Block navigation for all other URLs
            //   return NavigationDecision.prevent;
            // }
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (finish) {
            setState(() {
              isLoading = false;
            });
          },
        ),
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
    // return WebView(
    //   initialUrl: url,
    //   javascriptMode: JavascriptMode.unrestricted,
    //   userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.190 Safari/537.36', // Set user agent to mimic Chrome
    //   navigationDelegate: (NavigationRequest request) {
    //     // Add your navigation delegate logic here
    //     return NavigationDecision.navigate;
    //     // // Allow navigation only if the URL matches "example.com"
    //     // if (request.url.startsWith("https://example.com")) {
    //     //   return NavigationDecision.navigate;
    //     // } else {
    //     //   // Block navigation for all other URLs
    //     //   return NavigationDecision.prevent;
    //     // }
    //   },
    //
    //
    // );
  }

  Widget _buildHomeWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.home,
            size: 100,
            color: Colors.blue,
          ),
          const SizedBox(height: 20),
          Text(
            'Welcome to the Home Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            'Customized content goes here',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildCallNowWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_makePhoneCall("0131378373")],
      ),
    );
  }

  // Function to make the phone call
  _makePhoneCall(String phoneNumber) async {
    final encodedPhoneNumber = Uri.encodeComponent(phoneNumber);
    final url = 'tel:$encodedPhoneNumber';
    await launch(url);
  }

  void _handleTelLink(String url) async {
    final phoneNumber = url.substring(4); // Remove 'tel:'
    await launch('tel:$phoneNumber');
  }

  void _handleMailtoLink(String url) async {
    try {
      final emailAddress = Uri.decodeFull(url.substring(7));
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: emailAddress,
      );

      final String emailUrl = emailLaunchUri.toString();
      if (await canLaunch(emailUrl)) {
        await launch(emailUrl);
      } else {
        throw 'Could not launch $emailUrl';
      }
    } catch (e) {
      print('Error launching email client: $e');
      // Handle error gracefully, e.g., show a dialog
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
