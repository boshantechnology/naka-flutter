import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/BidModel.dart';
import '../providers/AppearanceProvider.dart';

class JobBidsListScreen extends StatefulWidget {
  final String jobTitle;

  const JobBidsListScreen({Key? key, required this.jobTitle}) : super(key: key);

  @override
  State<JobBidsListScreen> createState() => _JobBidsListScreenState();
}

class _JobBidsListScreenState extends State<JobBidsListScreen> {
  List<Bid> _bids = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBids();
  }

  Future<void> _loadBids() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final bidsList = prefs.getStringList('user_bids') ?? [];

      final bids = bidsList
          .map((bidJson) => Bid.fromMap(jsonDecode(bidJson)))
          .where((bid) => bid.jobTitle == widget.jobTitle)
          .toList();

      setState(() {
        _bids = bids;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateBidStatus(Bid bid, String newStatus) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bidsList = prefs.getStringList('user_bids') ?? [];

      final updatedList = bidsList.map((bidJson) {
        final bidData = jsonDecode(bidJson);
        if (bidData['id'] == bid.id) {
          bidData['status'] = newStatus;
        }
        return jsonEncode(bidData);
      }).toList();

      await prefs.setStringList('user_bids', updatedList);
      _loadBids();

      if (mounted) {
        String message = newStatus == 'accepted' 
            ? '✅ बोली स्वीकार कर दी गई!'
            : '❌ बोली अस्वीकार कर दी गई';
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: newStatus == 'accepted' ? Colors.green : Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
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
          'बोलियाँ (${_bids.length})',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  appearance.primaryColor,
                ),
              ),
            )
          : _bids.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 64, color: appearance.primaryColor.withValues(alpha: 0.3)),
                      SizedBox(height: 16),
                      Text(
                        'अभी कोई बोली नहीं',
                        style: TextStyle(
                          fontSize: 16,
                          color: appearance.brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                  itemCount: _bids.length,
                  itemBuilder: (context, index) {
                    final bid = _bids[index];
                    return _BidCard(
                      bid: bid,
                      appearance: appearance,
                      onAccept: () =>
                          _updateBidStatus(bid, 'accepted'),
                      onReject: () =>
                          _updateBidStatus(bid, 'rejected'),
                    );
                  },
                ),
    );
  }
}

class _BidCard extends StatelessWidget {
  final Bid bid;
  final AppearanceProvider appearance;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _BidCard({
    Key? key,
    required this.bid,
    required this.appearance,
    required this.onAccept,
    required this.onReject,
  }) : super(key: key);

  String _getStatusText(String status) {
    switch (status) {
      case 'accepted':
        return '✅ स्वीकृत';
      case 'rejected':
        return '❌ अस्वीकृत';
      default:
        return '⏳ लंबित';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appearance.brightness == Brightness.dark
            ? const Color(0xFF2A2A2A)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: appearance.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bid.workerName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: appearance.brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'बोली: ${bid.bidDate.day}/${bid.bidDate.month}/${bid.bidDate.year}',
                      style: TextStyle(
                        fontSize: 12,
                        color: appearance.brightness == Brightness.dark
                            ? Colors.grey[400]
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(bid.status).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getStatusText(bid.status),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(bid.status),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Bid Details
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: appearance.brightness == Brightness.dark
                  ? const Color(0xFF1E1E1E)
                  : const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'बोली राशि',
                          style: TextStyle(
                            fontSize: 12,
                            color: appearance.brightness == Brightness.dark
                                ? Colors.grey[400]
                                : Colors.grey,
                          ),
                        ),
                        Text(
                          '₹${bid.bidAmount.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: appearance.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'अवधि',
                          style: TextStyle(
                            fontSize: 12,
                            color: appearance.brightness == Brightness.dark
                                ? Colors.grey[400]
                                : Colors.grey,
                          ),
                        ),
                        Text(
                          '${bid.daysRequired} दिन',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: appearance.brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 12),

          // Message
          if (bid.message.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'संदेश:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: appearance.brightness == Brightness.dark
                        ? Colors.grey[300]
                        : Colors.grey[700],
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  bid.message,
                  style: TextStyle(
                    fontSize: 13,
                    color: appearance.brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black87,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),

          // Action Buttons
          if (bid.status == 'pending')
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'अस्वीकार करें',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'स्वीकार करें',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
