// ignore_for_file: body_might_complete_normally_nullable

import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AwsS3PluginFlutter {
  final File? file;
  final String? fileNameWithExt;
  final String? awsFolderPath;
  final String? poolId;
  final Regions? region;
  final String? bucketName;
  final String? AWSAccess;
  final String? AWSSecret;

  AwsS3PluginFlutter({
    @required this.file,
    @required this.fileNameWithExt,
    @required this.awsFolderPath,
    this.poolId,
    this.region = Regions.US_WEST_2,
    @required this.bucketName,
    @required this.AWSAccess,
    @required this.AWSSecret,
  });

  static const EventChannel _eventChannel =
      const EventChannel('uploading_status');

  static const MethodChannel _channel =
      const MethodChannel('"s3.wasabisys.com"');

  Future<String> get uploadFile async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent("filePath", () => file!.path);
    args.putIfAbsent("awsFolder", () => awsFolderPath);
    args.putIfAbsent("fileNameWithExt", () => fileNameWithExt);
    args.putIfAbsent("region", () => region.toString());
    args.putIfAbsent("bucketName", () => bucketName);
    args.putIfAbsent("AWSSecret", () => AWSSecret);
    args.putIfAbsent("AWSAccess", () => AWSAccess);

    debugPrint("AwsS3Plugin: file path is: ${file!.path}");

    final String result = await _channel.invokeMethod('uploadToS3', args);

    return result;
  }

  Future<String> get getPreSignedURLOfFile async {
    try {
      Map<String, dynamic> args = <String, dynamic>{};
      args.putIfAbsent("awsFolder", () => awsFolderPath);
      args.putIfAbsent("fileNameWithExt", () => fileNameWithExt);
      args.putIfAbsent("bucketName", () => bucketName);
      args.putIfAbsent("region", () => region.toString());
      args.putIfAbsent("AWSSecret", () => AWSSecret);
      args.putIfAbsent("AWSAccess", () => AWSAccess);

      final String result =
          await _channel.invokeMethod('createPreSignedURL', args);

      return result;
    } catch (e) {
      print('presigned URL failed with error $e');
      return "";
    }
  }

  Stream get getUploadStatus => _eventChannel.receiveBroadcastStream();
}

enum Regions {
  GovCloud,
  US_GOV_EAST_1,
  US_EAST_1,
  US_EAST_2,
  US_WEST_1,
  US_WEST_2,

  ///Default: The default region of AWS Android SDK
  EU_WEST_1,
  EU_WEST_2,
  EU_WEST_3,
  EU_CENTRAL_1,
  EU_NORTH_1,
  AP_EAST_1,
  AP_SOUTH_1,
  AP_SOUTHEAST_1,
  AP_SOUTHEAST_2,
  AP_NORTHEAST_1,
  AP_NORTHEAST_2,
  SA_EAST_1,
  CA_CENTRAL_1,
  CN_NORTH_1,
  CN_NORTHWEST_1,
  ME_SOUTH_1
}

const _aws_sha_256 = 'AWS4-HMAC-SHA256';
const _aws4_request = 'aws4_request';
const _aws4 = 'AWS4';
const _x_amz_date = 'x-amz-date';
const _x_amz_security_token = 'x-amz-security-token';
const _host = 'host';
const _authorization = 'Authorization';
const _default_content_type = 'application/json';
const _default_accept_type = 'application/json';

class AwsSigV4Client {
  late String endpoint;
  String? pathComponent;
  String region;
  String accessKey;
  String secretKey;
  String? sessionToken;
  String serviceName;
  String defaultContentType;
  String defaultAcceptType;

  AwsSigV4Client(this.accessKey, this.secretKey, String endpoint,
      {this.serviceName = 'execute-api',
      this.region = 'us-east-1',
      this.sessionToken,
      this.defaultContentType = _default_content_type,
      this.defaultAcceptType = _default_accept_type}) {
    final parsedUri = Uri.parse(endpoint);
    this.endpoint = '${parsedUri.scheme}://${parsedUri.host}';
    pathComponent = parsedUri.path;
  }
}

class SigV4Request {
  String? method;
  late String path;
  Map<String, String>? queryParams;
  Map<String, String?>? headers;
  String? authorizationHeader;
  String? url;
  late String body;
  AwsSigV4Client awsSigV4Client;
  late String canonicalRequest;
  String? hashedCanonicalRequest;
  String? credentialScope;
  late String stringToSign;
  String? datetime;
  late List<int> signingKey;
  late String signature;

  SigV4Request(
    this.awsSigV4Client, {
    required String method,
    String? path,
    this.datetime,
    this.queryParams,
    this.headers,
    this.authorizationHeader,
    dynamic body,
  }) {
    this.method = method.toUpperCase();
    this.path = '${awsSigV4Client.pathComponent}$path';
    headers =
        headers?.map((key, value) => MapEntry(key.toLowerCase(), value)) ?? {};

    if (headers!['content-type'] == null && this.method != 'GET') {
      headers!['content-type'] = awsSigV4Client.defaultContentType;
    }
    if (headers!['accept'] == null) {
      headers!['accept'] = awsSigV4Client.defaultAcceptType;
    }
    if (body == null || this.method == 'GET') {
      this.body = '';
    } else {
      this.body = json.encode(body);
    }
    if (body == '') {
      headers!.remove('content-type');
    }
    datetime = datetime ?? SigV4.generateDatetime();

    headers![_x_amz_date] = datetime;
    final endpointUri = Uri.parse(awsSigV4Client.endpoint);
    headers![_host] = endpointUri.host;

    headers![_authorization] =
        authorizationHeader ?? _generateAuthorization(datetime!);
    if (awsSigV4Client.sessionToken != null) {
      headers![_x_amz_security_token] = awsSigV4Client.sessionToken;
    }
    headers!.remove(_host);

    url = _generateUrl();
  }

  String _generateUrl() {
    var url = '${awsSigV4Client.endpoint}$path';
    if (queryParams != null) {
      final queryString = SigV4.buildCanonicalQueryString(queryParams);
      if (queryString != '') {
        url += '?$queryString';
      }
    }
    return url;
  }

  String _generateAuthorization(String datetime) {
    canonicalRequest =
        SigV4.buildCanonicalRequest(method, path, queryParams, headers!, body);
    hashedCanonicalRequest = SigV4.hashCanonicalRequest(canonicalRequest);
    credentialScope = SigV4.buildCredentialScope(
        datetime, awsSigV4Client.region, awsSigV4Client.serviceName);
    stringToSign = SigV4.buildStringToSign(
        datetime, credentialScope, hashedCanonicalRequest);
    signingKey = SigV4.calculateSigningKey(awsSigV4Client.secretKey, datetime,
        awsSigV4Client.region, awsSigV4Client.serviceName);
    signature = SigV4.calculateSignature(signingKey, stringToSign);
    return SigV4.buildAuthorizationHeader(
        awsSigV4Client.accessKey, credentialScope!, headers!, signature);
  }
}

class SigV4 {
  static String generateDatetime() {
    return DateTime.now()
        .toUtc()
        .toString()
        .replaceAll(RegExp(r'\.\d*Z$'), 'Z')
        .replaceAll(RegExp(r'[:-]|\.\d{3}'), '')
        .split(' ')
        .join('T');
  }

  static List<int> hash(List<int> value) {
    return sha256.convert(value).bytes;
  }

  static String hexEncode(List<int> value) {
    return hex.encode(value);
  }

  static List<int> sign(List<int> key, String message) {
    final hmac = Hmac(sha256, key);
    final dig = hmac.convert(utf8.encode(message));
    return dig.bytes;
  }

  static String hashCanonicalRequest(String request) {
    return hexEncode(hash(utf8.encode(request)));
  }

  static String buildCanonicalUri(String uri) {
    return Uri.encodeFull(uri);
  }

  static String buildCanonicalQueryString(Map<String, String>? queryParams) {
    if (queryParams == null) {
      return '';
    }

    final sortedQueryParams = [];
    queryParams.forEach((key, value) {
      sortedQueryParams.add(key);
    });
    sortedQueryParams.sort();

    final canonicalQueryStrings = [];
    sortedQueryParams.forEach((key) {
      canonicalQueryStrings.add(
          '$key=${Uri.encodeQueryComponent(queryParams[key]!).replaceAll('+', "%20")}');
    });

    return canonicalQueryStrings.join('&');
  }

  static String buildCanonicalHeaders(Map<String, String?> headers) {
    final sortedKeys = [];
    headers.forEach((property, _) {
      sortedKeys.add(property);
    });

    var canonicalHeaders = '';
    sortedKeys.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    sortedKeys.forEach((property) {
      canonicalHeaders += '${property.toLowerCase()}:${headers[property]}\n';
    });

    return canonicalHeaders;
  }

  static String buildCanonicalSignedHeaders(Map<String, String?> headers) {
    final sortedKeys = [];
    headers.forEach((property, _) {
      sortedKeys.add(property.toLowerCase());
    });
    sortedKeys.sort();

    return sortedKeys.join(';');
  }

  static String buildStringToSign(String datetime, String? credentialScope,
      String? hashedCanonicalRequest) {
    return '$_aws_sha_256\n$datetime\n$credentialScope\n$hashedCanonicalRequest';
  }

  static String buildCredentialScope(
      String datetime, String region, String service) {
    return '${datetime.substring(0, 8)}/$region/$service/$_aws4_request';
  }

  static String buildCanonicalRequest(
      String? method,
      String path,
      Map<String, String>? queryParams,
      Map<String, String?> headers,
      String payload) {
    final canonicalRequest = [
      method,
      buildCanonicalUri(path),
      buildCanonicalQueryString(queryParams),
      buildCanonicalHeaders(headers),
      buildCanonicalSignedHeaders(headers),
      hexEncode(hash(utf8.encode(payload))),
    ];
    return canonicalRequest.join('\n');
  }

  static String buildAuthorizationHeader(String accessKey,
      String credentialScope, Map<String, String?> headers, String signature) {
    return _aws_sha_256 +
        ' Credential=' +
        accessKey +
        '/' +
        credentialScope +
        ', SignedHeaders=' +
        buildCanonicalSignedHeaders(headers) +
        ', Signature=' +
        signature;
  }

  static List<int> calculateSigningKey(
      String secretKey, String datetime, String region, String service) {
    return sign(
        sign(
            sign(
                sign(utf8.encode('$_aws4$secretKey'), datetime.substring(0, 8)),
                region),
            service),
        _aws4_request);
  }

  static String calculateSignature(List<int> signingKey, String stringToSign) {
    return hexEncode(sign(signingKey, stringToSign));
  }
}

enum ACL {
  /// Owner gets FULL_CONTROL. No one else has access rights (default).
  private,

  /// Owner gets FULL_CONTROL. The AllUsers group (see Who is a grantee?) gets READ access.
  public_read,

  /// Owner gets FULL_CONTROL. The AllUsers group gets READ and WRITE access. Granting this on a bucket is generally not recommended.
  public_read_write,

  /// Owner gets FULL_CONTROL. Amazon EC2 gets READ access to GET an Amazon Machine Image (AMI) bundle from Amazon S3.
  aws_exec_read,

  /// Owner gets FULL_CONTROL. The AuthenticatedUsers group gets READ access.
  authenticated_read,

  /// Object owner gets FULL_CONTROL. Bucket owner gets READ access. If you specify this canned ACL when creating a bucket, Amazon S3 ignores it.
  bucket_owner_read,

  /// Both the object owner and the bucket owner get FULL_CONTROL over the object. If you specify this  dcanned ACL when creating a bucket, Amazon S3 ignores it.
  bucket_owner_full_control,

  /// The LogDelivery group gets WRITE and READ_ACP permissions on the bucket. For more information about logs
  log_delivery_write,
}

String aclToString(ACL acl) {
  switch (acl) {
    case ACL.private:
      return 'private';
    case ACL.public_read:
      return 'public-read';
    case ACL.public_read_write:
      return 'public-read-write';
    case ACL.aws_exec_read:
      return 'aws-exec-read';
    case ACL.authenticated_read:
      return 'authenticated-read';
    case ACL.bucket_owner_read:
      return 'bucket-owner-read';
    case ACL.bucket_owner_full_control:
      return 'bucket-owner-full-control';
    case ACL.log_delivery_write:
      return 'log-delivery-write';
  }
}

class Policy {
  String expiration;
  String region;
  ACL acl;
  String bucket;
  String key;
  String credential;
  String datetime;
  int maxFileSize;

  Policy(this.key, this.bucket, this.datetime, this.expiration, this.credential,
      this.maxFileSize, this.acl,
      {this.region = 'us-east-1'});

  factory Policy.fromS3PresignedPost(String key, String bucket,
      String accessKeyId, int expiryMinutes, int maxFileSize, ACL acl,
      {String region = 'us-east-1'}) {
    final datetime = SigV4.generateDatetime();
    final expiration = (DateTime.now())
        .add(Duration(minutes: expiryMinutes))
        .toUtc()
        .toString()
        .split(' ')
        .join('T');
    final cred =
        '$accessKeyId/${SigV4.buildCredentialScope(datetime, region, 's3')}';

    return Policy(key, bucket, datetime, expiration, cred, maxFileSize, acl,
        region: region);
  }

  String encode() {
    final bytes = utf8.encode(toString());
    return base64.encode(bytes);
  }

  @override
  String toString() {
    return '''
{ "expiration": "${this.expiration}",
  "conditions": [
    {"bucket": "${this.bucket}"},
    ["starts-with", "\$key", "${this.key}"],
    {"acl": "${aclToString(acl)}"},
    ["content-length-range", 1, ${this.maxFileSize}],
    {"x-amz-credential": "${this.credential}"},
    {"x-amz-algorithm": "AWS4-HMAC-SHA256"},
    {"x-amz-date": "${this.datetime}" }
  ]
}
''';
  }
}

/// Convenience class for uploading files to AWS S3
class AwsS3 {
  /// Upload a file, returning the file's public URL on success.
  static Future<String?> uploadFile({
    /// AWS access key
    required String accessKey,

    /// AWS secret key
    required String secretKey,

    /// The name of the S3 storage bucket to upload  to
    required String bucket,

    /// The file to upload
    required File file,

    /// The key to save this file as. Will override destDir and filename if set.
    String? key,

    /// The path to upload the file to (e.g. "uploads/public"). Defaults to the root "directory"
    String destDir = '',

    /// The AWS region. Must be formatted correctly, e.g. us-west-1
    String region = 'us-east-1',

    /// Access control list enables you to manage access to bucket and objects
    /// For more information visit [https://docs.aws.amazon.com/AmazonS3/latest/userguide/acl-overview.html]
    ACL acl = ACL.public_read,

    /// The filename to upload as. If null, defaults to the given file's current filename.
    String? filename,
  }) async {
    final endpoint = 'https://s3.wasabisys.com';
    final uploadKey = key ?? '$destDir/${filename ?? path.basename(file.path)}';

    final stream = http.ByteStream(Stream.castFrom(file.openRead()));
    final length = await file.length();

    final uri = Uri.parse(endpoint);
    final req = http.MultipartRequest("POST", uri);
    final multipartFile = http.MultipartFile('file', stream, length,
        filename: path.basename(file.path));

    final policy = Policy.fromS3PresignedPost(
        uploadKey, bucket, accessKey, 15, length, acl,
        region: region);
    final signingKey =
        SigV4.calculateSigningKey(secretKey, policy.datetime, region, 's3');
    final signature = SigV4.calculateSignature(signingKey, policy.encode());

    req.files.add(multipartFile);
    req.fields['key'] = policy.key;
    req.fields['acl'] = aclToString(acl);
    req.fields['X-Amz-Credential'] = policy.credential;
    req.fields['X-Amz-Algorithm'] = 'AWS4-HMAC-SHA256';
    req.fields['X-Amz-Date'] = policy.datetime;
    req.fields['Policy'] = policy.encode();
    req.fields['X-Amz-Signature'] = signature;

    try {
      final res = await req.send();

      if (res.statusCode == 204) return '$endpoint/$uploadKey';
    } catch (e) {
      print('Failed to upload to AWS, with exception:');
      print(e);
      return null;
    }
  }
}
