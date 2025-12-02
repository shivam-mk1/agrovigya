import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Professional {
  final String name;
  final String role;
  final String imageUrl;
  final List<SocialLink> socialLinks;

  Professional({
    required this.name,
    required this.role,
    required this.imageUrl,
    required this.socialLinks,
  });
}

class SocialLink {
  final String platform;
  final String iconPath;
  final String url;

  SocialLink({
    required this.platform,
    required this.iconPath,
    required this.url,
  });
}

class ProfessionalDirectory extends StatefulWidget {
  const ProfessionalDirectory({super.key});

  @override
  State<ProfessionalDirectory> createState() => _ProfessionalDirectoryState();
}

class _ProfessionalDirectoryState extends State<ProfessionalDirectory> {
  int? selectedMentorIndex;
  bool isFounderExpanded = false;

  final List<Professional> team = [
    Professional(
      name: "Siya Nimkar",
      role: "Researcher",
      imageUrl: "https://i.postimg.cc/PJ2jfK0m/siya-pic.jpg",
      socialLinks: [],
    ),
    Professional(
      name: "Shrut kolhe",
      role: "Researcher",
      imageUrl: "https://i.postimg.cc/KjPjcWMq/shrut-pic2-removebg-preview.png",
      socialLinks: [],
    ),
    Professional(
      name: "Suvansh Choudhary",
      role: "Developer",
      imageUrl: "https://i.ibb.co/PzCw2K7S/1000158921-01.jpg",
      socialLinks: [
        SocialLink(
          platform: 'LinkedIn',
          iconPath: 'assets/images/linkedin.png',
          url: 'https://www.linkedin.com/in/suvanshhh/',
        ),
        SocialLink(
          platform: 'Github',
          iconPath: 'assets/images/github.png',
          url: 'https://github.com/Suvanshhh',
        ),
      ],
    ),
    Professional(
      name: "Agniva Maiti",
      role: "Developer",
      imageUrl: "https://i.postimg.cc/hgzHNdVc/agniva-pic.jpg",
      socialLinks: [
        SocialLink(
          platform: 'LinkedIn',
          iconPath: 'assets/images/linkedin.png',
          url: 'https://www.linkedin.com/in/agniva-maiti/',
        ),
        SocialLink(
          platform: 'Github',
          iconPath: 'assets/images/github.png',
          url: 'https://github.com/AgnivaMaiti',
        ),
      ],
    ),
    Professional(
      name: "Shivam",
      role: "Developer",
      imageUrl: "https://i.postimg.cc/fLkx8mPW/shivam-pic.jpg",
      socialLinks: [
        SocialLink(
          platform: 'LinkedIn',
          iconPath: 'assets/images/linkedin.png',
          url: 'https://www.linkedin.com/in/shivam-2625b5210/',
        ),
        SocialLink(
          platform: 'Github',
          iconPath: 'assets/images/github.png',
          url: 'https://github.com/shivam-mk1',
        ),
      ],
    ),
    Professional(
      name: "Isha Deolekar",
      role: "Graphic and UI/UX Designer",
      imageUrl: "https://i.postimg.cc/NfMkPDmL/ISHa.jpg",
      socialLinks: [
        SocialLink(
          platform: 'LinkedIn',
          iconPath: 'assets/images/linkedin.png',
          url: 'https://www.linkedin.com/in/isha-deolekar-b48153247/',
        ),
      ],
    ),
  ];

  final List<Professional> mentors = [
    Professional(
      name: 'Adv. Ashok Potaradas',
      role: 'Vice Chairman\nCoordinator & Co-Chairman\nCOO, DES SMMC',
      imageUrl: 'https://i.ibb.co/PvGB5gpM/Ashok-palande-pic.jpg',
      socialLinks: [],
    ),
    Professional(
      name: 'Dr. Sunita Adhav',
      role: 'Principal, DES SMMC',
      imageUrl: 'https://i.ibb.co/9kCD72CN/sunita-adhav-pic.jpg',
      socialLinks: [],
    ),
    Professional(
      name: 'Anuja Sharma',
      role: 'Project Mentor',
      imageUrl: 'https://i.postimg.cc/MHWw8g36/anuja-pic.jpg',
      socialLinks: [],
    ),
    Professional(
      name: 'Dr. Aishwarya Yadav',
      role: 'Project Mentor',
      imageUrl: 'https://i.postimg.cc/Jn38vRqY/aishwarya-pic.jpg0',
      socialLinks: [],
    ),
  ];

  final Professional founder = Professional(
    name: 'Shubhra Tripathi',
    role: 'Founder & Director',
    imageUrl: "https://i.postimg.cc/65pKbJGz/shubhra-pic.jpg",
    socialLinks: [
      SocialLink(
        platform: 'LinkedIn',
        iconPath: 'assets/images/linkedin.png',
        url:
            'https://www.linkedin.com/in/shubhra-tripathi-82279b284?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app',
      ),
    ],
  );

  Future<void> _handleRefresh() async {
    try {
      imageCache.clear();
      imageCache.clearLiveImages();

      // Get all image URLs to preload
      List<String> imageUrls = [
        founder.imageUrl,
        ...mentors.map((mentor) => mentor.imageUrl),
      ];
      List<Future> preloadFutures =
          imageUrls.where((url) => url.startsWith('http')).map((url) {
            return precacheImage(NetworkImage(url), context).catchError((
              error,
            ) {
              return null;
            });
          }).toList();

      await Future.wait(preloadFutures);

      setState(() {
        selectedMentorIndex = null;
        isFounderExpanded = false;
      });

      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      setState(() {
        selectedMentorIndex = null;
        isFounderExpanded = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var s = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(toolbarHeight: 0, backgroundColor: Colors.white),
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        color: Color(0xFF4EBE44),
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(s.width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Our Founder',
                style: TextStyle(
                  fontSize: s.width * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4EBE44),
                ),
              ),
              SizedBox(height: s.height * 0.02),
              Center(
                child: SizedBox(
                  width: s.width > 600 ? s.width * 0.4 : s.width * 0.9,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isFounderExpanded = !isFounderExpanded;
                        selectedMentorIndex = null;
                      });
                    },
                    child: ProfessionalCard(
                      professional: founder,
                      isExpanded: isFounderExpanded,
                    ),
                  ),
                ),
              ),
              SizedBox(height: s.height * 0.025),
              Text(
                'Our Mentors',
                style: TextStyle(
                  fontSize: s.width * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4EBE44),
                ),
              ),
              SizedBox(height: s.height * 0.02),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: s.width > 600 ? 3 : 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: s.width * 0.03,
                  mainAxisSpacing: s.height * 0.0125,
                ),
                itemCount: mentors.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedMentorIndex == index;
                  return ProfessionalCard(
                    professional: mentors[index],
                    isExpanded: isSelected,
                  );
                },
              ),
              SizedBox(height: s.height * 0.025),
              Text(
                'Our Team',
                style: TextStyle(
                  fontSize: s.width * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4EBE44),
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: s.width > 600 ? 3 : 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: s.width * 0.03,
                  mainAxisSpacing: s.height * 0.0125,
                ),
                itemCount: team.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedMentorIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedMentorIndex = isSelected ? null : index;
                        isFounderExpanded = false;
                      });
                    },
                    child: ProfessionalCard(
                      professional: team[index],
                      isExpanded: isSelected,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfessionalCard extends StatefulWidget {
  final Professional professional;
  final bool isExpanded;

  const ProfessionalCard({
    super.key,
    required this.professional,
    required this.isExpanded,
  });

  @override
  State<ProfessionalCard> createState() => _ProfessionalCardState();
}

class _ProfessionalCardState extends State<ProfessionalCard> {
  @override
  Widget build(BuildContext context) {
    var s = MediaQuery.sizeOf(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(s.width * 0.05),
          bottomLeft: Radius.circular(s.width * 0.05),
        ),
        color:
            widget.isExpanded
                ? const Color(0xFFB5D6B6)
                : const Color(0xFFF1F8E9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(widget.isExpanded ? 25 : 12),
            spreadRadius:
                widget.isExpanded ? s.width * 0.005 : s.width * 0.0025,
            blurRadius: widget.isExpanded ? s.width * 0.02 : s.width * 0.01,
            offset: Offset(
              0,
              widget.isExpanded ? s.height * 0.005 : s.height * 0.0025,
            ),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(s.width * 0.05),
          bottomLeft: Radius.circular(s.width * 0.05),
        ),
        child: Stack(
          children: [
            SizedBox(
              height: s.height * 0.3,
              child: Column(
                children: [
                  Container(
                    height: s.height * 0.2,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(s.width * 0.05),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(s.width * 0.05),
                      ),
                      child: _buildImage(),
                    ),
                  ),

                  Expanded(
                    child: Container(
                      height: s.height * 0.1,
                      padding: EdgeInsets.all(s.width * 0.01),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              widget.professional.name,
                              style: TextStyle(
                                fontSize: s.width * 0.035,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF4EBE44),
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: s.height * 0.005),
                          Expanded(
                            child: Text(
                              widget.professional.role,
                              style: TextStyle(
                                fontSize: s.width * 0.025,
                                color: Colors.grey[700],
                                height: 1.2,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.isExpanded)
              Container(
                height: s.height * 0.3,
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(128),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(s.width * 0.05),
                    bottomLeft: Radius.circular(s.width * 0.05),
                  ),
                ),
                child: Center(child: _buildSocialIcons()),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (widget.professional.imageUrl.startsWith('http')) {
      return Image.network(
        widget.professional.imageUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
      );
    } else {
      return Image.asset(
        widget.professional.imageUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
      );
    }
  }

  Widget _buildPlaceholderImage() {
    var s = MediaQuery.sizeOf(context);
    return Container(
      color: Colors.grey[200],
      child: Icon(Icons.person, size: s.width * 0.15, color: Colors.grey),
    );
  }

  Widget _buildSocialIcons() {
    var s = MediaQuery.sizeOf(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          widget.professional.socialLinks.map((socialLink) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: s.width * 0.02),
              child: GestureDetector(
                onTap: () async {
                  if (socialLink.url.isNotEmpty) {
                    final Uri url = Uri.parse(socialLink.url);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  }
                },
                child: Container(
                  width: s.width * 0.1,
                  height: s.width * 0.1,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(s.width * 0.02),
                    child: Image.asset(
                      socialLink.iconPath,
                      fit: BoxFit.contain,
                      errorBuilder:
                          (context, error, stackTrace) => Icon(
                            _getIconForPlatform(socialLink.platform),
                            color: _getColorForPlatform(socialLink.platform),
                            size: s.width * 0.05,
                          ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  IconData _getIconForPlatform(String platform) {
    switch (platform.toLowerCase()) {
      case 'facebook':
        return Icons.facebook;
      case 'linkedin':
        return Icons.business;
      case 'twitter':
        return Icons.alternate_email;
      default:
        return Icons.link;
    }
  }

  Color _getColorForPlatform(String platform) {
    switch (platform.toLowerCase()) {
      case 'facebook':
        return const Color(0xFF1877F2);
      case 'linkedin':
        return const Color(0xFF0A66C2);
      case 'twitter':
        return const Color(0xFF1DA1F2);
      default:
        return Colors.grey;
    }
  }
}
