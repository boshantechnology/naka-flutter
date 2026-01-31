import 'package:flutter/material.dart';
import 'package:naka/utils/app_strings.dart'; // Import app_strings.dart

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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppStrings.postFreeJob,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(AppStrings.categoryDetails),
            _buildInfoField(AppStrings.category, _selectedCategory ?? ""),
            _buildDropdownField(
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
            ),
            _buildSectionHeader(AppStrings.adDetails),
            _buildTextField(
              AppStrings.enterTitle, 
              _titleController,
              isRequired: true,
            ),
            _buildSearchableRoleField(),
            _buildDropdownField(
              AppStrings.salaryType, 
              _selectedSalaryType, 
              _salaryTypes, 
              (value) {
                setState(() {
                  _selectedSalaryType = value;
                });
              },
              true,
            ),
            _buildTextField(
              AppStrings.minSalary, 
              _minSalaryController,
              isRequired: true,
              keyboardType: TextInputType.number,
            ),
            _buildTextField(
              AppStrings.maxSalary, 
              _maxSalaryController,
              isRequired: true,
              keyboardType: TextInputType.number,
            ),
            _buildTextField(
              AppStrings.adDescription, 
              _descriptionController,
              isRequired: true,
              maxLines: 3,
            ),
            _buildSectionHeader(AppStrings.jobLocation),
            _buildDropdownField(
              AppStrings.contactInfo, 
              _selectedLocation, 
              ["Hyderabad", "Mumbai", "Delhi", "Bangalore", "Chennai"], 
              (value) {
                setState(() {
                  _selectedLocation = value;
                });
              },
              true,
            ),
            _buildDropdownField(
              AppStrings.locality, 
              _selectedLocality, 
              _localities, 
              (value) {
                setState(() {
                  _selectedLocality = value;
                });
              },
              true,
            ),
            _buildTextField(
              AppStrings.mobile, 
              _mobileController,
              isRequired: true,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    AppStrings.privacy,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text(AppStrings.maintainPrivacy),
              value: _maintainPrivacy,
              onChanged: (value) {
                setState(() {
                  _maintainPrivacy = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
              activeColor: Colors.teal,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _postJob,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  AppStrings.postJob,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox.shrink(),
    );
  }

  Widget _buildSearchableRoleField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: AppStrings.selectRole,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
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
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey[300]!,
              ),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _roleSearchController,
                  decoration: InputDecoration(
                    hintText: AppStrings.searchRole,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isRoleSearching ? Icons.close : Icons.arrow_drop_down,
                        color: Colors.teal,
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
                      maxHeight: 200,
                    ),
                    child: _filteredRoles.isEmpty
                        ? ListTile(
                            title: Text(
                              "No roles found",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: _filteredRoles.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(_filteredRoles[index]),
                                onTap: () {
                                  _selectRole(_filteredRoles[index]);
                                },
                                tileColor: Colors.white,
                                hoverColor: Colors.teal.withOpacity(0.1),
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

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: const Color(0xFFEEEEEE),
      width: double.infinity,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Divider(color: Colors.teal.withOpacity(0.3)),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label, 
    TextEditingController controller, {
    bool isRequired = false,
    String? hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
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
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
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
                  color: Colors.teal,
                  width: 2,
                ),
              ),
            ),
            cursorColor: Colors.teal,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    String? selectedValue,
    List<String> items,
    Function(String?) onChanged,
    bool isRequired,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
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
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey[300]!,
              ),
            ),
            child: DropdownButtonFormField<String>(
              initialValue: selectedValue,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: InputBorder.none,
              ),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.teal),
              isExpanded: true,
              onChanged: onChanged,
              dropdownColor: Colors.white,
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