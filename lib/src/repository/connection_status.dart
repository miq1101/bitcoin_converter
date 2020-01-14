import 'dart:async';
import 'dart:io';
import 'package:bitcoin_converter/src/pages/no_connection_page.dart';
import 'package:bitcoin_converter/src/repository/repository.dart';
import 'package:bitcoin_converter/src/utils/constants.dart';
import 'package:flutter/material.dart';

class ConnectionStatusBar extends StatefulWidget {
  final Color color;
  final Widget title;
  final double width;
  final double height;
  final Offset endOffset;
  final Offset beginOffset;
  final Duration animationDuration;
  final String lookUpAddress;

  ConnectionStatusBar({
    Key key,
    this.height = 25,
    this.width = double.maxFinite,
    this.color = Colors.redAccent,
    this.endOffset = const Offset(0.0, 0.0),
    this.beginOffset = const Offset(0.0, -1.0),
    this.animationDuration = const Duration(milliseconds: 200),
    this.lookUpAddress = 'google.com',
    this.title = const Text(
      'Please check your internet connection',
      style: TextStyle(color: Colors.white, fontSize: 14),
    ),
  }) : super(key: key);

  _ConnectionStatusBarState createState() => _ConnectionStatusBarState();
}

class _ConnectionStatusBarState extends State<ConnectionStatusBar>
    with SingleTickerProviderStateMixin {
  StreamSubscription<DataConnectionStatus> _listener;
  DataConnectionChecker _dataConnectionChecker;

  BtcRepository _repository;
  bool _isOffline;
  int _rowCount;
  AnimationController controller;
  Animation<Offset> offset;
  @override
  void initState() {
    _repository = BtcRepository();
    _isOffline = false;
    _dataConnectionChecker = DataConnectionChecker();
    _connectionChanged();
    controller =
        AnimationController(vsync: this, duration: widget.animationDuration);

    offset = Tween<Offset>(begin: widget.beginOffset, end: widget.endOffset)
        .animate(controller);
    super.initState();
  }

  _showDialog() async {
    showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
            backgroundColor: Colors.grey[850],
            //title: Text("Please try later",style: TextStyle(color: Colors.white)),
            content: Container(
              height: BtcConstants.screenHeight / 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(
                    Icons.error_outline,
                    size: BtcConstants.screenHeight / 20,
                    color: Colors.white,
                  ),
                  Text("Something went wrong",style: TextStyle(color: Colors.white))
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Close",style: TextStyle(color: Colors.white),),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
        ));
  }

  _connectionChanged() async {
    _rowCount = await _repository.getRawCount();
    _listener = _dataConnectionChecker.onStatusChange.listen((status) async {
      if (status == DataConnectionStatus.connected) {
        BtcConstants.connectionStatus = true;
        if (_rowCount == 0) {
          bool isGetDb = await _repository.getDB();
          if (!isGetDb) {
            await _showDialog();
          } else {
            _rowCount = await _repository.getRawCount();
            BtcConstants.changeCurrencyBloc.getRequests();
            if (_isOffline == true) {
              Navigator.pop(context);
              _isOffline = false;
            }
          }
        } else {
          controller.reverse();
        }
      } else {
        BtcConstants.connectionStatus = false;
        print(_rowCount);
        if (_rowCount == 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => BtcNoConnection()));
          _isOffline = true;
        } else {
          controller.forward();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: offset,
      child: Container(
        child: SafeArea(
          bottom: false,
          child: Container(
            color: widget.color,
            width: widget.width,
            height: widget.height,
            child: Center(
              child: widget.title,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _listener.cancel();
    super.dispose();
  }
}

enum DataConnectionStatus {
  disconnected,
  connected,
}

class DataConnectionChecker {
  static const int DEFAULT_PORT = 53;
  static const Duration DEFAULT_TIMEOUT = const Duration(seconds: 3);
  static const Duration DEFAULT_INTERVAL = const Duration(seconds: 1);

  static final List<AddressCheckOptions> DEFAULT_ADDRESSES = List.unmodifiable([
    AddressCheckOptions(
      InternetAddress('1.1.1.1'),
      port: DEFAULT_PORT,
      timeout: DEFAULT_TIMEOUT,
    ),
  ]);

  List<AddressCheckOptions> addresses = DEFAULT_ADDRESSES;

  factory DataConnectionChecker() => _instance;
  DataConnectionChecker._() {
    _statusController.onListen = () {
      _maybeEmitStatusUpdate();
    };

    _statusController.onCancel = () {
      _timerHandle?.cancel();
      _lastStatus = null; // reset last status
    };
  }
  static final DataConnectionChecker _instance = DataConnectionChecker._();

  Future<AddressCheckResult> isHostReachable(
    AddressCheckOptions options,
  ) async {
    Socket sock;
    try {
      sock = await Socket.connect(
        options.address,
        options.port,
        timeout: options.timeout,
      );
      sock?.destroy();
      return AddressCheckResult(options, true);
    } catch (e) {
      sock?.destroy();
      return AddressCheckResult(options, false);
    }
  }

  List<AddressCheckResult> get lastTryResults => _lastTryResults;
  List<AddressCheckResult> _lastTryResults = <AddressCheckResult>[];

  Future<bool> get hasConnection async {
    List<Future<AddressCheckResult>> requests = [];

    for (var addressOptions in addresses) {
      requests.add(isHostReachable(addressOptions));
    }
    _lastTryResults = List.unmodifiable(await Future.wait(requests));

    return _lastTryResults.map((result) => result.isSuccess).contains(true);
  }

  Future<DataConnectionStatus> get connectionStatus async {
    return await hasConnection
        ? DataConnectionStatus.connected
        : DataConnectionStatus.disconnected;
  }

  Duration checkInterval = DEFAULT_INTERVAL;

  _maybeEmitStatusUpdate([Timer timer]) async {
    _timerHandle?.cancel();
    timer?.cancel();

    var currentStatus = await connectionStatus;

    if (_lastStatus != currentStatus && _statusController.hasListener) {
      _statusController.add(currentStatus);
    }

    if (!_statusController.hasListener) return;
    _timerHandle = Timer(checkInterval, _maybeEmitStatusUpdate);

    _lastStatus = currentStatus;
  }

  DataConnectionStatus _lastStatus;
  Timer _timerHandle;

  StreamController<DataConnectionStatus> _statusController =
      StreamController.broadcast();

  Stream<DataConnectionStatus> get onStatusChange => _statusController.stream;

  bool get hasListeners => _statusController.hasListener;

  bool get isActivelyChecking => _statusController.hasListener;
}

class AddressCheckOptions {
  final InternetAddress address;
  final int port;
  final Duration timeout;

  AddressCheckOptions(
    this.address, {
    this.port = DataConnectionChecker.DEFAULT_PORT,
    this.timeout = DataConnectionChecker.DEFAULT_TIMEOUT,
  });

  @override
  String toString() => "AddressCheckOptions($address, $port, $timeout)";
}

class AddressCheckResult {
  final AddressCheckOptions options;
  final bool isSuccess;

  AddressCheckResult(
    this.options,
    this.isSuccess,
  );

  @override
  String toString() => "AddressCheckResult($options, $isSuccess)";
}
