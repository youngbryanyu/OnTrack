/* The register page */
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/auth/auth_button.dart';
import 'package:frontend/components/auth/auth_error_popup.dart';
import 'package:frontend/components/auth/auth_text_field.dart';
import 'package:frontend/components/auth/auth_logo_tile.dart';

/* Login page widget */
class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  /* Text box controllers */
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  /* Sign in function */
  Future<void> registerUser() async {
    /* Show loading circle */
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      /* Await sign up */
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      /* Pop loading circle */
      if (mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (error) {
      /* Pop loading circle */
      if (mounted) {
        Navigator.pop(context);
      }

      if (error.code == 'email-already-in-use') {
        showPopup('The email is already taken');
      } else if (error.code == 'invalid-email') {
        showPopup('The email is invalid');
      } else if (error.code == 'weak-password') {
        showPopup('Your password must be at least 6 characters long');
      }
    } catch (error) {
      showPopup('Server error occurred');
    }
  }

  /* Shows an error message popup */
  void showPopup(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AuthErrorPopup(message: message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    /* Get the screen height */
    double screenHeight = MediaQuery.of(context).size.height;

    /* Determine whether to use dark or light mode for icons */
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final String appleLogoPath = isDarkMode
        ? 'lib/images/apple-logo-dark.png'
        : 'lib/images/apple-logo-light.png';
    final String onTrackLogoPath = isDarkMode
        ? 'lib/images/ontrack-logo-dark.png'
        : 'lib/images/ontrack-logo-light.png';

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /* Logo */
                    Image.asset(
                      onTrackLogoPath,
                      height: screenHeight * .2,
                      width: screenHeight * .2,
                    ),
                    SizedBox(height: screenHeight * .01),

                    /* Welcome text*/
                    Text(
                      'Welcome to',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'OnTrack',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * .02),

                    /* Email text field */
                    AuthTextField(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false,
                    ),
                    SizedBox(height: screenHeight * .01),

                    /* Password text field */
                    AuthTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),
                    SizedBox(height: screenHeight * .01),

                    /* Register button */
                    AuthButton(
                      onTap: registerUser,
                      message: 'Sign up',
                    ),
                    SizedBox(height: screenHeight * .03),

                    /* Continue with other login options */
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'Or continue with',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * .03),

                    /* Google and Apple sign in buttons */
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /* Google button */
                        const LogoTile(imagePath: 'lib/images/google-logo.png'),
                        const SizedBox(width: 25),

                        /* Apple button */
                        LogoTile(imagePath: appleLogoPath),
                      ],
                    ),
                    SizedBox(height: screenHeight * .05),

                    /* Link to register page */
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            'Login now',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // SizedBox(height: screenHeight * .01),
                  ]),
            ),
          ),
        ));
  }
}
