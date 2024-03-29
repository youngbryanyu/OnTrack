/* The register page */
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/auth/components/auth_button.dart';
import 'package:frontend/common/components/popup_dialog.dart';
import 'package:frontend/features/auth/components/auth_text_field.dart';
import 'package:frontend/features/auth/providers/auth_page_state_provider.dart';
import 'package:frontend/features/syncing/providers/syncing_page_state_provider.dart';
// import 'package:frontend/components/auth/auth_logo_tile.dart';
// import 'package:frontend/services/auth/auth_service.dart';

/* Login page widget */
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  /* Text box controllers */
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  /* whether to show password */
  bool passwordVisible = false;

  /* Sign in function */
  Future<void> registerUser() async {
    /* Show loading circle */
    showDialog(
      context: context,
      barrierDismissible: false,
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

      /* Send verification email */
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        user.sendEmailVerification(); /* Send in background */
      }

      /* Pop loading circle */
      if (mounted) {
        Navigator.pop(context);
      }

      /* Switch to syncing page selector */
      ref.read(authPageStateProvider.notifier).state = AuthPageState.syncing;
      ref.read(syncingPageStateProvider.notifier).state =
          SyncingPageState.syncing;
    } on FirebaseAuthException catch (error) {
      /* Pop loading circle */
      if (mounted) {
        Navigator.pop(context);
      }

      if (error.code == 'email-already-in-use') {
        if (mounted) {
          showAuthPopup(
            context,
            'Email already taken',
            'The email is already taken. Try logging in. If you forgot your password, you can reset it.',
          );
        }
      } else if (error.code == 'invalid-email') {
        if (mounted) {
          showAuthPopup(
            context,
            'Invalid email',
            'Please enter a valid email address',
          );
        }
      } else if (error.code == 'weak-password') {
        if (mounted) {
          showAuthPopup(
            context,
            'Invalid password',
            'Your password must be at least 6 characters long',
          );
        }
      } else if (error.code == 'operation-not-allowed') {
        if (mounted) {
          showAuthPopup(
            context,
            'Registration failed',
            'Email-based sign up is currently disabled.',
          );
        }
      } else if (error.code == 'too-many-requests') {
        if (mounted) {
          showAuthPopup(
            context,
            'Registration failed',
            'Too many recent sign up requests. Please try again later.',
          );
        }
      } else {
        /* Group all other errors together */
        if (mounted) {
          showAuthPopup(
            context,
            'Registration failed',
            'Unknown error occurred. Please try again later.',
          );
        }
      }
    } catch (error) {
      if (mounted) {
        showAuthPopup(
          context,
          'Registration failed',
          'Server error occurred. Please try again later.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    /* Get the screen height */
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    /* Determine whether to use dark or light mode for icons */
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final String onTrackLogoPath = isDarkMode
        ? 'lib/assets/images/ontrack-logo-dark.png'
        : 'lib/assets/images/ontrack-logo-light.png';

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    SizedBox(height: screenHeight * .01),

                    /* Logo */
                    Image.asset(
                      onTrackLogoPath,
                      height: screenHeight * .2,
                      width: screenHeight * .2,
                    ),
                    SizedBox(height: screenHeight * .01),

                    Text(
                      'Super simple exercise and macro tracking',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 14,
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
                      obscureText: !passwordVisible,
                      suffixIcon: Icon(
                        passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      onTap: () {
                        // Handle the icon tap
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                    SizedBox(height: screenHeight * .01),

                    /* Register button */
                    AuthButton(
                      onTap: registerUser,
                      message: 'Sign up',
                    ),
                    SizedBox(height: screenHeight * .03),

                    /* Continue with other login options */
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 25),
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         child: Divider(
                    //           thickness: 0.5,
                    //           color: Theme.of(context).colorScheme.surface,
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.symmetric(horizontal: 10),
                    //         child: Text(
                    //           'Or continue with',
                    //           style: TextStyle(
                    //             color: Theme.of(context).colorScheme.surface,
                    //           ),
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: Divider(
                    //           thickness: 0.5,
                    //           color: Theme.of(context).colorScheme.surface,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: screenHeight * .03),

                    /* 3P sign in buttons */
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     /* Google button */
                    //     LogoTile(
                    //       imagePath: 'lib/images/google-logo.png',
                    //       onTap: () => AuthService(context).signInWithGoogle(),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(height: screenHeight * .05),

                    /* Link to register page */
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        SizedBox(width: screenWidth * .01),
                        GestureDetector(
                          onTap: () {
                            ref.read(authPageStateProvider.notifier).state =
                                AuthPageState.login;
                          },
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
