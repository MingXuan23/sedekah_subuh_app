import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prim_derma_app/bloc/auth/login/login_bloc.dart';
import 'package:prim_derma_app/bloc/info/info_bloc.dart';
import 'package:prim_derma_app/models/donation_streak.dart';
import 'package:prim_derma_app/models/user.dart';
import 'package:prim_derma_app/pages/widget_tree/home_page.dart';
import 'package:prim_derma_app/repo/env_variable.dart';
import 'package:prim_derma_app/widget/message_widget.dart';

import 'package:prim_derma_app/widget/style.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  DonationStreak? prim_medal;
  DonationStreak? sedekah_subuh;
  String? code;

  Future<void> logout() async {
    bool result = await showPrimConfirmationDialog(
        context, ' LOG OUT ? ', 'Adakah anda pasti untuk logout?');
    if (result) {
      BlocProvider.of<LoginBloc>(context).add(LogoutRequested());
    }
  }

  void openPrimWeb() async {
    Uri uri =Uri.parse(PRIM__PROFILE_URL);
    var token = await User.retrieveToken();
    await launchUrl(uri, 
    mode: LaunchMode.platformDefault,
   
    webViewConfiguration: WebViewConfiguration(
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      ),);
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<InfoBloc>(context).add(requestInfoData());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InfoBloc, InfoState>(
      listener: (context, state) {
        if (state is InfoLoading) {
          showLoadingWidget(context);
        } else {
          endLoadingWidget();
        }

        if (state is InfoMismatchToken) {
          code = null;
          if (HomePage.selectedTab == 1) {
            showPrimMessageDialog(context, "Ralat, Tiada Rekod",
                "Sila aktifkan akaun anda dan login semula.");
          }
        } else if (state is InfoFetched) {
          code = state.code;
          prim_medal = DonationStreak.primMedal;
          sedekah_subuh = DonationStreak.sedekahSubuh;
        }

        setState(() {});
      },
      child: body(),
    );
  }

  Widget roundedButton(Widget child, Color color, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color, // Background color of the circle
                border: Border.all(
                  color: color, // Border color
                  width: 8.0, // Border thickness
                ),
              ),
            ),
            child,
          ],
        ),
        SizedBox(height: 8.0),
        Text(label),
      ],
    );
  }

  Widget buildCircularProgressIndicator(DonationStreak? streak, String label) {
    if (streak == null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(
                  value: 0,
                  strokeWidth: 8.0,
                  backgroundColor: Colors.grey,
                ),
              ),
              Text('0/40'),
            ],
          ),
          SizedBox(height: 8.0),
          Text(label),
        ],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(
                value: streak.currentStreak / streak.streakDays,
                strokeWidth: 8.0,
                backgroundColor: Colors.grey,
              ),
            ),
            Text('${streak.currentStreak}/${streak.streakDays}'),
          ],
        ),
        SizedBox(height: 8.0),
        Text(label),
      ],
    );
  }

  Widget body() {
    return Scaffold(
      appBar: PrimAppBar("Info Anda"),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Placeholder for your information
                      if (code != null)
                        Column(
                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blueGrey[50],
                                border: Border(
                                  bottom: BorderSide(
                                      color: PRIMARY_PURPLE, width: 6),
                                  left: BorderSide(
                                      color: PRIMARY_PURPLE, width: 1.5),
                                  top: BorderSide(
                                      color: PRIMARY_PURPLE, width: 1.5),
                                  right: BorderSide(
                                      color: PRIMARY_PURPLE, width: 1.5),
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              height: max(constraints.maxHeight * 0.05,40),
                              width: constraints.maxWidth * 0.9,
                              child: Center(
                                child: Text(
                                  "Mata Ganjaraan PRiM Anda: ${DonationStreak.prim_point}pts",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black ),
                                ),
                              ),
                            ),
                            SizedBox(height: max(constraints.maxHeight * 0.03,30 )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildCircularProgressIndicator(
                                    prim_medal, 'Prim Medal'),
                                buildCircularProgressIndicator(
                                    sedekah_subuh, 'Sedekah Subuh'),
                              ],
                            ),
                            SizedBox(height: constraints.maxHeight * 0.05),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                //roundedButton('Derma hari ini',(){},PRIMARY_GREY,'Derma hari ini'),
                                roundedButton(
                                    Text(
                                      DonationStreak.donationToday.toString(),
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    PRIMARY_GREY,
                                    'Derma Hari Ini'),
                                roundedButton(
                                    TextButton(
                                      onPressed: openPrimWeb,
                                      child: Icon(
                                        Icons.account_box,
                                        color: Colors.white,
                                        size: 60,
                                      ),
                                    ),
                                    PRIMARY_PURPLE,
                                    'Akaun Saya')
                              ],
                            ),
                            SizedBox(height: 10),
                          ],
                        )
                      else
                        Center(
                          child: PrimButton(
                            text: 'Aktif Akaun Saya',
                            color: PRIMARY_PURPLE,
                            onPressed: openPrimWeb,
                          ),
                        ),

                      Spacer(), // Fills the available space

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          children: [
                            PrimButton(
                              text: 'Kemas kini',
                              color: PRIMARY_GREY,
                              onPressed: () {
                                BlocProvider.of<InfoBloc>(context)
                                    .add(requestInfoData());
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            PrimButton(
                              text: '  Log Out  ',
                              color: SECONDARY_GREEN,
                              onPressed: logout,
                            )
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
      ),
    );
  }
}
