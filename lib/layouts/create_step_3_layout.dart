import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/firebase/firestore_methods.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/globals/user_simple_preference.dart';
import 'package:upoint_web/models/organizer_model.dart';
import 'package:upoint_web/pages/create_page.dart';
import 'package:upoint_web/widgets/responsive_layout.dart';

class CreateStep3Layout extends StatelessWidget {
  final OrganizerModel organizer;
  const CreateStep3Layout({
    super.key,
    required this.organizer,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: FirestoreMethods().uploadPost(organizer),
        builder: (context, snapshot) {
          bool isSuccess = snapshot.data == "success";
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: const CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return ResponsiveLayout(
              tabletLayout: tabletLayout(isSuccess, context),
              webLayout: webLayout(isSuccess, context),
            );
          }
        });
  }

  nextStep(BuildContext context) {
    UserSimplePreference.removeform();
    UserSimplePreference.removepost();
    Beamer.of(context).beamToNamed('/organizer/center');
  }

  Widget tabletLayout(bool isSuccess, BuildContext context) {
    print('切換到 tabletLayout');
    return CreatePage(
      isWeb: false,
      step: 3,
      nextStep: () => nextStep(context),
      child: Column(
        children: [
          MediumText(
            color: grey500,
            size: 20,
            text: isSuccess ? "您已上傳成功" : "上傳失敗，請聯絡service.upoint@gmail.com",
          ),
        ],
      ),
    );
  }

  Widget webLayout(bool isSuccess, BuildContext context) {
    print('切換到 desktopLayout');
    return CreatePage(
      isWeb: true,
      step: 3,
      nextStep: () => nextStep(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MediumText(
            color: grey500,
            size: 20,
            text: isSuccess ? "您已上傳成功" : "上傳失敗，請聯絡service.upoint@gmail.com",
          ),
        ],
      ),
    );
  }
}
