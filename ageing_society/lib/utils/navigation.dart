import 'package:flutter/material.dart';

void push(BuildContext context, Widget page) => Navigator.push(context, MaterialPageRoute(builder: (_) => page));
void pushReplacement(BuildContext context, Widget page) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
