import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/features/doctorRecord/presentation/provider/doctorprovider.dart';
import 'package:provider/provider.dart';

class ChatUI extends StatefulWidget {
  const ChatUI({super.key});

  @override
  State<ChatUI> createState() => _ChatUIState();
}

class _ChatUIState extends State<ChatUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Container(
            height: 70,
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset(
                            'images/chevron-left.png',
                            color: Theme.of(context).primaryColor,
                          )),
                    ),
                    Gap(15),
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: Hero(
                          tag: 'doctorimage',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              progressIndicatorBuilder:
                                  (context, url, progress) {
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
                              imageUrl: context
                                  .watch<doctorprpvider>()
                                  .mydoctorlist[0]
                                  .doctor
                                  .docProfilePicture,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                            ),
                          )),
                    ),
                    Gap(15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 180,
                          child: Text(
                            'Dr. Alabi Johnson',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 5,
                              width: 5,
                              child: SvgPicture.asset('images/dot.svg',
                                  color: Colors.green),
                            ),
                            Gap(5),
                            Text(
                              'Online',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.green),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Image.asset(
                      'images/voice_call.png',
                      height: 30,
                      width: 30,
                    ),
                    Gap(10),
                    Image.asset(
                      'images/video_call.png',
                      height: 30,
                      width: 30,
                    )
                  ],
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 44,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xffEDEDED))),
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Image.asset(
                    'images/attachment.png',
                    height: 20,
                    width: 20,
                  ),
                  Gap(5),
                  const Expanded(
                      child: TextField(
                    cursorHeight: 15,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(bottom: 10, left: 4),
                        hintText: 'Type Something',
                        hintStyle: TextStyle(fontSize: 14)),
                  )),
                  Gap(5),
                  Image.asset(
                    'images/send.png',
                    height: 20,
                    width: 20,
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
