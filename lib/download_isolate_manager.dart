import 'dart:async';
import 'dart:isolate';

import 'package:isolate_to_download/download_isolate_response.dart';
import 'package:isolate_to_download/download_isolate_request.dart';

class DownloadIsolateManager {
  final ReceivePort _uiReceivePort = ReceivePort("DownloaderReceivePort-UI");
  SendPort? _isolateSendPort;
  final StreamController<DownloadIsolateResponse> _streamController =
      StreamController.broadcast();

  Stream get responseStream => _streamController.stream;

  Isolate? _isolate;

  Future<void> setupDance() async {
    Isolate.spawn(_downloadFunction, _uiReceivePort.sendPort);
    _uiReceivePort.listen((data) {
      if (data is SendPort) {
        _isolateSendPort = data;
      } else if (data is DownloadIsolateResponse) {
        _streamController.add(data);
      }
    });
  }

  void download(DownloadMediaRequest request) {
    _isolateSendPort?.send(request);
  }

  void dispose() {
    _isolate?.kill();
  }
}

void _downloadFunction(SendPort uiSendPort) {
  final ReceivePort receivePort = ReceivePort("DownloaderReceivePort-Isolate");
  uiSendPort.send(receivePort.sendPort);
  receivePort.listen((data) async {
    if (data is DownloadMediaRequest) {
      final response = await _downloadMediaRequest(data);
      uiSendPort.send(response);
    }
  });
}

Future<DownloadIsolateResponse> _downloadMediaRequest(
    DownloadIsolateRequest request) async {
  await Future.delayed(const Duration(seconds: 10));
  return DownloadMediaResponse();
}
