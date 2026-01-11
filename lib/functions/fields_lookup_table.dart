/// Hash table search to quickly find info related to a particular section of
/// the backend analysis
dynamic fieldsLookupTable(String key) {
  const table = {
    "ball_eye_distance": {"unit": "px"},
    "elbow_angle": {
      "unit": "°",
      "range": {"min": 30, "max": 180}
    },
    "shoulder_angle": {
      "unit": "°",
      "range": {"min": 0, "max": 180}
    },
    "phase": {"unit": ""},
    "forward_distance": {"unit": "px"},
    "side_distance": {"unit": "px"},
    "vertical": {"unit": "px"},
    "horizontal": {"unit": "px"},
    "left_direction": {
      "unit": "°",
      "range": {"min": -90, "max": 90}
    },
    "right_direction": {
      "unit": "°",
      "range": {"min": -90, "max": 90}
    },
    "left_angle": {
      "unit": "°",
      "range": {"min": 0, "max": 180}
    },
    "right_angle": {
      "unit": "°",
      "range": {"min": 0, "max": 180}
    },
    "average_wrist_angle": {
      "unit": "°",
      "range": {"min": 0, "max": 180}
    },
    "average_deviation": {
      "unit": "°",
      "range": {"min": 0, "max": 30}
    },
    "max_deviation": {
      "unit": "°",
      "range": {"min": 0, "max": 45}
    },
    "deviation_ratio": {"unit": ""},
    "efficiency": {
      "unit": "%",
      "range": {"min": 0, "max": 100}
    },
    "angle_variance": {
      "unit": "°²",
      "range": {"min": 0, "max": 100}
    },
    "held": {"unit": ""},
    "frames_held": {"unit": "frames"},
    "final_elbow_angle": {
      "unit": "°",
      "range": {"min": 30, "max": 180}
    },
    "average_wrist_velocity": {"unit": "px/s"},
    "average_finger_velocity": {"unit": "px/s"}
  };

  return table.containsKey(key) ? table[key] : null;
}
