// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/navigation/app_routes_path.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/share_pref_keys.dart';
import 'package:onboarding_app/constants/share_preference.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/show_overlay_loader.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/qr_code_module/qr_code_provider/qr_code_provider.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';
import 'package:onboarding_app/widgets/common_form_builder_check_box.dart';
import 'package:provider/provider.dart';

class AcknowledgementScreen extends StatefulWidget {
  const AcknowledgementScreen({super.key});

  @override
  State<AcknowledgementScreen> createState() => _AcknowledgementScreenState();
}

class _AcknowledgementScreenState extends State<AcknowledgementScreen> {
  bool isAgree = false;
  bool isLoading = false;

  @override
  void initState() {
    initializeData();
    super.initState();
  }

  initializeData() async {
    setState(() {
      isLoading = true;
    });

    final qrCodeProvider = Provider.of<QRCodeProvider>(context, listen: false);

    await qrCodeProvider
        .getAcknowledgementDetailApiFunction(context: context, dataParameter: {
      "_": DateTime.now().millisecondsSinceEpoch.toString(),
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return isLoading
        ? const CircularProgressIndicator()
        : Consumer2(builder: (BuildContext context,
            QRCodeProvider qrCodeProvider, GeneralHelper helper, snapshot) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  constraints: const BoxConstraints(minHeight: 200),
                  width: SizeConfig.screenWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: PickColors.whiteColor,
                  ),
                  child: SvgPicture.asset(
                    PickImages.acknowledgementImage,
                    height: 250,
                    // width: 200,
                  ),
                ),
                PickHeightAndWidth.height20,
                Container(
                  padding: const EdgeInsets.all(15),
                  constraints: const BoxConstraints(minHeight: 200),
                  width: SizeConfig.screenWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: PickColors.whiteColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HtmlWidget(helper.translateTextTitle(
                              titleText: "Acknowledgement")
                          // style: CommonTextStyle().subMainHeadingTextStyle,
                          ),
                      PickHeightAndWidth.height20,
                      HtmlWidget(
                        qrCodeProvider.acknowledgementText ?? "",
                        // style:
                        //     CommonTextStyle().textFieldLabelTextStyle.copyWith(
                        //           fontWeight: FontWeight.normal,
                        //           fontSize: 14,
                        //         ),
                      ),
                    ],
                  ),
                ),
                PickHeightAndWidth.height20,
                CommonFormBuilderCheckbox(
                  fieldName: "agree",
                  onChanged: (value) {
                    setState(() {
                      isAgree = value;
                    });
                  },
                  isRequired: false,
                  title: helper.translateTextTitle(titleText: "I Agree"),
                ),
                PickHeightAndWidth.height40,
                Container(
                  constraints: const BoxConstraints(minWidth: 350),
                  width: SizeConfig.screenWidth! * 0.20,
                  child: CommonMaterialButton(
                    title:
                        helper.translateTextTitle(titleText: "Submit") ?? "-",
                    isButtonDisable: !isAgree,
                    onPressed: () async {
                      if (isAgree) {
                        showOverlayLoader(context);
                        if (await qrCodeProvider
                            .submitAcknowledgementDetailApiFunction(
                                dataParameter: {}, context: context)) {
                          qrCodeProvider.qrRequisitionId = null;
                          qrCodeProvider.qrCodeSubscription = null;
                          qrCodeProvider.qrCodeResumeSource;
                          qrCodeProvider.jobDescriptionData = null;
                          await Shared_Preferences.prefSetBool(
                              SharedP.instructionFlag, false);
                          hideOverlayLoader();
                          replaceNextScreenWithRoute(
                              context: context, routePath: AppRoutesPath.LOGIN);
                        } else {
                          hideOverlayLoader();
                        }
                      }
                    },
                  ),
                ),
              ],
            );
          });
  }
}
