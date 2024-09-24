import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CodeInfoPage extends StatelessWidget {
  final Map<String, dynamic> data = {
    "data": {
      "donation_streak": {"current_streak": 40, "streak_today": 0, "prim_medal": 0},
      "sedekah_subuh": {"current_streak": 1, "streak_today": 0, "prim_medal": 0},
      "prim_medal_days": 40,
      "sedekah_subuh_days": 40
    },
    "code": "test" // Change to a non-null value to test the progress indicators
  };

  @override
  Widget build(BuildContext context) {
    String? code = data['code'];
    var donationData = data['data'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Donation Info'),
      ),
      body: Center(
        child: code == null ? buildOpenUrlButton() : buildProgressIndicators(donationData),
      ),
    );
  }

  Widget buildOpenUrlButton() {
    return ElevatedButton(
      onPressed: () async {
        const url = 'https://your-url.com';
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      },
      child: Text('Open URL'),
    );
  }

  Widget buildProgressIndicators(Map<String, dynamic> donationData) {
    int primMedalMax = donationData['prim_medal_days'];
    int sedekahSubuhMax = donationData['sedekah_subuh_days'];

    int primMedalProgress = donationData['donation_streak']['current_streak'];
    int sedekahSubuhProgress = donationData['sedekah_subuh']['current_streak'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildCircularProgressIndicator(primMedalProgress, primMedalMax, 'Prim Medal'),
        buildCircularProgressIndicator(sedekahSubuhProgress, sedekahSubuhMax, 'Sedekah Subuh'),
      ],
    );
  }

  Widget buildCircularProgressIndicator(int progress, int max, String label) {
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
                value: progress / max,
                strokeWidth: 8.0,
                backgroundColor: Colors.grey, 
                
              ),
            ),
            Text('$progress/$max'),
          ],
        ),
        SizedBox(height: 8.0),
        Text(label),
      ],
    );
  }
}


