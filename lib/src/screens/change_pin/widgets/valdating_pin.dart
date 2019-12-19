import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:irmamobile/src/screens/change_pin/widgets/cancel_button.dart';
import 'package:irmamobile/src/theme/theme.dart';

class ValidatingPin extends StatelessWidget {
  static const String routeName = 'change_pin/validating_pin';

  final void Function() cancel;

  const ValidatingPin({@required this.cancel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: IrmaTheme.of(context).grayscale85,
          leading: CancelButton(cancel: cancel),
          title: Text(
            FlutterI18n.translate(context, 'change_pin.confirm_pin.title'),
            style: IrmaTheme.of(context).textTheme.display2,
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: IrmaTheme.of(context).largeSpacing),
                child: Column(children: [
                  SizedBox(height: IrmaTheme.of(context).hugeSpacing),
                  SvgPicture.asset('assets/non-free/irma_logo.svg'),
                  SizedBox(height: IrmaTheme.of(context).largeSpacing),
                  Container(
                    constraints: BoxConstraints(maxWidth: IrmaTheme.of(context).defaultSpacing * 16),
                    child: Text(
                      FlutterI18n.translate(context, 'change_pin.validating_pin.header'),
                      textAlign: TextAlign.center,
                      style: IrmaTheme.of(context).textTheme.display1,
                    ),
                  ),
                  SizedBox(height: IrmaTheme.of(context).defaultSpacing),
                  Container(
                    constraints: BoxConstraints(maxWidth: IrmaTheme.of(context).defaultSpacing * 20),
                    child: Text(
                      FlutterI18n.translate(context, 'change_pin.validating_pin.details'),
                      textAlign: TextAlign.center,
                      style: IrmaTheme.of(context).textTheme.body1,
                    ),
                  ),
                ]))));
  }
}