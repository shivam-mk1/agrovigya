import 'package:agro/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLanguageDialog();
    });
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xffFFF8F0),
          title: Text(
            'Select Language/भाषा निवडा',
            style: TextStyle(
              color: Color(0xff01342C),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: LanguageProvider.languageNames.length,
              itemBuilder: (BuildContext context, int index) {
                String langCode = LanguageProvider.languageNames.keys.elementAt(
                  index,
                );
                String langName = LanguageProvider.languageNames[langCode]!;
                return ListTile(
                  title: Text(
                    langName,
                    style: TextStyle(
                      color: Color(0xff01342C),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Provider.of<LanguageProvider>(
                      context,
                      listen: false,
                    ).loadLanguage(langCode);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final localizedStrings = languageProvider.localizedStrings;
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xff01342C),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    context.go('/login/Farmer');
                  },
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        "assets/images/farmer.svg",
                        width: w * 0.4,
                      ),
                      SizedBox(height: h * 0.02),
                      Container(
                        height: h * 0.05,
                        width: w * 0.4,
                        decoration: BoxDecoration(
                          color: Color(0xff4EBE44),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            localizedStrings['farmer'] ?? 'Farmer',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: h * 0.024,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: w * 0.1),
                InkWell(
                  onTap: () {
                    context.go('/login/Employer');
                  },
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        "assets/images/employer.svg",
                        width: w * 0.4,
                      ),
                      Container(
                        height: h * 0.05,
                        width: w * 0.4,
                        decoration: BoxDecoration(
                          color: Color(0xff4EBE44),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            localizedStrings['employer'] ?? 'Employer',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: h * 0.024,
                            ),
                          ),
                        ),
                      ),
                    ],
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
