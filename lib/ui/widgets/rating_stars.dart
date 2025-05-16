import 'package:flutter/material.dart';

class RatingStars extends StatefulWidget {
  final int starCount;
  final int initialRating;
  final void Function(int) onRated;
  final double size;

  const RatingStars({
    Key? key,
    this.starCount = 5,
    this.initialRating = 0,
    required this.onRated,
    this.size = 32.0,
  }) : super(key: key);

  @override
  _RatingStarsState createState() => _RatingStarsState();
}

class _RatingStarsState extends State<RatingStars> {
  late int _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  void didUpdateWidget(covariant RatingStars oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialRating != oldWidget.initialRating) {
      setState(() {
        _currentRating = widget.initialRating;
      });
    }
  }

  Widget _buildStar(int index) {
    final icon = index < _currentRating
        ? Icon(
            Icons.star,
            color: Colors.yellow,
            size: widget.size,
          )
        : Icon(
            Icons.star_border,
            size: widget.size,
          );
    return IconButton(
      icon: icon,
      onPressed: () {
        setState(() {
          _currentRating = index + 1;
        });
        widget.onRated(_currentRating);
      },
      splashRadius: widget.size,
      padding: EdgeInsets.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.starCount,
        (index) => _buildStar(index),
      ),
    );
  }
}
