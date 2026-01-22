import 'dart:core';

import 'package:flutter/material.dart';

const String kDefaultResultsJson = '''
{
  "analysis": {
    "set_point": {
      "ball_eye_distance": 1.23,
      "elbow_angle": 45,
      "shoulder_angle": 30,
      "scores": {
        "ball_eye_distance": 0.9,
        "elbow_angle": 0.85,
        "shoulder_angle": 0.95,
        "total": 0.9
      }
    },
    "jump": {
      "phase": 2,
      "forward_distance": 0.4,
      "side_distance": 0.1,
      "scores": {
        "phase": 1,
        "forward_distance": 0.8,
        "side_distance": 0.75,
        "overall_distance": 0.85,
        "total": 0.8
      }
    },
    "elbow_position": {
      "vertical": 1.1,
      "horizontal": 0.5,
      "scores": {
        "vertical": 0.9,
        "horizontal": 0.85,
        "total": 0.88
      }
    },
    "feet_direction": {
      "left_direction": 0,
      "right_direction": 0,
      "left_angle": 45,
      "right_angle": 50,
      "scores": {
        "left_foot": 0.8,
        "right_foot": 0.85,
        "total": 0.825
      }
    },
    "shot_path": {
      "average_deviation": 0.05,
      "max_deviation": 0.12,
      "deviation_ratio": 0.4,
      "efficiency": 0.95,
      "angle_variance": 0.02,
      "scores": {
        "average_deviation": 0.9,
        "efficiency": 0.95,
        "angle_variance": 0.88,
        "total": 0.91
      }
    },
    "follow_through": {
      "held": true,
      "frames_held": 12,
      "final_elbow_angle": 160,
      "average_wrist_angle": 45,
      "average_wrist_velocity": 0.3,
      "average_finger_velocity": 0.25,
      "scores": {
        "duration": 0.9,
        "elbow_extension": 0.85,
        "wrist_angle": 0.88,
        "hand_steadiness": 0.92,
        "jump": 0.87,
        "total": 0.884
      }
    }
  }
}
''';

const String kDefaultProfilePictureUrl =
    'https://ccqvtpiltowjpogbjmpd.supabase.co/storage/v1/object/public/profile_pictures/defaults/default_profile_male.png';

const String kFieldsLookupTableJson = '''
{
  "ball_eye_distance": { "unit": "px" },
  "elbow_angle": { "unit": "°", "range": { "min": 30, "max": 180 } },
  "shoulder_angle": { "unit": "°", "range": { "min": 0, "max": 180 } },
  "phase": { "unit": "" },
  "forward_distance": { "unit": "px" },
  "side_distance": { "unit": "px" },
  "vertical": { "unit": "px" },
  "horizontal": { "unit": "px" },
  "left_direction": { "unit": "°", "range": { "min": -90, "max": 90 } },
  "right_direction": { "unit": "°", "range": { "min": -90, "max": 90 } },
  "left_angle": { "unit": "°", "range": { "min": 0, "max": 180 } },
  "right_angle": { "unit": "°", "range": { "min": 0, "max": 180 } },
  "average_wrist_angle": { "unit": "°", "range": { "min": 0, "max": 180 } },
  "average_deviation": { "unit": "°", "range": { "min": 0, "max": 30 } },
  "max_deviation": { "unit": "°", "range": { "min": 0, "max": 45 } },
  "deviation_ratio": { "unit": "" },
  "efficiency": { "unit": "%", "range": { "min": 0, "max": 100 } },
  "angle_variance": { "unit": "°²", "range": { "min": 0, "max": 100 } },
  "held": { "unit": "" },
  "frames_held": { "unit": "frames" },
  "final_elbow_angle": { "unit": "°", "range": { "min": 30, "max": 180 } },
  "average_wrist_velocity": { "unit": "px/s" },
  "average_finger_velocity": { "unit": "px/s" }
}
''';

const List<Color> kMyColors = [
  Color(0xFF1F7A82),
  Color(0xFFFFCDD2),
  Color(0xFF3B6A6A),
  Color(0xFF8A9C94),
  Color(0xFF1E5F6C),
  Color(0xFF164A52),
  Color(0xFF6F8F88),
  Color(0xFFFFFFFF),
];

const String kDefaultFaqsJson = '''
[
  {
    "order": 1,
    "question": "My video won’t upload. What should I do?",
    "answer": "Check that your internet connection is stable. Weak or switching connections can interrupt uploads. If it still doesn’t work, close the app and try again."
  },
  {
    "order": 2,
    "question": "The app says 'Upload failed'. Why?",
    "answer": "This usually comes from a temporary connection drop or a large file. Try uploading again on a strong Wi-Fi connection. Make sure the video plays normally on your device."
  },
  {
    "order": 3,
    "question": "Processing takes too long. Is something wrong?",
    "answer": "Long or high-resolution videos naturally take more time. If processing goes beyond a few minutes, restart the app and try again with a shorter clip."
  }
]
''';

const passwordMinSize = 8;

const String hfSpace = "https://959857f59626f333d5.gradio.live";
const String supabaseDomain = "https://ccqvtpiltowjpogbjmpd.supabase.co";
