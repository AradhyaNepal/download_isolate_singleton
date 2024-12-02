abstract class DownloadIsolateRequest {}

class DownloadMediaRequest extends DownloadIsolateRequest {
  final String url;
  final String id;
  final String valueType;

  DownloadMediaRequest({
    required this.id,
    required this.url,
    required this.valueType,
  });
}
