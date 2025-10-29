import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SelectUserRole extends StatefulWidget {
  const SelectUserRole({super.key});

  @override
  State<SelectUserRole> createState() => _SelectUserRoleState();
}

class _SelectUserRoleState extends State<SelectUserRole>
    with SingleTickerProviderStateMixin {
  String selectedUserType = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.orange.shade50, Colors.white, Colors.green.shade50],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        "Select User Type",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Choose your role to continue",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        userTypeButton(
                          context,
                          "Farmer",
                          "assets/lotties/farmer.json",
                          Colors.green,
                          Icons.agriculture,
                        ),
                        const SizedBox(height: 24),
                        userTypeButton(
                          context,
                          "Employer",
                          "assets/lotties/employer.json",
                          Colors.blue,
                          Icons.business_center,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              if (selectedUserType.isEmpty) {
                                Fluttertoast.showToast(
                                  msg: "Please select a user type",
                                  gravity: ToastGravity.BOTTOM,
                                  textColor: Colors.white,
                                  backgroundColor: Colors.red,
                                  fontSize: 16,
                                );
                              } else {
                                context.go('/login/$selectedUserType');
                              }
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors:
                                      selectedUserType.isEmpty
                                          ? [
                                            Colors.grey.shade400,
                                            Colors.grey.shade500,
                                          ]
                                          : [
                                            Colors.orange.shade400,
                                            Colors.orange.shade600,
                                          ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        selectedUserType.isEmpty
                                            ? Colors.grey.withOpacity(0.3)
                                            : Colors.orange.withOpacity(0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 40,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Continue",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget userTypeButton(
    BuildContext context,
    String userType,
    String lottieAsset,
    Color color,
    IconData icon,
  ) {
    bool isSelected = selectedUserType == userType;

    return AnimatedScale(
      scale: isSelected ? 1.0 : 0.95,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              selectedUserType = userType;
            });
          },
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(isSelected ? 0.5 : 0.3),
                  blurRadius: isSelected ? 16 : 8,
                  spreadRadius: isSelected ? 2 : 0,
                  offset: Offset(0, isSelected ? 8 : 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(icon, color: Colors.white, size: 32),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          userType,
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isSelected ? "Selected" : "Tap to select",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Lottie.asset(
                    lottieAsset,
                    width: 140,
                    height: 140,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
