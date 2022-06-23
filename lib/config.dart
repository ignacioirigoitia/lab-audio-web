// Stream config
import 'package:flutter/material.dart';

const streamKey = 'u9ggjkydk77c';

// const userGordon = DemoUser(
//   id: 'ignacioirigoitia',
//   name: 'Ignacio Irigoitia',
//   image:
//       'https://pbs.twimg.com/profile_images/1262058845192335360/Ys_-zu6W_400x400.jpg',
// );

const userSalvatore = DemoUser(
  id: 'ignaciofindholding',
  name: 'Ignacio diferentt',
  image:
      'https://pbs.twimg.com/profile_images/1252869649349238787/cKVPSIyG_400x400.jpg',
);

@immutable
class DemoUser {
  final String id;
  final String name;
  final String image;

  const DemoUser({
    required this.id,
    required this.name,
    required this.image,
  });
}