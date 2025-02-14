class DetailsImageResponse {
  int? id;
  List<Logos>? logos;

  DetailsImageResponse({this.id, this.logos});

  DetailsImageResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['logos'] != null) {
      logos = <Logos>[];
      json['logos'].forEach((v) {
        logos!.add(new Logos.fromJson(v));
      });
    }
  }

}

class Logos {
  double? aspectRatio;
  String? filePath;
  int? height;
  String? id;
  String? fileType;
  int? voteAverage;
  int? voteCount;
  int? width;

  Logos(
      {this.aspectRatio,
        this.filePath,
        this.height,
        this.id,
        this.fileType,
        this.voteAverage,
        this.voteCount,
        this.width});

  Logos.fromJson(Map<String, dynamic> json) {
    aspectRatio = json['aspect_ratio'];
    filePath = json['file_path'];
    height = json['height'];
    id = json['id'];
    fileType = json['file_type'];
    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
    width = json['width'];
  }

}