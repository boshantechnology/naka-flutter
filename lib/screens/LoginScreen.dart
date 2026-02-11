import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:naka/services/AuthService.dart'; // Removed old service
import 'package:naka/config/app_colors.dart';
import 'package:naka/providers/AppearanceProvider.dart';
import 'package:provider/provider.dart'; // Keep for AppearanceProvider
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod; // Alias Riverpod
import 'package:sms_autofill/sms_autofill.dart';
import 'package:naka/features/auth/presentation/providers/auth_provider.dart'; // Import new provider
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends riverpod.ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  riverpod.ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends riverpod.ConsumerState<LoginScreen> {
  bool isOtpScreen = false;
  final TextEditingController _phoneController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    _checkIfAlreadyLoggedIn();
    // Auto-read phone number from device
    _getPhoneNumberHint();
  }

  Future<void> _checkIfAlreadyLoggedIn() async {
    final prefs = await SharedPreferences.getInstance(); // Import shared_preferences if needed
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    if (isLoggedIn && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  /// Fetches phone number hint from device SIM card
  Future<void> _getPhoneNumberHint() async {
    try {
      final String? phoneNumber = await SmsAutoFill().hint;
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        // Remove country code (+91) if present and get last 10 digits
        String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
        if (cleanNumber.length > 10) {
          cleanNumber = cleanNumber.substring(cleanNumber.length - 10);
        }
        if (cleanNumber.length == 10) {
          setState(() {
            _phoneController.text = cleanNumber;
          });
        }
      }
    } catch (e) {
      // Phone number hint not available, user will enter manually
      debugPrint('Phone number hint error: $e');
    }
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

  void _listenToAuthStates() {
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthLoading) {
        // You might want to show a loading dialog here or handle it in build
      } else if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message)),
        );
      } else if (next is AuthAuthenticated) {
        Navigator.pushReplacementNamed(context, '/home'); // OR /profile based on logic
      } else if (next is AuthCodeSent) {
        setState(() {
          isOtpScreen = true;
        });
      }
    });
  }

  void _sendOtp() async {
    String phone = _phoneController.text.trim();
    if (phone.isEmpty || phone.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid 10-digit phone number")),
      );
      return;
    }

    // Call Riverpod Provider
    await ref.read(authProvider.notifier).sendOtp(phone);
  }

  void _verifyOtp() async {
    String otp = _otpControllers.map((c) => c.text).join();
    if (otp.length < 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please enter the complete OTP")));
      return;
    }
    
    // Call Riverpod Provider
    await ref.read(authProvider.notifier).verifyOtp(_phoneController.text.trim(), otp);
  }

  @override
  Widget build(BuildContext context) {
    _listenToAuthStates();
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;

    return Consumer<AppearanceProvider>(
      builder: (context, appearance, _) {
        return Scaffold(
          backgroundColor: appearance.brightness == Brightness.dark
              ? const Color(0xFF1E1E1E)
              : AppColors.bgLight,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // Professional Logo Section
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            appearance.primaryColor.withOpacity(0.2),
                            appearance.primaryColor.withOpacity(0.05),
                          ],
                        ),
                        border: Border.all(
                          color: appearance.primaryColor,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.verified_user_rounded,
                          size: 50,
                          color: appearance.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Title & Description
                    Text(
                      'Phone Verification',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: appearance.brightness == Brightness.dark
                            ? Colors.white
                            : AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isOtpScreen
                          ? 'Enter the 6-digit code we sent to your phone'
                          : 'Start earning as a daily wage worker today!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: appearance.brightness == Brightness.dark
                            ? Colors.grey[400]
                            : AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Phone Number Input Screen
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: !isOtpScreen
                          ? Column(
                              key: const ValueKey('phoneScreen'),
                              children: [
                                // Phone Input Field
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color:
                                          appearance.brightness ==
                                              Brightness.dark
                                          ? Colors.grey[700]!
                                          : Colors.grey[300]!,
                                      width: 1.5,
                                    ),
                                    color:
                                        appearance.brightness == Brightness.dark
                                        ? const Color(0xFF2A2A2A)
                                        : Colors.white,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.phone_rounded,
                                        color: appearance.primaryColor,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        '+91',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: TextField(
                                          controller: _phoneController,
                                          keyboardType: TextInputType.phone,
                                          maxLength: 10,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          decoration: InputDecoration(
                                            hintText: '98765 43210',
                                            hintStyle: TextStyle(
                                              color:
                                                  appearance.brightness ==
                                                      Brightness.dark
                                                  ? Colors.grey[600]
                                                  : Colors.grey[400],
                                            ),
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  vertical: 16,
                                                ),
                                            counterText: '',
                                          ),
                                          style: TextStyle(
                                            fontSize: 16,
                                            color:
                                                appearance.brightness ==
                                                    Brightness.dark
                                                ? Colors.white
                                                : AppColors.text,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Send OTP Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _sendOtp,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: appearance.primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      elevation: 2,
                                    ),
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Icon(Icons.send_rounded, size: 20),
                                              SizedBox(width: 8),
                                              Text(
                                                'Send Verification Code',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              key: const ValueKey('otpScreen'),
                              children: [
                                // OTP Input Fields
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: List.generate(
                                    6,
                                    (index) => SizedBox(
                                      width: 48,
                                      child: TextField(
                                        controller: _otpControllers[index],
                                        focusNode: _otpFocusNodes[index],
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        maxLength: 1,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        onChanged: (value) {
                                          if (value.isNotEmpty && index < 5) {
                                            FocusScope.of(context).requestFocus(
                                              _otpFocusNodes[index + 1],
                                            );
                                          }
                                          if (value.isEmpty && index > 0) {
                                            _otpControllers[index - 1].clear();
                                            FocusScope.of(context).requestFocus(
                                              _otpFocusNodes[index - 1],
                                            );
                                          }
                                          // Auto-submit when all 6 digits are filled
                                          if (value.isNotEmpty && index == 5) {
                                            String otp = _otpControllers
                                                .map((c) => c.text)
                                                .join();
                                            if (otp.length == 6) {
                                              _verifyOtp();
                                            }
                                          }
                                        },
                                        decoration: InputDecoration(
                                          counterText: '',
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            borderSide: BorderSide(
                                              color:
                                                  appearance.brightness ==
                                                      Brightness.dark
                                                  ? Colors.grey[700]!
                                                  : Colors.grey[300]!,
                                              width: 1.5,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            borderSide: BorderSide(
                                              color: appearance.primaryColor,
                                              width: 2,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor:
                                              appearance.brightness ==
                                                  Brightness.dark
                                              ? const Color(0xFF2A2A2A)
                                              : Colors.grey[50],
                                        ),
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                          color:
                                              appearance.brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : AppColors.text,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 28),

                                // Verify Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _verifyOtp,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: appearance.primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      elevation: 2,
                                    ),
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Icon(
                                                Icons.check_circle_rounded,
                                                size: 20,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'Verify & Continue',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 18),

                                // Edit Phone Number Link
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isOtpScreen = false;
                                      for (var controller in _otpControllers) {
                                        controller.clear();
                                      }
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Wrong number? ',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              appearance.brightness ==
                                                  Brightness.dark
                                              ? Colors.grey[500]
                                              : AppColors.textSecondary,
                                        ),
                                      ),
                                      Text(
                                        'Change it',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: appearance.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ),

                    const SizedBox(height: 32),

                    // Footer Info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: appearance.primaryColor.withOpacity(0.08),
                        border: Border.all(
                          color: appearance.primaryColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.security_rounded,
                                color: appearance.primaryColor,
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Your number is secure and will never be shared',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: appearance.primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
