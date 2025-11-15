class FAQCategory {
  final String id;
  final String title;
  final String icon;
  final List<FAQItem> items;

  FAQCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.items,
  });
}

class FAQItem {
  final String id;
  final String question;
  final String answer;
  final List<String> keywords;
  final String categoryId;

  FAQItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.keywords,
    required this.categoryId,
  });

  bool matchesSearch(String query) {
    final lowerQuery = query.toLowerCase();
    
    // Check in question
    if (question.toLowerCase().contains(lowerQuery)) return true;
    
    // Check in answer
    if (answer.toLowerCase().contains(lowerQuery)) return true;
    
    // Check in keywords
    for (final keyword in keywords) {
      if (keyword.toLowerCase().contains(lowerQuery)) return true;
    }
    
    return false;
  }
}

class SearchMatch {
  final FAQItem item;
  final List<String> matchedPhrases;

  SearchMatch({
    required this.item,
    required this.matchedPhrases,
  });
}
