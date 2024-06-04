import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';
import 'package:onboarding_app/widgets/form_builder_controls/common_form_builder_date_picker.dart';
import 'package:onboarding_app/widgets/form_builder_controls/text_field_control.dart';

@RoutePage()
class PanCardProceedForm extends StatefulWidget {
  const PanCardProceedForm({super.key});

  @override
  State<PanCardProceedForm> createState() => _PanCardProceedFormState();
}

class _PanCardProceedFormState extends State<PanCardProceedForm> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: PickColors.whiteColor,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: PickColors.primaryColor,
        title: const Text("Video ID KYC"),
        leading: InkWell(
          onTap: () {
            backToScreen(context: context);
          },
          child: Icon(Icons.arrow_back_ios, color: PickColors.whiteColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SvgPicture.network(
                 Image.asset(
                PickImages.zingHrLogo,
                // scale: 5,
              ),
              PickHeightAndWidth.height30,
              CommonFormBuilderTextField(
                fieldName: "panNumber",
                hint: "PAN Number",
                isRequired: false,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.match(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$',
                      errorText: "Please Enter Valid PAN Number"),
                ]),
                onChanged: (value) {},
                keyboardType: TextInputType.number,
              ),
              CommonFormBuilderTextField(
                fieldName: "fullName",
                hint: "Your Full Name",
                isRequired: false,
                onChanged: (value) {},
                keyboardType: TextInputType.text,
              ),
              CommonFormBuilderTextField(
                fieldName: "fatherName",
                hint: "Father's Name",
                isRequired: false,
                onChanged: (value) {},
                keyboardType: TextInputType.text,
              ),
              CommonFormBuilderDateTimePicker(
                hint: "Date Of Birth",
                fieldName: "DateOfBirth",
                isRequired: false,
                isEnabled: false,
                onChanged: (DateTime? selectedDate) async {},
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CommonMaterialButton(
        title: "PROCEED",
        borderRadius: 0.0,
        onPressed: () async {},
      ),
    );
  }
}
