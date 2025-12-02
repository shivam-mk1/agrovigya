import 'package:agro/providers/language_provider.dart';
import 'package:agro/services/labor_estimation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LaborEstimationWidget extends StatefulWidget {
  const LaborEstimationWidget({super.key});

  @override
  State<LaborEstimationWidget> createState() => _LaborEstimationWidgetState();
}

class _LaborEstimationWidgetState extends State<LaborEstimationWidget>
    with TickerProviderStateMixin {
  final LaborEstimationService _estimationService = LaborEstimationService();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String _selectedCrop = 'Tomato';
  String _selectedCropType = 'Vegetable';
  double _area = 1.0;
  String _selectedSeason = 'Summer';
  String _selectedWageType = 'Govt';
  final double _govtWage = 350.0;
  final double _expectedWage = 450.0;

  Map<String, dynamic>? _estimationResult;
  bool _isLoading = false;

  final List<String> _cropOptions = [
    'Tomato',
    'Potato',
    'Onion',
    'Wheat',
    'Rice',
    'Corn',
    'Chickpea',
    'Apple',
    'Banana',
  ];
  final List<String> _seasonOptions = ['Spring', 'Summer', 'Fall', 'Winter'];
  final List<String> _wageTypeOptions = ['Govt', 'Expected'];

  // Icon mapping for crops
  final Map<String, IconData> _cropIcons = {
    'Tomato': Icons.local_grocery_store,
    'Potato': Icons.breakfast_dining,
    'Onion': Icons.circle_outlined,
    'Wheat': Icons.grass,
    'Rice': Icons.rice_bowl,
    'Corn': Icons.eco,
    'Chickpea': Icons.scatter_plot,
    'Apple': Icons.apple,
    'Banana': Icons.local_dining,
  };

  // Season icons
  final Map<String, IconData> _seasonIcons = {
    'Spring': Icons.local_florist,
    'Summer': Icons.wb_sunny,
    'Fall': Icons.park,
    'Winter': Icons.ac_unit,
  };

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
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _animationController.forward();
  }

  Future<void> _calculateEstimation() async {
    setState(() {
      _isLoading = true;
    });

    // Add haptic feedback
    // HapticFeedback.lightImpact();

    try {
      final result = await _estimationService.estimateCost(
        _selectedCrop,
        _selectedCropType,
        _area,
        _selectedWageType,
        _selectedSeason,
        _govtWage,
        _expectedWage,
      );

      setState(() {
        _estimationResult = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      _showErrorSnackBar(context, 'Error calculating estimation: $e');
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff01342C),
                    Color(0xff024A3E),
                    Color(0xff035D4F),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(78),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(languageProvider),
                      const SizedBox(height: 32),
                      _buildInputSection(languageProvider),
                      const SizedBox(height: 24),
                      _buildCalculateButton(languageProvider),
                      const SizedBox(height: 24),
                      if (_estimationResult != null)
                        _buildResultsSection(languageProvider),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(LanguageProvider languageProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xff4EBE44).withAlpha(51),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.agriculture,
              color: Color(0xff4EBE44),
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  languageProvider.translate('labor_estimation'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  languageProvider.translate('calculate_farming_costs'),
                  style: TextStyle(
                    color: Colors.white.withAlpha(204),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection(LanguageProvider languageProvider) {
    return Column(
      children: [
        _buildEnhancedDropdown(
          languageProvider,
          _selectedCrop,
          _cropOptions,
          (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedCrop = newValue;
                _selectedCropType = _estimationService.getCropTypeForCrop(
                  newValue,
                );
              });
            }
          },
          languageProvider.translate('crop'),
          Icons.eco,
          _cropIcons,
        ),
        const SizedBox(height: 20),

        _buildAreaInput(languageProvider),
        const SizedBox(height: 20),

        _buildEnhancedDropdown(
          languageProvider,
          _selectedSeason,
          _seasonOptions,
          (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedSeason = newValue;
              });
            }
          },
          languageProvider.translate('season'),
          Icons.calendar_today,
          _seasonIcons,
        ),
        const SizedBox(height: 20),

        _buildWageTypeSelector(languageProvider),
      ],
    );
  }

  Widget _buildAreaInput(LanguageProvider languageProvider) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withAlpha(26),
        border: Border.all(color: Colors.white.withAlpha(78)),
      ),
      child: TextFormField(
        style: const TextStyle(color: Colors.white, fontSize: 16),
        cursorColor: const Color(0xff4EBE44),
        decoration: InputDecoration(
          labelText: languageProvider.translate('area_in_hectares'),
          labelStyle: TextStyle(color: Colors.white.withAlpha(204)),
          prefixIcon: const Icon(
            Icons.crop_landscape,
            color: Color(0xff4EBE44),
          ),
          suffixText: 'ha',
          suffixStyle: TextStyle(color: Colors.white.withAlpha(204)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        keyboardType: TextInputType.number,
        initialValue: _area.toString(),
        onChanged: (value) {
          setState(() {
            _area = double.tryParse(value) ?? 1.0;
          });
        },
      ),
    );
  }

  Widget _buildWageTypeSelector(LanguageProvider languageProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          languageProvider.translate('wage_type'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children:
              _wageTypeOptions.map((option) {
                final isSelected = _selectedWageType == option;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedWageType = option;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.only(
                        right: option == _wageTypeOptions.last ? 0 : 12,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? const Color(0xff4EBE44)
                                : Colors.white.withAlpha(26),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              isSelected
                                  ? const Color(0xff4EBE44)
                                  : Colors.white.withAlpha(78),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            option == 'Govt'
                                ? Icons.account_balance
                                : Icons.trending_up,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            option,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${option == 'Govt' ? _govtWage.toInt() : _expectedWage.toInt()}',
                            style: TextStyle(
                              color: Colors.white.withAlpha(204),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildEnhancedDropdown(
    LanguageProvider languageProvider,
    String value,
    List<String> items,
    Function(String?)? onChanged,
    String label,
    IconData prefixIcon,
    Map<String, IconData> itemIcons,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withAlpha(26),
        border: Border.all(color: Colors.white.withAlpha(78)),
      ),
      child: DropdownButtonFormField<String>(
        style: const TextStyle(color: Colors.white, fontSize: 16),
        iconEnabledColor: Colors.white,
        dropdownColor: const Color(0xff01342C),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withAlpha(204)),
          prefixIcon: Icon(prefixIcon, color: const Color(0xff4EBE44)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        initialValue: value,
        items:
            items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Row(
                  children: [
                    Icon(
                      itemIcons[item] ?? Icons.circle,
                      color: const Color(0xff4EBE44),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(item, style: const TextStyle(color: Colors.white)),
                  ],
                ),
              );
            }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildCalculateButton(LanguageProvider languageProvider) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _calculateEstimation,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff4EBE44),
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: const Color(0xff4EBE44).withAlpha(102),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child:
            _isLoading
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      languageProvider.translate('calculating'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.calculate, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      languageProvider.translate('calculate_labor_cost'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildResultsSection(LanguageProvider languageProvider) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xff4EBE44).withAlpha(26),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.assessment,
                    color: Color(0xff4EBE44),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  languageProvider.translate('estimation_results'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xff01342C),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildResultCard(
              Icons.eco,
              languageProvider.translate('crop'),
              _estimationResult!['crop'].toString(),
              const Color(0xff4EBE44),
            ),

            _buildResultCard(
              Icons.crop_landscape,
              languageProvider.translate('area'),
              '${_estimationResult!['area']} ha',
              Colors.blue,
            ),

            _buildResultCard(
              Icons.calendar_today,
              languageProvider.translate('season'),
              _estimationResult!['season'].toString(),
              Colors.orange,
            ),

            _buildResultCard(
              Icons.people,
              languageProvider.translate('labor_required'),
              '${_estimationResult!['labor_demand']} ${languageProvider.translate('workers')}',
              Colors.purple,
            ),

            _buildResultCard(
              Icons.monetization_on,
              languageProvider.translate('cost_per_hectare'),
              '₹${_estimationResult!['cost_per_ha']}',
              Colors.teal,
            ),

            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff4EBE44), Color(0xff45A63A)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          languageProvider.translate('total_cost'),
                          style: TextStyle(
                            color: Colors.white.withAlpha(230),
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '₹${_estimationResult!['total_cost']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(78)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(51),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xff01342C),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _estimationService.dispose();
    super.dispose();
  }
}
