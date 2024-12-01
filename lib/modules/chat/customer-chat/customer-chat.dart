import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/modules/dashboard-page/dashboard-controller.dart';
import 'package:flutter_demo/utils.dart';
import 'package:flutter_demo/widgets/static-grid.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CustomerAllChat extends StatefulWidget {
  const CustomerAllChat({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<CustomerAllChat> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();

  List<dynamic> customerAllMessages = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    getAllCustomerMessages();
  }

  Future getAllCustomerMessages() async {
    var jsonData = await dashboardController.getAllCustomerMessages();
    if (jsonData != null && jsonData['code'] == 400) {
      Get.snackbar('Failure', jsonData['message'],
          snackPosition: SnackPosition.bottom,
          duration: const Duration(milliseconds: 1000));
      setState(() {
        customerAllMessages = [];
        isLoading = false;
      });
    } else {
      setState(() {
        customerAllMessages = jsonData['data']['chats'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Buyer Chat',
          style: SafeGoogleFont("Poppins",
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: const Color(0xff808089)),
        ),
        centerTitle: true,
      ),
      body: isLoading == false
          ? customerAllMessages.isNotEmpty
              ? SingleChildScrollView(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(255, 177, 195, 219),
                          Color(0xffE6EEFA),
                        ], // Gradient colors
                      ),
                    ),
                    height: Get.height,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => Container(),
                      itemCount: customerAllMessages.length,
                      itemBuilder: (context, index) {
                        final chat = customerAllMessages[index];
                        return Column(
                          children: [
                            ListTile(
                              leading: Stack(children: [
                                ClipOval(
                                  child: SizedBox(
                                      width: 55,
                                      height: 55,
                                      child: CachedNetworkImage(
                                        fit: BoxFit.fitHeight,
                                        width: 60,
                                        height: 60,
                                        imageUrl: chat['cus_image'] ??
                                            'http://buywithbunny.com/public/images/noimage/default_user_image.jpg',
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      )),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    width: 15,
                                    decoration: BoxDecoration(
                                      color:
                                          chat['chat_store_new_message'] == "1"
                                              ? Colors.transparent
                                              : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    constraints: const BoxConstraints(
                                      maxWidth: 15,
                                      minHeight: 15,
                                    ),
                                    child: Text(
                                      "",
                                      style: SafeGoogleFont(
                                        "Poppins",
                                        color: Colors.white,
                                        fontSize: 8,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              ]),
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  chat['chat_store_new_message'] == "1"
                                      ? const Text(
                                          "New message",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              color: Color.fromARGB(
                                                  255, 233, 97, 87)),
                                        )
                                      : Container(),
                                  Text(chat['chat_store_name'] ?? "",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal)),
                                ],
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(chat['chat_recent_msg'] ?? "",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400)),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                      DateFormat('dd-MMM-yyyy').format(
                                          DateTime.parse(chat['updated_at'])),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                showAllMessagesOfPerticularStore(
                                    chat['chat_id'].toString());
                              },
                            ),
                            const Divider(
                              endIndent: 6,
                              indent: 6,
                              color: Color.fromARGB(255, 145, 143, 143),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                )
              : const Center(
                  child:
                      SizedBox(height: 200, child: Text("No Chats available")))
          : const Center(
              child: SpinKitCircle(
                color: Color(0xffAF6CDA),
                size: 50,
              ),
            ),
    );
  }

  void showAllMessagesOfPerticularStore(String chatId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerIndividualChat(chatId: chatId),
      ),
    );
  }
}

class CustomerIndividualChat extends StatefulWidget {
  final String chatId;
  const CustomerIndividualChat({super.key, required this.chatId});

  @override
  CustomerIndividualChatState createState() => CustomerIndividualChatState();
}

class CustomerIndividualChatState extends State<CustomerIndividualChat> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  List<dynamic> messagesFromChat = [];
  bool isLoading = true;
  final TextEditingController _textEditingController = TextEditingController();
  bool focus = false;
  final FocusNode focusNodeSendMsg = FocusNode();
  String storeId = '';
  String storeName = '';
  @override
  void initState() {
    super.initState();
    getIndividualChatMessges(widget.chatId);
  }

  Future getIndividualChatMessges(String chatId) async {
    var jsonData =
        await dashboardController.getIndividualChatMessges(chatId.toString());

    // print(jsonData['data']['chats'][0]['chat_details']);
    // print(jsonData['data']['chats'][0]['chat_details']['store_id']);

    if (jsonData != null && jsonData['data'] != null) {
      setState(() {
        isLoading = false;
        messagesFromChat = jsonData['data']['chats'];
        storeId =
            jsonData['data']['chats'][0]['chat_details']['store_id'].toString();
        storeName = jsonData['data']['chats'][0]['chat_details']['store_name']
            .toString();
      });

      // call update flag API after entering Chat system

      await dashboardController.updateChatFlagFromCustomer(chatId.toString());
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          isLoading = false;
          messagesFromChat = [];
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(storeId);
    return SafeArea(
        child: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Scaffold(
              backgroundColor: Colors.grey[100],
              appBar: AppBar(
                title: Text(
                  storeName,
                  style: SafeGoogleFont("Poppins",
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: const Color(0xff808089)),
                ),
                centerTitle: true,
              ),
              body: isLoading == false
                  ? SingleChildScrollView(
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: messagesFromChat.isNotEmpty
                              ? StaticGrid(
                                  columnCount: 1,
                                  children: messagesFromChat.map((msg) {
                                    // itemCount: messagesFromChat.length,
                                    // itemBuilder:
                                    //     (BuildContext context, int index) {

                                    return buildChatPage(msg, isLoading);
                                  }).toList())
                              : const Text("No data found"),
                        ),
                      ),
                    )
                  : const SpinKitCircle(
                      color: Color(0xffAF6CDA),
                      size: 50,
                    ),
              floatingActionButton: FloatingActionButton.extended(
                  onPressed: () {
                    print("Onpredded flotinh");
                    setState(() async {});
                  },
                  label: Center(
                    child: SizedBox(
                        width: Get.width * 0.85,
                        height: 50,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Type your message',
                            hintStyle: const TextStyle(fontSize: 14),
                            prefixIcon: const Icon(
                              Icons.message_outlined,
                              size: 18,
                            ),
                            suffixIcon: _textEditingController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.send),
                                    onPressed: () async {
                                      print(storeId);
                                      print(_textEditingController.text);
                                      var data = await dashboardController
                                          .sendMsgFromCusToSeller(storeId,
                                              _textEditingController.text);
                                      print(data);
                                      if (data != null) {
                                        _textEditingController.clear();
                                        focus = false;
                                        await getIndividualChatMessges(
                                            widget.chatId);
                                      }

// 88888888888888888888

                                      _textEditingController.clear();
                                      SystemChannels.textInput
                                          .invokeMethod('TextInput.hide');
                                      focusNodeSendMsg.unfocus();
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                          ),
                          focusNode: focusNodeSendMsg,
                          autofocus: focus,
                          textInputAction: TextInputAction.done,
                          controller: _textEditingController,
                          onChanged: (value) {
                            setState(() {
                              _textEditingController.text = value;
                            });
                          },
                        )),
                  ),
                  backgroundColor: Colors.white),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            )));
  }

  Widget buildChatPage(Map<String, dynamic> chatDetails, bool isLoading) {
    // final chatDetailss = chatDetails['chat_details'];
    final chatMessagess = chatDetails['chat_messages'];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // buildStoreSection(chatDetailss),
        buildMessageSection(chatMessagess),
      ],
    );
  }

  // buildStoreSection(chatDetailss) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       Align(
  //         alignment: Alignment.center,
  //         child: Text(
  //           "$storeId:${chatDetailss['store_name'].toString()}",
  //           style: const TextStyle(fontSize: 25),
  //         ),
  //       ),
  //       Text(
  //         chatDetailss['cus_name'].toString(),
  //         style: const TextStyle(fontSize: 20),
  //       ),
  //     ],
  //   );
  // }

  buildMessageSection(Map<String, dynamic> messages) {
    final messageData1 = messages['data'];
    final messageData = List.from(messageData1.reversed);
    final newMessages = [
      {
        "msg_id": -1,
        "msg_chat_id": 0,
        "msg_text": "",
        "msg_attachments": [],
        "msg_by": 2,
        "msg_time": "2024-05-10 10:08:40"
      },
      {
        "msg_id": -2,
        "msg_chat_id": 0,
        "msg_text": "",
        "msg_attachments": [],
        "msg_by": 2,
        "msg_time": "2024-05-10 10:10:00"
      }
    ];
    messageData.addAll(newMessages);
    return SizedBox(
      height: Get.height - 100,
      child: ListView.builder(
        itemCount: messageData.length,
        itemBuilder: (BuildContext context, int index) {
          final message = messageData[index];
          print(message);
          final isSentByUser = message['msg_by'] == "2";
          return Align(
            alignment:
                isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
            child: message['msg_text'] != ''
                ? Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSentByUser
                          ? const Color(0xffA670D6)
                          : const Color.fromARGB(255, 127, 182, 119),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          DateFormat('dd-MMM-yyyy')
                              .format(DateTime.parse(message['msg_time'])),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: isSentByUser ? Colors.white : Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          message['msg_text'],
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: isSentByUser ? Colors.white : Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('hh:mm a')
                              .format(DateTime.parse(message['msg_time'])),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSentByUser ? Colors.white : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    color: Colors.transparent,
                    height: 40,
                  ),
          );
        },
      ),
    );
  }
}
