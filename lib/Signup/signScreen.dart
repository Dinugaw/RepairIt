import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:repair_me/Login/loginScreen.dart';
import 'VerifyUI.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => new _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  DateTime selectedDate = DateTime.now();
  DateTime dummyDate;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumController = TextEditingController();
  bool _validateName = false;
  bool _validateEmail = false;
  bool _validatePhone = false;
  bool _validatePassword = false;
  bool _validateDOB = false;
  bool _emailExist = false;
  bool _phoneExists = false;
  CountryCode code;
  bool isLoading = false;
  ProgressDialog pr;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime(1995),
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dummyDate = picked;
      });
  }

  Future<void> validateInputs(String email, String number) async {
    QuerySnapshot emailDocumentList;
    List<QuerySnapshot> phoneDocumentList;

    await Firestore.instance
        .collection('Users')
        .where('userEmail', isEqualTo: email)
        .getDocuments()
        .then((value) {
      if (value.documents.length != 0) {
        setState(() {
          _emailExist = true;
        });
      } else {
        setState(() {
          _emailExist = false;
        });
      }
    });
    await Firestore.instance
        .collection('Users')
        .where('userNumber', isEqualTo: number)
        .getDocuments()
        .then((value) {
      if (value.documents.length != 0) {
        setState(() {
          _phoneExists = true;
        });
      } else {
        setState(() {
          _phoneExists = false;
        });
      }
    });
  }

  void validateForm() {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(_emailController.text)) {
      setState(() {
        _validateEmail = true;
      });
    } else {
      setState(() {
        _validateEmail = false;
      });
    }
    if (_passController.text.length < 8) {
      setState(() {
        _validatePassword = true;
      });
    } else {
      setState(() {
        _validatePassword = false;
      });
    }

    if (_phoneNumController.text == null ||
        _phoneNumController.text.length < 8) {
      setState(() {
        _validatePhone = true;
      });
    } else {
      setState(() {
        _validatePhone = false;
      });
    }
    if (_nameController == null || _nameController.text.length < 1) {
      setState(() {
        _validateName = true;
      });
    } else {
      setState(() {
        _validateName = false;
      });
    }
    if (dummyDate == null) {
      showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text("Error"),
            content: new Text("Please select date of birth"),
          ));
      setState(() {
        _validateDOB = true;
      });
    } else {
      setState(() {
        _validateDOB = false;
      });
    }
  }

  Widget radioButton(bool isSelected) => Container(
        width: 16.0,
        height: 16.0,
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2.0, color: Colors.black)),
        child: isSelected
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.black),
              )
            : Container(),
      );

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: ScreenUtil.getInstance().setWidth(120),
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context);
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
        message: 'Please wait...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black54, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black54,
            fontSize: 19.0,
            fontWeight: FontWeight.w600));
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return new Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: true,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Image.asset(
                      "assets/repair-it.png",
                      height: 180,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(180),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 100.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: ScreenUtil.getInstance().setHeight(180),
                      ),
                      new Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(0.0, 15.0),
                                  blurRadius: 15.0),
                              BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(0.0, -10.0),
                                  blurRadius: 10.0),
                            ]),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("SIGNUP",
                                  style: TextStyle(
                                      fontSize:
                                          ScreenUtil.getInstance().setSp(45),
                                      fontFamily: "Poppins-Bold",
                                      letterSpacing: .6)),
                              SizedBox(
                                height: ScreenUtil.getInstance().setHeight(30),
                              ),
                              Text("Full Name",
                                  style: TextStyle(
                                      fontFamily: "Poppins-Medium",
                                      fontSize:
                                          ScreenUtil.getInstance().setSp(26))),
                              TextField(
                                controller: _nameController,
                                keyboardType: TextInputType.text,
                                onEditingComplete: () {
                                  validateForm();
                                  print("Chandegsadsad");
                                },
                                decoration: InputDecoration(
                                    errorText: _validateName
                                        ? "Name cannot be empty"
                                        : null,
                                    icon: Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                    ),
                                    hintText: "Full Name",
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 12.0)),
                              ),
                              SizedBox(
                                height: ScreenUtil.getInstance().setHeight(30),
                              ),
                              Text("Phone Number",
                                  style: TextStyle(
                                      fontFamily: "Poppins-Medium",
                                      fontSize:
                                          ScreenUtil.getInstance().setSp(26))),
                              Row(
                                children: <Widget>[
                                  CountryCodePicker(
                                    onChanged: (countryCode) {
                                      setState(() {
                                        code = countryCode;
                                        print(code.toString());
                                      });
                                    },
                                    // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                    initialSelection: 'LK',
                                    favorite: ['+94', 'LK'],

                                    // optional. Shows only country name and flag
                                    showCountryOnly: false,
                                    // optional. Shows only country name and flag when popup is closed.
                                    showOnlyCountryWhenClosed: false,
                                    // optional. aligns the flag and the Text left
                                    alignLeft: false,
                                  ),
                                  Icon(
                                    Icons.arrow_downward,
                                    size: 15,
                                    color: Colors.grey,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 20),
                                  ),
                                  Container(
                                    width:
                                        ScreenUtil.getInstance().setWidth(250),
                                    child: TextField(
                                      controller: _phoneNumController,
                                      keyboardType: TextInputType.number,
                                      onEditingComplete: () {
                                        validateForm();
                                      },
                                      decoration: InputDecoration(
                                          errorText: _validatePhone
                                              ? "Enter a valid phone number"
                                              : _phoneExists
                                                  ? "Number aldready exists!"
                                                  : null,
                                          hintText: "Phone Number",
                                          hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12.0)),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtil.getInstance().setHeight(35),
                              ),
                              Text("Email Address",
                                  style: TextStyle(
                                      fontFamily: "Poppins-Medium",
                                      fontSize:
                                          ScreenUtil.getInstance().setSp(26))),
                              TextField(
                                controller: _emailController,
                                onEditingComplete: () {
                                  validateForm();
                                  print("Chandegsadsad");
                                },
                                decoration: InputDecoration(
                                    errorText: _validateEmail
                                        ? "Enter a valid email"
                                        : _emailExist
                                            ? "Email aldready exists"
                                            : null,
                                    icon: Icon(Icons.email, color: Colors.grey),
                                    hintText: "Email Address",
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 12.0)),
                              ),
                              SizedBox(
                                height: ScreenUtil.getInstance().setHeight(30),
                              ),
                              Text("Password",
                                  style: TextStyle(
                                      fontFamily: "Poppins-Medium",
                                      fontSize:
                                          ScreenUtil.getInstance().setSp(26))),
                              TextField(
                                obscureText: true,
                                controller: _passController,
                                onEditingComplete: () {
                                  validateForm();
                                  print("Chandegsadsad");
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    errorText: _validatePassword
                                        ? "Password should contain at least 8 characters"
                                        : null,
                                    icon:
                                        Icon(Icons.vpn_key, color: Colors.grey),
                                    hintText: "Password",
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 12.0)),
                              ),
                              SizedBox(
                                height: ScreenUtil.getInstance().setHeight(35),
                              ),
                              // Row(
                              //   children: <Widget>[
                              //     Text("Date of Birth",
                              //         style: TextStyle(
                              //             fontFamily: "Poppins-Medium",
                              //             fontSize: ScreenUtil.getInstance()
                              //                 .setSp(26))),
                              //     Padding(
                              //       padding: EdgeInsets.only(right: 20),
                              //     ),
                              //     MaterialButton(
                              //       onPressed: () {
                              //         _selectDate(context);
                              //       },
                              //       color: Colors.grey,
                              //       child: Text(
                              //         dummyDate == null
                              //             ? "Select DOB"
                              //             : selectedDate.year.toString() +
                              //                 "-" +
                              //                 selectedDate.month.toString() +
                              //                 "-" +
                              //                 selectedDate.day.toString(),
                              //         style: TextStyle(color: Colors.white),
                              //       ),
                              //     )
                              //   ],
                              // )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            child: Container(
                              width: ScreenUtil.getInstance().setWidth(330),
                              height: ScreenUtil.getInstance().setHeight(100),
                              decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(6.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color(0xFF6078ea).withOpacity(.3),
                                        offset: Offset(0.0, 8.0),
                                        blurRadius: 8.0)
                                  ]),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    pr.show();
                                    validateForm();
                                    if (_validateName == false &&
                                        _validatePhone == false &&
                                        _validateEmail == false &&
                                        _validatePassword == false &&
                                        _validateDOB == false) {
                                      String phoneNum =
                                          _phoneNumController.text.toString();
                                      phoneNum = phoneNum
                                          .replaceFirst("0", "")
                                          .toString();
                                      validateInputs(
                                              _emailController.text,
                                              code == null
                                                  ? "+94" + phoneNum
                                                  : code.toString() + phoneNum)
                                          .then((value) {
                                        if (_emailExist == false &&
                                            _phoneExists == false) {
                                          pr.hide();
                                          Navigator.of(context)
                                              .push(PageRouteBuilder(
                                                  pageBuilder: (_, __, ___) =>
                                                      new Otp(
                                                        name: _nameController
                                                            .text,
                                                        email: _emailController
                                                            .text,
                                                        phoneNumber: code ==
                                                                null
                                                            ? "+94" + phoneNum
                                                            : code.toString() +
                                                                phoneNum,
                                                        password:
                                                            _passController
                                                                .text,
                                                        dateOfBirth: dummyDate
                                                            .toString(),
                                                      )))
                                              .then((value) {});
                                        } else {
                                          pr.hide();
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                actions: [
                                                  FlatButton(
                                                    child: Text(
                                                      "Ok",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily:
                                                              "Montserrat-Medium"),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                                title: Text(
                                                  "Email or Phone Number aldready exists.",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily:
                                                          "Montserrat-Medium"),
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      });
                                    } else {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                    // Navigator.of(context).push(PageRouteBuilder(
                                    //  pageBuilder: (_, __, ___) => new MainHomePage()));
                                  },
                                  child: Center(
                                    child: Text("CONTINUE",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Poppins-Bold",
                                            fontSize: 18,
                                            letterSpacing: 1.0)),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil.getInstance().setHeight(30),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Existing User ? ",
                            style: TextStyle(
                                fontSize: 20, fontFamily: "Poppins-Medium"),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          new LoginScreen()));
                            },
                            child: Text("Login",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                    fontFamily: "Poppins-Bold")),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
