import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/features/auth/presentation/provider/auth_provider.dart';
import 'package:h_smart/features/chat/presentation/pages/chatUi.dart';
import 'package:h_smart/features/chat/presentation/provider/chatservice.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<DocumentSnapshot> document = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: false,
          leading: null,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          titleSpacing: 0.1,
          foregroundColor: Colors.black,
          titleTextStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins'),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: const Text(
              'Chat',
              style: TextStyle(fontSize: 20),
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            height: 60,
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xffEBF1FF)),
                borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                const SizedBox(
                  height: 40,
                  width: 40,
                  child: CircleAvatar(
                      backgroundImage: AssetImage(
                    'images/bot.png',
                  )),
                ),
                Gap(20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Talk to Lola',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        SizedBox(
                            height: 15,
                            width: 15,
                            child: Image.asset('images/Brain.png')),
                        Gap(5),
                        Text(
                          'Chat with AI for health tips',
                          style: TextStyle(fontSize: 13, color: Colors.blue),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          Gap(20),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Something Went Wrong'),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              // context.read<ChatService>().getListFromFireBase(
              //     context.watch<authprovider>().email, snapshot.data!.docs);
              document.clear();
              for (var i = 0; i < snapshot.data!.docs.length; i++) {
                Map<String, dynamic> data =
                    snapshot.data!.docs[i].data()! as Map<String, dynamic>;

                if (context.watch<authprovider>().email != data['id']) {
                  document.add(snapshot.data!.docs[i]);
                }
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: document.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return chatlist(context, document, index);
                },
              );
            },
          ),
          //  chatlist(context);
        ]),
      ),
    );
  }

  Widget chatlist(BuildContext context, List<DocumentSnapshot> doc, index) {
    Map<String, dynamic> data = doc[index].data()! as Map<String, dynamic>;
    print(data['id']);
    if (context.watch<authprovider>().email != data['id']) {
      return InkWell(
        onTap: () {
          //  Navigator.pushNamed(context, '/ChatUi');
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatUI(
                  firstname: doc[index]['first_name'],
                  profile_pic: doc[index]['profile_pic'],
                  lastname: doc[index]['last_name'],
                  email: doc[index]['id'],
                ),
              ));
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          height: 60,
          decoration: BoxDecoration(
              border: Border.all(color: Color(0xffEBF1FF)),
              borderRadius: BorderRadius.circular(16)),
          child: Row(
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                    progressIndicatorBuilder: (context, url, progress) {
                      return Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                            value: progress.progress,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                    imageUrl: doc[index]['profile_pic'],
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              Gap(20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    doc[index]['first_name'] + ' ' + doc[index]['last_name'],
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      SizedBox(
                          height: 15,
                          width: 15,
                          child: Image.asset('images/ChatCircle.png')),
                      Gap(5),
                      Text(
                        'New Chat',
                        style: TextStyle(fontSize: 13, color: Colors.blue),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
