import 'package:flutter/material.dart';

/// The translations for all supported locales.
class AppLocalizations {
  AppLocalizations(this.localeName);

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get appName {
    if (localeName == 'hi') return 'नौकरी खोज';
    if (localeName == 'te') return 'ఉద్యోగ శోధన';
    if (localeName == 'kn') return 'ಕೆಲಸ ಹುಡುಕು';
    return 'Job Search';
  }

  String get home {
    if (localeName == 'hi') return 'होम';
    if (localeName == 'te') return 'హోమ్';
    if (localeName == 'kn') return 'ಮುಖ್ಯಪುಟ';
    return 'Home';
  }

  String get jobs {
    if (localeName == 'hi') return 'नौकरियां';
    if (localeName == 'te') return 'ఉద్యోగాలు';
    if (localeName == 'kn') return 'ಕೆಲಸ';
    return 'Jobs';
  }

  String get chat {
    if (localeName == 'hi') return 'चैट';
    if (localeName == 'te') return 'చాట్';
    if (localeName == 'kn') return 'ಚಾಟ್';
    return 'Chat';
  }

  String get profile {
    if (localeName == 'hi') return 'प्रोफाइल';
    if (localeName == 'te') return 'ప్రొఫైల్';
    if (localeName == 'kn') return 'ಪ್ರೊಫೈಲ್';
    return 'Profile';
  }

  String get settings {
    if (localeName == 'hi') return 'सेटिंग्स';
    if (localeName == 'te') return 'సెట్టింగ్‌లు';
    if (localeName == 'kn') return 'ಸೆಟ್ಟಿಂಗ್‌ಗಳು';
    return 'Settings';
  }

  String get searchHint {
    if (localeName == 'hi') return 'नौकरियां खोजें...';
    if (localeName == 'te') return 'ఉద్యోగాల కోసం శోధించండి...';
    if (localeName == 'kn') return 'ಕೆಲಸಕ್ಕಾಗಿ ಹುಡುಕಿ...';
    return 'Search for jobs...';
  }

  String get popularJobs {
    if (localeName == 'hi') return 'लोकप्रिय नौकरियां';
    if (localeName == 'te') return 'ప్రసిద్ధ ఉద్యోగాలు';
    if (localeName == 'kn') return 'ಜನಪ್ರಿಯ ಕೆಲಸಗಳು';
    return 'Popular Jobs';
  }

  String get viewAll {
    if (localeName == 'hi') return 'सभी देखें';
    if (localeName == 'te') return 'అన్నిటిని చూడండి';
    if (localeName == 'kn') return 'ಎಲ್ಲವನ್ನೂ ವೀಕ್ಷಿಸಿ';
    return 'View All';
  }

  String get nearbyJobs {
    if (localeName == 'hi') return 'नजदीकी नौकरियां';
    if (localeName == 'te') return 'సమీపంలోని ఉద్యోగాలు';
    if (localeName == 'kn') return 'ಸಮೀಪದ ಕೆಲಸಗಳು';
    return 'Nearby Jobs';
  }

  String get applyNow {
    if (localeName == 'hi') return 'अभी आवेदन करें';
    if (localeName == 'te') return 'ఇప్పుడు దరఖాస్తు చేయండి';
    if (localeName == 'kn') return 'ಈಗ ಅರ್ಜಿ ಸಲ್ಲಿಸಿ';
    return 'Apply Now';
  }

  String get jobDescription {
    if (localeName == 'hi') return 'नौकरी विवरण';
    if (localeName == 'te') return 'ఉద్యోగ వివరణ';
    if (localeName == 'kn') return 'ಕೆಲಸದ ವಿವರಣೆ';
    return 'Job Description';
  }

  String get qualifications {
    if (localeName == 'hi') return 'योग्यता';
    if (localeName == 'te') return 'అర్హతలు';
    if (localeName == 'kn') return 'ಅರ್ಹತೆಗಳು';
    return 'Qualifications';
  }

  String get responsibilities {
    if (localeName == 'hi') return 'जिम्मेदारियां';
    if (localeName == 'te') return 'బాధ్యతలు';
    if (localeName == 'kn') return 'ಜವಾಬ್ದಾರಿತ್ವಗಳು';
    return 'Responsibilities';
  }

  String get postFreeJob {
    if (localeName == 'hi') return 'मुफ्त नौकरी पोस्ट करें';
    if (localeName == 'te') return 'ఉచిత ఉద్యోగం పోస్ట్ చేయండి';
    if (localeName == 'kn') return 'ಉಚಿತ ಕೆಲಸ ಪೋಸ್ಟ್ ಮಾಡಿ';
    return 'Post Free Job';
  }

  String get categoryDetails {
    if (localeName == 'hi') return 'श्रेणी विवरण';
    if (localeName == 'te') return 'వర్గం వివరాలు';
    if (localeName == 'kn') return 'ವರ್ಗ ವಿವರಣೆಗಳು';
    return 'Category Details';
  }

  String get category {
    if (localeName == 'hi') return 'श्रेणी';
    if (localeName == 'te') return 'వర్గం';
    if (localeName == 'kn') return 'ವರ್ಗ';
    return 'Category';
  }

  String get subCategory {
    if (localeName == 'hi') return 'उप-श्रेणी';
    if (localeName == 'te') return 'ఉప-వర్గం';
    if (localeName == 'kn') return 'ಉಪ-ವರ್ಗ';
    return 'Sub-Category';
  }

  String get adDetails {
    if (localeName == 'hi') return 'विज्ञापन विवरण';
    if (localeName == 'te') return 'విజ్ఞాపన వివరాలు';
    if (localeName == 'kn') return 'ಜಾಹೀರಾತು ವಿವರಣೆಗಳು';
    return 'Ad Details';
  }

  String get enterTitle {
    if (localeName == 'hi') return 'विज्ञापन शीर्षक दर्ज करें (न्यूनतम 10 अक्षर)';
    if (localeName == 'te') return 'విజ్ఞాపన శీర్షికను నమోదు చేయండి (కనీసం 10 అక్షరాలు)';
    if (localeName == 'kn') return 'ಜಾಹೀರಾತು ಶೀರ್ಷಿಕೆ ನಮೂದಿಸಿ (ಕನಿಷ್ಠ 10 ಅಕ್ಷರಗಳು)';
    return 'Enter Ad title (Min 10 characters)';
  }

  String get selectRole {
    if (localeName == 'hi') return 'भूमिका चुनें';
    if (localeName == 'te') return 'పాత్ర ఎంచుకోండి';
    if (localeName == 'kn') return 'ಪಾತ್ರವನ್ನು ಆರಿಸಿ';
    return 'Select Role';
  }

  String get searchRole {
    if (localeName == 'hi') return 'भूमिका खोजें या चुनें';
    if (localeName == 'te') return 'పాత్ర కోసం శోధించండి లేదా ఎంచుకోండి';
    if (localeName == 'kn') return 'ಪಾತ್ರವನ್ನು ಹುಡುಕಿ ಅಥವಾ ಆರಿಸಿ';
    return 'Search or select a role';
  }

  String get salaryType {
    if (localeName == 'hi') return 'वेतन प्रकार';
    if (localeName == 'te') return 'జీతం రకం';
    if (localeName == 'kn') return 'ವೇತನ ಪ್ರಕಾರ';
    return 'Salary Type';
  }

  String get minSalary {
    if (localeName == 'hi') return 'न्यूनतम वेतन';
    if (localeName == 'te') return 'కనీస జీతం';
    if (localeName == 'kn') return 'ನ್ಯೂನತಮ ವೇತನ';
    return 'Min Salary';
  }

  String get maxSalary {
    if (localeName == 'hi') return 'अधिकतम वेतन';
    if (localeName == 'te') return 'గరిష్ట జీతం';
    if (localeName == 'kn') return 'ಗರಿಷ್ಠ ವೇತನ';
    return 'Max Salary';
  }

  String get adDescription {
    if (localeName == 'hi') return 'विज्ञापन विवरण (न्यूनतम 30 अक्षर)';
    if (localeName == 'te') return 'విజ్ఞాపన వివరణ (కనీసం 30 అక్షరాలు)';
    if (localeName == 'kn') return 'ಜಾಹೀರಾತು ವಿವರಣೆ (ಕನಿಷ್ಠ 30 ಅಕ್ಷರಗಳು)';
    return 'Ad Description (Min 30 characters)';
  }

  String get contactInfo {
    if (localeName == 'hi') return 'आपकी संपर्क जानकारी';
    if (localeName == 'te') return 'మీ సంపర్క సమాచారం';
    if (localeName == 'kn') return 'ನಿಮ್ಮ ಸಂಪರ್ಕ ಮಾಹಿತಿ';
    return 'Your contact information';
  }

  String get jobLocation {
    if (localeName == 'hi') return 'नौकरी स्थान';
    if (localeName == 'te') return 'ఉద్యోగ స్థానం';
    if (localeName == 'kn') return 'ಕೆಲಸದ ಸ್ಥಾನ';
    return 'Job Location';
  }

  String get locality {
    if (localeName == 'hi') return 'इलाका';
    if (localeName == 'te') return 'ప్రాంతం';
    if (localeName == 'kn') return 'ಪ್ರದೇಶ';
    return 'Locality';
  }

  String get mobile {
    if (localeName == 'hi') return 'मोबाइल';
    if (localeName == 'te') return 'మొబైల్';
    if (localeName == 'kn') return 'ಮೊಬೈಲ್';
    return 'Mobile';
  }

  String get otpInfo {
    if (localeName == 'hi') return 'अगर दिया गया नंबर सत्यापित नहीं है तो OTP भेजा जाएगा';
    if (localeName == 'te') return 'ఇచ్చిన సంఖ్య ధృవీకరించబడకపోతే OTP పంపబడుతుంది';
    if (localeName == 'kn') return 'ನೀಡಿದ ಸಂಖ್ಯೆ ಪರಿಶೀಲಿತವಾಗಿಲ್ಲದಿದ್ದರೆ OTP ಅನ್ನು ಕಳುಹಿಸಲಾಗುತ್ತದೆ';
    return 'An OTP will be sent and read if given number is not verified';
  }

  String get verifyInfo {
    if (localeName == 'hi') return 'अपना नंबर सत्यापित करने से विश्वास बढ़ता है और सही डील पाने की संभावना बढ़ जाती है।';
    if (localeName == 'te') return 'మీ సంఖ్యను ధృవీకరించడం నమ్మకాన్ని పెంచుకుంటుంది మరియు సరైన డీల్ పొందే అవకాశాలను పెంచుకుంటుంది.';
    if (localeName == 'kn') return 'ನಿಮ್ಮ ಸಂಖ್ಯೆಯನ್ನು ಪರಿಶೀಲಿಸುವುದು ವಿಶ್ವಾಸವನ್ನು ಹೆಚ್ಚಿಸುತ್ತದೆ ಮತ್ತು ಸರಿಯಾದ ಡೀಲ್ ಪಡೆಯುವ ಸಾಧ್ಯತೆ ಹೆಚ್ಚಾಗುತ್ತದೆ.';
    return 'Verifying your number creates trust and increase your chances of getting the right deal.';
  }

  String get privacy {
    if (localeName == 'hi') return 'गोपनीयता';
    if (localeName == 'te') return 'గోప్యత';
    if (localeName == 'kn') return 'ಗೋಪ್ಯತೆ';
    return 'Privacy';
  }

  String get maintainPrivacy {
    if (localeName == 'hi') return 'मेरी गोपनीयता बनाए रखें';
    if (localeName == 'te') return 'నా గోప్యతను నిర్వహించండి';
    if (localeName == 'kn') return 'ನನ್ನ ಗೋಪ್ಯತೆಯನ್ನು ನಿರ್ವಹಿಸಿ';
    return 'Maintain My Privacy';
  }

  String get postJob {
    if (localeName == 'hi') return 'नौकरी पोस्ट करें';
    if (localeName == 'te') return 'ఉద్యోగం పోస్ట్ చేయండి';
    if (localeName == 'kn') return 'ಕೆಲಸ ಪೋಸ್ಟ್ ಮಾಡಿ';
    return 'POST JOB';
  }

  String get createProfile {
    if (localeName == 'hi') return 'प्रोफ़ाइल बनाएं';
    if (localeName == 'te') return 'ప్రొఫైల్ సృష్టించండి';
    if (localeName == 'kn') return 'ಪ್ರೊಫೈಲ್ ರಚಿಸಿ';
    return 'Create Profile';
  }

  String get name {
    if (localeName == 'hi') return 'नाम';
    if (localeName == 'te') return 'పేరు';
    if (localeName == 'kn') return 'ಹೆಸರು';
    return 'Name';
  }

  String get gender {
    if (localeName == 'hi') return 'लिंग';
    if (localeName == 'te') return 'లింగం';
    if (localeName == 'kn') return 'ಲಿಂಗ';
    return 'Gender';
  }

  String get age {
    if (localeName == 'hi') return 'उम्र';
    if (localeName == 'te') return 'వయస్సు';
    if (localeName == 'kn') return 'ವಯಸ್ಸು';
    return 'Age';
  }

  String get experience {
    if (localeName == 'hi') return 'अनुभव (वर्ष)';
    if (localeName == 'te') return 'అనుభవం (సంవత్సరాలు)';
    if (localeName == 'kn') return 'ಅನುಭವ (ವರ್ಷಗಳು)';
    return 'Experience (Years)';
  }

  String get dailyWage {
    if (localeName == 'hi') return 'दैनिक वेतन';
    if (localeName == 'te') return 'దైనిక కూలీ';
    if (localeName == 'kn') return 'ದೈನಂದಿನ ವೇತನ';
    return 'Daily Wage';
  }

  String get profession {
    if (localeName == 'hi') return 'पेशा';
    if (localeName == 'te') return 'వృత్తి';
    if (localeName == 'kn') return 'ಉದ್ಯೋಗ';
    return 'Profession';
  }

  String get professionType {
    if (localeName == 'hi') return 'पेशा प्रकार';
    if (localeName == 'te') return 'వృత్తి రకం';
    if (localeName == 'kn') return 'ುದ್ಯೋಗ ಪ್ರಕಾರ';
    return 'Profession Type';
  }

  String get location {
    if (localeName == 'hi') return 'स्थान';
    if (localeName == 'te') return 'స్థానం';
    if (localeName == 'kn') return 'ಸ್ಥಾನ';
    return 'Location';
  }

  String get saveProfile {
    if (localeName == 'hi') return 'प्रोफ़ाइल सहेजें';
    if (localeName == 'te') return 'ప్రొఫైల్ సేవ్ చేయండి';
    if (localeName == 'kn') return 'ಪ್ರೊಫೈಲ್ ಉಳಿಸಿ';
    return 'Save Profile';
  }

  String get profileImage {
    if (localeName == 'hi') return 'प्रोफ़ाइल छवि (वैकल्पिक)';
    if (localeName == 'te') return 'ప్రొఫైల్ చిత్రం (ఐచ్ఛికం)';
    if (localeName == 'kn') return 'ಪ್ರೊಫೈಲ್ ಚಿತ್ರ (ಐಚ್ಛಿಕ)';
    return 'Profile Image (Optional)';
  }

  String get language {
    if (localeName == 'hi') return 'भाषा';
    if (localeName == 'te') return 'భాష';
    if (localeName == 'kn') return 'ಭಾಷೆ';
    return 'Language';
  }

  String get english {
    if (localeName == 'hi') return 'अंग्रेज़ी';
    if (localeName == 'te') return 'ఆంగ్లం';
    if (localeName == 'kn') return 'ಆಂಗ್ಲ';
    return 'English';
  }

  String get hindi {
    if (localeName == 'hi') return 'हिंदी';
    if (localeName == 'te') return 'హిందీ';
    if (localeName == 'kn') return 'ಹಿಂದೀ';
    return 'Hindi';
  }

  String get telugu {
    if (localeName == 'hi') return 'तेलुगु';
    if (localeName == 'te') return 'తెలుగు';
    if (localeName == 'kn') return 'ತೆಲುಗು';
    return 'Telugu';
  }

  String get tamil {
    if (localeName == 'hi') return 'तामिल';
    if (localeName == 'te') return 'తమిళ్లు';
    if (localeName == 'kn') return 'ತಮಿಳು';
    return 'Tamil';
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return Future.value(AppLocalizations(locale.languageCode));
  }

  @override
  bool isSupported(Locale locale) => ['en', 'hi', 'te', 'kn'].contains(locale.languageCode);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
