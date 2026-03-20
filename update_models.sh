#!/bin/bash
# A quick way to append latitude and longitude to models

for file in lib/models/events.dart lib/models/support.dart lib/models/resources.dart; do
  # Add fields
  sed -i '' '/final String youtube;/a\
  final double latitude;\
  final double longitude;
' "$file"

  # Add to constructor
  sed -i '' '/required this.youtube,/a\
    this.latitude = 0.0,\
    this.longitude = 0.0,
' "$file"

  # Add to copyWith signature
  sed -i '' '/String? youtube,/a\
    double? latitude,\
    double? longitude,
' "$file"

  # Add to copyWith return
  sed -i '' '/youtube: youtube ?? this.youtube,/a\
      latitude: latitude ?? this.latitude,\
      longitude: longitude ?? this.longitude,
' "$file"

  # Add to toMap
  sed -i '' "/'youtube': youtube,/a\\
      'latitude': latitude,\\
      'longitude': longitude,
" "$file"

  # Add to fromMap
  sed -i '' "/youtube: map\['youtube'\] ?? '',/a\\
      latitude: map['latitude']?.toDouble() ?? 0.0,\\
      longitude: map['longitude']?.toDouble() ?? 0.0,
" "$file"

done
