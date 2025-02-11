import 'package:flutter/material.dart';

class Movie {
  final String title;
  final String director;
  final String posterUrl;
  final String synopsis;
  final String producer;
  final String writers;
  final String cast;

  Movie(
      {required this.title,
      required this.director,
      required this.posterUrl,
      required this.synopsis,
      required this.producer,
      required this.writers,
      required this.cast});
}

final List<Movie> nowPlayingMovies = [
  Movie(
      title: 'AVENGERS',
      director: 'Joss Whedon',
      posterUrl: 'images/img_poster/avengers.jpg',
      synopsis:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      producer: 'Josh Whedon',
      writers: 'Josh Whedon, Zak Penn',
      cast:
          'Robert Downey Jr., Chris Evans, Scarlett Johansson, Jeremy Renner, Mark Ruffalo, Chris Hemsworth, Tom Hiddleston'),
  Movie(
      title: 'AVENGERS: INFINITY WAR',
      director: 'Anthony & Joe Russo',
      posterUrl: 'images/img_poster/infinity_war.jpg',
      synopsis:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      producer: 'Josh Whedon',
      writers: 'Josh Whedon, Zak Penn',
      cast:
          'Robert Downey Jr., Chris Evans, Scarlett Johansson, Jeremy Renner, Mark Ruffalo, Chris Hemsworth, Tom Hiddleston'),
];

final List<Movie> comingSoonMovies = [
  Movie(
      title: 'AVENGERS: ENDGAME',
      director: 'Anthony & Joe Russo',
      posterUrl: 'images/img_poster/endgame.jpg',
      synopsis:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      producer: 'Josh Whedon',
      writers: 'Josh Whedon, Zak Penn',
      cast:
          'Robert Downey Jr., Chris Evans, Scarlett Johansson, Jeremy Renner, Mark Ruffalo, Chris Hemsworth, Tom Hiddleston'),
  Movie(
      title: 'AVENGERS: AGE OF ULTRON',
      director: 'Joss Whedon',
      posterUrl: 'images/img_poster/age_of_ultron.jpg',
      synopsis:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      producer: 'Josh Whedon',
      writers: 'Josh Whedon, Zak Penn',
      cast:
          'Robert Downey Jr., Chris Evans, Scarlett Johansson, Jeremy Renner, Mark Ruffalo, Chris Hemsworth, Tom Hiddleston'),
];
