import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fodie_ai/common/common.dart';
import 'package:fodie_ai/common/injection/dependencies.dart';
import 'package:image_picker/image_picker.dart';
import 'cubit/ai_chat_cubit.dart';
import 'cubit/ai_chat_state.dart';
import '../../../common/model/ai_chat_models.dart';

class AIChatPage extends StatelessWidget {
  final List<XFile>? selectedPhotos;

  const AIChatPage({
    super.key,
    this.selectedPhotos,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AIChatCubit>(),
      child: _AIChatPageContent(selectedPhotos: selectedPhotos),
    );
  }
}

class _AIChatPageContent extends StatefulWidget {
  final List<XFile>? selectedPhotos;

  const _AIChatPageContent({
    Key? key,
    this.selectedPhotos,
  }) : super(key: key);

  @override
  State<_AIChatPageContent> createState() => _AIChatPageContentState();
}

class _AIChatPageContentState extends State<_AIChatPageContent> {
  final TextEditingController _messageController = TextEditingController();

  final List<String> _suggestions = [
    'High protein',
    'Gluten free',
    'Less fat',
    'Low carb',
    'Vegetarian',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.selectedPhotos != null) {
      context.read<AIChatCubit>().setSelectedPhotos(widget.selectedPhotos!);
    }
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    _messageController.clear();
    context.read<AIChatCubit>().sendMessage(text);
  }

  void _onSuggestionTap(String suggestion) {
    _sendMessage(suggestion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu AI Assistant'),
      ),
      body: BlocBuilder<AIChatCubit, AIChatState>(
        builder: (context, state) {
          return Column(
            children: [
              // Messages list
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16.r),
                  reverse: true,
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final message = state.messages[state.messages.length - 1 - index];
                    return _buildMessageBubble(message);
                  },
                ),
              ),
              
              // Loading indicator
              if (state.status == AIChatStatus.loading)
                Padding(
                  padding: EdgeInsets.all(8.r),
                  child: const LinearProgressIndicator(),
                ),

              // Suggestions row
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.r),
                height: 50.r,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 8.r),
                  itemCount: _suggestions.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.r),
                      child: ActionChip(
                        label: Text(_suggestions[index]),
                        onPressed: () => _onSuggestionTap(_suggestions[index]),
                      ),
                    );
                  },
                ),
              ),

              // Input area
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4.r,
                      offset: Offset(0, -2.r),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Ask about your menu...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.r,
                            vertical: 8.r,
                          ),
                        ),
                        textInputAction: TextInputAction.send,
                        onSubmitted: _sendMessage,
                      ),
                    ),
                    SizedBox(width: 8.r),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () => _sendMessage(_messageController.text),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.r),
        padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 10.r),
        decoration: BoxDecoration(
          color: message.isUser
              ? Theme.of(context).primaryColor
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2.r,
              offset: Offset(0, 1.r),
            ),
          ],
        ),
        constraints: BoxConstraints(maxWidth: 0.75.sw),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? Colors.white : null,
              ),
            ),
            if (message.suggestions != null && message.suggestions!.isNotEmpty)
              ..._buildSuggestionsList(message.suggestions!),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSuggestionsList(List<MenuItemSuggestion> suggestions) {
    return [
      SizedBox(height: 8.r),
      ...suggestions.map((suggestion) => Container(
        margin: EdgeInsets.only(top: 8.r),
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              suggestion.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
            if (suggestion.description.isNotEmpty) ...[
              SizedBox(height: 4.r),
              Text(
                suggestion.description,
                style: TextStyle(fontSize: 12.sp),
              ),
            ],
            if (suggestion.matchingPreferences.isNotEmpty) ...[
              SizedBox(height: 4.r),
              Wrap(
                spacing: 4.r,
                children: suggestion.matchingPreferences
                    .map((pref) => Chip(
                          label: Text(
                            pref,
                            style: TextStyle(fontSize: 10.sp),
                          ),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ))
                    .toList(),
              ),
            ],
            if (suggestion.price != null) ...[
              SizedBox(height: 4.r),
              Text(
                '\$${suggestion.price!.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ],
        ),
      )),
    ];
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}