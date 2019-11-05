import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmamobile/src/models/credential.dart';
import 'package:irmamobile/src/models/irma_configuration.dart';
import 'dart:ui' as ui;

import 'button.dart';
import 'backgrounds.dart';
import 'card-personal-data.dart';
import 'open-close-event.dart';

class IrmaCard extends StatefulWidget {
  final StreamController<bool> unfoldStream = StreamController();
  final StreamController<void> updateStream = StreamController();
  final StreamController<void> removeStream = StreamController();
  final StreamController<OpenCloseEvent> openCloseStream = StreamController();

  final String lang = ui.window.locale.languageCode;

  final Credential personalData;
  final bool isOpen;

  IrmaCard(this.personalData, this.isOpen);

  @protected
  @mustCallSuper
  void dispose() {
    unfoldStream.close();
    updateStream.close();
    removeStream.close();
    openCloseStream.close();
  }

  @override
  _IrmaCardState createState() => _IrmaCardState();

  open({double height}) {
    openCloseStream.sink.add(OpenCloseEvent(OpenCloseStatus.open, height));
  }

  close() {
    openCloseStream.sink.add(OpenCloseEvent(OpenCloseStatus.close, 0));
  }
}

class _IrmaCardState extends State<IrmaCard> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  static final _opacityTween = Tween<double>(begin: 0, end: 1);
  static final _rotateTween = Tween<double>(begin: 0, end: math.pi);

  static const animationDuration = 250;
  static const indent = 100.0;
  static const headerBottom = 30.0;
  static const borderRadius = Radius.circular(15.0);
  static const padding = 15.0;
  static const transparentWhiteLine = Color(0xaaffffff);
  static const transparentWhiteBackground = Color(0x55ffffff);

  Tween _heightTween = Tween<double>(begin: 240, end: 400);

  // State
  bool isUnfolded = false;
  bool isCardReadable = false;

  IrmaCardTheme irmaCardTheme;
  AssetImage IrmaCardThemeImage;

  @override
  void initState() {
    controller = AnimationController(duration: const Duration(milliseconds: animationDuration), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    widget.openCloseStream.stream.listen((OpenCloseEvent event) {
      if (event.name == OpenCloseStatus.open) {
        open(height: event.height);
      } else if (event.name == OpenCloseStatus.close) {
        close();
      }
    });

    irmaCardTheme = calculateIrmaCardTheme(widget.personalData.issuer);
    IrmaCardThemeImage = irmaCardTheme.getBackgroundImage();

    super.initState();
  }

  @override
  void didUpdateWidget(oldWidget) {
    if (widget.isOpen != oldWidget.isOpen) {
      if (widget.isOpen) {
        open(height: 400);
      } else {
        close();
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  calculateIrmaCardTheme(Issuer issuer) {
    int strNum = issuer.id.runes.reduce((oldChar, newChar) {
      return (oldChar << 2) ^ newChar;
    });

    List<IrmaCardTheme> bgSection = backgrounds[strNum % backgrounds.length];
    return bgSection[(strNum ~/ backgrounds.length) % bgSection.length];
  }

  open({double height}) {
    _heightTween = Tween<double>(begin: 240, end: height);
    controller.forward();
    setState(() {
      isUnfolded = true;
    });
    widget.unfoldStream.sink.add(true);
  }

  close() {
    controller.reverse();
    setState(() {
      isUnfolded = false;
    });
    widget.unfoldStream.sink.add(false);
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: animation,
      builder: (buildContext, child) {
        return GestureDetector(
            onLongPress: () {
              setState(() {
                isCardReadable = true;
              });
            },
            onLongPressUp: () {
              setState(() {
                isCardReadable = false;
              });
            },
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: padding,
                        right: padding,
                        bottom: headerBottom,
                      ),
                      child: Text(
                        FlutterI18n.translate(context, 'card.personaldata'),
                        style: Theme.of(context).textTheme.headline.copyWith(color: irmaCardTheme.fgColor),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(padding),
                      child: Opacity(
                          opacity: _opacityTween.evaluate(animation),
                          child: _opacityTween.evaluate(animation) == 0
                              ? Text("")
                              : CardPersonalData(widget.personalData, widget.personalData.issuer, isCardReadable,
                                  widget.lang, irmaCardTheme)),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Semantics(
                            button: true,
                            enabled: false,
                            label: FlutterI18n.translate(context, 'accessibility.unfold'),
                            child: Transform(
                              origin: Offset(27, 24),
                              transform: Matrix4.rotationZ(
                                _rotateTween.evaluate(animation),
                              ),
                              child: IconButton(
                                onPressed: () {},
                                icon: SvgPicture.asset('assets/icons/arrow-down.svg'),
                                padding: EdgeInsets.only(left: padding),
                                alignment: Alignment.centerLeft,
                              ),
                            ),
                          ),
                        ),
                        Opacity(
                            opacity: _opacityTween.evaluate(animation),
                            child: CardButton(
                                'assets/icons/update.svg', 'accessibility.update', widget.updateStream.sink)),
                        Opacity(
                            opacity: _opacityTween.evaluate(animation),
                            child:
                                CardButton('assets/icons/remove.svg', 'accessibility.remove', widget.removeStream.sink))
                      ],
                    ),
                    height: 50,
                    decoration: BoxDecoration(
                      color: transparentWhiteBackground,
                      borderRadius: BorderRadius.only(
                        bottomLeft: borderRadius,
                        bottomRight: borderRadius,
                      ),
                    ),
                  ),
                ],
              ),
              height: _heightTween.evaluate(animation),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: irmaCardTheme.bgColor,
                  borderRadius: BorderRadius.all(
                    borderRadius,
                  ),
                  image:
                      DecorationImage(image: IrmaCardThemeImage, fit: BoxFit.fitWidth, alignment: Alignment.topCenter)),
            ));
      });
}
