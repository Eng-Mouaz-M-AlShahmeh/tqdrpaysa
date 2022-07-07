/// Copyright (c) 2022, Jul. Developed by Eng Mouaz M. Al-Shahmeh
/// TQDRPaySa package
library tqdrpaysa;

///adding necessary packages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

///Code starts here
class TqdrPaySa extends StatefulWidget {
  ///initialization of [TqdrPaySa]
  const TqdrPaySa(
      {Key? key,
      this.amount,
      this.phone,
      required this.store,
      this.orderNumber,
      required this.apiKey})
      : super(key: key);

  ///definition of TQDR map of your order number or numbers
  final Map<String, String>? orderNumber;

  ///definition of amount of TQDR payment
  final String? amount;

  ///definition of customer phone
  final String? phone;

  ///definition of TQDR store to pay with
  final String? store;

  ///definition of TQDR api key
  final String? apiKey;

  @override

  ///creating state
  TqdrPaySaState createState() => TqdrPaySaState();
}

class TqdrPaySaState extends State<TqdrPaySa> {
  ///definition of TQDR map of your order number or numbers
  late Map<String, String>? orderNumber;

  ///definition of amount of TQDR payment
  late String? amount;

  ///definition of customer phone
  late String? phone;

  ///definition of TQDR store to pay with
  late String? store;

  ///definition of TQDR api key
  late String? apiKey;

  ///definition of TQDRPaySa key for the form of payment
  final tqdrPaySaKey = GlobalKey<FormState>();

  ///initializing values of attributes which were not defined by user
  @override
  void initState() {
    setState(() {
      ///initializing orderNumber
      orderNumber = widget.orderNumber ?? <String, String>{};

      ///initializing amount
      amount = widget.amount ?? '';

      ///initializing phone
      phone = widget.phone ?? '';

      ///initializing store
      store = widget.store ?? '';

      ///initializing apiKey
      apiKey = widget.apiKey ?? '';
    });
    super.initState();
  }

  ///initializing list of inputs for order numbers functionality
  List inputs = [];

  ///initializing start of inputs for order numbers functionality
  int i = 1;

  ///initializing the state of loading for the payment send button state
  int loading = 0;

  @override
  Widget build(BuildContext context) {
    ///definition of amount Controller to handle text into text form field
    final TextEditingController amountController =
        TextEditingController(text: amount);
    amountController.value = amountController.value.copyWith(
      selection: TextSelection.fromPosition(
        TextPosition(offset: amount!.length),
      ),
    );

    ///definition of amount Controller to handle text into text form field
    final TextEditingController phoneController =
        TextEditingController(text: phone);
    phoneController.value = phoneController.value.copyWith(
      selection: TextSelection.fromPosition(
        TextPosition(offset: phone!.length),
      ),
    );

    ///definition the function of error snack message
    void errorSnackBar(String message) {
      /// stop loading
      setState(() {
        loading = 0;
      });
      final snackBar =
          SnackBar(content: Text(message), backgroundColor: Colors.red);

      /// Find the Scaffold in the Widget tree and use it to show a SnackBar!
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    ///definition the function of success snack message
    void successSnackBar(String message) {
      /// restore and clean any changes
      setState(() {
        loading = 0;
        inputs = [];
        i = 1;
        amount = '';
        phone = '';
        orderNumber = <String, String>{};
      });
      final snackBar =
          SnackBar(content: Text(message), backgroundColor: Colors.green);

      /// Find the Scaffold in the Widget tree and use it to show a SnackBar!
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    /// TQDR Payment API Function
    Future<dynamic> tqdrPayApi(
      BuildContext context,
      String? amount,
      String? phone,
      String? store,
      Map orderNumber,
    ) async {
      Uri? url = Uri.tryParse('https://tqdr.com.sa/api/invoiceorder/pay');
      Map data = {};
      Map orBody = {};
      orderNumber.map((keyMap, valueMap) {
        orBody["$keyMap"] = "$valueMap";
        return MapEntry("$keyMap", "$valueMap");
      });
      data["apikey"] = apiKey;
      data["amount"] = amount;
      data["phone"] = phone;
      data["store"] = store;
      data["order_number"] = orBody;
      String body = json.encode(data);

      http.Response response = await http.post(url!,
          headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",

            /// Required for CORS support to work
            "Access-Control-Allow-Credentials": "true",

            /// Required for cookies, authorization headers with HTTPS
            "Access-Control-Allow-Headers":
                "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
            "Access-Control-Allow-Methods": "GET, HEAD, POST, OPTIONS",
            "Connection": "keep-alive",
          },
          body: body);
      if (response.statusCode == 200) {
        return 'عملية ناجحة';
      } else if (response.statusCode == 400) {
        var jsonx = json.decode(response.body);
        errorSnackBar("${jsonx['message']}");
        return null;
      } else if (response.statusCode == 422) {
        var jsonx = json.decode(response.body);
        errorSnackBar("${jsonx['message']}");
        return null;
      } else {
        errorSnackBar('هناك خطأ راجع الدعم الفني');
        return null;
      }
    }

    /// TQDR Payment Function to use into TQDR send button
    tqdrPay(BuildContext context, String? amount, String? phone, String? store,
        Map orderNumber) {
      setState(() {
        loading = 1;
        Future.delayed(const Duration(milliseconds: 0), () {
          tqdrPayApi(
            context,
            amount,
            phone,
            store,
            orderNumber,
          ).then((value) {
            if (value != null) {
              successSnackBar('$value');
              return;
            } else {
              loading = 0;
              return;
            }
          });
        });
      });
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: tqdrPaySaKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter(RegExp("[0-9]"), allow: true)
                  ],
                  decoration: InputDecoration(
                    label: const Text(
                      'المبلغ',
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                    ),
                    labelStyle: Theme.of(context).textTheme.headline5,
                    errorStyle: Theme.of(context).textTheme.headline6,
                    hintText: '',
                    hintStyle: Theme.of(context).textTheme.headline5,
                    fillColor: const Color(0xffffffff),
                    filled: true,
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(
                        color: Color(0xffffffff),
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(
                        color: Color(0xff5486e7),
                        width: 1.0,
                      ),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      amount = val;
                    });
                  },
                  validator: (String? val) {
                    if (val!.isEmpty) {
                      return 'هذا الحقل مطلوب';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter(RegExp("[0-9]"), allow: true)
                  ],
                  decoration: InputDecoration(
                    label: const Text(
                      'رقم الجوال',
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                    ),
                    labelStyle: Theme.of(context).textTheme.headline5,
                    errorStyle: Theme.of(context).textTheme.headline6,
                    hintText: '05xxxxxxxx',
                    hintStyle: Theme.of(context).textTheme.headline5,
                    fillColor: const Color(0xffffffff),
                    filled: true,
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(
                        color: Color(0xffffffff),
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(
                        color: Color(0xff5486e7),
                        width: 1.0,
                      ),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      phone = val;
                    });
                  },
                  validator: (String? val) {
                    if (val!.isEmpty) {
                      return 'هذا الحقل مطلوب';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: TextFormField(
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            decoration: InputDecoration(
                              label: const Text(
                                'رقم الإيصال',
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                              ),
                              labelStyle: Theme.of(context).textTheme.headline5,
                              errorStyle: Theme.of(context).textTheme.headline6,
                              hintText: '',
                              hintStyle: Theme.of(context).textTheme.headline5,
                              fillColor: const Color(0xffffffff),
                              filled: true,
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                borderSide: BorderSide(
                                  color: Color(0xffffffff),
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                borderSide: BorderSide(
                                  color: Color(0xff5486e7),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            validator: (String? val) {
                              if (val!.isEmpty) {
                                return 'هذا الحقل مطلوب';
                              } else {
                                return null;
                              }
                            },
                            onChanged: (val) {
                              setState(() {
                                orderNumber!.addEntries(
                                    [MapEntry('0', val.toString())]);
                              });
                            }),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Tooltip(
                      message: 'للدفع بأكثر من رقم إيصال',
                      textStyle: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(color: Colors.white),
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            i = i + 1;
                            inputs.add(i);
                          });
                          setState(() {});
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xff5486e7)),
                          textStyle: MaterialStateProperty.all(
                            const TextStyle(
                              fontSize: 14.0,
                              color: Color(0xffffffff),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.07,
                            child: const Center(
                              child: Text(
                                '+',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Color(0xffffffff),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                (inputs == []) || (inputs.isEmpty)
                    ? const SizedBox()
                    : SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: ListView.builder(
                          itemCount: inputs.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 0.0, 0.0, 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.08,
                                      child: TextFormField(
                                        textDirection: TextDirection.rtl,
                                        textAlign: TextAlign.right,
                                        decoration: InputDecoration(
                                          label: const Text(
                                            'رقم الإيصال',
                                            textDirection: TextDirection.rtl,
                                            textAlign: TextAlign.right,
                                          ),
                                          labelStyle: Theme.of(context)
                                              .textTheme
                                              .headline5,
                                          errorStyle: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                          hintText: '',
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .headline5,
                                          fillColor: const Color(0xffffffff),
                                          filled: true,
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.0)),
                                            borderSide: BorderSide(
                                              color: Color(0xffffffff),
                                              width: 1.0,
                                            ),
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.0)),
                                            borderSide: BorderSide(
                                              color: Color(0xff5486e7),
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
                                        onChanged: (val) {
                                          setState(() {
                                            orderNumber!.addEntries([
                                              MapEntry('${inputs[index]}',
                                                  val.toString())
                                            ]);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        inputs.remove(inputs[index]);
                                      });
                                      setState(() {});
                                    },
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      )),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              const Color(0xff862a2a)),
                                      textStyle: MaterialStateProperty.all(
                                        const TextStyle(
                                          fontSize: 14.0,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.07,
                                        child: const Center(
                                          child: Text(
                                            '-',
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color: Color(0xffffffff),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                const SizedBox(height: 10.0),
                loading == 1
                    ? OutlinedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xfff0ad4e)),
                          textStyle: MaterialStateProperty.all(
                            const TextStyle(
                              fontSize: 14.0,
                              color: Color(0xffffffff),
                            ),
                          ),
                        ),
                        child: SizedBox(
                          height: 65.0,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ))
                    : OutlinedButton(
                        onPressed: () {
                          if (!tqdrPaySaKey.currentState!.validate()) {
                            return;
                          } else {
                            if (store == '' || apiKey == '') {
                              errorSnackBar('هناك خطأ راجع الدعم الفني');
                              return;
                            }
                            tqdrPay(
                              context,
                              amount,
                              phone,
                              store,
                              orderNumber!,
                            );
                          }
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xfff0ad4e)),
                          textStyle: MaterialStateProperty.all(
                            const TextStyle(
                              fontSize: 14.0,
                              color: Color(0xffffffff),
                            ),
                          ),
                        ),
                        child: SizedBox(
                          height: 65.0,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                'إرسال',
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

///end of code
