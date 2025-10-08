import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/medication.dart';
import '../models/search_history.dart';
import '../database/database_helper.dart';
import '../database/data_importer.dart';
import '../widgets/medication_card.dart';
import '../widgets/search_history_widget.dart';

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

      // Đảm bảo dữ liệu đã được import
      await _dataImporter.ensureDataLoaded();
      
      // Load tất cả thuốc từ database
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
        final results = await _dbHelper.searchMedicationsAdvanced(query);
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header với logo MediCrush và thanh tìm kiếm
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
                  
                  // Thanh tìm kiếm
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
                      child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'Search for a Medication',
                        hintStyle: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.primary,
                        ),
                        suffixIcon: _isSearching 
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Nút lịch sử
                                IconButton(
                                  onPressed: _showHistoryDialog,
                                  icon: const Icon(
                                    Icons.history,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                ),
                                // Nút xóa
                                IconButton(
                                  onPressed: _clearSearch,
                                  icon: const Icon(
                                    Icons.close,
                                    color: AppColors.textSecondary,
                                    size: 20,
                                  ),
                                ),
                              ],
                            )
                          : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                      onSubmitted: (value) {
                        _handleSearch(value);
                        _saveSearchHistory(value, _filteredMedications);
                      },
                    ),
                    ),
                  ),
                  
                  // Nút Done khi đang tìm kiếm
                  if (_isSearching) ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _clearSearch,
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.surface,
                            foregroundColor: AppColors.textSecondary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Done',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            
            // Nội dung chính
            Expanded(
              child: _isLoading
                ? _buildLoadingIndicator()
                : _isSearching 
                  ? _buildSearchResults()
                  : _buildHomeContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          SizedBox(height: 16),
          Text(
            'Đang tải dữ liệu thuốc...',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          _buildWelcomeSection(),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    // Lưu lịch sử tìm kiếm khi có kết quả
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
                  'Kết quả tìm kiếm: ${_filteredMedications.length} thuốc',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              // Nút lịch sử trong header
              IconButton(
                onPressed: _showHistoryDialog,
                icon: const Icon(
                  Icons.history,
                  color: AppColors.primary,
                  size: 20,
                ),
                tooltip: 'Xem lịch sử tìm kiếm',
              ),
            ],
          ),
        ),
        
        // Search results
        Expanded(
          child: MedicationSearchResults(
            medications: _filteredMedications,
            // onMedicationTap sẽ được xử lý tự động trong MedicationCard
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
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
          const Icon(
            Icons.medical_services,
            size: 50,
            color: AppColors.primary,
          ),
          const SizedBox(height: 15),
          const Text(
            'Welcome to MediCrush',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            'Reliable and accessible medical information platform',
            style: TextStyle(
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
    // Tìm kiếm được xử lý tự động trong _onSearchChanged
    // Method này giữ lại để tương thích với onSubmitted
  }


}
