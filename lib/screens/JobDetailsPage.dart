import 'package:flutter/material.dart';
import 'package:naka/config/app_colors.dart';
import 'package:naka/providers/AppearanceProvider.dart';
import 'package:naka/screens/ChatScreen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';

class JobDetailsPage extends StatefulWidget {
  final Map<String, dynamic> job;

  const JobDetailsPage({super.key, required this.job});

  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  final FlutterTts flutterTts = FlutterTts();
  bool isPlayingAudio = false;
  bool isTranslated = false;
  bool isTranslating = false;
  late Map<String, String> translatedJob;
  final GoogleTranslator translator = GoogleTranslator();

  @override
  void initState() {
    super.initState();
    _initTts();
    translatedJob = {};
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage('en-IN');
    await flutterTts.setSpeechRate(0.85);
  }

  Future<void> _speakJobInfo() async {
    String text = '''
    Job Title: ${widget.job['title'] ?? 'Not specified'}.
    Company: ${widget.job['company'] ?? 'Not specified'}.
    Location: ${widget.job['location'] ?? 'Not specified'}.
    Salary: ${widget.job['salary'] ?? 'Not specified'}.
    Description: ${widget.job['description'] ?? 'No description provided'}.
    ''';

    setState(() {
      isPlayingAudio = true;
    });

    await flutterTts.speak(text);
    
    flutterTts.setCompletionHandler(() {
      setState(() {
        isPlayingAudio = false;
      });
    });
  }

  Future<void> _stopAudio() async {
    await flutterTts.stop();
    setState(() {
      isPlayingAudio = false;
    });
  }

  Future<void> _toggleTranslation() async {
    if (isTranslated) {
      setState(() {
        isTranslated = false;
      });
    } else {
      setState(() {
        isTranslating = true;
      });

      try {
        String title = widget.job['title'] ?? '';
        String company = widget.job['company'] ?? '';
        String location = widget.job['location'] ?? '';
        String salary = widget.job['salary'] ?? '';
        String description = widget.job['description'] ?? '';

        var translatedTitle = await translator.translate(title, from: 'en', to: 'hi');
        var translatedCompany = await translator.translate(company, from: 'en', to: 'hi');
        var translatedLocation = await translator.translate(location, from: 'en', to: 'hi');
        var translatedSalary = await translator.translate(salary, from: 'en', to: 'hi');
        var translatedDescription = await translator.translate(description, from: 'en', to: 'hi');

        setState(() {
          translatedJob = {
            'title': translatedTitle.toString(),
            'company': translatedCompany.toString(),
            'location': translatedLocation.toString(),
            'salary': translatedSalary.toString(),
            'description': translatedDescription.toString(),
          };
          isTranslated = true;
          isTranslating = false;
        });
      } catch (e) {
        setState(() {
          isTranslating = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Translation error: $e')),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppearanceProvider>(
      builder: (context, appearance, _) {
        return Scaffold(
          backgroundColor: appearance.brightness == Brightness.dark
              ? const Color(0xFF1E1E1E)
              : const Color(0xFFF9FAFB),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: appearance.brightness == Brightness.dark
                ? const Color(0xFF2A2A2A)
                : AppColors.white,
            foregroundColor: appearance.brightness == Brightness.dark
                ? Colors.white
                : AppColors.black,
            title: Text(
              'Job Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: appearance.brightness == Brightness.dark
                    ? Colors.white
                    : AppColors.black,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: appearance.brightness == Brightness.dark
                    ? Colors.white
                    : AppColors.black,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  /// Profile Icon & Job Name
                  Column(
                    children: [
                      const CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.work_outline, size: 36, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isTranslated && translatedJob.isNotEmpty
                            ? translatedJob['title'] ?? widget.job['title']
                            : widget.job['title'],
                        style: appearance.getTitleStyle().copyWith(
                          color: appearance.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isTranslated && translatedJob.isNotEmpty
                            ? translatedJob['company'] ?? widget.job['company']
                            : widget.job['company'],
                        style: appearance.getBodyStyle().copyWith(
                          color: appearance.brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// TTS and Translation Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// Listen Button
                      InkWell(
                        onTap: isPlayingAudio ? _stopAudio : _speakJobInfo,
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isPlayingAudio ? Icons.stop_circle : Icons.mic,
                                size: 20,
                                color: isPlayingAudio ? Colors.red : Colors.purple,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isPlayingAudio ? 'Stop' : 'Listen',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isPlayingAudio ? Colors.red : Colors.purple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      /// Translate Button
                      InkWell(
                        onTap: _toggleTranslation,
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.translate,
                                size: 20,
                                color: isTranslated ? Colors.green[700] : Colors.green,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isTranslating ? 'Translating...' : (isTranslated ? 'English' : 'हिंदी'),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// Action Buttons (Call, SMS, Apply)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(Icons.phone, 'Call', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              userName: widget.job['company'] ?? 'Contractor',
                            ),
                          ),
                        );
                      }, appearance),
                      _buildActionButton(Icons.sms, 'SMS', () {
                        // Add SMS functionality
                      }, appearance),
                      ElevatedButton(
                        onPressed: () {
                          // Add apply functionality
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appearance.primaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Apply',
                          style: appearance.getBodyStyle().copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// Google Map Placeholder
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: appearance.brightness == Brightness.dark
                          ? Colors.grey[800]
                          : Colors.blueGrey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Google Map Placeholder',
                        style: TextStyle(
                          fontSize: 16,
                          color: appearance.brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.black54,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// Job Details & About Tab (Static UI for now)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Job Details',
                        style: appearance.getTitleStyle().copyWith(
                          color: appearance.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      Text(
                        'About',
                        style: appearance.getBodyStyle().copyWith(
                          color: appearance.brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  /// Job Details Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 18, color: appearance.primaryColor),
                          const SizedBox(width: 6),
                          Text(
                            isTranslated && translatedJob.isNotEmpty
                                ? translatedJob['location'] ?? widget.job['location']
                                : widget.job['location'],
                            style: appearance.getBodyStyle().copyWith(
                              color: appearance.brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.attach_money, size: 18, color: appearance.primaryColor),
                          const SizedBox(width: 6),
                          Text(
                            isTranslated && translatedJob.isNotEmpty
                                ? translatedJob['salary'] ?? widget.job['salary']
                                : widget.job['salary'],
                            style: appearance.getBodyStyle().copyWith(
                              color: appearance.brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (widget.job['isRemote'] == true)
                        Row(
                          children: [
                            Icon(Icons.wifi, size: 18, color: appearance.primaryColor),
                            const SizedBox(width: 6),
                            Text(
                              'Remote',
                              style: appearance.getBodyStyle().copyWith(
                                color: appearance.brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// Work Description
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Work Description',
                      style: appearance.getTitleStyle().copyWith(
                        color: appearance.brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isTranslated && translatedJob.isNotEmpty
                        ? translatedJob['description'] ?? (widget.job['description'] ?? 'Sample job description')
                        : (widget.job['description'] ?? 'Sample job description'),
                    style: appearance.getBodyStyle().copyWith(
                      color: appearance.brightness == Brightness.dark
                          ? Colors.grey[300]
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Helper method to build action buttons
  Widget _buildActionButton(
    IconData icon,
    String label,
    VoidCallback onPressed,
    AppearanceProvider appearance,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: appearance.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: appearance.primaryColor, size: 20),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: appearance.getSmallStyle().copyWith(
              color: appearance.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}