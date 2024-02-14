import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/models/organizer_model.dart';
import 'package:upoint_web/pages/create_page.dart';
import 'package:upoint_web/widgets/responsive_layout.dart';
import '../firebase/firestore_methods.dart';
import '../widgets/center/components/link_field.dart';

class CreateStep3Layout extends StatelessWidget {
  final OrganizerModel organizer;
  final Function(int) jumpToPage;
  const CreateStep3Layout({
    super.key,
    required this.organizer,
    required this.jumpToPage,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
        future: FirestoreMethods().uploadPost(organizer),
        builder: (context, snapshot) {
          bool isSuccess = snapshot.data?["status"] == "success";
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            String? formUrl = snapshot.data?["formUrl"];
            return ResponsiveLayout(
              tabletLayout: tabletLayout(isSuccess, context, formUrl),
              webLayout: webLayout(isSuccess, context, formUrl),
            );
          }
        });
  }

  nextStep(BuildContext context) {
    Beamer.of(context).beamToNamed('/organizer/center');
  }

  Widget tabletLayout(
    bool isSuccess,
    BuildContext context,
    String? formUrl,
  ) {
    print('切換到 tabletLayout');
    return CreatePage(
      isWeb: false,
      step: 3,
      nextStep: () => nextStep(context),
      child: Padding(
        padding: const EdgeInsets.only(top: 60, bottom: 101),
        child: Column(
          children: [
            Container(
              height: 152,
              width: 152,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(isSuccess
                      ? "assets/create_success.png"
                      : "assets/create_failed.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            MediumText(
              color: grey500,
              size: 20,
              text: isSuccess ? "創建成功" : "創建失敗，請聯絡service.upoint@gmail.com",
            ),
            const SizedBox(height: 50),
            if (isSuccess && formUrl != null) LinkField(formUrl: formUrl),
          ],
        ),
      ),
    );
  }

  Widget webLayout(
    bool isSuccess,
    BuildContext context,
    String? formUrl,
  ) {
    print('切換到 desktopLayout');
    return CreatePage(
      isWeb: true,
      step: 3,
      nextStep: () => nextStep(context),
      child: Padding(
        padding: const EdgeInsets.only(top: 45, bottom: 86),
        child: Column(
          children: [
            Container(
              height: 152,
              width: 152,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(isSuccess
                      ? "assets/create_success.png"
                      : "assets/create_failed.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            MediumText(
              color: grey500,
              size: 20,
              text: isSuccess ? "創建成功" : "創建失敗，請聯絡service.upoint@gmail.com",
            ),
            const SizedBox(height: 50),
            if (isSuccess && formUrl != null) LinkField(formUrl: formUrl),
          ],
        ),
      ),
    );
  }
}
