import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/help_controller.dart';
import '../models/faq_model.dart';

class HelpView extends GetView<HelpController> {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Obx(() {
              if (controller.isSearching.value) {
                return _buildSearchResults();
              }
              return _buildCategoriesAndFAQ();
            }),
          ),
        ],
      ),
    );
  }

  // Premium Header with Search
  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0c4a6e),
            const Color(0xFF0e5a8a),
            const Color(0xFF075985),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pusat Bantuan',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Temukan jawaban atas pertanyaan Anda',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller.searchController,
                  onChanged: controller.onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Cari bantuan...',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                    suffixIcon: Obx(() {
                      if (controller.searchQuery.value.isEmpty) {
                        return const SizedBox();
                      }
                      return IconButton(
                        onPressed: controller.clearSearch,
                        icon: const Icon(Icons.clear),
                        color: Colors.grey.shade400,
                      );
                    }),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Categories and FAQ
  Widget _buildCategoriesAndFAQ() {
    return CustomScrollView(
      slivers: [
        // Categories
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kategori',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildCategoryChips(),
              ],
            ),
          ),
        ),
        
        // FAQ Items
        Obx(() {
          final items = controller.filteredItems;
          
          if (items.isEmpty) {
            return const SliverFillRemaining(
              child: Center(
                child: Text('Tidak ada FAQ ditemukan'),
              ),
            );
          }
          
          return SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = items[index];
                  return _buildFAQItem(item);
                },
                childCount: items.length,
              ),
            ),
          );
        }),
      ],
    );
  }

  // Category Chips
  Widget _buildCategoryChips() {
    return Obx(() {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          // All Categories
          _buildCategoryChip(
            label: 'Semua',
            icon: '📚',
            isSelected: controller.selectedCategoryId.value == null,
            onTap: () => controller.selectCategory(null),
          ),
          
          // Individual Categories
          ...controller.categories.map((category) {
            return _buildCategoryChip(
              label: category.title,
              icon: category.icon,
              isSelected: controller.selectedCategoryId.value == category.id,
              onTap: () => controller.selectCategory(category.id),
            );
          }),
        ],
      );
    });
  }

  Widget _buildCategoryChip({
    required String label,
    required String icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF0c4a6e)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF0c4a6e)
                : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF0c4a6e).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // FAQ Item
  Widget _buildFAQItem(FAQItem item) {
    return Obx(() {
      final isExpanded = controller.expandedItemId.value == item.id;
      final category = controller.getCategoryById(item.categoryId);
      
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => controller.toggleExpand(item.id),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question Header
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Icon
                      if (category != null)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0c4a6e).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            category.icon,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      
                      const SizedBox(width: 12),
                      
                      // Question Text
                      Expanded(
                        child: Text(
                          item.question,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0c4a6e),
                          ),
                        ),
                      ),
                      
                      // Expand Icon
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: const Color(0xFF0c4a6e),
                      ),
                    ],
                  ),
                  
                  // Answer (Expanded)
                  AnimatedCrossFade(
                    firstChild: const SizedBox(),
                    secondChild: Padding(
                      padding: const EdgeInsets.only(top: 12, left: 48),
                      child: Text(
                        item.answer,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.6,
                        ),
                      ),
                    ),
                    crossFadeState: isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 200),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  // Search Results
  Widget _buildSearchResults() {
    return Obx(() {
      final results = controller.searchResults;
      
      if (results.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'Tidak ada hasil',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Coba kata kunci lain',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        );
      }
      
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final match = results[index];
          return _buildSearchResultItem(match);
        },
      );
    });
  }

  // Search Result Item with Highlighting
  Widget _buildSearchResultItem(SearchMatch match) {
    final item = match.item;
    final category = controller.getCategoryById(item.categoryId);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFDE59).withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFDE59).withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Close search and expand this item
            controller.clearSearch();
            controller.selectCategory(item.categoryId);
            controller.toggleExpand(item.id);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Badge
                if (category != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0c4a6e).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          category.icon,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          category.title,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0c4a6e),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Question with Highlighting
                _buildHighlightedText(
                  item.question,
                  match.matchedPhrases,
                  const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0c4a6e),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Answer Preview with Highlighting
                _buildHighlightedText(
                  _getAnswerPreview(item.answer),
                  match.matchedPhrases,
                  TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                  maxLines: 3,
                ),
                
                const SizedBox(height: 8),
                
                // "Lihat Detail" Link
                Row(
                  children: [
                    Text(
                      'Lihat detail',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0c4a6e),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward,
                      size: 14,
                      color: Color(0xFF0c4a6e),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Highlighted Text Widget
  Widget _buildHighlightedText(
    String text,
    List<String> highlightWords,
    TextStyle baseStyle, {
    int? maxLines,
  }) {
    if (highlightWords.isEmpty) {
      return Text(
        text,
        style: baseStyle,
        maxLines: maxLines,
        overflow: maxLines != null ? TextOverflow.ellipsis : null,
      );
    }

    final spans = <TextSpan>[];
    var currentIndex = 0;
    final lowerText = text.toLowerCase();
    
    // Create a map of positions for all highlight words
    final highlights = <int, int>{};
    for (final word in highlightWords) {
      final lowerWord = word.toLowerCase();
      var searchIndex = 0;
      
      while (true) {
        final index = lowerText.indexOf(lowerWord, searchIndex);
        if (index == -1) break;
        
        highlights[index] = word.length;
        searchIndex = index + word.length;
      }
    }
    
    // Sort highlights by position
    final sortedPositions = highlights.keys.toList()..sort();
    
    for (final position in sortedPositions) {
      if (position > currentIndex) {
        // Add non-highlighted text
        spans.add(TextSpan(
          text: text.substring(currentIndex, position),
          style: baseStyle,
        ));
      }
      
      final length = highlights[position]!;
      final highlightText = text.substring(position, position + length);
      
      // Add highlighted text
      spans.add(TextSpan(
        text: highlightText,
        style: baseStyle.copyWith(
          backgroundColor: const Color(0xFFFFDE59).withValues(alpha: 0.5),
          fontWeight: FontWeight.bold,
          color: const Color(0xFF0c4a6e),
        ),
      ));
      
      currentIndex = position + length;
    }
    
    // Add remaining text
    if (currentIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentIndex),
        style: baseStyle,
      ));
    }
    
    return RichText(
      text: TextSpan(children: spans),
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : TextOverflow.clip,
    );
  }

  String _getAnswerPreview(String answer) {
    const maxLength = 150;
    if (answer.length <= maxLength) return answer;
    return '${answer.substring(0, maxLength)}...';
  }
}
