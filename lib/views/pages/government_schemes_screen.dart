import 'dart:convert';
import 'package:agro/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GovernmentSchemes extends StatefulWidget {
  const GovernmentSchemes({super.key});

  @override
  State<GovernmentSchemes> createState() => _GovernmentSchemesState();
}

class _GovernmentSchemesState extends State<GovernmentSchemes>
    with TickerProviderStateMixin {
  List<Map<String, String>> schemes = [];
  List<Map<String, String>> filteredSchemes = [];
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    loadSchemes();
    _searchController.addListener(_filterSchemes);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> loadSchemes() async {
    try {
      final String jsonString = await DefaultAssetBundle.of(
        context,
      ).loadString('assets/data/govt_schemes.json');
      final List<dynamic> jsonData = jsonDecode(jsonString);
      setState(() {
        schemes =
            jsonData.map((item) => Map<String, String>.from(item)).toList();
        filteredSchemes = schemes;
      });
      _animationController.forward();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error : $e"), backgroundColor: Colors.red),
      );
    }
  }

  void _filterSchemes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredSchemes =
          schemes.where((scheme) {
            return (scheme['Scheme Name'] ?? '').toLowerCase().contains(
                  query,
                ) ||
                (scheme['Scheme Type'] ?? '').toLowerCase().contains(query) ||
                (scheme['Target Audience'] ?? '').toLowerCase().contains(query);
          }).toList();
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final localizedStrings = languageProvider.localizedStrings;

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFF8FFFE),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(160),
          child: Container(
            decoration: BoxDecoration(color: Color(0xFF01342C)),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            localizedStrings['government schemes'] ??
                                "Government Schemes",
                            style: const TextStyle(
                              color: Color(0xFFFFF8F0),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF4EBE44).withAlpha(53),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: () {
                              _scaffoldKey.currentState?.openEndDrawer();
                            },
                            icon: const Icon(
                              Icons.menu,
                              color: Color(0xFFFFF8F0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFFFFF8F0),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(28),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _searchController,
                              cursorColor: const Color(0xFF01342C),
                              decoration: InputDecoration(
                                hintText: "Search schemes...",
                                hintStyle: TextStyle(
                                  color: Color(0xFF01342C).withAlpha(155),
                                  fontSize: 16,
                                ),
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  color: Color(0xFF01342C).withAlpha(155),
                                  size: 24,
                                ),
                                suffixIcon:
                                    _searchController.text.isNotEmpty
                                        ? IconButton(
                                          onPressed: () {
                                            _searchController.clear();
                                          },
                                          icon: Icon(
                                            Icons.clear_rounded,
                                            color: Color(
                                              0xFF01342C,
                                            ).withAlpha(155),
                                          ),
                                        )
                                        : IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.mic_rounded,
                                            color: Color(
                                              0xFF01342C,
                                            ).withAlpha(155),
                                          ),
                                        ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Color(0xFF4EBE44).withAlpha(53),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.tune_rounded,
                              color: Color(0xFFFFF8F0),
                              size: 24,
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
        body:
            schemes.isEmpty
                ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF2E7D65),
                    ),
                  ),
                )
                : FadeTransition(
                  opacity: _fadeAnimation,
                  child: buildSchemeListView(filteredSchemes),
                ),
      ),
    );
  }

  Widget buildSchemeListView(List<Map<String, String>> schemes) {
    if (schemes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              "No schemes found",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Try adjusting your search terms",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24.0),
      itemCount: schemes.length,
      itemBuilder: (context, index) {
        final scheme = schemes[index];
        return AnimatedContainer(
          duration: Duration(milliseconds: 300 + (index * 100)),
          curve: Curves.easeOutBack,
          margin: const EdgeInsets.only(bottom: 20),
          child: SchemeCard(scheme: scheme, index: index),
        );
      },
    );
  }
}

class SchemeCard extends StatefulWidget {
  final Map<String, String> scheme;
  final int index;

  const SchemeCard({super.key, required this.scheme, required this.index});

  @override
  State<SchemeCard> createState() => _SchemeCardState();
}

class _SchemeCardState extends State<SchemeCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _cardAnimationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(
        parent: _cardAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _cardAnimationController.dispose();
    super.dispose();
  }

  Color _getSchemeTypeColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'employment':
        return const Color(0xFF4CAF50);
      case 'financial':
        return const Color(0xFF2196F3);
      case 'agricultural':
        return const Color(0xFF8BC34A);
      case 'education':
        return const Color(0xFFFF9800);
      case 'health':
        return const Color(0xFFE91E63);
      default:
        return const Color(0xFF9C27B0);
    }
  }

  IconData _getSchemeTypeIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'employment':
        return Icons.work_rounded;
      case 'financial':
        return Icons.account_balance_wallet_rounded;
      case 'agricultural':
        return Icons.agriculture_rounded;
      case 'education':
        return Icons.school_rounded;
      case 'health':
        return Icons.health_and_safety_rounded;
      default:
        return Icons.account_balance_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final schemeType = widget.scheme['Scheme Type'] ?? 'General';
    final typeColor = _getSchemeTypeColor(schemeType);
    final typeIcon = _getSchemeTypeIcon(schemeType);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTapDown: (_) => _cardAnimationController.forward(),
            onTapUp: (_) => _cardAnimationController.reverse(),
            onTapCancel: () => _cardAnimationController.reverse(),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: typeColor.withAlpha(28),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(typeIcon, color: typeColor, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.scheme['Scheme Name'] ?? 'Unknown Scheme',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: typeColor.withAlpha(28),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                schemeType,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: typeColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey.shade400,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildQuickInfo(),
                  AnimatedCrossFade(
                    firstChild: const SizedBox.shrink(),
                    secondChild: _buildExpandedContent(),
                    crossFadeState:
                        _isExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickInfo() {
    return Row(
      children: [
        _buildInfoChip(
          Icons.attach_money_rounded,
          widget.scheme['Income Level'] ?? 'N/A',
          const Color(0xFF4CAF50),
        ),
        const SizedBox(width: 12),
        _buildInfoChip(
          Icons.location_on_rounded,
          widget.scheme['States Eligible'] ?? 'N/A',
          const Color(0xFF2196F3),
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withAlpha(28),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FFFE),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              _buildDetailRow(
                'Duration',
                widget.scheme['Duration'] ?? 'N/A',
                Icons.schedule_rounded,
              ),
              _buildDetailRow(
                'Job Type',
                widget.scheme['Job Type'] ?? 'N/A',
                Icons.work_outline_rounded,
              ),
              _buildDetailRow(
                'Target Audience',
                widget.scheme['Target Audience'] ?? 'N/A',
                Icons.group_rounded,
              ),
              _buildDetailRow(
                'Location',
                widget.scheme['Location'] ?? 'N/A',
                Icons.place_rounded,
              ),
              _buildDetailRow(
                'Status',
                widget.scheme['Scheme Status'] ?? 'N/A',
                Icons.info_outline_rounded,
              ),
              _buildDetailRow(
                'Ministry',
                widget.scheme['Ministry'] ?? 'N/A',
                Icons.account_balance_rounded,
              ),
              _buildDetailRow(
                'Application Process',
                widget.scheme['Application Process'] ?? 'N/A',
                Icons.description_rounded,
              ),
              _buildDetailRow(
                'Target Age',
                widget.scheme['Target Age'] ?? 'N/A',
                Icons.cake_rounded,
              ),
              _buildDetailRow(
                'Target Gender',
                widget.scheme['Target Gender'] ?? 'N/A',
                Icons.person_rounded,
              ),
              _buildDetailRow(
                'Target Occupation',
                widget.scheme['Target Occupation'] ?? 'N/A',
                Icons.business_center_rounded,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download_rounded),
                label: const Text("Download Brochure"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2E7D65),
                  side: const BorderSide(color: Color(0xFF2E7D65)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.send_rounded),
                label: const Text("Apply Now"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF01342C).withAlpha(200),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
            ),
          ),
        ],
      ),
    );
  }
}
