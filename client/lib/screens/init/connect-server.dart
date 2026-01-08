import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ripple_client/extensions/color.dart';
import 'package:ripple_client/extensions/context.dart';
import 'package:ripple_client/providers/api_provider.dart';

class ConnectServerScreen extends HookConsumerWidget {
  const ConnectServerScreen({super.key});

  Future<String?> verifyServerUrl(BuildContext context, String urlStr) async {
    final url = Uri.tryParse(urlStr.trim());

    if (url == null) {
      context.showSnackBar('Please enter a valid URL.');
      return null;
    }

    try {
      final dio = Dio();
      final res = await dio.getUri(url.replace(path: '/ping'));

      if (!context.mounted) {
        return null;
      }
      if (res.statusCode == 200) {
        final data = res.data;
        if (data is Map<String, dynamic> && data['pong'] == true) {
          return url.toString();
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = context.tp.isDarkMode;
    final pedningReq = useState(false);
    final textController = useTextEditingController();

    return Scaffold(
      body: Stack(
        children: [
          /// --- Background blobs ---
          Positioned(
            top: -200,
            left: -150,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                color: context.tp.colors.primary.wOpacity(0.20),
                borderRadius: BorderRadius.circular(300),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: const SizedBox(),
              ),
            ),
          ),
          Positioned(
            bottom: -200,
            right: -150,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(300),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: const SizedBox(),
              ),
            ),
          ),

          Column(
            children: [
              /// --- Main Card ---
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Card(
                      elevation: 12,
                      surfaceTintColor: Colors.transparent,
                      color: theme.colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isDark
                              ? const Color(0xFF283039)
                              : Colors.grey.shade300,
                        ),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// --- Hero gradient ---
                          Container(
                            height: 120,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  theme.colorScheme.primary,
                                  Colors.blue.shade600,
                                ],
                              ),
                            ),
                            child: Center(
                              child: Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                  // backdropFilter: ImageFilter.blur(
                                  //   sigmaX: 10,
                                  //   sigmaY: 10,
                                  // ),
                                ),
                                child: const Icon(
                                  Icons.dns,
                                  size: 34,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                /// Headline
                                Text(
                                  "Connect to your server",
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.headlineSmall!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Enter your home server URL to start chatting securely with your team.",
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                    color: isDark
                                        ? Colors.grey.shade400
                                        : Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 28),

                                /// Input field
                                TextField(
                                  controller: textController,
                                  readOnly: pedningReq.value,
                                  decoration: InputDecoration(
                                    labelText: "Server URL",
                                    prefixIcon: const Icon(Icons.link),
                                    hintText: "https://chat.your-domain.com",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                /// Buttons
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: FilledButton(
                                    onPressed: () async {
                                      if (pedningReq.value) return;
                                      pedningReq.value = true;
                                      final urlTxt = textController.text;

                                      final error = await ref
                                          .read(apiConfigProvider.notifier)
                                          .connectServer(urlTxt);
                                      if (!context.mounted) return;
                                      if (error != null) {
                                        context.showSnackBar(error);
                                      } else {
                                        context.go('/login');
                                      }

                                      pedningReq.value = false;
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          pedningReq.value
                                              ? "Connecting..."
                                              : "Connect",
                                        ),
                                        SizedBox(width: 8),
                                        Icon(Icons.arrow_forward, size: 18),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      context.go('/welcome');
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              /// Footer
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  "By connecting, you agree to our Terms of Service and Privacy Policy.",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
