import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';


class FaceMatcher {
  late Interpreter interpreter;

  // Load the model from assets to a writable directory
  Future<void> loadModel() async {
    Directory appDir = await getApplicationDocumentsDirectory();
 //    String modelPath = '${appDir.path}/facenet.tflite';
 //
 // //   ByteData data = await rootBundle.load('assets/facenet.tflite');
 //  //  List<int> bytes = data.buffer.asUint8List();
 //    File modelFile = File(modelPath);
 //    await modelFile.writeAsBytes(bytes);

  //  interpreter = await Interpreter.fromFile(modelFile);
  }

  // Custom helper functions to get color channels
  int getRed(int color) => (color >> 16) & 0xFF;
  int getGreen(int color) => (color >> 8) & 0xFF;
  int getBlue(int color) => color & 0xFF;
  int getAlpha(int color) => (color >> 24) & 0xFF;

  // Preprocess image to 160x160 and normalize to -1 to 1
  img.Image preprocessImage(img.Image image) {
    final resizedImage = img.copyResize(image, width: 160, height: 160);

    for (int y = 0; y < resizedImage.height; y++) {
      for (int x = 0; x < resizedImage.width; x++) {
        final pixel = resizedImage.getPixel(x, y); // Pixel object
        double r = (pixel.r - 127.5) / 128.0;
        double g = (pixel.g - 127.5) / 128.0;
        double b = (pixel.b - 127.5) / 128.0;
        resizedImage.setPixelRgba(x, y, (r * 255).toInt(), (g * 255).toInt(), (b * 255).toInt(), pixel.a);
      }
    }
    return resizedImage;
  }

  // Extract face embeddings from the image
  List<double> getFaceEmbedding(img.Image image) {
    final processedImage = preprocessImage(image);

    var input = List<List<List<List<double>>>>.filled(1,
        List<List<List<double>>>.filled(160,
            List<List<double>>.filled(160,
                List<double>.filled(3, 0.0))));

    for (int y = 0; y < processedImage.height; y++) {
      for (int x = 0; x < processedImage.width; x++) {
        final pixel = processedImage.getPixel(x, y);
        input[0][y][x][0] = (pixel.r - 127.5) / 128.0;
        input[0][y][x][1] = (pixel.g - 127.5) / 128.0;
        input[0][y][x][2] = (pixel.b - 127.5) / 128.0;
      }
    }

    final output = List<double>.filled(128, 0.0).reshape([1, 128]);
    interpreter.run(input, output);

    return output[0];
  }
  // Calculate cosine similarity between two embeddings
  double calculateCosineSimilarity(List<double> emb1, List<double> emb2) {
    double dotProduct = 0.0;
    double magnitude1 = 0.0;
    double magnitude2 = 0.0;

    for (int i = 0; i < emb1.length; i++) {
      dotProduct += emb1[i] * emb2[i];
      magnitude1 += emb1[i] * emb1[i];
      magnitude2 += emb2[i] * emb2[i];
    }

    magnitude1 = sqrt(magnitude1);
    magnitude2 = sqrt(magnitude2);

    return dotProduct / (magnitude1 * magnitude2);
  }

  // Convert cosine similarity to a percentage
  double similarityToPercentage(double similarity) {
    return max(0, min(((similarity + 1) / 2) * 100, 100)); // Bound between 0 and 100
  }

  // Match two face images and return the matching percentage
  double matchFaces(Uint8List img1, Uint8List img2) {
    final image1 = img.decodeImage(img1)!;
    final image2 = img.decodeImage(img2)!;

    final emb1 = getFaceEmbedding(image1);
    final emb2 = getFaceEmbedding(image2);

    final similarity = calculateCosineSimilarity(emb1, emb2);
    final percentage = similarityToPercentage(similarity);

    return percentage;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final faceMatcher = FaceMatcher();
  await faceMatcher.loadModel();

  runApp(MyApp(faceMatcher: faceMatcher));
}

class MyApp extends StatelessWidget {
  final FaceMatcher faceMatcher;

  MyApp({required this.faceMatcher});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face Matcher',
      home: FaceMatcherScreen(faceMatcher: faceMatcher),
    );
  }
}

class FaceMatcherScreen extends StatefulWidget {
  final FaceMatcher faceMatcher;

  FaceMatcherScreen({required this.faceMatcher});

  @override
  _FaceMatcherScreenState createState() => _FaceMatcherScreenState();
}

class _FaceMatcherScreenState extends State<FaceMatcherScreen> {
  double _similarityPercentage = 0.0;

  Future<void> _loadImagesAndMatch() async {
    final ImagePicker picker = ImagePicker();

    // Pick the first image
    final XFile? pickedFile1 = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile1 == null) {
      // Handle if no image was selected
      return;
    }
    Uint8List img1 = await pickedFile1.readAsBytes();

    // Pick the second image
    final XFile? pickedFile2 = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile2 == null) {
      // Handle if no image was selected
      return;
    }
    Uint8List img2 = await pickedFile2.readAsBytes();

    // Match faces
    double similarity = widget.faceMatcher.matchFaces(img1, img2);
    setState(() {
      _similarityPercentage = similarity;
    });
  }

  Future<Uint8List> _loadImage(String path) async {
    return await rootBundle.load(path).then((data) => data.buffer.asUint8List());
  }

  @override
  void initState() {
    super.initState();
    _loadImagesAndMatch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Matcher App'),
      ),
      body: Center(
        child: Text('Similarity Percentage: ${_similarityPercentage.toStringAsFixed(2)}%'),
      ),
    );
  }
}
