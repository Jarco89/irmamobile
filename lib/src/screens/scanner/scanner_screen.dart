import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmamobile/src/data/irma_repository.dart';
import 'package:irmamobile/src/models/session.dart';
import 'package:irmamobile/src/models/session_events.dart';
import 'package:irmamobile/src/screens/scanner/widgets/qr_scanner.dart';
import 'package:irmamobile/src/screens/session/session.dart';
import 'package:irmamobile/src/screens/session/session_screen.dart';
import 'package:irmamobile/src/screens/wallet/wallet_screen.dart';
import 'package:irmamobile/src/widgets/irma_app_bar.dart';

class ScannerScreen extends StatelessWidget {
  static const routeName = "/scanner";

  static void _onClose(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _onSuccess(BuildContext context, SessionPointer sessionPointer) {
    // QR was scanned using IRMA app's internal QR code scanner, so we know for sure
    // the session continues on a second device. Therefore we can overrule the session pointer.
    sessionPointer.continueOnSecondDevice = true;

    HapticFeedback.vibrate();
    startSessionAndNavigate(
      Navigator.of(context),
      sessionPointer,
    );
  }

  // TODO: Make this function private again and / or split it out to a utility function
  static Future<void> startSessionAndNavigate(
    NavigatorState navigator,
    SessionPointer sessionPointer, {
    bool webview = false,
  }) async {
    final repo = IrmaRepository.get();
    final event = NewSessionEvent(
      request: sessionPointer,
      inAppCredential: await repo.getInAppCredential(),
    );

    repo.hasActiveSessions().then((hasActiveSessions) {
      repo.dispatch(event, isBridgedEvent: true);

      if (hasActiveSessions) {
        // After this session finishes, we want to go back to the previous session
        if (webview) {
          // replace webview with session screen
          navigator.pushReplacementNamed(
            SessionScreen.routeName,
            arguments: SessionScreenArguments(
              sessionID: event.sessionID,
              sessionType: event.request.irmaqr,
              hasUnderlyingSession: true,
            ),
          );
        } else {
          // webview is already dismissed, just push the session screen
          navigator.pushNamed(
            SessionScreen.routeName,
            arguments: SessionScreenArguments(
              sessionID: event.sessionID,
              sessionType: event.request.irmaqr,
              hasUnderlyingSession: true,
            ),
          );
        }
      } else {
        navigator.pushNamedAndRemoveUntil(
          SessionScreen.routeName,
          ModalRoute.withName(WalletScreen.routeName),
          arguments: SessionScreenArguments(
            sessionID: event.sessionID,
            sessionType: event.request.irmaqr,
            hasUnderlyingSession: false,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IrmaAppBar(
        title: const Text('QR code scan'),
        leadingAction: () => _onClose(context),
        leadingIcon: Icon(Icons.arrow_back, semanticLabel: FlutterI18n.translate(context, "accessibility.back")),
        actions: const [],
      ),
      body: Stack(
        children: <Widget>[
          QRScanner(
            onClose: () => _onClose(context),
            onFound: (code) => _onSuccess(context, code),
          ),
        ],
      ),
    );
  }
}
