// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_demo/modules/cart/my-cart.dart';
import 'package:flutter_demo/modules/dashboard-page/dashboard-controller.dart';
import 'package:flutter_demo/utils.dart';
// import 'package:flutter_demo/widgets/user_profile.dart'; // Import the UserProfile widget
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex0 = 4;
  File? selectedImageFile;
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController gender = TextEditingController();
  String? imageUrl;
  @override
  void initState() {
    super.initState();
    fetchCustomerProfie();
  }

  Future fetchCustomerProfie() async {
    var jsonData = await dashboardController.fetchCustomerProfie();
    setState(() {
      loadingUserPprofile = false;
      errormsg1 = false;
    });
    if (jsonData != null && jsonData['code'] == 400) {
      Get.snackbar('Failure', jsonData['message'],
          snackPosition: SnackPosition.bottom,
          duration: const Duration(milliseconds: 800));
    } else {
      if (jsonData != null && jsonData["data"] != null) {
        firstNameController.text = jsonData['data'][0]['first_name'].toString();

        if (jsonData['data'][0]['last_name'] != null) {
          lastNameController.text = jsonData['data'][0]['last_name'].toString();
        } else {
          lastNameController.text = " ";
        }

        emailController.text = jsonData['data'][0]['user_email'].toString();
        phoneController.text = jsonData['data'][0]['user_phone'].toString();
        dateController.text = jsonData['data'][0]['user_dob'].toString();
        gender.text = jsonData['data'][0]['user_gender'].toString();

        setState(() {
          imageUrl = jsonData['data'][0]['user_avatar'];
          dashboardController.currentUserImage =
              jsonData['data'][0]['user_avatar'];
        });
      }
    }
  }

  String _oldPassword = '';
  String _newPassword = '';
  String _confirmPassword = '';

  bool _isObscureOldPassword = true;
  bool _isObscureNewPassword = true;
  bool _isObscureConfirmPassword = true;

  final _formKey1 = GlobalKey<FormState>();

  bool errormsg = false;
  bool errormsg1 = false;

  String? errormessage;
  String? errormessage1;

  DateTime? selectedDate;
  Uint8List? bytes;
  bool loadingUserPprofile = true;

  @override
  Widget build(BuildContext context) {
    final List<String> pageKeys = [
      '/dashboard',
      dashboardController.isStoreCreated == true
          ? '/storeDashboardIndividual?storeId=${dashboardController.customerStoreId}'
          : '/storeRegistrationPage',
      '/favourites',
      '/myCart',
      '/userProfile',
    ];
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          Get.toNamed('/dashboard');
          return;
        }
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Scaffold(
            key: _scaffoldKey,
            appBar: appBar(dashboardController, "Profile", context, false),
            body: _buildUserProfile(dashboardController, selectedImageFile),
            bottomNavigationBar:
                bottomNavigationItems(currentIndex0, context, pageKeys),
          ),
        ),
      ),
    );
  }

  BottomNavigationBar bottomNavigationItems(
      int currentIndex0, BuildContext context, List<String> pageKeys) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xffAF6CDA),
      unselectedItemColor: const Color(0xff808089),
      currentIndex: currentIndex0,
      onTap: (index) {
        Get.offNamed(
            pageKeys[index]); // Use Get.offNamed to clear previous pages
      },
      items: [
        BottomNavigationBarItem(
          label: 'Home',
          icon: InkWell(
              onTap: () {
                Get.offNamed('/dashboard');
              },
              child: const Icon(Icons.home_filled)),
        ),
        BottomNavigationBarItem(
          label: dashboardController.isStoreCreated == true
              ? 'My Store'
              : 'Create Store',
          icon: InkWell(
            onTap: () {
              dashboardController
                  .clearControllerFromDashBoardAndNavigateTostore(
                      context, dashboardController.isStoreCreated);
            },
            child: Stack(children: [
              const Icon(Icons.storefront_outlined),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: dashboardController.buyerHasNewMessage
                        ? Colors.red
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ]),
          ),
        ),
        BottomNavigationBarItem(
          label: 'Favorites',
          icon: InkWell(
              onTap: () {
                Get.offNamed('/favourites');
              },
              child: const Icon(Icons.favorite_outline)),
        ),
        BottomNavigationBarItem(
          label: 'Cart',
          icon: InkWell(
              onTap: () {
                Get.offNamed('/myCart');
              },
              child: Stack(children: [
                const Icon(Icons.shopping_cart),
                (dashboardController.totalCartCount != '-1' &&
                        dashboardController.totalCartCount != '0')
                    ? Positioned(
                        right: 0,
                        top: 1,
                        bottom: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            dashboardController.totalCartCount,
                            style: SafeGoogleFont(
                              "Poppins",
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ])),
        ),
        BottomNavigationBarItem(
          label: 'Profile',
          icon: InkWell(
              onTap: () {
                Get.offNamed('/userProfile');
              },
              child: const Icon(Icons.person)),
        ),
      ],
    );
  }

  Widget _buildUserProfile(
      DashboardController dashboardController, selectedImageFile) {
    imageUrl = dashboardController.currentUserImage;

    return SingleChildScrollView(
      child: Form(
        key: _formKey1,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: imageSection(selectedImageFile, imageUrl)),
              const SizedBox(height: 20),
              Text(
                "First Name",
                style: SafeGoogleFont(
                  "Poppins",
                  color: const Color(0xFF868889),
                  fontSize: 15,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextFormField(
                controller: firstNameController,
                onChanged: (value) {
                  errormsg1 = false;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Last Name",
                style: SafeGoogleFont(
                  "Poppins",
                  color: const Color(0xFF868889),
                  fontSize: 15,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // SizedBox(
              //   height: 100,
              //   child: Image.memory(
              //     bytes!,
              //     fit: BoxFit
              //         .cover, // Adjust the fit as per your UI requirements
              //   ),
              // ),
              TextFormField(
                controller: lastNameController,
                onChanged: (value) {
                  errormsg1 = false;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter last name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Email",
                style: SafeGoogleFont(
                  "Poppins",
                  color: const Color(0xFF868889),
                  fontSize: 15,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextFormField(
                controller: emailController,
                onChanged: (value) {
                  errormsg1 = false;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter email';
                  }
                  // You can add more validation for email format here if needed
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Phone Number",
                style: SafeGoogleFont(
                  "Poppins",
                  color: const Color(0xFF868889),
                  fontSize: 15,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (value) {
                  errormsg1 = false;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter phone number';
                  }

                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Gender",
                style: SafeGoogleFont(
                  "Poppins",
                  color: const Color(0xFF868889),
                  fontSize: 15,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Radio(
                    value: 'Male',
                    groupValue: gender.text,
                    onChanged: (value) {
                      setState(() {
                        gender.text = value!;
                      });
                    },
                  ),
                  const Text('Male'),
                  Radio(
                    value: 'Female',
                    groupValue: gender.text,
                    onChanged: (value) {
                      setState(() {
                        gender.text = value!;
                      });
                    },
                  ),
                  const Text('Female'),
                  Radio(
                    value: 'Others',
                    groupValue: gender.text,
                    onChanged: (value) {
                      setState(() {
                        gender.text = value!;
                      });
                    },
                  ),
                  const Text('Other'),
                ],
              ),
              Text(
                "DOB",
                style: SafeGoogleFont(
                  "Poppins",
                  color: const Color(0xFF868889),
                  fontSize: 15,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextFormField(
                readOnly: true,
                controller: dateController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your date of birth';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    pwdModal(context);
                  },
                  child: Text(
                    "Change Password",
                    style: SafeGoogleFont(
                      "Poppins",
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff868889),
                    ),
                  ),
                ),
              ),
              errormsg1 == true
                  ? Text("$errormessage1",
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: const TextStyle(color: Colors.red))
                  : Container(),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffAF6CDA),
                  ),
                  onPressed: () async {
                    if (_formKey1.currentState!.validate()) {
                      updateCustomerProfile(
                          firstNameController,
                          phoneController,
                          lastNameController,
                          emailController,
                          gender,
                          dateController,
                          selectedImageFile,
                          context);
                    }
                  },
                  child: Text(
                    'Update',
                    style: SafeGoogleFont(
                      "Poppins",
                      color: Colors.white,
                      fontSize: 16,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        // dateController.text = '${picked.month}-${picked.day}-${picked.year}';
        dateController.text = '${picked.year}-${picked.month}-${picked.day}';
      });
    }
  }

  Future<dynamic> pwdModal(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              insetPadding: const EdgeInsets.all(0),
              title: const Text('Change Password'),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: oldPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Old Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscureOldPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscureOldPassword = !_isObscureOldPassword;
                              });
                            },
                          ),
                        ),
                        obscureText: _isObscureOldPassword,
                        validator: (value) {
                          if (value!.isEmpty) {
                            setState(() {
                              errormsg = true;
                            });
                            return 'Please enter your old password';
                          }
                          setState(() {
                            errormsg = false;
                          });
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _oldPassword = value;
                            errormsg = false;
                          });
                        },
                      ),
                      TextFormField(
                        controller: newPasswordController,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscureNewPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscureNewPassword = !_isObscureNewPassword;
                              });
                            },
                          ),
                        ),
                        obscureText: _isObscureNewPassword,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a new password';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _newPassword = value;
                            errormsg = false;
                          });
                        },
                      ),
                      TextFormField(
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscureConfirmPassword =
                                    !_isObscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                        obscureText: _isObscureConfirmPassword,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please confirm your new password';
                          }
                          if (value != _newPassword) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _confirmPassword = value;
                            errormsg = false;
                          });
                        },
                      ),
                      if (errormsg)
                        Text(
                          "$errormessage",
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: const TextStyle(color: Colors.red),
                        ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            bool a = await changePwd(oldPasswordController,
                                confirmPasswordController);
                            if (a) {
                              fetchCustomerProfie();
                            }
                            // Close the dialog
                          }
                        },
                        child: const Text("submit"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<dynamic> pwdModal1(BuildContext context) {
    bool isFormValid = false; // Variable to track form validation

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: AlertDialog(
                insetPadding: const EdgeInsets.all(0),
                title: const Text('Change Password'),
                content: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    onChanged: () {
                      // Check form validation status on form change
                      setState(() {
                        isFormValid = _formKey.currentState!.validate();
                      });
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          obscureText: _isObscureOldPassword,
                          controller: oldPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Old Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscureOldPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscureOldPassword =
                                      !_isObscureOldPassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your old password';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _oldPassword = value;
                              errormsg = false;
                            });
                          },
                        ),
                        TextFormField(
                          controller: newPasswordController,
                          decoration: InputDecoration(
                            labelText: 'New Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscureNewPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscureNewPassword =
                                      !_isObscureNewPassword;
                                });
                              },
                            ),
                          ),
                          obscureText: _isObscureNewPassword,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a new password';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _newPassword = value;
                              errormsg = false;
                            });
                          },
                        ),
                        TextFormField(
                          controller: confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscureConfirmPassword =
                                      !_isObscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                          obscureText: _isObscureConfirmPassword,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please confirm your new password';
                            }
                            if (value != _newPassword) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _confirmPassword = value;
                              errormsg = false;
                            });
                          },
                        ),
                        errormsg == true
                            ? Text("$errormessage",
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: const TextStyle(color: Colors.red))
                            : Container(),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              isFormValid ? Colors.blue : Colors.grey,
                            ),
                          ),
                          onPressed:
                              isFormValid // Enable button only if form is valid
                                  ? () {
                                      changePwd(oldPasswordController,
                                          confirmPasswordController);

                                      // Close the dialog
                                    }
                                  : null, // Disable button if form is not valid
                          child: const Text("submit"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget imageSection(selectedImageFile, String? imageUrl) {
    return InkWell(
        onTap: () {
          _showImageOptions(context);
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color.fromARGB(255, 155, 218,
                      218), // You can specify any color you want here
                  width: 2, // Adjust the width of the border
                ),
              ),
              child: ClipOval(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 160, 149, 226),
                    image: selectedImageFile != null
                        ? DecorationImage(
                            image: FileImage(selectedImageFile!),
                            fit: BoxFit.cover)
                        : (imageUrl!.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover)
                            : null),
                  ),
                  child: selectedImageFile == null && imageUrl!.isEmpty
                      ? const Icon(Icons.account_circle,
                          size: 100, color: Colors.grey) // Placeholder icon
                      : null,
                ),
              ),
            ),
            Positioned(
              bottom: 1,
              right: 0,
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(Icons.edit,
                    size: 16, color: Color.fromARGB(255, 144, 145, 146)),
              ),
            ),
          ],
        ));
  }

  void _showImageOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(0),
          title: const Text(
            "Choose an option",
            style: TextStyle(fontSize: 22),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _getImageFromGallery(context);
                  },
                  child: const Text("Gallery"),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    cameraUpload(context);
                  },
                  child: const Text("Camera"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _getImageFromGallery(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.deepPurple,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          selectedImageFile = File(croppedFile.path);
        });
        Navigator.pop(context);
      }
    }
  }

  void cameraUpload(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      CroppedFile? croppedFile = await ImageCropper()
          .cropImage(sourcePath: pickedFile.path, aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ], uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.deepPurple,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
        ),
      ]);
      if (croppedFile != null) {
        setState(() {
          selectedImageFile = File(croppedFile.path);
        });

        Navigator.pop(context);
      }
    }
  }

  Future changePwd(oldPasswordController, confirmPasswordController) async {
    var jsonData = await dashboardController.changePwd(
        oldPasswordController.text, confirmPasswordController.text, context);

    if (jsonData != null && jsonData['code'] == 400) {
      setState(() {
        errormsg = true;
        errormessage = jsonData['message'];
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errormessage!),
        ));
      });
    } else {
      var displayMessage = jsonData['message'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(displayMessage),
      ));
      Navigator.of(context).pop();
      return true;
    }
  }

  Future updateCustomerProfile(
      firstNameController,
      phoneController,
      lastNameController,
      emailController,
      gender,
      dateController,
      selectedImageFile,
      context) async {
    setState(() {
      loadingUserPprofile = true;
    });

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: 80.0,
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (loadingUserPprofile == true)
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xffAF6CDA)),
                      ),
                      SizedBox(width: 20),
                      Text(
                        "Updating profile...",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );

    var val = await dashboardController.updateCustomerProfile(
        firstNameController.text,
        lastNameController.text,
        emailController.text,
        phoneController.text,
        gender.text,
        dateController.text,
        selectedImageFile,
        context);
    if (val == "true") {
      Future.delayed(const Duration(seconds: 2));
      Get.offAllNamed('/dashboard');
      setState(() {
        loadingUserPprofile = false;
      });
      // Get.offAndToNamed('/dashboard');
      await fetchCustomerProfie();
    } else if (val == "false") {
      setState(() {
        errormsg1 = true;
        loadingUserPprofile = false;
        errormessage1 = "Error updating profile";
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error updating profile"),
      ));
    }
  }
}

class UploadedFile {
  bool test;
  String originalName;
  String mimeType;
  int size;
  int error;
  dynamic hashName;

  UploadedFile({
    required this.test,
    required this.originalName,
    required this.mimeType,
    required this.size,
    required this.error,
    required this.hashName,
  });

  Map<String, dynamic> toJson() {
    return {
      'test': test,
      'originalName': originalName,
      'mimeType': mimeType,
      'size': size,
      'error': error,
      'hashName': hashName,
    };
  }
}
