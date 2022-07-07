# [TQDRPaySa](https://tqdr.com.sa)
### [Android](https://play.google.com/store/apps/developer?id=مؤسسة+تقدر+للوساطة+التجارية)
### [iOS](https://apps.apple.com/app/ت%D9%90قدر/id1610298357)

Flutter package for TQDRPaySa.


## About:
- TQDR is a Saudi digital platform owned by TQDR Commercial Brokerage Corporation 
specialized in providing a receipt payment service for all your digital purchases 
by linking customers to stores and applications through a network of accredited 
stores as service providers (TQDR) through whom you can pay and take a receipt 
that enables you to shop in all approved electronic stores as partners to appreciate 
Currently in Riyadh and soon in all regions of the Kingdom of Saudi Arabia.
- Our mission is to connect people with stores and applications by providing innovative, 
smart, easy and secure payment solutions with professionalism and love. Our vision 
is to be the first cash payment option for digital payments in the Kingdom of Saudi Arabia.

## Terms of use:
Because of the nature of the service provided, 
it is not possible to retrieve electronic payments through us, 
but you can do so according to the terms and conditions of our partners, 
service providers that are valued. And in case you encounter any problem, 
we will work hard to solve it for you as much as possible.

## Privacy and policy:
In TQDR we believe in the confidentiality of information and the privacy of customers, 
and therefore we have adopted steps and working mechanisms that preserve the privacy 
of customers and the confidentiality of information of stores, applications and customers.

## Installation and Basic Usage

Add to pubspec.yaml:

```yaml
dependencies:
  tqdrpaysa: ^1.0.1
```

Then import it to your project:

```dart
import 'package:tqdrpaysa/tqdrpaysa.dart';
```

Finally add **TqdrPaySa** in `Scaffold`:

```dart
@override
Widget build(BuildContext context) {
  return const Scaffold(
    body: Center(
      child: TqdrPaySa(
        // You can pick api key from contract you do with TQDRPaySa
        apiKey: 'abcdefg12345',
        // The same you can pick store id from contract you do with TQDRPaySa
        store: '123',
      ),
    ),
  );
}
```

There are two required attributes of class **TqdrPaySa**. Attribute `apiKey` is a String, which defines what api key you can pick from contract you do with TQDRPaySa. `store` attribute defines the store id, which you can pick from contract you do with TQDRPaySa.


## Thank you

Make sure to check out [example project](https://github.com/Eng-Mouaz-M-AlShahmeh/tqdrpaysa/tree/master/example).
If you find this package useful, star my GitHub [repository](https://github.com/Eng-Mouaz-M-AlShahmeh/tqdrpaysa).

Flutter plugin was developed by: [Eng Mouaz M. Al-Shahmeh](https://twitter.com/mouaz_m_shahmeh)
