import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/debug_print.dart';

// ignore: must_be_immutable
class CustomSearchableDropdown<T> extends StatefulWidget {
  ///Hint text shown when the dropdown is empty
  final Widget? hintText;

  ///Background decoration of dropdown, i.e. with this you can wrap dropdown with Card
  final Widget Function(Widget child)? backgroundDecoration;

  ///Shown if there is no record found
  final Widget? noRecordText;

  ///Dropdown trailing icon
  final Widget? trailingIcon;

  ///Dropdown trailing icon
  final Widget? leadingIcon;

  ///Search bar hint text
  final String? searchHintText;

  ///Dropdowns margin padding with other widgets
  final EdgeInsetsGeometry? margin;

  ///Height of dropdown's dialog, default: MediaQuery.of(context).size.height*0.3
  final double? dropDownMaxHeight;

  ///Returns selected Item
  final void Function(T? value)? onChanged;

  //Initial value of dropdown
  T? value;

  //Is dropdown enabled
  bool isEnabled;

  //Triggers this function if dropdown pressed while disabled
  VoidCallback? disabledOnTap;

  ///Dropdown items
  List<SearchableDropdownMenuItem<T>>? items;

  ///Paginated request service which is returns DropdownMenuItem list
  Future<List<SearchableDropdownMenuItem<T>>?> Function(
      int page, String? searchKey)? paginatedRequest;

  ///Future service which is returns DropdownMenuItem list
  Future<List<SearchableDropdownMenuItem<T>>?> Function()? futureRequest;

  ///Paginated request item count which returns in one page, this value is using for knowledge about isDropdown has more item or not.
  int? requestItemCount;
  SearchableDropdownController<T> controller;
  double? rightPadding;
  double? leftPadding;
  bool? isAddNewFunctionality;

  CustomSearchableDropdown(
      {Key? key,
      this.hintText,
      this.backgroundDecoration,
      this.searchHintText,
      this.noRecordText,
      this.dropDownMaxHeight,
      this.margin,
      this.trailingIcon,
      this.leadingIcon,
      this.onChanged,
      this.items,
      this.value,
      this.isEnabled = true,
      this.disabledOnTap,
      required this.controller,
      this.isAddNewFunctionality,
      this.leftPadding,
      this.rightPadding})
      : super(key: key);

  CustomSearchableDropdown.paginated(
      {Key? key,
      this.hintText,
      this.backgroundDecoration,
      this.searchHintText,
      this.noRecordText,
      this.dropDownMaxHeight,
      this.margin,
      this.trailingIcon,
      this.leadingIcon,
      this.isEnabled = true,
      this.disabledOnTap,
      this.onChanged,
      required this.paginatedRequest,
      this.requestItemCount,
      this.isAddNewFunctionality,
      this.leftPadding,
      this.rightPadding,
      required this.controller})
      : super(key: key);

  CustomSearchableDropdown.future(
      {Key? key,
      this.hintText,
      this.backgroundDecoration,
      this.searchHintText,
      this.noRecordText,
      this.dropDownMaxHeight,
      this.margin,
      this.trailingIcon,
      this.leadingIcon,
      this.isEnabled = true,
      this.disabledOnTap,
      this.onChanged,
      this.rightPadding,
      this.leftPadding,
      this.isAddNewFunctionality,
      required this.futureRequest,
      required this.controller})
      : super(key: key);

  @override
  State<CustomSearchableDropdown<T>> createState() =>
      _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<CustomSearchableDropdown<T>> {
  @override
  void initState() {
    printDebug(textString: "==============On Init Ca.........");

    widget.futureRequest = widget.futureRequest;
    widget.requestItemCount = widget.requestItemCount ?? 0;
    widget.items = widget.items;
    widget.controller.searchedItems.value = widget.items;
    for (var element in widget.items ?? <SearchableDropdownMenuItem<T>>[]) {
      if (element.value == widget.value) {
        widget.controller.selectedItem.value = element;
        return;
      }
    }
    widget.controller.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: widget.controller.key,
      width: MediaQuery.of(context).size.width,
      child: widget.backgroundDecoration != null
          ? widget
              .backgroundDecoration!(buildDropDown(context, widget.controller))
          : buildDropDown(context, widget.controller),
    );
  }

  GestureDetector buildDropDown(
      BuildContext context, SearchableDropdownController<T> controller) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (widget.isEnabled) {
          _dropDownOnTab(
              context, controller, widget.rightPadding, widget.leftPadding);
        } else if (widget.disabledOnTap != null) {
          widget.disabledOnTap!();
        }
      },
      child: Padding(
        padding: widget.margin ??
            EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
        child: Row(
          children: [
            Expanded(
                child: Row(
              children: [
                if (widget.leadingIcon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 3.0),
                    child: widget.leadingIcon!,
                  ),
                Flexible(child: dropDownText(controller)),
              ],
            )),
            widget.trailingIcon ??
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: !widget.isEnabled ? PickColors.hintColor : null,
                  size: MediaQuery.of(context).size.height * 0.033,
                ),
          ],
        ),
      ),
    );
  }

  _dropDownOnTab(
      BuildContext context,
      SearchableDropdownController<T> controller,
      double? rightPadding,
      double? leftPadding) {
    bool isReversed = false;
    double? positionFromBottom = controller.key.globalPaintBounds != null
        ? MediaQuery.of(context).size.height -
            controller.key.globalPaintBounds!.bottom
        : null;
    double alertDialogMaxHeight =
        widget.dropDownMaxHeight ?? MediaQuery.of(context).size.height * 0.3;
    double? dialogPositionFromBottom = positionFromBottom != null
        ? positionFromBottom - alertDialogMaxHeight
        : null;
    if (dialogPositionFromBottom != null) {
      if (dialogPositionFromBottom <= 0) {
        isReversed = true;
        dialogPositionFromBottom += alertDialogMaxHeight +
            controller.key.globalPaintBounds!.height +
            MediaQuery.of(context).size.height * 0.005;
      } else {
        dialogPositionFromBottom -= MediaQuery.of(context).size.height * 0.005;
      }
    }
    if (controller.items == null) {
      if (widget.paginatedRequest != null)
        controller.getItemsWithPaginatedRequest(page: 1, isNewSearch: true);
      if (widget.futureRequest != null) controller.getItemsWithFutureRequest();
    } else {
      controller.searchedItems.value = controller.items;
    }

    showDialog(
      context: context,
      builder: (context) {
        double? reCalculatePosition = dialogPositionFromBottom;
        double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

        if (reCalculatePosition != null &&
            reCalculatePosition <= keyboardHeight) {
          reCalculatePosition =
              (keyboardHeight - reCalculatePosition) + reCalculatePosition;
        }
        return Padding(
          padding: EdgeInsets.only(
              bottom: reCalculatePosition ?? 0,
              left: leftPadding ?? MediaQuery.of(context).size.height * 0.02,
              right: rightPadding ?? MediaQuery.of(context).size.height * 0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: alertDialogMaxHeight,
                child: _buildStatefullDropdownCard(
                    context, controller, isReversed),
              ),
            ],
          ),
        );
      },
      barrierDismissible: true,
      barrierColor: Colors.transparent,
    );
  }

  Widget _buildStatefullDropdownCard(BuildContext context,
      SearchableDropdownController<T> controller, bool isReversed) {
    return Column(
      mainAxisAlignment:
          isReversed ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(
                    MediaQuery.of(context).size.height * 0.015))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              verticalDirection:
                  isReversed ? VerticalDirection.up : VerticalDirection.down,
              children: [
                buildSearchBar(context, controller),
                Flexible(
                  child: buildListView(controller, isReversed),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Padding buildSearchBar(
      BuildContext context, SearchableDropdownController controller) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
      child: Row(
        children: [
          Expanded(
            child: CustomSearchBar(
              focusNode: controller.searchFocusNode,
              changeCompletionDelay: const Duration(milliseconds: 200),
              hintText: widget.searchHintText ?? 'Search',
              isOutlined: true,
              leadingIcon: Icon(Icons.search,
                  size: MediaQuery.of(context).size.height * 0.033),
              onChangeComplete: (value) {
                controller.searchText = value;
                if (controller.items != null) {
                  controller.fillSearchedList(value);
                  return;
                }
                if (value == '') {
                  controller.getItemsWithPaginatedRequest(
                      page: 1, isNewSearch: true);
                } else {
                  controller.getItemsWithPaginatedRequest(
                      page: 1, key: value, isNewSearch: true);
                }
              },
            ),
          ),
          widget.isAddNewFunctionality ?? false
              ? SizedBox(
                  width: 10,
                )
              : Container(),
          widget.isAddNewFunctionality ?? false
              ? InkWell(
                  onTap: () {
                    if (controller.searchText != "") {
                      if (widget.onChanged != null) {
                        Navigator.pop(context);

                        widget.onChanged!(controller.searchText as T?);
                        controller.selectedItem.value =
                            SearchableDropdownMenuItem(
                                value: controller.searchText,
                                label: controller.searchText,
                                child: Container(
                                  child: Text(controller.searchText),
                                ));
                        controller.searchText = "";
                      }
                    }
                  },
                  child: SvgPicture.asset(
                    PickImages.addIcon,
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Widget buildListView(
      SearchableDropdownController<T> controller, bool isReversed) {
    return ValueListenableBuilder(
      valueListenable: (widget.paginatedRequest != null
          ? controller.paginatedItemList
          : controller.searchedItems),
      builder: (context, List<SearchableDropdownMenuItem<T>>? itemList,
              child) =>
          itemList == null
              ? const Center(child: CircularProgressIndicator())
              : itemList.isEmpty
                  ? Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.height * 0.015),
                      child: widget.noRecordText ?? const Text('No record'),
                    )
                  : Scrollbar(
                      thumbVisibility: true,
                      controller: controller.scrollController,
                      child: ListView.builder(
                        controller: controller.scrollController,
                        padding: _listviewPadding(context, isReversed),
                        itemCount: itemList.length + 1,
                        shrinkWrap: true,
                        reverse: isReversed,
                        itemBuilder: (context, index) {
                          if (index < itemList.length) {
                            final item = itemList.elementAt(index);
                            return CustomInkwell(
                              child: item.child,
                              onTap: () {
                                controller.selectedItem.value = item;
                                if (widget.onChanged != null) {
                                  widget.onChanged!(item.value);
                                }
                                Navigator.pop(context);
                                if (item.onTap != null) item.onTap!();
                              },
                            );
                          } else {
                            return ValueListenableBuilder(
                              valueListenable: controller.state,
                              builder: (context, SearcableDropdownState state,
                                      child) =>
                                  state == SearcableDropdownState.Busy
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : const SizedBox(),
                            );
                          }
                        },
                      ),
                    ),
    );
  }

  EdgeInsets _listviewPadding(BuildContext context, bool isReversed) {
    return EdgeInsets.only(
        left: MediaQuery.of(context).size.height * 0.01,
        right: MediaQuery.of(context).size.height * 0.01,
        bottom: !isReversed ? MediaQuery.of(context).size.height * 0.06 : 0,
        top: isReversed ? MediaQuery.of(context).size.height * 0.06 : 0);
  }

  Widget dropDownText(SearchableDropdownController<T> controller) {
    return ValueListenableBuilder(
      valueListenable: controller.selectedItem,
      builder: (context, SearchableDropdownMenuItem<T>? selectedItem, child) =>
          selectedItem?.child ??
          (selectedItem?.label != null
              ? Text(
                  selectedItem!.label,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  style: widget.isEnabled
                      ? CommonTextStyle().noteHeadingTextStyle
                      : CommonTextStyle().noteHeadingTextStyle,
                )
              : widget.hintText) ??
          const SizedBox.shrink(),
    );
  }
}

//New File Class

class SearchableDropdownMenuItem<T> {
  T? value;

  ///This is for searching or if child property is null this will be shwon
  String label;

  ///Dropdown item widget
  Widget child;

  ///Item on tap
  VoidCallback? onTap;

  SearchableDropdownMenuItem({
    this.value,
    required this.label,
    required this.child,
    this.onTap,
  });
}

//New File Class
// ignore: constant_identifier_names
enum SearcableDropdownState { Initial, Busy, Error, Loaded }

class SearchableDropdownController<T> {
  final ValueNotifier<SearcableDropdownState> state =
      ValueNotifier<SearcableDropdownState>(SearcableDropdownState.Initial);

  ScrollController scrollController = ScrollController();
  GlobalKey key = GlobalKey();
  FocusNode searchFocusNode = FocusNode();

  ValueNotifier<SearchableDropdownMenuItem<T>?> selectedItem =
      ValueNotifier<SearchableDropdownMenuItem<T>?>(null);

  final ValueNotifier<List<SearchableDropdownMenuItem<T>>?> paginatedItemList =
      ValueNotifier<List<SearchableDropdownMenuItem<T>>?>(null);

  Future<List<SearchableDropdownMenuItem<T>>?> Function(int page, String? key)?
      paginatedRequest;
  Future<List<SearchableDropdownMenuItem<T>>?> Function()? futureRequest;

  int requestItemCount = 0;

  List<SearchableDropdownMenuItem<T>>? items;

  ValueNotifier<List<SearchableDropdownMenuItem<T>>?> searchedItems =
      ValueNotifier<List<SearchableDropdownMenuItem<T>>?>(null);

  bool _hasMoreData = true;
  int _page = 1;
  String searchText = '';

  void onInit() {
    if (paginatedRequest == null) return;
    scrollController.addListener(() {
      if (scrollController.position.atEdge &&
          scrollController.position.pixels != 0) {
        printDebug(textString: "=======================At End.....");
        if (searchText.isNotEmpty) {
          getItemsWithPaginatedRequest(page: _page, key: searchText);
        } else {
          getItemsWithPaginatedRequest(page: _page);
        }
      }
    });
  }

  void dispose() {
    searchFocusNode.dispose();
    scrollController.dispose();
  }

  Future<void> getItemsWithPaginatedRequest(
      {required int page, String? key, bool isNewSearch = false}) async {
    printDebug(textString: "Pagination Call....");
    if (paginatedRequest == null) return;
    printDebug(textString: "Pagination Call....");
    if (isNewSearch) {
      _page = 1;
      paginatedItemList.value = null;
      _hasMoreData = true;
    }
    if (!_hasMoreData) return;
    state.value = SearcableDropdownState.Busy;
    final response = await paginatedRequest!(page, key);
    if (response is! List<SearchableDropdownMenuItem<T>>) return;
    printDebug(
        textString: "============== give me Responce......=======${response}");
    paginatedItemList.value ??= [];
    paginatedItemList.value = paginatedItemList.value! + response;
    printDebug(
        textString:
            "==================Pagination. Count...${requestItemCount}");
    if (response.length < requestItemCount) {
      printDebug(textString: "==================Pagination...Page...${_page}");
      _hasMoreData = false;
    } else {
      _page = _page + 1;
      printDebug(textString: "==================Pagination...Page...${_page}");
    }
    state.value = SearcableDropdownState.Loaded;
    printDebug(textString: 'searchable dropdown has more data: $_hasMoreData');
  }

  Future<void> getItemsWithFutureRequest() async {
    if (futureRequest == null) return;

    state.value = SearcableDropdownState.Busy;
    final response = await futureRequest!();
    if (response is! List<SearchableDropdownMenuItem<T>>) return;
    items = response;
    searchedItems.value = response;
    state.value = SearcableDropdownState.Loaded;
  }

  void fillSearchedList(String? value) {
    if (value == null || value.isEmpty) searchedItems.value = items;

    List<SearchableDropdownMenuItem<T>> tempList = [];
    for (var element in items ?? <SearchableDropdownMenuItem<T>>[]) {
      if (element.label.containsWithTurkishChars(value!)) tempList.add(element);
    }
    searchedItems.value = tempList;
  }
}

extension CustomStringExtension on String {
  bool containsWithTurkishChars(String key) {
    return replaceTurkishChars.contains(key.replaceTurkishChars);
  }

  String get replaceTurkishChars {
    var replaced = toLowerCase();
    replaced = replaced.replaceAll('ş', 's');
    replaced = replaced.replaceAll('ı', 'i');
    replaced = replaced.replaceAll('ğ', 'g');
    replaced = replaced.replaceAll('ç', 'c');
    replaced = replaced.replaceAll('ö', 'o');
    replaced = replaced.replaceAll('ü', 'u');
    return replaced;
  }
}

extension CustomGlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);
      return renderObject!.paintBounds.shift(offset);
    } else {
      return null;
    }
  }
}

class CustomSearchBar extends StatelessWidget {
  ///Cancelable operation ile klavyeden değer girme işlemi kontrol edilir
  ///Verilen delay içerisinde klavyeden yeni bir giriş olmaz ise bu fonksiyon tetiklenir.
  final Function(String value)? onChangeComplete;

  ///Klavyeden değer girme işlemi bittikten kaç milisaniye sonra on change complete fonksiyonunun tetikleneceğini belirler
  final Duration changeCompletionDelay;

  final String? hintText;
  final Widget? leadingIcon;
  final bool isOutlined;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final TextStyle? style;

  const CustomSearchBar({
    Key? key,
    this.onChangeComplete,
    this.changeCompletionDelay = const Duration(milliseconds: 800),
    this.hintText,
    this.leadingIcon,
    this.isOutlined = false,
    this.focusNode,
    this.controller,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FocusNode myfocusNode = focusNode ?? FocusNode();
    CancelableOperation? cancelableOpertaion;

    void _startCancelableOperation() {
      cancelableOpertaion = CancelableOperation.fromFuture(
        Future.delayed(changeCompletionDelay),
        onCancel: () {},
      );
    }

    Padding _buildTextField() {
      return Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          maxLines: 1,
          onChanged: (value) async {
            await cancelableOpertaion?.cancel();
            _startCancelableOperation();
            cancelableOpertaion?.value.whenComplete(() async {
              if (onChangeComplete != null) onChangeComplete!(value);
            });
          },
          style: style,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            isDense: true,
            border: InputBorder.none,
            hintText: hintText,
            icon: leadingIcon,
          ),
        ),
      );
    }

    return CustomInkwell(
      padding: EdgeInsets.zero,
      disableTabEffect: true,
      onTap: myfocusNode.requestFocus,
      child: isOutlined
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * 0.01),
                border: Border.all(
                    color: (style?.color ?? Colors.black).withOpacity(0.5)),
              ),
              child: _buildTextField(),
            )
          : Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(
                      MediaQuery.of(context).size.height * 0.015))),
              child: _buildTextField(),
            ),
    );
  }
}

class CustomInkwell extends StatelessWidget {
  final Function()? onTap;
  final EdgeInsets? padding;
  final Widget child;
  final bool disableTabEffect;
  const CustomInkwell(
      {Key? key,
      required this.onTap,
      required this.child,
      this.padding,
      this.disableTabEffect = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: disableTabEffect ? Colors.transparent : null,
      splashColor: disableTabEffect ? Colors.transparent : null,
      highlightColor: disableTabEffect ? Colors.transparent : null,
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(MediaQuery.of(context).size.height * 0.015),
      child: Padding(
        padding: padding ??
            EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
        child: child,
      ),
    );
  }
}
