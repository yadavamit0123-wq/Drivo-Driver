import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/common/common.dart';
import 'package:restart_tagxi/core/model/user_detail_model.dart';
import 'package:restart_tagxi/core/utils/custom_loader.dart';
import 'package:restart_tagxi/core/utils/custom_textfield.dart';
import 'package:restart_tagxi/features/home/application/home_bloc.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';

class ChatPageWidget extends StatelessWidget {
  const ChatPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      final bloc = context.read<HomeBloc>();

      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          titleSpacing: 0,
          title: Row(
            children: [
              // Back button
              IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded,
                    color: Theme.of(context).primaryColorDark, size: 20),
                onPressed: () {
                  Navigator.of(context).pop();
                  bloc.add(ChatSeenEvent());
                  bloc.add(ShowChatEvent());
                },
              ),
              // User avatar
              Container(
                height: size.width * 0.13,
                width: size.width * 0.13,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Theme.of(context)
                        .disabledColor
                        .withAlpha((0.2 * 255).toInt())),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: CachedNetworkImage(
                    imageUrl: userData!.onTripRequest!.userImage,
                    fit: BoxFit.fill,
                    placeholder: (context, url) => const Center(
                      child: Loader(),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Text(""),
                    ),
                  ),
                ),
              ),
              SizedBox(width: size.width * 0.025),
              // User name
              Expanded(
                child: Text(
                  userData!.onTripRequest!.userName,
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                width: size.width,
                height: 1, // Fixed height for divider
                color: AppColors.hintColor.withOpacity(0.2),
              ),
              SizedBox(height: size.width * 0.05),
              // Chat messages
              Expanded(
                child: SingleChildScrollView(
                  controller: bloc.chatScrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _chatHistoryData(size, context, bloc.chats),
                      SizedBox(height: size.width * 0.025),
                    ],
                  ),
                ),
              ),

              // Input bar
              _inputBar(context, size, bloc),
            ],
          ),
        ),
      );
    });
  }

  Widget _inputBar(BuildContext context, Size size, HomeBloc bloc) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 10, 16, size.width * 0.05),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 1,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              controller: bloc.chatField,
              hintText: AppLocalizations.of(context)!.typeMessage,
            ),
          ),
          SizedBox(width: size.width * 0.025),
          // Send button
          GestureDetector(
            onTap: () {
              if (bloc.chatField.text.isNotEmpty) {
                bloc.add(SendChatEvent(message: bloc.chatField.text));
                bloc.chatField.clear();
              }
            },
            child: Icon(Icons.send,
                color: Theme.of(context).primaryColorDark, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _chatHistoryData(
      Size size, BuildContext context, List<dynamic> chatList) {
    if (chatList.isEmpty) return const SizedBox();

    return RawScrollbar(
      radius: const Radius.circular(20),
      child: ListView.builder(
        itemCount: chatList.length,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final bloc = context.read<HomeBloc>();
            if (bloc.chatScrollController.hasClients) {
              bloc.chatScrollController.animateTo(
                bloc.chatScrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
              );
            }
          });

          // In driver app, from_type 1 is usually user/customer
          // existing logic: (chatList[index]['from_type'] != 1) ? centerRight (Me/Driver) : centerLeft (User)
          final isMe = chatList[index]['from_type'] != 1;

          Color sentColor = (Theme.of(context).brightness == Brightness.dark)
              ? const Color(0xffE7EDEF)
              : AppColors.black;
          Color receivedColor = const Color(0xffE7EDEF);

          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // Message bubble
                Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: size.width * 0.72),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 11),
                    decoration: BoxDecoration(
                      color: isMe ? sentColor : receivedColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(10),
                        topRight: const Radius.circular(10),
                        bottomLeft:
                            isMe ? const Radius.circular(10) : Radius.zero,
                        bottomRight:
                            isMe ? Radius.zero : const Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      chatList[index]['message'],
                      style: TextStyle(
                        fontSize: 15,
                        color: isMe
                            ? (Theme.of(context).brightness == Brightness.dark
                                ? AppColors.black
                                : AppColors.white)
                            : AppColors.black,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                // Timestamp row
                Row(
                  mainAxisAlignment:
                      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Text(
                      chatList[index]['converted_created_at'],
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 4),
                      // Double tick icon for sent messages
                      Icon(
                        Icons.done_all_rounded,
                        size: 15,
                        color: Colors.grey.shade500,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }
}
