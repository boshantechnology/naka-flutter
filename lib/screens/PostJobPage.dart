import 'package:flutter/material.dart';
import 'package:naka/config/app_colors.dart';
import 'package:naka/utils/app_strings.dart';
import 'package:naka/providers/AppearanceProvider.dart';
import 'package:provider/provider.dart';

class PostJobPage extends StatefulWidget {
  const PostJobPage({super.key});

  @override
  State<PostJobPage> createState() => _PostJobPageState();
}

class _PostJobPageState extends State<PostJobPage> {
  // Form controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _minSalaryController = TextEditingController();
  final TextEditingController _maxSalaryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _roleSearchController = TextEditingController();
  
  // Dropdown values
  final String? _selectedCategory = AppStrings.jobs;
  String? _selectedSubCategory = AppStrings.fullTimeJobs;
  String? _selectedRole;
  String? _selectedLocation = "Hyderabad";
  String? _selectedLocality;
  String? _selectedSalaryType = "Monthly"; // Default salary type
  bool _maintainPrivacy = false;
  bool _isRoleSearching = false;

  // Sample roles for dropdown - expanded for better search demonstration
  final List<String> _allRoles = [
    "Software Developer", 
    "Web Developer",
    "Mobile App Developer",
    "UI/UX Designer", 
    "Graphic Designer",
    "Project Manager",
    "Product Manager",
    "Business Analyst",
    "Data Analyst",
    "Data Scientist",
    "Digital Marketing Specialist",
    "Content Writer",
    "HR Manager",
    "Accountant",
    "Sales Executive",
    "Customer Support",
    "System Administrator",
    "Network Engineer",
    "DevOps Engineer",
    "QA Tester"
  ];
  
  List<String> _filteredRoles = [];
  
  // Sample localities
  final List<String> _localities = ["Hitech City", "Banjara Hills", "Ameerpet", "Madhapur", "Gachibowli"];
  
  // Salary types
  final List<String> _salaryTypes = ["Yearly", "Monthly", "Daily"];

  @override
  void initState() {
    super.initState();
    // Initialize filtered roles with all roles
    _filteredRoles = List.from(_allRoles);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _minSalaryController.dispose();
    _maxSalaryController.dispose();
    _descriptionController.dispose();
    _mobileController.dispose();
    _roleSearchController.dispose();
    super.dispose();
  }

  void _filterRoles(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredRoles = List.from(_allRoles);
      } else {
        _filteredRoles = _allRoles
            .where((role) => role.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _selectRole(String role) {
    setState(() {
      _selectedRole = role;
      _roleSearchController.text = role;
      _isRoleSearching = false;
    });
  }

  void _postJob() {
    // Validate and submit job post
    if (_validateForm()) {
      print("Job Posted Successfully!");
      print("Title: ${_titleController.text}");
      print("Category: $_selectedCategory");
      print("Sub-Category: $_selectedSubCategory");
      print("Role: $_selectedRole");
      print("Salary Type: $_selectedSalaryType");
      print("Salary Range: ${_minSalaryController.text} - ${_maxSalaryController.text}");
      print("Description: ${_descriptionController.text}");
      print("Location: $_selectedLocation");
      print("Locality: $_selectedLocality");
      print("Contact Mobile: ${_mobileController.text}");
      print("Privacy Setting: ${_maintainPrivacy ? 'Private' : 'Public'}");
    }
  }

  bool _validateForm() {
    // Basic validation
    if (_titleController.text.length < 10) {
      _showError("Ad title must be at least 10 characters");
      return false;
    }
    if (_descriptionController.text.length < 30) {
      _showError("Description must be at least 30 characters");
      return false;
    }
    if (_selectedRole == null) {
      _showError("Please select a role");
      return false;
    }
    if (_selectedSalaryType == null) {
      _showError("Please select salary type");
      return false;
    }
    if (_minSalaryController.text.isEmpty || _maxSalaryController.text.isEmpty) {
      _showError("Please enter salary range");
      return false;
    }
    if (_selectedLocation == null) {
      _showError("Please select job location");
      return false;
    }
    if (_selectedLocality == null) {
      _showError("Please select locality");
      return false;
    }
    if (_mobileController.text.isEmpty) {
      _showError("Please enter contact mobile number");
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
                // Category Section
                _buildCompactCard(
                  appearance: appearance,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                    'Category Details',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildCompactInfoField(AppStrings.category, _selectedCategory ?? "", appearance),
                  _buildCompactDropdown(
                    AppStrings.subCategory,
                    _selectedSubCategory,
                    [
                      AppStrings.fullTimeJobs, 
                      AppStrings.partTimeJobs, 
                      AppStrings.dailyWage, 
                      AppStrings.workFromHome
                    ],
                    (value) {
                      setState(() {
                        _selectedSubCategory = value;
                      });
                    },
                    false,
                    appearance,
                  ),
                ],
              ),
            ),
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
                    AppStrings.enterTitle, 
                    _titleController,
                    isRequired: true,
                    appearance: appearance,
                  ),
                  _buildSearchableRoleFieldCompact(appearance),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildCompactDropdown(
                          AppStrings.salaryType, 
                          _selectedSalaryType, 
                          _salaryTypes, 
                          (value) {
                            setState(() {
                              _selectedSalaryType = value;
                            });
                          },
                          true,
                          appearance,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildCompactTextField(
                          'Min Salary', 
                          _minSalaryController,
                          isRequired: true,
                          keyboardType: TextInputType.number,
                          appearance: appearance,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildCompactTextField(
                          'Max Salary', 
                          _maxSalaryController,
                          isRequired: true,
                          keyboardType: TextInputType.number,
                          appearance: appearance,
                        ),
                      ),
                    ],
                  ),
                  _buildCompactTextField(
                    AppStrings.adDescription,
                    _descriptionController,
                    isRequired: true,
                    maxLines: 3,
                    appearance: appearance,
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
                    'Location',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildCompactDropdown(
                    AppStrings.contactInfo, 
                    _selectedLocation, 
                    ["Hyderabad", "Mumbai", "Delhi", "Bangalore", "Chennai"], 
                    (value) {
                      setState(() {
                        _selectedLocation = value;
                      });
                    },
                    true,
                    appearance,
                  ),
                  _buildCompactDropdown(
                    AppStrings.locality, 
                    _selectedLocality, 
                    _localities, 
                    (value) {
                      setState(() {
                        _selectedLocality = value;
                      });
                    },
                    true,
                    appearance,
                  ),
                  _buildCompactTextField(
                    AppStrings.mobile, 
                    _mobileController,
                    isRequired: true,
                    keyboardType: TextInputType.phone,
                    appearance: appearance,
                  ),
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

  Widget _buildSearchableRoleFieldCompact(AppearanceProvider appearance) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: AppStrings.selectRole,
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
          Container(
            decoration: BoxDecoration(
              color: appearance.brightness == Brightness.dark
                  ? const Color(0xFF2A2A2A)
                  : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: (appearance.brightness == Brightness.dark
                    ? Colors.grey[700]
                    : Colors.grey[300]) ?? Colors.grey[300]!,
              ),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _roleSearchController,
                  style: TextStyle(
                    fontSize: 12,
                    color: appearance.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: AppStrings.searchRole,
                    hintStyle: TextStyle(
                      fontSize: 12,
                      color: appearance.brightness == Brightness.dark
                          ? Colors.grey[600]
                          : Colors.grey[400],
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      iconSize: 18,
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        _isRoleSearching ? Icons.close : Icons.arrow_drop_down,
                        color: appearance.primaryColor,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_isRoleSearching) {
                            _roleSearchController.clear();
                            _filterRoles("");
                          }
                          _isRoleSearching = !_isRoleSearching;
                        });
                      },
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _isRoleSearching = true;
                    });
                  },
                  onChanged: (value) {
                    _filterRoles(value);
                  },
                ),
                if (_isRoleSearching)
                  Container(
                    constraints: const BoxConstraints(
                      maxHeight: 150,
                    ),
                    child: _filteredRoles.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              "No roles found",
                              style: TextStyle(
                                fontSize: 11,
                                color: appearance.brightness == Brightness.dark
                                    ? Colors.grey[500]
                                    : Colors.grey[600],
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: _filteredRoles.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  _filteredRoles[index],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: appearance.brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                dense: true,
                                onTap: () {
                                  _selectRole(_filteredRoles[index]);
                                },
                                tileColor: appearance.brightness == Brightness.dark
                                    ? const Color(0xFF2A2A2A)
                                    : Colors.white,
                                hoverColor: appearance.primaryColor.withOpacity(0.1),
                              );
                            },
                          ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}