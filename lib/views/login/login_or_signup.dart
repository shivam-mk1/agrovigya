import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SelectUserRole extends StatefulWidget {
  const SelectUserRole({super.key});

  @override
  State<SelectUserRole> createState() => _SelectUserRoleState();
}

class _SelectUserRoleState extends State<SelectUserRole> {
  String selectedUserType = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Select User Type",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                userTypeButton(
                  context,
                  "Farmer",
                  "assets/lotties/farmer.json",
                  Colors.green,
                ),
                SizedBox(height: 20),
                userTypeButton(
                  context,
                  "Employer",
                  "assets/lotties/employer.json",
                  Colors.blue,
                ),
              ],
            ),
            SizedBox(height: 40),
            InkWell(
              onTap: () {
                if (selectedUserType.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Please select a user type",
                    gravity: ToastGravity.BOTTOM,
                    textColor: Colors.white,
                    backgroundColor: Colors.red,
                  );
                } else {
                  context.go('/login/$selectedUserType');
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.orange,
                  border: Border.all(color: Colors.black54),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 30,
                  ),
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget userTypeButton(
    BuildContext context,
    String userType,
    String lottieAsset,
    Color color,
  ) {
    bool isSelected = selectedUserType == userType;

    return InkWell(
      onTap: () {
        setState(() {
          selectedUserType = userType;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.black54,
            width: isSelected ? 4 : 1,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ]
                  : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              userType,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Lottie.asset(lottieAsset, width: 250, height: 250),
          ],
        ),
      ),
    );
  }
}
