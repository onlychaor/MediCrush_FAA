import 'medication.dart';

class SearchHistoryItem {
  final String id;
  final String query;
  final List<Medication> results;
  final DateTime timestamp;
  final int resultCount;

  const SearchHistoryItem({
    required this.id,
    required this.query,
    required this.results,
    required this.timestamp,
    required this.resultCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'query': query,
      'resultCount': resultCount,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'results': results.map((med) => med.id).toList(),
    };
  }

  factory SearchHistoryItem.fromJson(Map<String, dynamic> json, List<Medication> allMedications) {
    final resultIds = List<String>.from(json['results'] ?? []);
    final results = allMedications.where((med) => resultIds.contains(med.id)).toList();
    
    return SearchHistoryItem(
      id: json['id'],
      query: json['query'],
      results: results,
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      resultCount: json['resultCount'],
    );
  }
}

class SearchHistoryManager {
  static const int _maxHistoryItems = 20;
  static List<SearchHistoryItem> _searchHistory = [];

  static List<SearchHistoryItem> get searchHistory => List.unmodifiable(_searchHistory);

  static void addSearchHistory(String query, List<Medication> results) {
    if (query.trim().isEmpty || results.isEmpty) return;

    // Tạo ID duy nhất
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    
    final historyItem = SearchHistoryItem(
      id: id,
      query: query.trim(),
      results: results,
      timestamp: DateTime.now(),
      resultCount: results.length,
    );

    // Xóa lịch sử cũ nếu có cùng query
    _searchHistory.removeWhere((item) => item.query.toLowerCase() == query.toLowerCase());
    
    // Thêm vào đầu danh sách
    _searchHistory.insert(0, historyItem);
    
    // Giới hạn số lượng lịch sử
    if (_searchHistory.length > _maxHistoryItems) {
      _searchHistory = _searchHistory.take(_maxHistoryItems).toList();
    }
  }

  static void clearHistory() {
    _searchHistory.clear();
  }

  static void removeHistoryItem(String id) {
    _searchHistory.removeWhere((item) => item.id == id);
  }

  static List<SearchHistoryItem> searchInHistory(String query) {
    if (query.trim().isEmpty) return _searchHistory;
    
    final lowerQuery = query.toLowerCase();
    return _searchHistory.where((item) => 
      item.query.toLowerCase().contains(lowerQuery)
    ).toList();
  }
}
