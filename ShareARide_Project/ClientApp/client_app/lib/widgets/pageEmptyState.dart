import 'package:flutter/material.dart';

Widget pageEmptyState(iconProp, colorProp, titleProp, titleColorProp) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconProp,
            size: 80,
            color: colorProp,
          ),
          const SizedBox(height: 16),
          Text(
            titleProp,
            style: TextStyle(
              fontSize: 18, 
              color: titleColorProp
            ),
          ),
        ],
      ),
    );
  }