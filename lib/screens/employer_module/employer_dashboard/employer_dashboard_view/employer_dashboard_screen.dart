import 'package:auto_route/auto_route.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/navigation/app_routes_path.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/employer_module/employer_dashboard/employer_dashboard_common/employer_dashboard_category_widget.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';
import 'package:provider/provider.dart';

@RoutePage()
class EmployerDashboardScreen extends StatefulWidget {
  const EmployerDashboardScreen({super.key});

  @override
  State<EmployerDashboardScreen> createState() =>
      _EmployerDashboardScreenState();
}

class _EmployerDashboardScreenState extends State<EmployerDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: PickColors.bgColor,
      body: Consumer(
          builder: (BuildContext context, GeneralHelper helper, snapshot) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  constraints: const BoxConstraints(minHeight: 200),
                  height: SizeConfig.screenWidth! * 0.15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: AssetImage(PickImages.employerBgImage),
                      fit: checkPlatForm(context: context, platforms: [
                        CustomPlatForm.TABLET_VIEW,
                        CustomPlatForm.TABLET,
                        CustomPlatForm.MOBILE_VIEW,
                        CustomPlatForm.MOBILE,
                        CustomPlatForm.MIN_MOBILE_VIEW,
                        CustomPlatForm.MIN_MOBILE,
                      ])
                          ? BoxFit.cover
                          : BoxFit.contain,
                    ),
                  ),
                ),
                PickHeightAndWidth.height20,
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      GlobalList.employerDashboardCategoryDataList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 90,
                      crossAxisCount:
                          checkPlatForm(context: context, platforms: [
                        CustomPlatForm.TABLET_VIEW,
                        CustomPlatForm.TABLET,
                        CustomPlatForm.MOBILE_VIEW,
                        CustomPlatForm.MOBILE,
                        CustomPlatForm.MIN_MOBILE_VIEW,
                        CustomPlatForm.MIN_MOBILE,
                      ])
                              ? 1
                              : 3,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        moveToNextScreenWithRoute(
                            context: context,
                            routePath: GlobalList
                                    .employerDashboardCategoryDataList[index]
                                ["path"]);
                        //Change Selection Of Drawer When Back to Old Screen
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          helper.setSelectedEmployerDrawerPagePath(
                              pagePath: GlobalList
                                      .employerDashboardCategoryDataList[index]
                                  ["path"]);
                        });
                      },
                      child: Container(
                        child: index == 0
                            ? DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(12),
                                color: PickColors.primaryColor,
                                child: Container(
                                  width: SizeConfig.screenWidth,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: GlobalList
                                            .employerDashboardCategoryDataList[
                                        index]["color"],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                        GlobalList
                                                .employerDashboardCategoryDataList[
                                            index]["icon"],
                                        color: PickColors.primaryColor,
                                      ),
                                      PickHeightAndWidth.height15,
                                      Text(
                                        GlobalList
                                                .employerDashboardCategoryDataList[
                                            index]["title"],
                                        style: CommonTextStyle()
                                            .buttonTextStyle
                                            .copyWith(
                                              color: PickColors.primaryColor,
                                            ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : EmployerDashboardCategoryWidget(
                                color: GlobalList
                                        .employerDashboardCategoryDataList[
                                    index]["color"],
                                icon: GlobalList
                                        .employerDashboardCategoryDataList[
                                    index]["icon"],
                                title: GlobalList
                                        .employerDashboardCategoryDataList[
                                    index]["title"],
                              ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: SizeConfig.screenWidth! * 0.1,
                ),
                Container(
                  constraints: const BoxConstraints(minWidth: 350),
                  width: SizeConfig.screenWidth! * 0.20,
                  child: CommonMaterialButton(
                    title: helper.translateTextTitle(
                            titleText: "Add new candidate") ??
                        "-",
                    onPressed: () async {
                      moveToNextScreenWithRoute(
                        context: context,
                        routePath: AppRoutesPath.ADD_NEW_CANDIDATE,
                      );

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        helper.setSelectedEmployerDrawerPagePath(
                            pagePath: AppRoutesPath.ADD_NEW_CANDIDATE);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
