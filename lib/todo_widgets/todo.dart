import 'package:flutter/material.dart';

enum Priority{

  urgent(
      color:Colors.red,
      icon:Icons.priority_high_rounded,
      title:'urgent'
  ),
  high(
      color:Colors.orange,
      icon:Icons.warning_amber_rounded,
      title:'high'
  ),
  medium(
      color:Colors.yellow,
      icon:Icons.change_circle_rounded,
      title:'medium'
  ),
  low(
      color:Colors.green,
      icon:Icons.low_priority_rounded,
      title:'low'
  );

  const Priority({required this.color,required this.icon,required this.title});

  final Color color;
  final IconData icon;
  final String title;

}


class Todo{

  const Todo({required this.title,required this.description,required this.priority});

  final String title;
  final String description;
  final Priority priority;

}