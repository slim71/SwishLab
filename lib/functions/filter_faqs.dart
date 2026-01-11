/// Filter the list of FAQs using the provided search filter
Future<List<dynamic>> filterFaqs(
  List<dynamic> faqs,
  String search,
) async {
  if (search.isEmpty) return faqs;

  final q = search.toLowerCase();

  return faqs.where((item) {
    final question = item['question']?.toString().toLowerCase() ?? '';
    final answer = item['answer']?.toString().toLowerCase() ?? '';
    return question.contains(q) || answer.contains(q);
  }).toList();
}
