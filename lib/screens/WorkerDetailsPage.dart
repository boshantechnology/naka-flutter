import 'package:flutter/material.dart';
import 'package:naka/config/app_colors.dart';
import 'package:naka/providers/AppearanceProvider.dart';
import 'package:naka/screens/ChatScreen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';

class WorkerDetailsPage extends StatefulWidget {
  final Map<String, dynamic> worker;

  const WorkerDetailsPage({super.key, required this.worker});

  @override
  State<WorkerDetailsPage> createState() => _WorkerDetailsPageState();
}

class _WorkerDetailsPageState extends State<WorkerDetailsPage> {
  final FlutterTts flutterTts = FlutterTts();
  bool isPlayingAudio = false;
  bool isTranslated = false;
  bool isTranslating = false;
  late Map<String, String> translatedWorker;
  final GoogleTranslator translator = GoogleTranslator();

  @override
  void initState() {
    super.initState();
    _initTts();
    translatedWorker = {};
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage('en-IN');
    await flutterTts.setSpeechRate(0.85);
  }

  Future<void> _speakWorkerInfo() async {
    String text = '''
    Worker Name: ${widget.worker['name'] ?? 'Unknown'}.
    Type: ${widget.worker['type'] ?? 'Worker'}.
    Daily Rate: ${widget.worker['dailyRate'] ?? '0'} rupees per day.
    Half day Rate: ${widget.worker['halfDayRate'] ?? '0'} rupees for half day.
    Skills: ${widget.worker['skills'] ?? 'Not specified'}.
    Location: ${widget.worker['location'] ?? 'Not specified'}.
    Rating: ${widget.worker['rating'] ?? '0'} stars.
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
        String name = widget.worker['name'] ?? '';
        String type = widget.worker['type'] ?? '';
        String skills = widget.worker['skills'] ?? '';
        String location = widget.worker['location'] ?? '';

        var translatedName = await translator.translate(name, from: 'en', to: 'hi');
        var translatedType = await translator.translate(type, from: 'en', to: 'hi');
        var translatedSkills = await translator.translate(skills, from: 'en', to: 'hi');
        var translatedLocation = await translator.translate(location, from: 'en', to: 'hi');

        setState(() {
          translatedWorker = {
            'name': translatedName.toString(),
            'type': translatedType.toString(),
            'skills': translatedSkills.toString(),
            'location': translatedLocation.toString(),
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
              'Worker Details',
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
                  /// Profile Picture & Worker Name
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(
                          widget.worker['image'] ?? 'https://randomuser.me/api/portraits/men/32.jpg',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isTranslated && translatedWorker.isNotEmpty
                            ? translatedWorker['name'] ?? (widget.worker['name'] ?? 'Unknown Worker')
                            : (widget.worker['name'] ?? 'Unknown Worker'),
                        style: appearance.getTitleStyle().copyWith(
                          color: appearance.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isTranslated && translatedWorker.isNotEmpty
                            ? translatedWorker['type'] ?? (widget.worker['type'] ?? 'Carpenter')
                            : (widget.worker['type'] ?? 'Carpenter'),
                        style: appearance.getBodyStyle().copyWith(
                          color: appearance.brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.worker['rating'] ?? '4.5'} (${widget.worker['reviews'] ?? '120'} reviews)',
                            style: appearance.getSmallStyle().copyWith(
                              color: appearance.brightness == Brightness.dark
                                  ? Colors.grey[300]
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
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
                        onTap: isPlayingAudio ? _stopAudio : _speakWorkerInfo,
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

                  const SizedBox(height: 16),

                  /// Action Buttons (Call, SMS, Hire)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(Icons.phone, 'Call', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              userName: widget.worker['name'] ?? 'Worker',
                            ),
                          ),
                        );
                      }, appearance),
                      _buildActionButton(Icons.sms, 'Message', () {
                        // Add message functionality
                      }, appearance),
                      ElevatedButton(
                        onPressed: () {
                          // Add hire functionality
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
                          'Hire',
                          style: appearance.getBodyStyle().copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// Location Map Placeholder
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

                  /// Worker Details & Reviews Tab
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Details',
                        style: appearance.getTitleStyle().copyWith(
                          color: appearance.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      Text(
                        'Reviews',
                        style: appearance.getBodyStyle().copyWith(
                          color: appearance.brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  /// Worker Details Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 18, color: appearance.primaryColor),
                          const SizedBox(width: 6),
                          Text(
                            isTranslated && translatedWorker.isNotEmpty
                                ? translatedWorker['location'] ?? (widget.worker['location'] ?? 'Mumbai, India')
                                : (widget.worker['location'] ?? 'Mumbai, India'),
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
                            '₹${widget.worker['hourlyRate'] ?? '500'}/hour',
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
                          Icon(Icons.verified_user, size: 18, color: Colors.green),
                          const SizedBox(width: 6),
                          Text(
                            '${widget.worker['experience'] ?? '5'} years experience',
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
                          Icon(Icons.work, size: 18, color: appearance.primaryColor),
                          const SizedBox(width: 6),
                          Text(
                            '${widget.worker['jobsCompleted'] ?? '45'} jobs completed',
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

                  /// Skills Section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Skills & Expertise',
                      style: appearance.getTitleStyle().copyWith(
                        color: appearance.brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (widget.worker['skills'] is List<String> 
                        ? widget.worker['skills'] as List<String>
                        : (widget.worker['skills'] as String?)?.split(',').map((s) => s.trim()).toList() ?? ['Carpentry', 'Repairs', 'Installation']
                    ).map((skill) {
                      String displaySkill = skill;
                      if (isTranslated && translatedWorker.containsKey('skills')) {
                        displaySkill = translatedWorker['skills'] ?? skill;
                      }
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: appearance.primaryColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          displaySkill,
                          style: appearance.getSmallStyle().copyWith(
                            color: appearance.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  /// About Worker
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'About',
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
                    widget.worker['about'] ?? 'Experienced worker with a proven track record of delivering high-quality work. '
                        'Dedicated to customer satisfaction and attention to detail.',
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
