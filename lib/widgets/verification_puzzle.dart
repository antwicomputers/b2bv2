import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VerificationPuzzle extends StatefulWidget {
  final Function(bool) onVerified;

  const VerificationPuzzle({super.key, required this.onVerified});

  @override
  State<VerificationPuzzle> createState() => _VerificationPuzzleState();
}

class _VerificationPuzzleState extends State<VerificationPuzzle> {
  double _dragValue = 0.0;
  bool _isVerified = false;
  final double _threshold = 0.9; // 90% of the way to verify

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: _isVerified ? Colors.green.withValues(alpha: 0.5) : Colors.white12),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              _isVerified ? "VERIFIED" : "SLIDE TO VERIFY",
              style: GoogleFonts.bebasNeue(
                letterSpacing: 2,
                color: _isVerified ? Colors.green : Colors.white38,
                fontSize: 16,
              ),
            ),
          ),
          Positioned(
            left: _dragValue * (MediaQuery.of(context).size.width - 124), // Approx width minus padding
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                if (_isVerified) return;
                setState(() {
                  double move = details.primaryDelta! / (MediaQuery.of(context).size.width - 124);
                  _dragValue = (_dragValue + move).clamp(0.0, 1.0);
                });
              },
              onHorizontalDragEnd: (details) {
                if (_isVerified) return;
                if (_dragValue >= _threshold) {
                  setState(() {
                    _dragValue = 1.0;
                    _isVerified = true;
                  });
                  widget.onVerified(true);
                } else {
                  setState(() {
                    _dragValue = 0.0;
                  });
                }
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _isVerified ? Colors.green : Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  _isVerified ? Icons.check : Icons.arrow_forward_ios_rounded,
                  color: _isVerified ? Colors.white : Colors.black,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
