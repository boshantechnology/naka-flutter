import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:naka/config/app_colors.dart';
import 'package:naka/screens/LocationPickerScreen.dart';
import 'package:naka/providers/AppearanceProvider.dart';
import 'package:provider/provider.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _wageController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String? _gender;
  String? _professionType;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _locationController.text = "Location services disabled";
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _locationController.text = "Permission denied";
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _locationController.text = "Permission permanently denied";
      return;
    }

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      final Placemark place = placemarks[0];
      String city = place.locality ?? '';
      String state = place.administrativeArea ?? '';
      String country = place.country ?? '';
      setState(() {
        _locationController.text = "$city, $state, $country";
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _experienceController.dispose();
    _wageController.dispose();
    _professionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _chooseImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.primary),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _chooseImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.primary),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _chooseImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

   Future<void> _submitForm() async {
    final formData = {
      'name': _nameController.text,
      'gender': _gender ?? '',
      'age': _ageController.text,
      'experience': _experienceController.text,
      'dailyWage': _wageController.text,
      'profession': _professionController.text,
      'professionType': _professionType ?? '',
      'location': _locationController.text,
      'profileImage': _profileImage?.path ?? 'No image selected',
    };
  
    print('Profile Form Data:');
    formData.forEach((key, value) {
      print('$key: $value');
    });
   final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('is_profile_done', true);
    // Navigate to home screen using named route
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppearanceProvider>(
      builder: (context, appearance, _) {
        return Scaffold(
          backgroundColor: appearance.brightness == Brightness.dark
              ? const Color(0xFF1E1E1E)
              : const Color(0xFFF8F9FA),
          appBar: AppBar(
            backgroundColor: appearance.brightness == Brightness.dark
                ? const Color(0xFF2A2A2A)
                : Colors.white,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: appearance.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Create Profile',
              style: TextStyle(
                color: appearance.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image Card
                _buildCompactCard(
                  appearance: appearance,
                  child: Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8EEF5),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: appearance.primaryColor,
                              width: 2,
                        ),
                        image: _profileImage != null
                            ? DecorationImage(
                                image: FileImage(_profileImage!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _profileImage == null
                          ? const Icon(
                              Icons.camera_alt,
                              color: Color(0xFF8B94A8),
                              size: 32,
                            )
                          : null,
                    ),
                    GestureDetector(
                      onTap: _showImageSourceDialog,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            
            // Personal Info Card
            _buildCompactCard(
              appearance: appearance,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildCompactInputField(
                    label: 'Full Name',
                    placeholder: 'Enter your full name',
                    controller: _nameController,
                    appearance: appearance,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildCompactDropdownFieldNew(
                          label: 'Gender',
                          items: ['Male', 'Female', 'Other'],
                          onChanged: (value) {
                            setState(() {
                              _gender = value;
                            });
                          },
                          appearance: appearance,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildCompactInputField(
                          label: 'Age',
                          placeholder: 'Enter age',
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          appearance: appearance,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            
            // Experience & Wage Card
            _buildCompactCard(
              appearance: appearance,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Work Information',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildCompactDropdownFieldNew(
                          label: 'Experience',
                          items: ['0-1', '1-2', '2-3', '3-5', '5+'],
                          onChanged: (value) {
                            _experienceController.text = value ?? '';
                          },
                          appearance: appearance,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildCompactInputField(
                          label: 'Daily Wage',
                          placeholder: 'In USD',
                          controller: _wageController,
                          keyboardType: TextInputType.number,
                          appearance: appearance,
                        ),
                      ),
                    ],
                  ),
                  _buildCompactInputField(
                    label: 'Profession',
                    placeholder: 'e.g. Electrician, Plumber',
                    controller: _professionController,
                    appearance: appearance,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildCompactDropdownFieldNew(
                          label: 'Profession Type',
                          items: ['Helper', 'Technician', 'Specialist', 'Manager'],
                          onChanged: (value) {
                            setState(() {
                              _professionType = value;
                            });
                          },
                          appearance: appearance,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildCompactLocationFieldNew(appearance: appearance),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Complete Profile',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompactCard({required Widget child, required AppearanceProvider appearance}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: appearance.brightness == Brightness.dark
            ? const Color(0xFF2A2A2A)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildCompactInputField({
    required String label,
    required String placeholder,
    required TextEditingController controller,
    required AppearanceProvider appearance,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: appearance.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyle(
              fontSize: 12,
              color: appearance.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(
                fontSize: 12,
                color: appearance.brightness == Brightness.dark
                    ? Colors.grey[600]
                    : const Color(0xFFA0A8B8),
              ),
              filled: true,
              fillColor: appearance.brightness == Brightness.dark
                  ? const Color(0xFF2A2A2A)
                  : Colors.white,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: appearance.brightness == Brightness.dark
                      ? Colors.grey[700]!
                      : Colors.grey[300]!,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: appearance.brightness == Brightness.dark
                      ? Colors.grey[700]!
                      : Colors.grey[300]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF17A2B8),
                  width: 1.5,
                ),
              ),
            ),
            cursorColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildCompactDropdownFieldNew({
    required String label,
    required List<String> items,
    required void Function(String?) onChanged,
    required AppearanceProvider appearance,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: appearance.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              color: appearance.brightness == Brightness.dark
                  ? const Color(0xFF2A2A2A)
                  : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: appearance.brightness == Brightness.dark
                    ? Colors.grey[700]!
                    : Colors.grey[300]!,
              ),
            ),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                border: InputBorder.none,
              ),
              icon: Icon(Icons.arrow_drop_down, color: appearance.primaryColor, size: 18),
              isExpanded: true,
              onChanged: onChanged,
              dropdownColor: appearance.brightness == Brightness.dark
                  ? const Color(0xFF2A2A2A)
                  : Colors.white,
              style: TextStyle(
                fontSize: 12,
                color: appearance.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
              items: items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactLocationFieldNew({required AppearanceProvider appearance}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: appearance.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LocationPickerScreen(
                    onLocationSelected: (location) {
                      setState(() {
                        _locationController.text = location;
                      });
                    },
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: appearance.brightness == Brightness.dark
                    ? const Color(0xFF2A2A2A)
                    : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: appearance.brightness == Brightness.dark
                      ? Colors.grey[700]!
                      : Colors.grey[300]!,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _locationController.text.isEmpty
                          ? 'Select Location'
                          : _locationController.text,
                      style: TextStyle(
                        fontSize: 12,
                        color: _locationController.text.isEmpty
                            ? (appearance.brightness == Brightness.dark
                                ? Colors.grey[600]
                                : const Color(0xFFA0A8B8))
                            : (appearance.brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black87),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.location_on,
                    color: appearance.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
