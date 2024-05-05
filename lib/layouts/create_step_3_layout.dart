import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/models/organizer_model.dart';
import 'package:upoint_web/pages/create_page.dart';
import 'package:upoint_web/widgets/responsive_layout.dart';
import '../firebase/firestore_methods.dart';
import '../widgets/center/components/link_field.dart';
import '../widgets/circular_loading.dart';

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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularLoading(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            bool isSuccess = snapshot.data?["status"] == "success";
            String res = snapshot.data?["status"];
            String? formUrl = snapshot.data?["formUrl"];
            return ResponsiveLayout(
              tabletLayout: tabletLayout(isSuccess, context, formUrl, res),
              webLayout: webLayout(isSuccess, context, formUrl, res),
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
    String res,
  ) {
    debugPrint('切換到 tabletLayout');
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
              text:
                  isSuccess ? "創建成功" : "創建失敗，請聯絡service.upoint@gmail.com：$res",
            ),
            const SizedBox(height: 50),
            if (isSuccess && formUrl != null)
              LinkField(url: formUrl, title: "報名連結"),
          ],
        ),
      ),
    );
  }

  Widget webLayout(
    bool isSuccess,
    BuildContext context,
    String? formUrl,
    String res,
  ) {
    debugPrint('切換到 desktopLayout');
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
                  image: AssetImage(
                    isSuccess
                        ? "assets/create_success.png"
                        : "assets/create_failed.png",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            MediumText(
              color: grey500,
              size: 20,
              text:
                  isSuccess ? "創建成功" : "創建失敗，請聯絡service.upoint@gmail.com：$res",
            ),
            const SizedBox(height: 50),
            if (isSuccess && formUrl != null)
              LinkField(url: formUrl, title: "報名連結"),
          ],
        ),
      ),
    );
  }
}
