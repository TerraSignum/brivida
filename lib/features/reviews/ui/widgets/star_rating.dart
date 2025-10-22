import 'package:flutter/material.dart';

/// Star rating widget for review submission and display
class StarRating extends StatefulWidget {
  final int initialRating;
  final int maxStars;
  final bool readOnly;
  final double starSize;
  final Color activeColor;
  final Color inactiveColor;
  final ValueChanged<int>? onRatingChanged;

  const StarRating({
    super.key,
    this.initialRating = 0,
    this.maxStars = 5,
    this.readOnly = false,
    this.starSize = 32.0,
    this.activeColor = Colors.amber,
    this.inactiveColor = Colors.grey,
    this.onRatingChanged,
  });

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  late int _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  void didUpdateWidget(StarRating oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialRating != widget.initialRating) {
      _currentRating = widget.initialRating;
    }
  }

  void _updateRating(int rating) {
    if (widget.readOnly) return;

    setState(() {
      _currentRating = rating;
    });

    widget.onRatingChanged?.call(rating);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.maxStars, (index) {
        final starNumber = index + 1;
        final isActive = starNumber <= _currentRating;

        return GestureDetector(
          onTap: widget.readOnly ? null : () => _updateRating(starNumber),
          child: Container(
            padding: const EdgeInsets.all(4),
            child: Icon(
              isActive ? Icons.star : Icons.star_border,
              size: widget.starSize,
              color: isActive ? widget.activeColor : widget.inactiveColor,
            ),
          ),
        );
      }),
    );
  }
}

/// Compact star rating display for lists
class CompactStarRating extends StatelessWidget {
  final double rating;
  final int maxStars;
  final double starSize;
  final Color activeColor;
  final Color inactiveColor;
  final bool showValue;

  const CompactStarRating({
    super.key,
    required this.rating,
    this.maxStars = 5,
    this.starSize = 16.0,
    this.activeColor = Colors.amber,
    this.inactiveColor = Colors.grey,
    this.showValue = true,
  });

  @override
  Widget build(BuildContext context) {
    final fullStars = rating.floor();
    final hasHalfStar = (rating - fullStars) >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Full stars
        ...List.generate(
            fullStars,
            (index) => Icon(
                  Icons.star,
                  size: starSize,
                  color: activeColor,
                )),

        // Half star
        if (hasHalfStar)
          Icon(
            Icons.star_half,
            size: starSize,
            color: activeColor,
          ),

        // Empty stars
        ...List.generate(
          maxStars - fullStars - (hasHalfStar ? 1 : 0),
          (index) => Icon(
            Icons.star_border,
            size: starSize,
            color: inactiveColor,
          ),
        ),

        // Rating value
        if (showValue) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: starSize * 0.75,
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }
}

/// Rating breakdown widget showing distribution
class RatingBreakdown extends StatelessWidget {
  final Map<int, int> distribution;
  final int totalCount;
  final double maxBarWidth;

  const RatingBreakdown({
    super.key,
    required this.distribution,
    required this.totalCount,
    this.maxBarWidth = 200.0,
  });

  @override
  Widget build(BuildContext context) {
    if (totalCount == 0) {
      return const Text('Noch keine Bewertungen');
    }

    return Column(
      children: List.generate(5, (index) {
        final starRating = 5 - index; // 5, 4, 3, 2, 1
        final count = distribution[starRating] ?? 0;
        final percentage = count / totalCount;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              // Star number
              Text(
                '$starRating',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(width: 4),

              // Star icon
              Icon(
                Icons.star,
                size: 12,
                color: Colors.amber,
              ),
              const SizedBox(width: 8),

              // Progress bar
              Expanded(
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.grey[300],
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentage,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Count
              SizedBox(
                width: 30,
                child: Text(
                  '$count',
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
