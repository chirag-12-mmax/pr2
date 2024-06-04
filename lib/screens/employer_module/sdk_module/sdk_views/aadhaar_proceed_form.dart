import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
class AadhaarProceedFormScreen extends StatefulWidget {
  const AadhaarProceedFormScreen({super.key});

  @override
  State<AadhaarProceedFormScreen> createState() =>
      _AadhaarProceedFormScreenState();
}

class _AadhaarProceedFormScreenState extends State<AadhaarProceedFormScreen> {
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
                fieldName: "AadharId",
                hint: "Aadhaar Number",
                isRequired: false,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                ],
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.equalLength(
                    12,
                    allowEmpty: true,
                    errorText: "Please Enter Valid AadhaarId",
                  )
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
                fieldName: "gender",
                hint: "Gender",
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
              CommonFormBuilderTextField(
                fieldName: "address",
                hint: "Address",
                isRequired: false,
                onChanged: (value) {},
                keyboardType: TextInputType.text,
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
