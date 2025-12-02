import 'package:agro/providers/language_provider.dart';
import 'package:agro/viewmodels/signup_viewmodel.dart';
import 'package:agro/repositories/auth_repository.dart';
import 'package:agro/services/auth_service.dart';
import 'package:agro/views/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignUp extends StatelessWidget {
  final String userType;

  const SignUp({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignupViewModel(AuthRepository(AuthService())),
      child: Consumer<SignupViewModel>(
        builder: (context, viewModel, child) {
          return SignUpView(userType: userType, viewModel: viewModel);
        },
      ),
    );
  }
}

class SignUpView extends StatefulWidget {
  final String userType;
  final SignupViewModel viewModel;

  const SignUpView({
    super.key,
    required this.userType,
    required this.viewModel,
  });

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      widget.viewModel.signUpWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;
    final languageProvider = Provider.of<LanguageProvider>(context);
    final localizedStrings = languageProvider.localizedStrings;

    if (widget.viewModel.status == AuthStatus.authenticated) {
      // Navigate to home screen after successful signup
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/main');
      });
    }

    if (widget.viewModel.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Fluttertoast.showToast(
          msg: widget.viewModel.errorMessage!,
          backgroundColor: Colors.red,
        );
      });
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Color(0xff01342C),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      localizedStrings['signup'] ?? 'Sign Up',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: h * 0.05),
                    buildTextField(
                      localizedStrings['email'] ?? "Email",
                      localizedStrings['enter registered email'] ??
                          "Enter registered email address",
                      _emailController,
                      TextInputType.emailAddress,
                      (value) {
                        if (value == null || value.isEmpty) {
                          return localizedStrings['please enter email'] ??
                              "Please enter email address";
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return localizedStrings['please enter a valid email'] ??
                              "Please enter a valid email address";
                        }
                        return null;
                      },
                      null,
                      null,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    buildTextField(
                      localizedStrings['password'] ?? "Password",
                      localizedStrings['enter password'] ??
                          "Enter your password",
                      _passwordController,
                      TextInputType.visiblePassword,
                      (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    buildTextField(
                      localizedStrings['confirm_password'] ?? "Confirm Password",
                      localizedStrings['confirm_your_password'] ??
                          "Confirm your password",
                      _confirmPasswordController,
                      TextInputType.visiblePassword,
                      (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    widget.viewModel.status == AuthStatus.authenticating
                        ? CustomLoadingWidget(color: Colors.white, size: 50)
                        : InkWell(
                            onTap: _handleSignUp,
                            child: Container(
                              width: w * 0.6,
                              height: MediaQuery.of(context).size.height * 0.05,
                              decoration: BoxDecoration(
                                color: Color(0xff4EBE44),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  localizedStrings['signup'] ?? 'Sign Up',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Divider(
                      thickness: 1,
                      color: Colors.white,
                      height: 20,
                      indent: 0,
                      endIndent: 0,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    InkWell(
                      onTap: () {
                        widget.viewModel.signInWithGoogle();
                      },
                      child: Container(
                        width: w * 0.8,
                        height: h * 0.05,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage("assets/images/google.png"),
                              height: h * 0.035,
                            ),
                            SizedBox(width: w * 0.02),
                            Text(
                              localizedStrings['google_signup'] ??
                                  'Sign up with Google',
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: h * 0.015),
                    Row(
                      children: [
                        Text(
                          localizedStrings['already_registered'] ??
                              "Already Registered?",
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {
                            context.go('/login/${widget.userType}');
                          },
                          child: Text(
                            localizedStrings['login'] ?? "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          localizedStrings['here'] ?? 'here',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    String hint,
    TextEditingController controller,
    TextInputType type,
    String? Function(String?)? validator,
    Widget? suffixIcon,
    VoidCallback? onTap,
  ) {
    final double h = MediaQuery.of(context).size.height;
    final languageProvider = Provider.of<LanguageProvider>(context);
    final localizedStrings = languageProvider.localizedStrings;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        SizedBox(height: h * 0.01),
        TextFormField(
          cursorColor: Colors.black,
          controller: controller,
          keyboardType: type,
          obscureText: label == "Password" || label == "Confirm Password" ? _obscurePassword : false,
          decoration: InputDecoration(
            suffixIcon:
                suffixIcon != null
                    ? IconButton(onPressed: onTap, icon: suffixIcon)
                    : null,
            hintText: localizedStrings[hint] ?? hint,
            fillColor: Color(0xffE1E5E2),
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.transparent,
              ), // Border color when focused
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
