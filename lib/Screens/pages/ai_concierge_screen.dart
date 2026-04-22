import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:b2bmobile/providers/user_provider.dart';
import '../../services/ai_service.dart';

class AIConciergeScreen extends StatefulWidget {
  const AIConciergeScreen({super.key});

  @override
  State<AIConciergeScreen> createState() => _AIConciergeScreenState();
}

class _AIConciergeScreenState extends State<AIConciergeScreen> {
  final TextEditingController _queryController = TextEditingController();
  final List<Map<String, String>> _messages = [
    {
      'role': 'ai',
      'text': "Welcome to Back 2 Black. I'm your AI Concierge. How can I assist you with finding Black-owned businesses today?"
    }
  ];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleAskAI() async {
    final text = _queryController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _queryController.clear();
      _isLoading = true;
    });
    _scrollToBottom();

    final response = await AIService().getResponse(
      prompt: text,
      systemContext: "You are the Concierge for Back 2 Black. Your job is to help the user navigate the community, find businesses, and explain the loyalty points system.",
      agentType: 'concierge',
    );

    if (mounted) {
      setState(() {
        _messages.add({'role': 'ai', 'text': response});
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final isPremium = userProvider.userModel?.isBlack ?? false;

    if (!isPremium) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.rocket_launch, size: 80, color: Colors.blueAccent),
                const SizedBox(height: 24),
                Text("AI CONCIERGE", style: GoogleFonts.bebasNeue(fontSize: 32, letterSpacing: 2)),
                const SizedBox(height: 16),
                Text(
                  "This is a premium feature exclusive to verified Black-owned business members. Please complete your verification to unlock AI-powered insights and concierge services.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(color: Colors.white70, fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Go Back", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("AI CONCIERGE", style: GoogleFonts.bebasNeue(letterSpacing: 2.0)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (ctx, i) => _buildMessageBubble(_messages[i]),
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white60)),
            ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, String> msg) {
    final isAI = msg['role'] == 'ai';
    return Align(
      alignment: isAI ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isAI ? const Color(0xFF1E1E1E) : Colors.white10,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isAI ? Colors.white.withValues(alpha: 0.1) : Colors.transparent),
        ),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Text(
          msg['text']!,
          style: GoogleFonts.outfit(color: isAI ? Colors.white70 : Colors.white, fontSize: 14, height: 1.4),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      decoration: const BoxDecoration(
        color: Color(0xFF0F0F0F),
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _queryController,
              onSubmitted: (_) => _handleAskAI(),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: "Ask me anything...",
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.send_rounded, color: Colors.black, size: 18),
              onPressed: _handleAskAI,
            ),
          ),
        ],
      ),
    );
  }
}
