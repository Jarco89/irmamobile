import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmamobile/src/screens/enrollment/models/enrollment_bloc.dart';
import 'package:irmamobile/src/screens/enrollment/models/enrollment_event.dart';
import 'package:irmamobile/src/screens/enrollment/widgets/cancel_button.dart';
import 'package:irmamobile/src/screens/enrollment/widgets/choose_pin.dart';
import 'package:irmamobile/src/theme/theme.dart';
import 'package:irmamobile/src/widgets/pin_field.dart';

class ConfirmPin extends StatelessWidget {
  static const String routeName = 'enrollment/confirm_pin';

  @override
  Widget build(BuildContext context) {
    final EnrollmentBloc enrollmentBloc = BlocProvider.of<EnrollmentBloc>(context);

    return Scaffold(
        appBar: AppBar(
          leading: CancelButton(routeName: ChoosePin.routeName),
          title: Text(FlutterI18n.translate(context, 'enrollment.choose_pin.confirm_title')),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.only(top: IrmaTheme.of(context).spacing * 2),
              child: Column(children: [
                Text(
                  FlutterI18n.translate(context, 'enrollment.choose_pin.confirm_instruction'),
                  style: Theme.of(context).textTheme.body1,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: IrmaTheme.of(context).spacing),
                PinField(
                  maxLength: 5,
                  onSubmit: (String pin) {
                    enrollmentBloc.dispatch(PinConfirmed(pin: pin));
                  },
                )
              ])),
        ));
  }
}