import 'package:flutter/material.dart';
import 'package:naka/config/app_colors.dart';
import 'package:naka/utils/app_strings.dart';
import 'package:naka/providers/AppearanceProvider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:naka/screens/LocationPickerScreen.dart';

class PostJobPage extends StatefulWidget {
  const PostJobPage({super.key});

  @override
  State<PostJobPage> createState() => _PostJobPageState();
}

class _PostJobPageState extends State<PostJobPage> {
  // Form controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _wageController = TextEditingController();
  final TextEditingController _workersNeededController = TextEditingController();
  final TextEditingController _workDateController = TextEditingController();
  
  // Dropdown values
  final String _selectedCategory = AppStrings.jobs;
  final String _selectedSubCategory = AppStrings.dailyWage;
  String? _selectedJobType;
  String? _selectedLocation;
  String? _selectedWageType = "Per Day"; // Daily or Hourly
  bool _maintainPrivacy = false;

  // Job types for daily wage work
  final List<String> _jobTypes = [
    "Construction",
    "Cleaning",
    "Delivery",
    "Loading/Unloading",
    "Cooking",
    "Gardening",
    "Plumbing",
    "Electrical",
    "Painting",
    "Carpentry",
    "Labor",
    "Other"
  ];
  
  // Sample localities
  final List<String> _localities = ["Hitech City", "Banjara Hills", "Ameerpet", "Madhapur", "Gachibowli"];
  
  // Wage types
  final List<String> _wageTypes = ["Per Day", "Per Hour"];
  
  // Image upload
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Set default date to today
    _workDateController.text = DateTime.now().toString().split(' ')[0];
    // Get current location
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Use default if permission denied
          _selectedLocation = "Hyderabad, Telangana, India";
          setState(() {});
          return;
        }
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String city = place.locality ?? place.administrativeArea ?? "Hyderabad";
        String state = place.administrativeArea ?? "Telangana";
        String country = place.country ?? "India";
        
        setState(() {
          _selectedLocation = "$city, $state, $country";
        });
      } else {
        _selectedLocation = "Hyderabad, Telangana, India";
        setState(() {});
      }
    } catch (e) {
      // Fallback to default location
      setState(() {
        _selectedLocation = "Hyderabad, Telangana, India";
      });
      print("Error getting location: $e");
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _mobileController.dispose();
    _wageController.dispose();
    _workersNeededController.dispose();
    _workDateController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      _showError("Failed to pick image");
    }
  }

  Future<void> _captureImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      _showError("Failed to capture image");
    }
  }

  void _postJob() {
    // Validate and submit job post
    if (_validateForm()) {
      print("Job Posted Successfully!");
      print("Title: ${_titleController.text}");
      print("Job Type: $_selectedJobType");
      print("Wage: ${_wageController.text} ($_selectedWageType)");
      print("Workers Needed: ${_workersNeededController.text}");
      print("Work Date: ${_workDateController.text}");
      print("Description: ${_descriptionController.text}");
      print("Location: $_selectedLocation");
      print("Contact Mobile: ${_mobileController.text}");
      print("Privacy Setting: ${_maintainPrivacy ? 'Private' : 'Public'}");
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Job posted successfully!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  bool _validateForm() {
    // Basic validation for daily wage work
    if (_titleController.text.length < 5) {
      _showError("Job title must be at least 5 characters");
      return false;
    }
    if (_selectedJobType == null) {
      _showError("Please select job type");
      return false;
    }
    if (_wageController.text.isEmpty) {
      _showError("Please enter wage amount");
      return false;
    }
    if (_workersNeededController.text.isEmpty) {
      _showError("Please enter number of workers needed");
      return false;
    }
    if (_descriptionController.text.length < 10) {
      _showError("Description must be at least 10 characters");
      return false;
    }
    if (_selectedLocation == null || _selectedLocation!.isEmpty) {
      _showError("Please select work location from map");
      return false;
    }
    
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
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
              onPressed: () {
                // Navigate to home by finding the parent JobBottomNavigationWrapper
                // and updating its selected index to 0
                Navigator.of(context).pushNamed('/home');
              },
            ),
            title: Text(
              'Post a Job',
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
            const SizedBox(height: 10),
            
            // Job Details Section
            _buildCompactCard(
              appearance: appearance,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Job Details',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildCompactTextField(
                    'Job Title', 
                    _titleController,
                    hintText: 'e.g., Painting Work, Cleaning',
                    isRequired: true,
                    appearance: appearance,
                  ),
                  _buildCompactDropdown(
                    'Job Type',
                    _selectedJobType,
                    _jobTypes,
                    (value) {
                      setState(() {
                        _selectedJobType = value;
                      });
                    },
                    true,
                    appearance,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildCompactDropdown(
                          'Wage Type', 
                          _selectedWageType, 
                          _wageTypes, 
                          (value) {
                            setState(() {
                              _selectedWageType = value;
                            });
                          },
                          true,
                          appearance,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildCompactTextField(
                          'Wage Amount', 
                          _wageController,
                          hintText: '₹',
                          isRequired: true,
                          keyboardType: TextInputType.number,
                          appearance: appearance,
                        ),
                      ),
                    ],
                  ),
                  _buildCompactTextField(
                    'Workers Needed', 
                    _workersNeededController,
                    hintText: 'e.g., 5',
                    isRequired: true,
                    keyboardType: TextInputType.number,
                    appearance: appearance,
                  ),
                  _buildDatePickerField(appearance),
                  _buildCompactTextField(
                    'Description',
                    _descriptionController,
                    hintText: 'Describe the work details, requirements, timing...',
                    isRequired: true,
                    maxLines: 4,
                    appearance: appearance,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            
            // Image Upload Section
            _buildCompactCard(
              appearance: appearance,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Job Image (Optional)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_selectedImage == null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[300]!,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[50],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.image_outlined,
                            size: 40,
                            color: appearance.primaryColor,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'No image selected',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: _pickImage,
                                icon: const Icon(Icons.photo_library),
                                label: const Text('Gallery'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: appearance.primaryColor,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                onPressed: _captureImage,
                                icon: const Icon(Icons.camera_alt),
                                label: const Text('Camera'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[600],
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: appearance.primaryColor,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.file(
                              _selectedImage!,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton.icon(
                                  onPressed: _pickImage,
                                  icon: const Icon(Icons.edit),
                                  label: const Text('Change'),
                                ),
                                TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _selectedImage = null;
                                    });
                                  },
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  label: const Text('Remove', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: const Text(
                      '💡 Tip: Upload a clear image of the work/location (800x600px recommended for best quality). Helps workers understand the job better!',
                      style: TextStyle(fontSize: 11, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            
            // Location Section
            _buildCompactCard(
              appearance: appearance,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Work Location',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocationPickerScreen(
                            onLocationSelected: (location) {
                              setState(() {
                                _selectedLocation = location;
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
                        vertical: 12,
                        horizontal: 10,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, size: 18, color: appearance.primaryColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _selectedLocation?.isNotEmpty == true
                                  ? _selectedLocation!
                                  : 'Tap to select location on map',
                              style: TextStyle(
                                fontSize: 12,
                                color: appearance.brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.map, size: 18, color: appearance.primaryColor),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            const SizedBox(height: 10),
            
            // Privacy Section
            _buildCompactCard(
              appearance: appearance,
              child: Row(
                children: [
                  Checkbox(
                    value: _maintainPrivacy,
                    onChanged: (value) {
                      setState(() {
                        _maintainPrivacy = value ?? false;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),
                  Expanded(
                    child: Text(
                      AppStrings.maintainPrivacy,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            // Post Job Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _postJob,
                style: ElevatedButton.styleFrom(
                  backgroundColor: appearance.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Post Job Now',
                  style: appearance.getSmallStyle().copyWith(
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

  Widget _buildDatePickerField(AppearanceProvider appearance) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: 'Work Date',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: appearance.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
              children: const [
                TextSpan(
                  text: " *",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: _workDateController,
            readOnly: true,
            style: const TextStyle(fontSize: 12),
            decoration: InputDecoration(
              filled: true,
              fillColor: appearance.brightness == Brightness.dark
                  ? const Color(0xFF2A2A2A)
                  : Colors.white,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              suffixIcon: Icon(Icons.calendar_today, size: 16, color: appearance.primaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
            ),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (pickedDate != null) {
                setState(() {
                  _workDateController.text = pickedDate.toString().split(' ')[0];
                });
              }
            },
          ),
        ],
      ),
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

  Widget _buildCompactInfoField(String label, String value, AppearanceProvider appearance) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: appearance.brightness == Brightness.dark
                  ? Colors.grey[500]
                  : Colors.grey,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: appearance.getSmallStyle().copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: appearance.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactTextField(
    String label, 
    TextEditingController controller, {
    bool isRequired = false,
    String? hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    AppearanceProvider? appearance,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              children: isRequired
                  ? const [
                      TextSpan(
                        text: " *",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ]
                  : [],
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 12),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(fontSize: 12),
              filled: true,
              fillColor: appearance?.brightness == Brightness.dark
                  ? const Color(0xFF2A2A2A)
                  : Colors.white,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppColors.primary,
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

  Widget _buildCompactDropdown(
    String label,
    String? selectedValue,
    List<String> items,
    Function(String?) onChanged,
    bool isRequired,
    AppearanceProvider? appearance,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: appearance?.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
              children: isRequired
                  ? const [
                      TextSpan(
                        text: " *",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ]
                  : [],
            ),
          ),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              color: appearance?.brightness == Brightness.dark
                  ? const Color(0xFF2A2A2A)
                  : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: appearance?.brightness == Brightness.dark
                    ? Colors.grey[700]!
                    : Colors.grey[300]!,
              ),
            ),
            child: DropdownButtonFormField<String>(
              initialValue: selectedValue,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                border: InputBorder.none,
              ),
              icon: Icon(Icons.arrow_drop_down, color: appearance?.primaryColor ?? AppColors.primary, size: 18),
              isExpanded: true,
              onChanged: onChanged,
              dropdownColor: appearance?.brightness == Brightness.dark
                  ? const Color(0xFF2A2A2A)
                  : Colors.white,
              style: TextStyle(
                fontSize: 12,
                color: appearance?.brightness == Brightness.dark
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
}
