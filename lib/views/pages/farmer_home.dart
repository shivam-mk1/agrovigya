import 'package:agro/views/widgets/custom_section_header.dart';
import 'package:agro/views/pages/news.dart';
import 'package:agro/providers/language_provider.dart';
import 'package:agro/services/weather.dart';
import 'package:agro/widgets/crop_recommendation_widget.dart';
import 'package:agro/widgets/labor_estimation_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FarmerHome extends StatefulWidget {
  const FarmerHome({super.key});

  @override
  State<FarmerHome> createState() => _FarmerHomeState();
}

class _FarmerHomeState extends State<FarmerHome> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final localizedStrings = languageProvider.localizedStrings;
    final double h = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xffFFF8F0),
        appBar: CustomSectionHeader(
          title: "Hello Farmer",
          showDrawer: true,
          height: 70,
          profileImage: AssetImage('assets/images/shivam.jpeg'),
          onProfilePressed: () {
            context.go('/profile');
          },
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),

                // Weather Section
                _buildSectionCard(
                  title: localizedStrings['weather'] ?? "Weather",
                  icon: Icons.wb_sunny_outlined,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha(26),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: WeatherCard(),
                  ),
                ),

                SizedBox(height: h * 0.03),

                _buildSectionCard(
                  title: localizedStrings['crops_for_you'] ?? "Crops for you",
                  icon: Icons.agriculture_outlined,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha(26),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: CropRecommendationWidget(),
                  ),
                ),

                SizedBox(height: h * 0.03),

                // Labor Estimation Section
                _buildSectionCard(
                  title: languageProvider.translate('labor_estimation'),
                  icon: Icons.groups_outlined,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha(26),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: LaborEstimationWidget(),
                  ),
                ),

                SizedBox(height: h * 0.03),

                // News Section
                _buildSectionCard(
                  title: "Latest News",
                  icon: Icons.newspaper_outlined,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha(26),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: NewsWidget(),
                  ),
                ),

                SizedBox(height: h * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Color(0xff01342C).withAlpha(13),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Color(0xff01342C), size: 20),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Color(0xff01342C),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        child,
      ],
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xff01342C).withAlpha(26),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.language, color: Color(0xff01342C), size: 24),
              ),
              // SizedBox(width: 12),
              Expanded(
                child: Text(
                  languageProvider.translate('change_language'),
                  style: TextStyle(
                    color: Color(0xff01342C),
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
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
                String langName = LanguageProvider.languageNames.values
                    .elementAt(index);

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xffFFF8F0),
                  ),
                  child: ListTile(
                    title: Text(
                      langName,
                      style: TextStyle(
                        color: Color(0xff01342C),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Icon(
                      Icons.check_circle_outline,
                      color: Color(0xFF4EBE44),
                      size: 20,
                    ),
                    onTap: () {
                      languageProvider.loadLanguage(langCode);
                      Navigator.pop(context);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
