import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/date_formates.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/widgets/form_builder_controls/custom_form_date/custom_formbuilder_date_picker.dart';
import 'package:onboarding_app/widgets/form_builder_controls/text_field_control.dart';
import 'package:jhijri/jHijri.dart';

// CommonFormBuilderDateTimePicker
class CommonFormBuilderDateTimePicker extends StatefulWidget {
  const CommonFormBuilderDateTimePicker({
    super.key,
    this.hint,
    this.onChanged,
    this.onEditingComplete,
    this.isInRow = false,
    required this.fieldName,
    this.fullyDisable = false,
    this.isRequired = false,
    required this.isEnabled,
    this.fillColor,
    this.focusNode,
    this.isHijri = false,
  });

  final String? hint;

  final dynamic onChanged;
  final Function()? onEditingComplete;
  final bool isInRow;
  final String fieldName;
  final bool fullyDisable;
  final bool isRequired;
  final bool isEnabled;
  final bool? fillColor;
  final FocusNode? focusNode;
  final bool isHijri;

  @override
  State<CommonFormBuilderDateTimePicker> createState() =>
      _CommonFormBuilderDateTimePickerState();
}

class _CommonFormBuilderDateTimePickerState
    extends State<CommonFormBuilderDateTimePicker> {
  TextEditingController selectedHijriController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      child: Padding(
        padding: EdgeInsets.only(bottom: 15),
        child: Column(
          children: [
            CustomFormBuilderDateTimePicker(
              mouseCursor: MaterialStateMouseCursor.clickable,
              isHijriCal: widget.isHijri,
              name: widget.fieldName,
              format: DateFormate.normalDateFormate,
              locale: Locale('en', 'GB'),
              helpText: widget.hint,
              initialEntryMode: DatePickerEntryMode.calendar,
              keyboardType: TextInputType.number,
              enabled: widget.isEnabled,
              style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                  color: widget.fullyDisable == true || !(widget.isEnabled)
                      ? PickColors.blackColor.withOpacity(0.2)
                      : PickColors.blackColor),
              validator: FormBuilderValidators.compose([
                if (widget.isRequired)
                  FormBuilderValidators.required(
                      errorText: "${widget.hint} is Mandatory"),
                // (value) {
                //   if (['DateOfBirth'].contains(widget.fieldName)) {
                //     if (value.toString().trim() != "") {
                //       if ((value!.difference(DateTime.now()).inDays / 365) > 18) {
                //         return null;
                //       } else {
                //         return "Age Can not be less than 18 years";
                //       }
                //     } else {
                //       return null;
                //     }
                //   } else {
                //     return null;
                //   }
                // }
              ]),
              inputType: InputType.date,
              initialDate: ['DateOfBirth', 'actualDateofBirth']
                      .contains(widget.fieldName)
                  ? DateTime(DateTime.now().year - 18, DateTime.now().month - 1,
                      DateTime.now().day)
                  : DateTime.now(),
              lastDate: [
                'fromDate',
                'dateofBirth',
                'dateofIssue',
                'dateofJoining',
                'dateofConfirmation',
                'dateofSeparation'
              ].contains(widget.fieldName)
                  ? DateTime.now()
                  : null,
              firstDate: ['medicalPolicyExpiryDate'].contains(widget.fieldName)
                  ? DateTime.now()
                  : null,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                selectedHijriController.text =
                    value != null ? formatDateToHijri(value) : "";

                widget.onChanged(value);
              },
              onEditingComplete: widget.onEditingComplete,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                errorStyle: const TextStyle(
                  fontSize: 0,
                  height: 0.01,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                // hoverColor: widget.fillColor == true
                //     ? PickColors.whiteColor
                //     : PickColors.whiteColor,
                filled: true,
                fillColor: widget.fillColor == true
                    ? widget.fullyDisable == true || !(widget.isEnabled)
                        ? PickColors.bgColor
                        : PickColors.whiteColor
                    : widget.fullyDisable == true || !(widget.isEnabled)
                        ? PickColors.bgColor
                        : PickColors.whiteColor,
                helperText: widget.isInRow ? "" : null,
                suffixIconConstraints: const BoxConstraints(),
                prefixIconConstraints: const BoxConstraints(),

                // errorStyle: const TextStyle(
                //   fontWeight: FontWeight.w100,
                //   overflow: TextOverflow.visible,
                //   fontSize: 10,
                // ),
                // hintStyle: CommonTextStyle().noteHeadingTextStyle.copyWith(
                //     fontSize: 13,
                //     color: widget.fullyDisable == true
                //         ? PickColors.hintColor.withOpacity(0.2)
                //         : PickColors.hintColor),

                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.hint ?? "-",
                      style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                          fontSize: 15,
                          color:
                              widget.fullyDisable == true || !(widget.isEnabled)
                                  ? PickColors.blackColor.withOpacity(0.5)
                                  : PickColors.blackColor.withOpacity(0.5)),
                    ),
                    if (widget.isRequired)
                      Text(
                        '*',
                        style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                            fontSize: 15, color: PickColors.primaryColor),
                      ),
                  ],
                ),
                // contentPadding:
                //     const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                suffixIcon: MouseRegion(
                  cursor: widget.isEnabled
                      ? SystemMouseCursors.click
                      : SystemMouseCursors.basic,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SvgPicture.asset(
                      PickImages.calenderImage,
                      colorFilter: ColorFilter.mode(
                          widget.fullyDisable == true || !(widget.isEnabled)
                              ? PickColors.primaryColor.withOpacity(0.3)
                              : PickColors.primaryColor,
                          BlendMode.srcIn),
                    ),
                  ),
                ),
                // suffix: InkWell(
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 12),
                //     child: SvgPicture.asset(
                //       PickImages.calenderImage,
                //       colorFilter: ColorFilter.mode(
                //           widget.fullyDisable == true || !(widget.isEnabled)
                //               ? PickColors.primaryColor.withOpacity(0.3)
                //               : PickColors.primaryColor,
                //           BlendMode.srcIn),
                //     ),
                //   ),
                // ),
                // hintText: widget.hint,
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: PickColors.successColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                ),
              ),
            ),
            if (widget.isHijri)
              SizedBox(
                height: 10,
              ),
            if (widget.isHijri)
              CommonFormBuilderTextField(
                fieldName: widget.fieldName + "_hijri",
                hint: (widget.hint ?? "") + "(Hijri)",
                isOnlyUppercase: false,
                textController: selectedHijriController,
                isRequired: false,
                fullyDisable: true,
                onChanged: (value) {},
                keyboardType: TextInputType.text,
              )
          ],
        ),
      ),
    );
  }
}

String formatDateToHijri(DateTime date) {
  date = DateTime(HijriDate.dateToHijri(date).year,
      HijriDate.dateToHijri(date).month, HijriDate.dateToHijri(date).day);
  List<String> weekdays = [
    'Al ‘ahad',
    'A lith nayn',
    'Ath thu la tha’',
    'Al ar ba a’',
    'Al kha mis',
    'Al jum ah',
    'As sabt'
  ];
  List<String> hijriMonths = [
    'Muharram',
    'Safar',
    'Rabi\' al-Awwal',
    'Rabi\' al-Thani',
    'Jumadal-Awwal',
    'Jumadal-Akhir',
    'Rajab',
    'Sha\'ban',
    'Ramadan',
    'Shawwal',
    'Dhu al-Qi\'dah',
    'Dhu al-Hijjah'
  ];

  String weekday = weekdays[date.weekday - 1];
  String hijriMonth = hijriMonths[date.month - 1];

  String formattedDate = "$weekday, ${date.day} $hijriMonth ${date.year} H";
  return formattedDate;
}
