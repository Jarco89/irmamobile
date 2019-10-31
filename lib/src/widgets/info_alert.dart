import 'package:flutter/material.dart';
import 'package:irmamobile/src/theme/theme.dart';

class InfoAlert extends StatelessWidget {
  final String title;
  final String body;
  final List<Widget> widgets;

  const InfoAlert({Key key, @required this.title, @required this.body, this.widgets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boxWidgets = <Widget>[
      Text(
        title,
        style: Theme.of(context).textTheme.title,
      ),
      SizedBox(
        height: IrmaTheme.of(context).spacing,
      ),
      Center(
        child: Text(
          body,
          style: Theme.of(context).textTheme.body1,
        ),
      ),
    ];
    if (this.widgets != null) boxWidgets.addAll(this.widgets);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: IrmaTheme.of(context).interactionInformation,
        border: Border.all(color: Color(0xffbbbbbb)),
      ),
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.info_outline,
                size: 24,
              ),
              SizedBox(
                width: 0.5 * IrmaTheme.of(context).spacing,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: boxWidgets,
                ),
              ),
            ],
          )),
    );
  }
}