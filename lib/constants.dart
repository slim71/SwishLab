import 'dart:core';

import 'package:flutter/material.dart';

import 'styles/theme_manager.dart';

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

List<Color> get kMyColors => [
      AppThemeManager.currentColors.primaryOne,
      AppThemeManager.currentColors.primaryTwo,
      AppThemeManager.currentColors.alternateOne,
      AppThemeManager.currentColors.alternateTwo,
      AppThemeManager.currentColors.retroOne,
      AppThemeManager.currentColors.retroTwo,
      if (AppThemeManager.currentColors.primaryThree != null) AppThemeManager.currentColors.primaryThree!,
      if (AppThemeManager.currentColors.alternateThree != null) AppThemeManager.currentColors.alternateThree!,
      if (AppThemeManager.currentColors.retroThree != null) AppThemeManager.currentColors.retroThree!,
    ];

List<Color> get settingsItemBackgrounds => [
      AppThemeManager.currentColors.alternateTwo,
      AppThemeManager.currentColors.primaryOne,
      AppThemeManager.currentColors.retroThree ?? AppThemeManager.currentColors.retroOne,
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

const String kDefaultFeedbackJson = '''
[
  {
    "section": "Set point",
    "scores": [
      {
        "name": "Ball eye distance",
        "ranges": [
          { "min": 0.0, "max": 0.375, "feedback": "The ball is too close to your face, blocking your vision. Try to create more space." },
          { "min": 0.375, "max": 0.625, "feedback": "Fair spacing, but the ball still partially obstructs your view. Push it slightly forward." },
          { "min": 0.625, "max": 0.875, "feedback": "Good distance. You have a clear sightline to the rim." },
          { "min": 0.875, "max": 1.0, "feedback": "Perfect spacing between the ball and your eyes for maximum visibility." }
        ]
      },
      {
        "name": "Elbow angle",
        "ranges": [
          { "min": 0.0, "max": 0.375, "feedback": "Your elbow angle is too tight. Work on creating that 90-degree 'L' shape." },
          { "min": 0.375, "max": 0.625, "feedback": "Fair angle, but try to keep it more consistent for better power transfer." },
          { "min": 0.625, "max": 0.875, "feedback": "Good elbow angle. You've created a strong leverage point." },
          { "min": 0.875, "max": 1.0, "feedback": "Perfect elbow angle. You're in a powerful and stable shooting position." }
        ]
      },
      {
        "name": "Shoulder angle",
        "ranges": [
          { "min": 0.0, "max": 0.375, "feedback": "Your shoulder is misaligned. Keep it relaxed and square to your target." },
          { "min": 0.375, "max": 0.625, "feedback": "Fair shoulder position, but ensure it doesn't rotate too much during the shot." },
          { "min": 0.625, "max": 0.875, "feedback": "Good shoulder alignment. Your upper body is stable." },
          { "min": 0.875, "max": 1.0, "feedback": "Excellent shoulder positioning. Perfectly aligned with your shooting line." }
        ]
      }
    ]
  },
  {
    "section": "Jump",
    "scores": [
      {
        "name": "Phase",
        "ranges": [
          { "min": 0.0, "max": 0.375, "feedback": "Your jump timing is off. Work on synchronizing your release with your lift." },
          { "min": 0.375, "max": 0.625, "feedback": "Fair timing. Try to release the ball closer to the peak of your jump." },
          { "min": 0.625, "max": 0.875, "feedback": "Good jump phase. You're utilizing your leg power well." },
          { "min": 0.875, "max": 1.0, "feedback": "Perfect timing! Releasing at the exact peak of your jump for maximum range." }
        ]
      },
      {
        "name": "Forward distance",
        "ranges": [
          { "min": 0.0, "max": 0.375, "feedback": "You're drifting too far forward. Aim for a more vertical jump." },
          { "min": 0.375, "max": 0.625, "feedback": "Fair verticality, but there's still significant forward drift. Tighten your lift." },
          { "min": 0.625, "max": 0.875, "feedback": "Good verticality. Minimal forward drift detected." },
          { "min": 0.875, "max": 1.0, "feedback": "Outstanding vertical jump. Perfectly balanced landing." }
        ]
      },
      {
        "name": "Side distance",
        "ranges": [
          { "min": 0.0, "max": 0.375, "feedback": "You're drifting sideways. Focus on landing in a straight line." },
          { "min": 0.375, "max": 0.625, "feedback": "Fair side control. Ensure your body weight is centered when you jump." },
          { "min": 0.625, "max": 0.875, "feedback": "Good lateral stability. You're staying aligned with the rim." },
          { "min": 0.875, "max": 1.0, "feedback": "Perfect lateral balance. Zero sideways drift during the shot." }
        ]
      },
      {
        "name": "Overall distance",
        "ranges": [
          { "min": 0.0, "max": 0.375, "feedback": "Too much movement during your jump. Focus on a vertical 'elevator' lift." },
          { "min": 0.375, "max": 0.625, "feedback": "Fair landing zone. Try to minimize your total displacement." },
          { "min": 0.625, "max": 0.875, "feedback": "Good body control. Your landing is consistent and stable." },
          { "min": 0.875, "max": 1.0, "feedback": "Flawless jump mechanics. Perfectly vertical displacement." }
        ]
      }
    ]
  },
  {
    "section": "Elbow position",
    "scores": [
      {
        "name": "Vertical",
        "ranges": [
          { "min": 0.0, "max": 0.375, "feedback": "Your elbow is too low at release. Lift it to give your shot a better arc." },
          { "min": 0.375, "max": 0.625, "feedback": "Fair vertical positioning. Aim for a slightly higher release point." },
          { "min": 0.625, "max": 0.875, "feedback": "Good elbow height. This creates a soft landing arc for the ball." },
          { "min": 0.875, "max": 1.0, "feedback": "Perfect vertical alignment. Ideal height for a professional arc." }
        ]
      },
      {
        "name": "Horizontal",
        "ranges": [
          { "min": 0.0, "max": 0.375, "feedback": "Your elbow is flaring out significantly. Tuck it in for a straighter path." },
          { "min": 0.375, "max": 0.625, "feedback": "Fair horizontal position. Keep working on pointing your elbow at the rim." },
          { "min": 0.625, "max": 0.875, "feedback": "Good elbow tuck. Your arm is well-aligned with your target." },
          { "min": 0.875, "max": 1.0, "feedback": "Perfect horizontal alignment. Your arm is a straight arrow to the basket." }
        ]
      }
    ]
  },
  {
    "section": "Feet direction",
    "scores": [
      {
        "name": "Left foot",
        "ranges": [
          { "min": 0.0, "max": 0.375, "feedback": "Your left foot is pointing away from the target. Square it up for stability." },
          { "min": 0.375, "max": 0.625, "feedback": "Fair left foot position. Ensure it's pointing consistently at your target." },
          { "min": 0.625, "max": 0.875, "feedback": "Good left foot alignment. Solid anchor for your shooting base." },
          { "min": 0.875, "max": 1.0, "feedback": "Perfect left foot direction. Provides a stable foundation." }
        ]
      },
      {
        "name": "Right foot",
        "ranges": [
          { "min": 0.0, "max": 0.375, "feedback": "Your right foot is misaligned. Point your toes toward the rim." },
          { "min": 0.375, "max": 0.625, "feedback": "Fair right foot direction. Small adjustments will improve your balance." },
          { "min": 0.625, "max": 0.875, "feedback": "Good right foot alignment. Guides your entire shooting motion." },
          { "min": 0.875, "max": 1.0, "feedback": "Perfect right foot position. Ideal for a straight shooting line." }
        ]
      }
    ]
  },
  {
    "section": "Shot path",
    "scores": [
      {
        "name": "Average deviation",
        "ranges": [
          { "min": 0.0, "max": 0.375, "feedback": "Your shot path is very erratic. Focus on a linear motion." },
          { "min": 0.375, "max": 0.625, "feedback": "Fair path consistency. Try to minimize any lateral ball movement." },
          { "min": 0.625, "max": 0.875, "feedback": "Good linear motion. The ball path is relatively straight." },
          { "min": 0.875, "max": 1.0, "feedback": "Masterful path control. Perfectly straight from set point to release." }
        ]
      },
      {
        "name": "Efficiency",
        "ranges": [
          { "min": 0.0, "max": 0.375, "feedback": "There is a lot of wasted energy in your shot. Simplify your motion." },
          { "min": 0.375, "max": 0.625, "feedback": "Fair efficiency. Work on a smoother transition to release." },
          { "min": 0.625, "max": 0.875, "feedback": "Good energy transfer. Your shot feels fluid and controlled." },
          { "min": 0.875, "max": 1.0, "feedback": "Perfect efficiency. Maximum power with minimum effort." }
        ]
      },
      {
        "name": "Angle variance",
        "ranges": [
          { "min": 0.0, "max": 0.375, "feedback": "Your release angle is very inconsistent. Stick to one arc." },
          { "min": 0.375, "max": 0.625, "feedback": "Fair angle control. Aim for a more repeatable release." },
          { "min": 0.625, "max": 0.875, "feedback": "Good arc consistency. You're hitting your spots well." },
          { "min": 0.875, "max": 1.0, "feedback": "Flawless angle repeatability. Your arc is identical every time." }
        ]
      }
    ]
  },
  {
    "section": "Follow through",
    "scores": [
      {
        "name": "Duration",
        "ranges": [
          { "min": 0.0, "max": 0.375, "feedback": "You're dropping your arm immediately. Hold it 'in the cookie jar'." },
          { "min": 0.375, "max": 0.625, "feedback": "Fair follow-through duration. Hold it until the ball hits the rim." },
          { "min": 0.625, "max": 0.875, "feedback": "Good discipline. You're holding your release well." },
          { "min": 0.875, "max": 1.0, "feedback": "Perfect follow-through. Held for the ideal amount of time." }
        ]
      },
      {
        "name": "Elbow extension",
        "ranges": [
          { "min": 0.0, "max": 0.375, "feedback": "Your arm is short-circuiting. Fully lock your elbow at the top." },
          { "min": 0.375, "max": 0.625, "feedback": "Fair extension. Work on reaching higher toward the ceiling." },
          { "min": 0.625, "max": 0.875, "feedback": "Good arm extension. You're getting solid height on your shot." },
          { "min": 0.875, "max": 1.0, "feedback": "Masterful extension. Perfectly locked elbow at release." }
        ]
      },
      {
        "name": "Wrist angle",
        "ranges": [
          { "min": 0.0, "max": 0.375, "feedback": "Your wrist flick is weak. Snap it down for better rotation." },
          { "min": 0.375, "max": 0.625, "feedback": "Fair wrist snap. Relax your hand more after release." },
          { "min": 0.625, "max": 0.875, "feedback": "Good snap. The ball has a healthy amount of backspin." },
          { "min": 0.875, "max": 1.0, "feedback": "Perfect wrist action. Clean, soft rotation on every shot." }
        ]
      },
      {
        "name": "Hand steadiness",
        "ranges": [
          { "min": 0.0, "max": 0.375, "feedback": "Your hand is shaking after release. Keep it rock solid." },
          { "min": 0.375, "max": 0.625, "feedback": "Fair hand control. Avoid any extra movement after the ball leaves." },
          { "min": 0.625, "max": 0.875, "feedback": "Good hand steadiness. Your release is calm and controlled." },
          { "min": 0.875, "max": 1.0, "feedback": "Imperceptible movement. A perfectly steady follow-through." }
        ]
      },
      {
        "name": "Jump",
        "ranges": [
          { "min": 0.0, "max": 0.375, "feedback": "Stick your landing! Your balance after the shot is crucial." },
          { "min": 0.375, "max": 0.625, "feedback": "Fair post-shot balance. Try to land and stay set." },
          { "min": 0.625, "max": 0.875, "feedback": "Good landing. You're ready for the rebound or next play." },
          { "min": 0.875, "max": 1.0, "feedback": "Perfect balance. You're landing like a pro every time." }
        ]
      }
    ]
  }
]
''';

const passwordMinSize = 8;

const String hfSpace = "https://slim71-shootingformanalyzer.hf.space";
//const String hfSpace = "https://d46dcadeb557551be0.gradio.live";
const String supabaseDomain = "https://ccqvtpiltowjpogbjmpd.supabase.co";
