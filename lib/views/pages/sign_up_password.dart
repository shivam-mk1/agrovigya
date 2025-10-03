import 'package:agro/providers/language_provider.dart';
import 'package:agro/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignUpPassword extends StatefulWidget {
  final String email;
  const SignUpPassword({super.key, required this.email});

  @override
  State<SignUpPassword> createState() => _SignUpPasswordState();
}

class _SignUpPasswordState extends State<SignUpPassword> {
  final authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final TextEditingController passwordController = TextEditingController(),
      confirmPasswordController = TextEditingController();

  void _handleSignUp() async {
    if (_formKey.currentState!.validate() &&
        passwordController.text == confirmPasswordController.text) {
      authService.signUpWithEmailAndPassword(
        widget.email,
        passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: const Color(0xff01342C),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12, left: 12, top: 20),
                  child: Text(
                    'Sign Up',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                      color: Colors.white,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        buildTextField(
                          labelKey: "Password",
                          hintKey: "Ex: JohnDoe@123",
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          suffixIcon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onSuffixTap:
                              () => setState(() {
                                _obscurePassword = !_obscurePassword;
                              }),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        buildTextField(
                          labelKey: "Confirm Password",
                          hintKey: "Ex: JohnDoe@123",
                          controller: confirmPasswordController,
                          keyboardType: TextInputType.visiblePassword,
                          suffixIcon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onSuffixTap:
                              () => setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              }),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 40),
                        InkWell(
                          onTap: _handleSignUp,
                          child: Container(
                            width: 200,
                            height: MediaQuery.of(context).size.height * 0.05,
                            decoration: BoxDecoration(
                              color: Color(0xff4EBE44),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Divider(color: Colors.white54),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                context.go('/login/Farmer');
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required String labelKey,
    required String hintKey,
    required TextEditingController controller,
    required TextInputType keyboardType,
    String? Function(String?)? validator,
    Widget? suffixIcon,
    VoidCallback? onSuffixTap,
  }) {
    final double h = MediaQuery.of(context).size.height;
    final languageProvider = Provider.of<LanguageProvider>(context);
    final localizedStrings = languageProvider.localizedStrings;

    // Determine if the field is a password-related field
    bool isPasswordField =
        labelKey == 'password' || labelKey == 'confirm_password';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            localizedStrings[labelKey] ?? labelKey,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        SizedBox(height: h * 0.01),
        TextFormField(
          cursorColor: Colors.black,
          controller: controller,
          keyboardType: keyboardType,
          obscureText:
              isPasswordField
                  ? (labelKey == 'password'
                      ? _obscurePassword
                      : _obscureConfirmPassword)
                  : false,
          decoration: InputDecoration(
            suffixIcon:
                suffixIcon != null
                    ? IconButton(onPressed: onSuffixTap, icon: suffixIcon)
                    : null,
            hintText: localizedStrings[hintKey] ?? hintKey,
            fillColor: const Color(0xffE1E5E2),
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
