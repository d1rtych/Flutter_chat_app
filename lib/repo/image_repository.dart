import 'dart:convert';
import 'dart:io';

import 'package:flutter_learn/models/image_model.dart';
import 'package:http/http.dart' as http;

class ImageRepository {
  Future<List<PixelfordImage>> getNetworkImages() async {
    try {
      var endpointUrl = Uri.parse('https://pixelford.com/api2/images');

      final response = await http.get(endpointUrl);

      if (response.statusCode == 200) {
        final List<dynamic> decodedList = jsonDecode(response.body);
        final List<PixelfordImage> _imageList = decodedList.map((listItem) {
          return PixelfordImage.fromJson(listItem);
        }).toList();

        return _imageList;
      } else {
        throw Exception('API not successful');
      }
    } on SocketException {
      throw Exception('No internet connection :(');
    } on HttpException {
      throw Exception('Could not retrieve th images');
    } on FormatException {
      throw Exception('Bad response format');
    } catch (error) {
      throw Exception('Unknown error');
    }
  }
}
