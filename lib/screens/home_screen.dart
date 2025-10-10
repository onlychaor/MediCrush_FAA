import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/medication.dart';
import '../models/search_history.dart';
import '../database/database_helper.dart';
import '../database/data_importer.dart';
import '../widgets/medication_card.dart';
import '../widgets/search_history_widget.dart';
import '../l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final DataImporter _dataImporter = DataImporter();
  
  List<Medication> _allMedications = [];
  List<Medication> _filteredMedications = [];
  bool _isSearching = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMedications();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadMedications() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Ensure data is loaded
      await _dataImporter.ensureDataLoaded();
      
      // Load all medications from database
      final medications = await _dbHelper.getAllMedications();
      
      setState(() {
        _allMedications = medications;
        _filteredMedications = medications;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading medications: $e');
      setState(() {
        _isLoading = false;
      });
      
      // Fallback to sample data if database fails
      _allMedications = Medication.getSampleMedications();
      _filteredMedications = _allMedications;
    }
  }

  void _onSearchChanged() async {
    final query = _searchController.text.trim();
    setState(() {
      _isSearching = query.isNotEmpty;
    });
    
    if (_isSearching) {
      // Sử dụng SQLite search thay vì in-memory search
      try {
        print('🔍 Searching for: "$query"');
        final results = await _dbHelper.searchMedicationsAdvanced(query);
        print('📊 Found ${results.length} results');
        
        if (results.isEmpty) {
          print('❌ No results found for: "$query"');
          // Test with simple search
          final simpleResults = await _dbHelper.searchMedications(query);
          print('📊 Simple search found ${simpleResults.length} results');
        }
        
        setState(() {
          _filteredMedications = results;
        });
      } catch (e) {
        print('Error searching medications: $e');
        // Fallback to in-memory search
        setState(() {
          _filteredMedications = _allMedications
              .where((medication) => medication.matchesSearch(query))
              .toList();
        });
      }
    } else {
      setState(() {
        _filteredMedications = _allMedications;
      });
    }
  }

  void _saveSearchHistory(String query, List<Medication> results) {
    if (query.isNotEmpty && results.isNotEmpty) {
      SearchHistoryManager.addSearchHistory(query, results);
    }
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _isSearching = false;
      _filteredMedications = _allMedications;
    });
    _searchFocusNode.unfocus();
  }

  void _focusSearchField() {
    _searchFocusNode.requestFocus();
  }

  void _showHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => SearchHistoryDialog(
        historyItems: SearchHistoryManager.searchHistory,
        onHistoryTap: (query) {
          _searchController.text = query;
          _onSearchChanged();
        },
        onRemoveHistory: (id) {
          setState(() {
            SearchHistoryManager.removeHistoryItem(id);
          });
        },
        onClearAll: () {
          setState(() {
            SearchHistoryManager.clearHistory();
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            // Header with MediCrush logo and search bar
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
              child: Column(
                children: [
                  // Logo MediCrush
                  const Text(
                    'MediCrush',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textWhite,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Search bar
                  GestureDetector(
                    onTap: _focusSearchField,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: AppColors.textPrimary,
                          width: 1,
                        ),
                      ),
                      child: CupertinoTextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      autofocus: false,
                      placeholder: l10n.searchHint,
                      placeholderStyle: const TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: const BoxDecoration(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      prefix: const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(
                          CupertinoIcons.search,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      suffix: _isSearching 
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Nút lịch sử
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: _showHistoryDialog,
                                  child: const Icon(
                                    CupertinoIcons.clock,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                ),
                                // Nút Go
                                CupertinoButton(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(15),
                                  onPressed: _clearSearch,
                                  child: Text(
                                    l10n.go,
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                            )
                          : null,
                      onSubmitted: (value) {
                        _handleSearch(value);
                        _saveSearchHistory(value, _filteredMedications);
                      },
                    ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Nội dung chính
            Expanded(
              child: _isLoading
                ? _buildLoadingIndicator(l10n)
                : _isSearching 
                  ? _buildSearchResults(l10n)
                  : _buildHomeContent(l10n),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CupertinoActivityIndicator(
            radius: 14,
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.loadingMedicationData,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          _buildWelcomeSection(l10n),
        ],
      ),
    );
  }

  Widget _buildSearchResults(AppLocalizations l10n) {
    // Save search history when there are results
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_searchController.text.isNotEmpty && _filteredMedications.isNotEmpty) {
        _saveSearchHistory(_searchController.text, _filteredMedications);
      }
    });

    return Column(
      children: [
        // Search header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          color: AppColors.surface,
          child: Row(
            children: [
              const Icon(
                Icons.search,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${l10n.searchResults}: ${_filteredMedications.length} ${l10n.medications}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              // Nút lịch sử trong header
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _showHistoryDialog,
                child: const Icon(
                  CupertinoIcons.clock,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        
        // Search results
        Expanded(
          child: MedicationSearchResults(
            medications: _filteredMedications,
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFE53E3E), // Red color like first aid box
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF2D3748), // Dark border
                width: 2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Handle on top
                Positioned(
                  top: -8,
                  left: 20,
                  right: 20,
                  child: Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: const Color(0xFF2D3748),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                // Red cross in center
                Center(
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: const Color(0xFF2D3748),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      CupertinoIcons.plus,
                      size: 20,
                      color: Color(0xFFE53E3E), // Red cross
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Text(
            l10n.welcomeToMedicrush,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            l10n.reliableMedicalInfo,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }





  void _handleSearch(String query) {
    // Search is handled automatically in _onSearchChanged
    // This method is kept for compatibility with onSubmitted
  }


}
