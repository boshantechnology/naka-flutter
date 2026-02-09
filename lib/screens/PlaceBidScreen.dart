import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../models/BidModel.dart';
import '../providers/AppearanceProvider.dart';

class PlaceBidScreen extends StatefulWidget {
  final Map<String, dynamic> job;

  const PlaceBidScreen({super.key, required this.job});

  @override
  State<PlaceBidScreen> createState() => _PlaceBidScreenState();
}

class _PlaceBidScreenState extends State<PlaceBidScreen> {
  late TextEditingController _bidAmountController;
  late TextEditingController _daysController;
  late TextEditingController _messageController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _bidAmountController = TextEditingController();
    _daysController = TextEditingController();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _bidAmountController.dispose();
    _daysController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitBid() async {
    if (_bidAmountController.text.isEmpty ||
        _daysController.text.isEmpty ||
        _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('सभी फील्ड भरें'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final bidAmount = double.parse(_bidAmountController.text);
      final days = int.parse(_daysController.text);

      if (bidAmount <= 0 || days <= 0) {
        throw FormatException('राशि और दिन सकारात्मक होने चाहिए');
      }

      final bid = Bid(
        id: const Uuid().v4(),
        jobTitle: widget.job['title'] as String,
        workerName: 'आप',
        bidAmount: bidAmount,
        daysRequired: days,
        message: _messageController.text,
        status: 'pending',
        bidDate: DateTime.now(),
      );

      final prefs = await SharedPreferences.getInstance();
      final bidsList = prefs.getStringList('user_bids') ?? [];
      bidsList.add(jsonEncode(bid.toMap()));
      await prefs.setStringList('user_bids', bidsList);

      // Notification
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '✅ बोली सफलतापूर्वक लगाई गई!',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '₹${bidAmount.toStringAsFixed(0)} का बोली',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('त्रुटि: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appearance = Provider.of<AppearanceProvider>(context);

    return Scaffold(
      backgroundColor: appearance.brightness == Brightness.dark
          ? const Color(0xFF1E1E1E)
          : const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: appearance.primaryColor,
        elevation: 0,
        title: Text(
          'बोली लगाएं',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job Details Card
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: appearance.brightness == Brightness.dark
                    ? const Color(0xFF2A2A2A)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: appearance.primaryColor.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'काम का विवरण',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: appearance.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.work, color: appearance.primaryColor, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'काम का नाम',
                              style: TextStyle(
                                fontSize: 12,
                                color: appearance.brightness == Brightness.dark
                                    ? Colors.grey[400]
                                    : Colors.grey,
                              ),
                            ),
                            Text(
                              widget.job['title'] as String,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: appearance.brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.attach_money,
                          color: appearance.primaryColor, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'बजट',
                              style: TextStyle(
                                fontSize: 12,
                                color: appearance.brightness == Brightness.dark
                                    ? Colors.grey[400]
                                    : Colors.grey,
                              ),
                            ),
                            Text(
                              widget.job['salary'] as String,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: appearance.brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Bid Amount
            Text(
              'आपकी बोली राशि (₹)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: appearance.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _bidAmountController,
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: appearance.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
              decoration: InputDecoration(
                hintText: 'उदा: 5000',
                hintStyle: TextStyle(
                  color: appearance.brightness == Brightness.dark
                      ? Colors.grey[400]
                      : Colors.grey,
                ),
                prefixIcon: Icon(Icons.currency_rupee,
                    color: appearance.primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: appearance.primaryColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: appearance.primaryColor.withValues(alpha: 0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: appearance.primaryColor),
                ),
                filled: true,
                fillColor: appearance.brightness == Brightness.dark
                    ? const Color(0xFF2A2A2A)
                    : const Color(0xFFF5F5F5),
              ),
            ),
            SizedBox(height: 20),

            // Days Required
            Text(
              'कितने दिनों में पूरा करेंगे?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: appearance.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _daysController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: appearance.brightness == Brightness.dark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                hintText: 'दिन संख्या',
                hintStyle: TextStyle(
                  color: appearance.brightness == Brightness.dark
                      ? Colors.grey[400]
                      : Colors.grey,
                ),
                prefixIcon: Icon(Icons.calendar_today,
                    color: appearance.primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: appearance.primaryColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: appearance.primaryColor.withValues(alpha: 0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: appearance.primaryColor),
                ),
                filled: true,
                fillColor: appearance.brightness == Brightness.dark
                    ? const Color(0xFF2A2A2A)
                    : const Color(0xFFF5F5F5),
              ),
            ),
            SizedBox(height: 20),

            // Message
            Text(
              'संदेश (वैकल्पिक)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: appearance.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _messageController,
              maxLines: 4,
              style: TextStyle(color: appearance.brightness == Brightness.dark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                hintText: 'अपने कौशल और अनुभव के बारे में बताएं...',
                hintStyle: TextStyle(
                  color: appearance.brightness == Brightness.dark
                      ? Colors.grey[400]
                      : Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: appearance.primaryColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: appearance.primaryColor.withValues(alpha: 0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: appearance.primaryColor),
                ),
                filled: true,
                fillColor: appearance.brightness == Brightness.dark
                    ? const Color(0xFF2A2A2A)
                    : const Color(0xFFF5F5F5),
              ),
            ),
            SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitBid,
                style: ElevatedButton.styleFrom(
                  backgroundColor: appearance.primaryColor,
                  disabledBackgroundColor:
                      appearance.primaryColor.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isSubmitting
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'बोली जमा करें',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
