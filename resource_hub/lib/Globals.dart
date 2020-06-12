import 'dart:collection';

import 'package:flutter/material.dart';

var posts;
var postsLength;
var lastRefreshedTime;
HashSet bookmarkedPostids;
HashSet likedPosts;
var bookmarkedPosts;
var bookmarkedPostsLength;

var accentColor = Color(0xff42a5f5);

bool darkThemeEnabled = false;
