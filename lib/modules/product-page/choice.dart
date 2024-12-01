import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/core/utils/size_utils.dart';
import 'package:flutter_demo/modules/dashboard-page/dashboard-controller.dart';
import 'package:flutter_demo/theme/theme_helper.dart';
import 'package:flutter_demo/widgets/custom_text_form_field.dart';
import 'package:get/get.dart';

class ChoiceCard extends StatefulWidget {
  final int choiceNumber;

  const ChoiceCard({super.key, required this.choiceNumber});

  @override
  _ChoiceCardState createState() => _ChoiceCardState();
}

class _ChoiceCardState extends State<ChoiceCard> {
  int stockQuantity = 0;
  List<dynamic> choiceList = [];
  Map<String, dynamic>? selectedChoiceData;
  int choiceCount = 0;
  List choiceCards = [];
  final DashboardController dashboardController =
      Get.find<DashboardController>();

  TextEditingController priceController = TextEditingController();
  GlobalKey<FormState> choiceFormKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  bool isChoiceSelected = false;
  bool submitAttemptChoice = false;
  int quantity = 0;

  bool validateChoiceCard() {
    return priceController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = quantity.toString();
    return Form(
      key: choiceFormKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      const Text(
                        'Choice Type',
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        height: 50,
                        width: 200,
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          // value: dashboardController.selectedChoice,
                          items: dashboardController.choiceList
                              .map<DropdownMenuItem<String>>((cccc) {
                            return DropdownMenuItem<String>(
                              value: cccc['ch_name'].toString(),
                              child: Text(cccc['ch_name']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            print(value);
                            var selectedChoice =
                                dashboardController.choiceList.firstWhere(
                              (category) =>
                                  category['ch_name'].toString() == value,
                            );
                            setState(() {
                              // dashboardController.selectedChoice = value;
                              selectedChoiceData =
                                  dashboardController.choiceList.firstWhere(
                                      (element) => element['ch_name'] == value);

                              dashboardController.selectedChoiceID =
                                  selectedChoice['ch_id'];
                            });
                            choiceFormKey.currentState!.validate();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a Choice'; // Error message when dropdown is not selected
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  mrpPrice(dashboardController),
                  sellingPrice(dashboardController),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      const Text(
                        'Update Stock',
                        style: TextStyle(fontSize: 10),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        splashRadius: 5,
                        onPressed: () {
                          setState(() {
                            if (quantity > 0) {
                              quantity--;
                            }
                          });
                        },
                      ),
                      SizedBox(
                        width: 50,
                        height: 30,
                        child: TextFormField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            hintText: '',
                          ),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          onChanged: (text) {
                            if (text.isNotEmpty) {
                              quantity = int.parse(text);
                            }
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add,
                        ),
                        splashRadius: 5,
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),

          // const SizedBox(height: 16),
          // // Display subsequent choice cards
          // for (var choiceCard in choiceCards) choiceCard,
          // const SizedBox(height: 16),

          // Display "Add Choice" button after the last card
          // ElevatedButton(
          //   onPressed: () {
          //     setState(() {
          //       submitAttemptChoice = true;
          //     });

          //     if (choiceFormKey.currentState!.validate()) {
          //       setState(() {
          //         choiceCount++;
          //         choiceCards.add(ChoiceCard(choiceNumber: choiceCount + 1));
          //       });
          //     }
          //   },
          //   child: const Text('Add Choice'),
          // ),
        ],
      ),
    );
  }

  mrpPrice(DashboardController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text("MRP".tr,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: theme.textTheme.titleSmall),
          ),
          CustomTextFormField(
            controller: controller.mrpPriceController,
            margin: getMargin(left: 20, top: 14, right: 20),
            // textStyle: CustomTextStyles.bodyLargeGray60001,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (submitAttemptChoice && (value == null || value.isEmpty)) {
                return 'Please enter MRP name';
              }
              return null;
            },
            onChanged: (value) {
              choiceFormKey.currentState!.validate();
            },
            // hintStyle: CustomTextStyles.bodyLargeGray60001,
            textInputAction: TextInputAction.next,
            autofocus: false,
            alignment: Alignment.center,
            defaultBorderDecoration: TextFormFieldStyleHelper.underLinePrimary,
            enabledBorderDecoration: TextFormFieldStyleHelper.underLinePrimary,
            focusedBorderDecoration: TextFormFieldStyleHelper.underLinePrimary,
            disabledBorderDecoration: TextFormFieldStyleHelper.underLinePrimary,
          ),
        ],
      ),
    );
  }

  sellingPrice(DashboardController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text("Selling Price".tr,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: theme.textTheme.titleSmall),
          ),
          CustomTextFormField(
            controller: controller.sellingPriceController,
            margin: getMargin(left: 20, top: 14, right: 20),
            // textStyle: CustomTextStyles.bodyLargeGray60001,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (submitAttemptChoice && (value == null || value.isEmpty)) {
                return 'Please enter selling price value';
              }
              return null;
            },
            onChanged: (value) {
              choiceFormKey.currentState!.validate();
            },
            // hintStyle: CustomTextStyles.bodyLargeGray60001,
            textInputAction: TextInputAction.next,
            autofocus: false,
            alignment: Alignment.center,
            defaultBorderDecoration: TextFormFieldStyleHelper.underLinePrimary,
            enabledBorderDecoration: TextFormFieldStyleHelper.underLinePrimary,
            focusedBorderDecoration: TextFormFieldStyleHelper.underLinePrimary,
            disabledBorderDecoration: TextFormFieldStyleHelper.underLinePrimary,
          ),
        ],
      ),
    );
  }
}
