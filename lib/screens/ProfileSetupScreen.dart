import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:naka/config/app_colors.dart';

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
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: AppColors.bgLight,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Create Profile',
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildProfileImageField(),
            const SizedBox(height: 24),
            _buildInputField(
              label: 'Name',
              placeholder: 'Enter your name',
              icon: Icons.person,
              controller: _nameController,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: _buildDropdownField(
                    label: 'Gender',
                    items: ['Male', 'Female', 'Other'],
                    icon: Icons.wc,
                    isCompact: true,
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  flex: 1,
                  child: _buildInputField(
                    label: 'Age',
                    placeholder: 'Enter your age',
                    icon: Icons.cake,
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: _buildDropdownField(
                    label: 'Experience (Years)',
                    items: ['0-1', '1-2', '2-3', '3+'],
                    icon: Icons.work,
                    onChanged: (value) {
                      _experienceController.text = value ?? '';
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  flex: 1,
                  child: _buildDropdownField(
                    label: 'Daily Wage',
                    items: ['200-300', '300-500', '500-800', '800+'],
                    icon: Icons.attach_money,
                    onChanged: (value) {
                      _wageController.text = value ?? '';
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInputField(
              label: 'Profession',
              placeholder: 'Enter your profession',
              icon: Icons.business_center,
              controller: _professionController,
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              label: 'Profession Type',
              items: ['Helper', 'Technician'],
              icon: Icons.category,
              onChanged: (value) {
                setState(() {
                  _professionType = value;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildLocationField(),
            const SizedBox(height: 24),
            _buildSaveButton(),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox.shrink(),
    );
  }

  Widget _buildProfileImageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Profile Image (Optional)',
          style: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: GestureDetector(
            onTap: _showImageSourceDialog,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(60),
                border: Border.all(color: AppColors.grey),
                image: _profileImage != null
                    ? DecorationImage(
                        image: FileImage(_profileImage!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _profileImage == null
                  ? const Icon(Icons.camera_alt, color: AppColors.primary, size: 40)
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required String placeholder,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w500,
                fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(
              color: AppColors.greyMedium,
              fontSize: 16,
            ),
            filled: true,
            fillColor: AppColors.bgSurface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            prefixIcon: Icon(icon, color: AppColors.primary),
          ),
          style: const TextStyle(color: AppColors.text, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required List<String> items,
    required IconData icon,
    bool isCompact = false,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w500,
                fontSize: 16)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.bgSurface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 14,
              horizontal: isCompact ? 8 : 16,
            ),
            prefixIcon: Icon(icon, color: AppColors.primary),
            prefixIconConstraints: isCompact
                ? const BoxConstraints(minWidth: 36, minHeight: 36)
                : null,
          ),
          dropdownColor: AppColors.bgSurface,
          items: items
              .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                        color: AppColors.text,
                        fontSize: isCompact ? 14 : 16),
                  )))
              .toList(),
          onChanged: onChanged,
          hint: Text(
            'Select',
            style: TextStyle(
                color: AppColors.greyMedium,
                fontSize: isCompact ? 14 : 16),
          ),
          isDense: isCompact,
        ),
      ],
    );
  }

  Widget _buildLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
          style: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _locationController,
          enabled: false,
          decoration: InputDecoration(
            hintText: 'Auto-filled location',
            hintStyle: const TextStyle(color: AppColors.greyMedium, fontSize: 16),
            filled: true,
            fillColor: AppColors.bgSurface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            prefixIcon: const Icon(Icons.location_on, color: AppColors.primary),
          ),
          style: const TextStyle(color: AppColors.text, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: const Text(
          'Save Profile',
          style: TextStyle(
              color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
