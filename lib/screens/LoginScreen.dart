import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naka/services/AuthService.dart';
import 'package:naka/config/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isOtpScreen = false;
  final TextEditingController _phoneController = TextEditingController();
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
      List.generate(6, (_) => FocusNode());
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    // No listeners needed - using onChanged callback in TextField instead
  }

  @override
  void dispose() {
    _phoneController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _sendOtp() async {
    String phone = _phoneController.text.trim();
    if (phone.isEmpty || phone.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid phone number")),
      );
      return;
    }

    await _authService.savePhoneNumber(phone);
    setState(() {
      isOtpScreen = true;
    });
  }

  void _verifyOtp() async {
    String otp = _otpControllers.map((c) => c.text).join();
    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter the complete OTP")),
      );
      return;
    }

    if (otp == "123456") { // ✅ Mock verification
      await _authService.loginSuccess();
      Navigator.pushReplacementNamed(context, '/profile');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid OTP")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo/Image
            Container(
              height: 150,
              width: 150,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                      'https://i.postimg.cc/zDLDCwp7/image2.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Phone Verification',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'We need to register your phone number before getting started!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            if (!isOtpScreen)
              Column(
                children: [
                  // Phone Input
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.bgBorder),
                      color: AppColors.white,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.arrow_drop_down,
                            color: AppColors.black),
                        const SizedBox(width: 8),
                        const Text(
                          '+91',
                          style: TextStyle(fontSize: 16, color: AppColors.black),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              hintText: 'Enter phone number',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: AppColors.bgBorder),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _sendOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Send the Code',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white),
                      ),
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  // OTP Inputs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      6,
                      (index) => SizedBox(
                        width: 50,
                        child: TextField(
                          controller: _otpControllers[index],
                          focusNode: _otpFocusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) {
                            // Move to next field automatically
                            if (value.isNotEmpty && index < 5) {
                              FocusScope.of(context).requestFocus(_otpFocusNodes[index + 1]);
                            }
                            // If backspace on empty field, go to previous
                            if (value.isEmpty && index > 0) {
                              _otpControllers[index - 1].clear();
                              FocusScope.of(context).requestFocus(_otpFocusNodes[index - 1]);
                            }
                          },
                          decoration: InputDecoration(
                            counterText: '',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                              color: AppColors.textSecondary,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _verifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Verify Phone Number',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Edit phone number?',
                        style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isOtpScreen = false;
                            // Clear OTP fields
                            for (var controller in _otpControllers) {
                              controller.clear();
                            }
                          });
                        },
                        child: const Text(
                          'Send again',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
