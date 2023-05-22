// ignore_for_file: deprecated_member_use, no_leading_underscores_for_local_identifiers, prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:tutor_me/screens/navigation-screens/nav_conversation_screen.dart';

import '../../blocs/payment/payment_bloc.dart';
import '../../utilities/stream.dart';

class ContractPayment extends StatefulWidget {
  const ContractPayment({super.key});

  @override
  State<ContractPayment> createState() => _ContractPaymentState();
}

class _ContractPaymentState extends State<ContractPayment> {
  @override
  void initState() {
    super.initState();
  }

  _ContractPaymentState() {
    initPayment();
  }

  Future<void> initPayment() async {
    const pubKey =
        "pk_test_51N83xmF8DXig5RpUsgcJiT6WFS4GwM69CA3OMGqxTJLNfEiR15E7FtFx9fagYQaZ3LDkJ8pU1uVMSV4ofuJRbGLV00n1dLo6L6";
    Stripe.publishableKey = pubKey;
    await Stripe.instance.applySettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: const Color(0xFF4ECDE6),
        elevation: 0,
        title: const Text(
          'Contract Payment',
          style: TextStyle(
            fontFamily: 'Lato',
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          // Hide the keyboard when tapping outside of the input field
          FocusScope.of(context).unfocus();
        },
        child: BlocProvider(
          create: (context) => PaymentBloc(),
          child: SingleChildScrollView(
            child: BlocBuilder<PaymentBloc, PaymentState>(
              builder: (context, state) {
                CardFormEditController _controller = CardFormEditController(
                  initialDetails: state.cardFieldInputDetails,
                );

                if (state.status == PaymentStatus.initial) {
                  return Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset(
                          'assets/images/payment.png',
                          fit: BoxFit.contain,
                          height: 300.h,
                          width: 100.w,
                        ),
                        Text(
                          "Enter Card Details",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Lato',
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: CardFormField(
                            controller: _controller,
                            style: CardFormStyle(
                              backgroundColor: Colors.white,
                              borderWidth: 1,
                              borderColor: Colors.grey,
                              borderRadius: 10,
                              cursorColor: Colors.blue,
                              textColor: Colors.black,
                              fontSize: 15,
                              placeholderColor:
                                  const Color.fromARGB(255, 0, 0, 0),
                              textErrorColor: Color.fromARGB(255, 255, 0, 0),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF60D2E9),
                            minimumSize: Size(180.w, 50.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.r),
                              side: const BorderSide(color: Color(0xFF4ECDE6)),
                            ),
                          ),
                          onPressed: () {
                            context.read<PaymentBloc>().add(
                                  const PaymentCreateIntent(
                                    billingDetails: BillingDetails(
                                      email: 'sarimsohail@gmail.com',
                                    ),
                                    items: [
                                      {'id': 0},
                                    ],
                                  ),
                                );
                          },
                          child: Text(
                            'Pay',
                            style: TextStyle(
                              fontSize: 25.sp,
                              fontFamily: 'Righteous',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (state.status == PaymentStatus.success) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(height: 300.h),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF60D2E9),
                            minimumSize: Size(180.w, 50.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.r),
                              side: const BorderSide(color: Color(0xFF4ECDE6)),
                            ),
                          ),
                          onPressed: () {
                            context.read<PaymentBloc>().add(PaymentStart());

                            Navigator.pop(context);
                            Navigator.pop(context);
                            
                            },
                          child: Text(
                            'Payment Complete',
                            style: TextStyle(
                              fontSize: 25.sp,
                              fontFamily: 'Righteous',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                if (state.status == PaymentStatus.failure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 300.h),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF60D2E9),
                            minimumSize: Size(180.w, 50.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.r),
                              side: const BorderSide(color: Color(0xFF4ECDE6)),
                            ),
                          ),
                          onPressed: () {
                            context.read<PaymentBloc>().add(PaymentStart());
                          },
                          child: Text(
                            'Retry',
                            style: TextStyle(
                              fontSize: 25.sp,
                              fontFamily: 'Righteous',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
