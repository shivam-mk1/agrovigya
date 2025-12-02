import 'dart:ui';
import 'package:agro/views/pages/team_page.dart';
import 'package:agro/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;
    final padding = screenWidth * 0.05; // 5% of screen width
    final fontScale = screenWidth / 375; // Base width for scaling fonts

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with Hero Image
          SliverAppBar(
            expandedHeight: screenHeight * 0.4,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFF147b2c),
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Hero Image with Gradient Overlay
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/about.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withAlpha(77),
                          Colors.black.withAlpha(179),
                        ],
                      ),
                    ),
                  ),
                  // Logo and Title
                  Positioned(
                    top:
                        MediaQuery.of(context).padding.top +
                        screenHeight * 0.025,
                    left: padding,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(padding * 0.4),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(51),
                              borderRadius: BorderRadius.circular(
                                padding * 0.6,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                padding * 0.2,
                              ),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: padding * 0.5,
                                  sigmaY: padding * 0.5,
                                ),
                                child: Image(
                                  image: const AssetImage(
                                    'assets/images/trim_logo.png',
                                  ),
                                  height: screenHeight * 0.04,
                                  width: screenHeight * 0.04,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: padding * 0.6),
                          Text(
                            'Agrovigya',
                            style: TextStyle(
                              fontSize: 24 * fontScale,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Main Title
                  Positioned(
                    bottom: screenHeight * 0.05,
                    left: padding,
                    right: padding,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About Us',
                            style: TextStyle(
                              fontSize: 36 * fontScale,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(height: padding * 0.4),
                          Text(
                            'Transforming Agriculture for Tomorrow',
                            style: TextStyle(
                              fontSize: 18 * fontScale,
                              color: Colors.white.withAlpha(230),
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // Main Description Card
                  Container(
                    margin: EdgeInsets.all(padding),
                    padding: EdgeInsets.all(padding * 1.2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(padding),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha(26),
                          spreadRadius: screenWidth * 0.005,
                          blurRadius: padding * 0.5,
                          offset: Offset(0, padding * 0.25),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ModernSectionTitle(
                          title:
                              'Transforming Agriculture, Empowering Rural Workforce',
                          subtitle:
                              'Bridging Employment Gaps for a Sustainable Future',
                          fontScale: fontScale,
                        ),
                        SizedBox(height: padding),
                        _buildDescriptionText(
                          'Agrovigya is a pioneering digital platform committed to transforming India\'s agricultural landscape by addressing disguised unemployment and fostering sustainable livelihoods. Our mission is to empower farmers, job seekers, and rural workers by integrating technology-driven solutions that bridge the gap between agriculture, employment, and skill development.',
                          fontScale,
                        ),
                        SizedBox(height: padding * 0.8),
                        _buildDescriptionText(
                          'Through data-driven crop recommendations, labor estimation tools, and job-matching services, we optimize agricultural productivity while connecting job seekers with relevant employment opportunities. Agrovigya also facilitates upskilling programs to enhance employability and provides seamless access to government schemes, subsidies, and financial aid.',
                          fontScale,
                        ),
                        SizedBox(height: padding * 0.8),
                        _buildDescriptionText(
                          'By leveraging AI-driven insights and a user-friendly interface, we ensure accessibility and efficiency in rural workforce development. Our platform is more than just an app—it\'s a movement toward economic self-sufficiency, enabling farmers to increase their earnings, reducing unemployment, and creating a sustainable, technology-driven agricultural ecosystem.',
                          fontScale,
                        ),
                      ],
                    ),
                  ),

                  // Vision Section
                  _buildFeatureSection(
                    title: 'Our Vision',
                    image: 'assets/images/about_1.jpg',
                    description:
                        'At Agrovigya, we envision a future where agriculture thrives through modernization, rural employment is optimized, and individuals have access to the skills and opportunities necessary for economic growth. Our goal is to create a sustainable ecosystem where farmers maximize productivity through data-driven insights, job seekers find meaningful employment beyond agriculture, and skill development bridges the gap between industry needs and workforce capabilities.',
                    additionalText:
                        'By integrating technology, innovation, and government support, we strive to empower rural communities, reduce disguised unemployment, and foster a resilient agricultural economy that is both profitable and future-ready.',
                    isReversed: false,
                    padding: padding,
                    screenHeight: screenHeight,
                    fontScale: fontScale,
                  ),

                  // Mission Section
                  _buildFeatureSection(
                    title: 'Our Mission',
                    image: 'assets/images/about_2.jpg',
                    description:
                        'Our mission is to empower farmers with smarter agricultural practices, connect job seekers with meaningful employment opportunities, and bridge skill gaps through targeted upskilling programs. By integrating government schemes, financial support, and industry-driven training, we aim to enhance productivity, increase incomes, and create a self-reliant rural economy.',
                    additionalText:
                        'Through innovation and collaboration, we strive to build a future where agriculture is sustainable, employment is accessible, and every individual has the tools to achieve economic growth.',
                    isReversed: true,
                    padding: padding,
                    screenHeight: screenHeight,
                    fontScale: fontScale,
                  ),

                  // Key Features Section
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: padding,
                      vertical: padding * 0.5,
                    ),
                    child: Column(
                      children: [
                        ModernSectionTitle(
                          title: 'What We Offer',
                          subtitle:
                              'Comprehensive solutions for agricultural excellence',
                          fontScale: fontScale,
                        ),
                        SizedBox(height: padding * 1.2),
                        _buildFeatureGrid(padding, screenWidth, fontScale),
                      ],
                    ),
                  ),

                  // Team Button Section
                  Container(
                    margin: EdgeInsets.all(padding),
                    padding: EdgeInsets.all(padding * 1.2),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF147b2c),
                          const Color(0xFF1a9b35),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(padding),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF147b2c).withAlpha(77),
                          spreadRadius: screenWidth * 0.005,
                          blurRadius: padding * 0.75,
                          offset: Offset(0, padding * 0.4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.groups_rounded,
                          color: Colors.white,
                          size: screenHeight * 0.06,
                        ),
                        SizedBox(height: padding * 0.8),
                        Text(
                          'Meet Our Team',
                          style: TextStyle(
                            fontSize: 24 * fontScale,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: padding * 0.4),
                        Text(
                          'Get to know the passionate individuals behind Agrovigya',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16 * fontScale,
                            color: Colors.white.withAlpha(230),
                          ),
                        ),
                        SizedBox(height: padding),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfessionalDirectory(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF147b2c),
                            padding: EdgeInsets.symmetric(
                              horizontal: padding * 1.6,
                              vertical: padding * 0.8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                padding * 1.5,
                              ),
                            ),
                            elevation: 5,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.arrow_forward_rounded),
                              SizedBox(width: padding * 0.4),
                              Text(
                                languageProvider.translate('Meet Our Team'),
                                style: TextStyle(
                                  fontSize: 16 * fontScale,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionText(String text, double fontScale) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16 * fontScale,
        height: 1.6,
        color: Colors.grey[700],
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildFeatureSection({
    required String title,
    required String image,
    required String description,
    required String additionalText,
    required bool isReversed,
    required double padding,
    required double screenHeight,
    required double fontScale,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: padding,
        vertical: padding * 0.5,
      ),
      child: Card(
        elevation: 8,
        shadowColor: Colors.grey.withAlpha(51),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(padding),
        ),
        child: Container(
          padding: EdgeInsets.all(padding * 1.2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(padding),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.grey[50]!],
            ),
          ),
          child: Column(
            children: [
              ModernSectionTitle(title: title, fontScale: fontScale),
              SizedBox(height: padding * 1.2),
              if (!isReversed) ...[
                _buildRoundedImage(image, screenHeight, padding),
                SizedBox(height: padding),
              ],
              _buildDescriptionText(description, fontScale),
              SizedBox(height: padding * 0.8),
              _buildDescriptionText(additionalText, fontScale),
              if (isReversed) ...[
                SizedBox(height: padding),
                _buildRoundedImage(image, screenHeight, padding),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoundedImage(
    String imagePath,
    double screenHeight,
    double padding,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(padding * 0.8),
      child: Container(
        height: screenHeight * 0.25,
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(78),
              spreadRadius: padding * 0.1,
              blurRadius: padding * 0.4,
              offset: Offset(0, padding * 0.2),
            ),
          ],
        ),
        child: Image(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildFeatureGrid(
    double padding,
    double screenWidth,
    double fontScale,
  ) {
    final features = [
      {
        'icon': Icons.agriculture_outlined,
        'title': 'Smart Farming',
        'description': 'AI-driven crop recommendations',
      },
      {
        'icon': Icons.work_outline,
        'title': 'Job Matching',
        'description': 'Connect with opportunities',
      },
      {
        'icon': Icons.school_outlined,
        'title': 'Skill Development',
        'description': 'Upskilling programs',
      },
      {
        'icon': Icons.account_balance_outlined,
        'title': 'Government Schemes',
        'description': 'Access subsidies & aid',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: screenWidth > 600 ? 4 : 2,
        crossAxisSpacing: padding * 0.6,
        mainAxisSpacing: padding * 0.9,
        childAspectRatio: 1.1,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(padding * 0.9),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(26),
                spreadRadius: padding * 0.05,
                blurRadius: padding * 0.4,
                offset: Offset(0, padding * 0.2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(padding * 0.4),
                decoration: BoxDecoration(
                  color: const Color(0xFF147b2c).withAlpha(26),
                  borderRadius: BorderRadius.circular(padding * 0.6),
                ),
                child: Icon(
                  feature['icon'] as IconData,
                  color: const Color(0xFF147b2c),
                  size: screenWidth * 0.08,
                ),
              ),
              SizedBox(height: padding * 0.4),
              Text(
                feature['title'] as String,
                style: TextStyle(
                  fontSize: 16 * fontScale,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff4EBE44),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: padding * 0.1),
              Expanded(
                child: Text(
                  feature['description'] as String,
                  style: TextStyle(
                    fontSize: 12 * fontScale,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ModernSectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final double fontScale;

  const ModernSectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.fontScale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 28 * fontScale,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF147b2c),
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: fontScale * 8),
        Container(
          width: fontScale * 60,
          height: fontScale * 4,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF147b2c), Color(0xFF1a9b35)],
            ),
            borderRadius: BorderRadius.circular(fontScale * 2),
          ),
        ),
        if (subtitle != null) ...[
          SizedBox(height: fontScale * 12),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 16 * fontScale,
              color: Colors.grey[600],
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

class ContactItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final double fontScale;

  const ContactItem({
    super.key,
    required this.icon,
    required this.text,
    this.fontScale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).size.width * 0.05;
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF147b2c), size: 20 * fontScale),
        SizedBox(width: padding * 0.6),
        Text(text, style: TextStyle(fontSize: 16 * fontScale)),
      ],
    );
  }
}

class TeamMember extends StatefulWidget {
  const TeamMember({super.key});

  @override
  State<TeamMember> createState() => _TeamMemberState();
}

class _TeamMemberState extends State<TeamMember> {
  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).size.width * 0.05;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
        crossAxisSpacing: padding * 0.5,
        mainAxisSpacing: padding * 0.5,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        return Container();
      },
    );
  }
}
