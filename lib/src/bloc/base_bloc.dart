import 'package:bitcoin_converter/src/repository/repository.dart';

abstract class BtcBaseBloc {
  final repository = BtcRepository();

  dispose();
}