import 'package:flutter/material.dart';
import '../models/search_history.dart';
import '../theme/app_colors.dart';

class SearchHistoryWidget extends StatelessWidget {
  final List<SearchHistoryItem> historyItems;
  final Function(String) onHistoryTap;
  final Function(String) onRemoveHistory;
  final VoidCallback? onClearAll;

  const SearchHistoryWidget({
    super.key,
    required this.historyItems,
    required this.onHistoryTap,
    required this.onRemoveHistory,
    this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    if (historyItems.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: AppColors.textLight,
            ),
            SizedBox(height: 16),
            Text(
              'Chưa có lịch sử tìm kiếm',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Hãy bắt đầu tìm kiếm thuốc',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Header với nút xóa tất cả
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Lịch sử tìm kiếm',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              if (onClearAll != null)
                TextButton(
                  onPressed: onClearAll,
                  child: const Text(
                    'Xóa tất cả',
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
        ),
        
        // Danh sách lịch sử
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: historyItems.length,
            itemBuilder: (context, index) {
              final item = historyItems[index];
              return _buildHistoryItem(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(SearchHistoryItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => onHistoryTap(item.query),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Icon lịch sử
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.history,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Thông tin tìm kiếm
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.query,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.resultCount} kết quả • ${_formatTime(item.timestamp)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Nút xóa
              IconButton(
                onPressed: () => onRemoveHistory(item.id),
                icon: const Icon(
                  Icons.close,
                  size: 18,
                  color: AppColors.textLight,
                ),
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Vừa xong';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}

class SearchHistoryDialog extends StatelessWidget {
  final List<SearchHistoryItem> historyItems;
  final Function(String) onHistoryTap;
  final Function(String) onRemoveHistory;
  final VoidCallback? onClearAll;

  const SearchHistoryDialog({
    super.key,
    required this.historyItems,
    required this.onHistoryTap,
    required this.onRemoveHistory,
    this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.border,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.history,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Lịch sử tìm kiếm',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Nội dung
            Expanded(
              child: SearchHistoryWidget(
                historyItems: historyItems,
                onHistoryTap: (query) {
                  Navigator.of(context).pop();
                  onHistoryTap(query);
                },
                onRemoveHistory: onRemoveHistory,
                onClearAll: onClearAll,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
