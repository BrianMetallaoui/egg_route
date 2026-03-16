import 'package:flutter/material.dart';

/// Describes a single action button revealed when swiping left on a card.
class SwipeAction {
  final IconData icon;
  final String label;
  final bool enabled;
  final Color color;
  final Color disabledColor;
  final VoidCallback onTap;

  const SwipeAction({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.color,
    required this.disabledColor,
    required this.onTap,
  });
}

/// A card wrapper that supports swipe gestures:
///
/// - **Swipe right** → delete (red background with trash icon, fires on release
///   past threshold).
/// - **Swipe left** → reveals tappable action buttons provided via [actions].
///
/// The [child] widget is what gets swiped.
class SwipeableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onDelete;
  final List<SwipeAction> actions;

  /// Width allocated per action button. Total revealed width = actions.length * actionButtonWidth.
  final double actionButtonWidth;

  const SwipeableCard({
    super.key,
    required this.child,
    this.onDelete,
    this.actions = const [],
    this.actionButtonWidth = 70,
  });

  @override
  State<SwipeableCard> createState() => _SwipeableCardState();
}

class _SwipeableCardState extends State<SwipeableCard>
    with SingleTickerProviderStateMixin {
  double _offset = 0;
  bool _dragging = false;

  static const double _deleteThreshold = 100;

  late final AnimationController _snapController;

  double get _actionWidth => widget.actions.length * widget.actionButtonWidth;

  @override
  void initState() {
    super.initState();
    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _snapController.dispose();
    super.dispose();
  }

  void _animateTo(double target) {
    final start = _offset;
    _snapController.reset();
    void listener() {
      setState(() {
        _offset = start + (target - start) * _snapController.value;
      });
    }

    _snapController.addListener(listener);
    _snapController.forward().then((_) {
      _snapController.removeListener(listener);
    });
  }

  void _onDragStart(DragStartDetails details) {
    _dragging = true;
    _snapController.stop();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (!_dragging) return;
    setState(() {
      _offset = (_offset + details.primaryDelta!).clamp(
        -_actionWidth,
        widget.onDelete != null ? _deleteThreshold + 40 : 0,
      );
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (!_dragging) return;
    _dragging = false;

    if (_offset > _deleteThreshold && widget.onDelete != null) {
      _animateTo(0);
      widget.onDelete!();
    } else if (_offset < -_actionWidth * 0.4) {
      _animateTo(-_actionWidth);
    } else {
      _animateTo(0);
    }
  }

  void _close() {
    _animateTo(0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deleteProgress = (_offset / _deleteThreshold).clamp(0.0, 1.0);
    final showDelete = _offset > 0;
    final showActions = _offset < 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Delete background (revealed on right swipe)
            if (showDelete)
              Positioned.fill(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 24),
                  color: Color.lerp(
                    theme.colorScheme.errorContainer,
                    theme.colorScheme.error,
                    deleteProgress,
                  ),
                  child: Icon(
                    Icons.delete,
                    color: Color.lerp(
                      theme.colorScheme.onErrorContainer,
                      theme.colorScheme.onError,
                      deleteProgress,
                    ),
                    size: 28,
                  ),
                ),
              ),

            // Action buttons (revealed on left swipe)
            if (showActions && widget.actions.isNotEmpty)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: _actionWidth,
                    child: Row(
                      children: widget.actions.map((action) {
                        return Expanded(
                          child: _SwipeActionButton(
                            action: action,
                            onClose: _close,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

            // The card itself
            Transform.translate(
              offset: Offset(_offset, 0),
              child: GestureDetector(
                onHorizontalDragStart: _onDragStart,
                onHorizontalDragUpdate: _onDragUpdate,
                onHorizontalDragEnd: _onDragEnd,
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwipeActionButton extends StatelessWidget {
  final SwipeAction action;
  final VoidCallback onClose;

  const _SwipeActionButton({required this.action, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final effectiveColor = action.enabled ? action.color : action.disabledColor;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.enabled
            ? () {
                action.onTap();
                onClose();
              }
            : null,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(action.icon, color: effectiveColor, size: 24),
              const SizedBox(height: 2),
              Text(
                action.enabled ? action.label : 'Done',
                style: TextStyle(
                  color: effectiveColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
