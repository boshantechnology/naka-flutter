import 'package:flutter/material.dart';
import 'package:naka/config/app_colors.dart';

class PhoneVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const PhoneVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<PhoneVerificationScreen> createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  late List<TextEditingController> otpControllers;
  late List<FocusNode> otpFocusNodes;

  @override
  void initState() {
    super.initState();
    otpControllers = List.generate(6, (_) => TextEditingController());
    otpFocusNodes = List.generate(6, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleOtpInput(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      otpFocusNodes[index + 1].requestFocus();
    }
  }

  void _verifyOtp() {
    String otp = otpControllers.map((controller) => controller.text).join();
    if (otp.length == 6) {
      // Navigate to next screen or verify OTP
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP Verified!')),
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: AppColors.bgLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  // Title
                  const Text(
                    'Verify Phone Number',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Subtitle
                  Text(
                    'Enter the OTP sent to ${widget.phoneNumber}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // OTP Input Fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      6,
                      (index) => SizedBox(
                        width: 50,
                        height: 60,
                        child: TextField(
                          controller: otpControllers[index],
                          focusNode: otpFocusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          onChanged: (value) => _handleOtpInput(index, value),
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: AppColors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.bgBorder,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Resend OTP
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Didn\'t receive OTP? ',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: 'Resend',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            recognizer: null, // Add tap gesture if needed
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Verify Button
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _verifyOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Verify OTP',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
