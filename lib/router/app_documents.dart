class AppDocument {
  final String file;
  final String title;

  const AppDocument(this.file, this.title);
}

const Map<String, AppDocument> appDocuments = {
  'EULA': AppDocument('EULA', 'End User License Agreement'),
  'PRIVACY': AppDocument('PrivacyPolicy', 'Privacy Policy'),
  'TAC': AppDocument('TAC', 'Terms and Conditions'),
  'DISCLAIMER': AppDocument('Disclaimer', 'Disclaimer'),
  'USE': AppDocument('AcceptableUsePolicy', 'Acceptable Use Policy'),
};
