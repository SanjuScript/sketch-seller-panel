import 'package:drawer_panel/FUNCTIONS/AUTH_FUNCTIONS/admin_auth_functions.dart';
import 'package:drawer_panel/HELPERS/asset_helper.dart';
import 'package:drawer_panel/SCREENS/home_screen.dart';
import 'package:drawer_panel/STORAGE/app_storage.dart';
import 'package:flutter/material.dart';

class GoogleLoginScreen extends StatelessWidget {
  const GoogleLoginScreen({super.key});

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Signing in..."),
            ],
          ),
        ),
      ),
    );
  }

  void _dismissLoadingDialog(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Image.asset(
            //     'assets/logo.png',
            //     height: 100,
            //   ),
            // ),
            const SizedBox(height: 20),
            Text(
              "Welcome Back!",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 10),
            Text(
              "Sign in with your Google account to continue.",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            InkWell(
              onTap: () async {
                _showLoadingDialog(context);

                final result =
                    await AuthenticationFn.googleLogin(context: context);

                // ScaffoldMessenger.of(context)
                //     .showSnackBar(SnackBar(content: Text(result)));

                if (result == "Google login successful!" ||
                    result == "Google sign-up successful!") {
                  _dismissLoadingDialog(context);
                  await PerfectStateManager.saveState('isAuthenticated', true);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                } else {
                  _dismissLoadingDialog(context);
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.teal,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      GetAsset.google,
                      height: 24,
                      width: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Sign in with Google",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.teal, // Teal text for consistency
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "By signing in, you agree to our ",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                GestureDetector(
                  onTap: () {
                    print("Terms & Conditions clicked");
                  },
                  child: Text(
                    "Terms & Conditions",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
