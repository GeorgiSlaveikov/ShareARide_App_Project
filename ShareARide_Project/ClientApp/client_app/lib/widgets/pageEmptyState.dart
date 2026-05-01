import 'package:flutter/material.dart';

Widget pageEmptyState(iconProp, colorProp, titleProp, titleColorProp) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            // Icons.checklist_rtl_rounded,
            iconProp,
            size: 80,
            // color: Colors.grey.shade300,
            color: colorProp,
          ),
          const SizedBox(height: 16),
          Text(
            // "No pending requests",
            titleProp,
            style: TextStyle(
              fontSize: 18, 
              // color: Colors.grey
              color: titleColorProp
            ),
          ),
        ],
      ),
    );
  }