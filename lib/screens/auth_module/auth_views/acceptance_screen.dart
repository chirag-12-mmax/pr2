import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/screens/auth_module/auth_views/e_signature_screen.dart';
import 'package:onboarding_app/screens/auth_module/auth_views/video_acceptance_screen.dart';
import 'package:onboarding_app/widgets/common_tab_bar.dart';
import 'package:provider/provider.dart';

class AcceptanceFlowWidget extends StatefulWidget {
  final String remarkString;
  const AcceptanceFlowWidget({super.key, required this.remarkString});

  @override
  State<AcceptanceFlowWidget> createState() => _AcceptanceFlowWidgetState();
}

class _AcceptanceFlowWidgetState extends State<AcceptanceFlowWidget> {
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
    await authProvider.getAcceptanceDetailsApiFunction(
        context: context,
        time: DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
        type: authProvider.candidateCurrentStage ==
                CandidateStages.OFFER_ACCEPTANCE
            ? "OfferLetter"
            : "AppointmentLetter");

    if (authProvider.acceptanceDetailsData != null) {
      if (authProvider.acceptanceDetailsData!.acceptanceDetails!.isSignature ??
          false) {
        authProvider.selectedTabIndex = 1;
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Consumer(builder:
            (BuildContext context, AuthProvider authProvider, snapshot) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(
                    GlobalList.acceptanceList.length,
                    (index) {
                      return CommonTabWidget(
                        onTapTab: () {
                          if (authProvider.acceptanceDetailsData!
                                  .acceptanceDetails!.isSignature ??
                              false) {
                            authProvider.updateAcceptanceScreenIndex(
                                tabIndex: index);
                          }
                        },
                        currentStepIndex: authProvider.selectedTabIndex,
                        stepIndex: index,
                        stepText: GlobalList.acceptanceList[index],
                      );
                    },
                  ),
                ),
                authProvider.selectedTabIndex == 0
                    ? EVideoSignaturePadScreen()
                    : VideoAcceptanceScreen(
                        remarkString: widget.remarkString,
                      )
              ],
            );
          });
  }
}
