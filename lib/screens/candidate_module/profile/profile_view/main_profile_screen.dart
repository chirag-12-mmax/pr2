// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_models/set_config.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_providers/profile_provider.dart';
import 'package:onboarding_app/screens/employer_module/employer_provider/dashboard_provider.dart';
import 'package:provider/provider.dart';

// TabsRouter? profileTabsRouter;

@RoutePage()
class ProfileWebScreen extends StatefulWidget {
  const ProfileWebScreen(
      {super.key,
      @PathParam('applicantId') this.applicantId,
      @PathParam('requisitionId') this.requisitionId});
  final String? applicantId;
  final String? requisitionId;
  @override
  State<ProfileWebScreen> createState() => _ProfileWebScreenState();
}

class _ProfileWebScreenState extends State<ProfileWebScreen> {
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

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final employerDashboardProvider =
        Provider.of<EmployerDashboardProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    await profileProvider.getProfileConfigurationDetailApiFunction(
        context: context,
        setDetails: SetConfigurationModel(
            combinationID: "0",
            employeeCode: "",
            myTeam: "",
            role: "OB JoiningKit",
            sectionId: "",
            signUpID: currentLoginUserType == loginUserTypes.first
                ? (authProvider.applicantInformation!.signUpId ?? "").toString()
                : (authProvider.employerLoginData!.signUpID ?? "").toString(),
            subscriptionName: currentLoginUserType == loginUserTypes.first
                ? authProvider.currentUserAuthInfo!.subscriptionId!
                : authProvider.employerLoginData!.subscriptionId));

    //Get Count Details For Tabs
    await profileProvider.getCandidateProfileStatusProvider(
        context: context,
        obApplicantId: currentLoginUserType == loginUserTypes.first
            ? authProvider.currentUserAuthInfo!.obApplicantId ?? ""
            : widget.applicantId ?? "",
        role: "OB JoiningKit",
        time: DateTime.now().toUtc().millisecondsSinceEpoch.toString());

    //Get Count Details For Tabs
    await profileProvider.getAllFamilyMemberListListApiFunction(
        context: context,
        obApplicantID: currentLoginUserType == loginUserTypes.first
            ? authProvider.currentUserAuthInfo!.obApplicantId ?? ""
            : widget.applicantId ?? "",
        time: DateTime.now().toUtc().millisecondsSinceEpoch.toString());

    if (currentLoginUserType != loginUserTypes.first) {
      authProvider.candidateCurrentStage = GlobalList.getCandidateCurrentStage(
          stageCode: (profileProvider.candidateProfileStatusInformation!
                      .profileStatus!.applicationStageId ??
                  "")
              .toString());
    }

    await profileProvider.getCommonMasterProvider(
        context: context,
        subscriptionName: currentLoginUserType == loginUserTypes.first
            ? authProvider.currentUserAuthInfo!.subscriptionId ?? ""
            : authProvider.employerLoginData!.subscriptionId ?? "",
        time: DateTime.now().toUtc().millisecondsSinceEpoch.toString());

    await profileProvider.getCustomMasterProvider(
        context: context,
        role: "OB JoiningKit",
        subscriptionName: currentLoginUserType == loginUserTypes.first
            ? authProvider.currentUserAuthInfo!.subscriptionId ?? ""
            : authProvider.employerLoginData!.subscriptionId ?? "",
        time: DateTime.now().toUtc().millisecondsSinceEpoch.toString());
    employerDashboardProvider.selectedObApplicantID = widget.applicantId ?? "";
    employerDashboardProvider.selectedRequisitionID =
        widget.requisitionId ?? "";

    await profileProvider.getFamilyMasterListApiFunction(
        context: context,
        time: DateTime.now().toUtc().millisecondsSinceEpoch.toString());

    await profileProvider.getSkillMasterApiFunction(
        context: context,
        time: DateTime.now().toUtc().millisecondsSinceEpoch.toString());

    await profileProvider.getBankMasterApiFunction(
        context: context,
        time: DateTime.now().toUtc().millisecondsSinceEpoch.toString());

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer(builder:
        (BuildContext context, ProfileProvider profileProvider, snapshot) {
      return isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : const AutoRouter();
    });
  }
}
