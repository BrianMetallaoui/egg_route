import 'package:flutter/material.dart';

/// A reusable searchable dropdown built on [RawAutocomplete].
///
/// Takes a list of items, displays a search field with a filtered dropdown,
/// and lets the user pick one item. Used for customer and product selection.
class SearchableDropdown<T extends Object> extends StatefulWidget {
  final List<T> items;
  final String Function(T item) labelBuilder;
  final String Function(T item)? subtitleBuilder;
  final T? selectedItem;
  final ValueChanged<T> onSelected;
  final VoidCallback? onCleared;
  final String hintText;
  final Widget? trailingAction;

  const SearchableDropdown({
    super.key,
    required this.items,
    required this.labelBuilder,
    this.subtitleBuilder,
    this.selectedItem,
    required this.onSelected,
    this.onCleared,
    this.hintText = 'Search...',
    this.trailingAction,
  });

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T extends Object>
    extends State<SearchableDropdown<T>> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  List<T> _currentOptions = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.selectedItem != null
          ? widget.labelBuilder(widget.selectedItem as T)
          : '',
    );
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(SearchableDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focusNode.hasFocus) {
      _syncText();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _syncText() {
    final label = widget.selectedItem != null
        ? widget.labelBuilder(widget.selectedItem as T)
        : '';
    if (_controller.text != label) {
      _controller.text = label;
    }
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _focusNode.hasFocus) {
          // Select all text so user can immediately type to replace
          _controller.selection = TextSelection(
            baseOffset: 0,
            extentOffset: _controller.text.length,
          );
          // Scroll to top of scrollable area for max dropdown room
          try {
            Scrollable.ensureVisible(
              context,
              alignment: 0.0,
              duration: const Duration(milliseconds: 200),
            );
          } catch (_) {}
        }
      });
    } else {
      // Restore selected item's label when losing focus
      _syncText();
    }
  }

  void _clear() {
    _controller.clear();
    _focusNode.unfocus();
    widget.onCleared?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final fieldWidth = constraints.maxWidth;
              return RawAutocomplete<T>(
                textEditingController: _controller,
                focusNode: _focusNode,
                optionsBuilder: (textEditingValue) {
                  final query = textEditingValue.text.toLowerCase().trim();
                  if (query.isEmpty) {
                    _currentOptions = widget.items;
                  } else {
                    _currentOptions = widget.items
                        .where(
                          (item) => widget
                              .labelBuilder(item)
                              .toLowerCase()
                              .contains(query),
                        )
                        .toList();
                  }
                  return _currentOptions;
                },
                displayStringForOption: widget.labelBuilder,
                onSelected: (item) {
                  widget.onSelected(item);
                  _focusNode.unfocus();
                },
                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: fieldWidth,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              final item = options.elementAt(index);
                              final label = widget.labelBuilder(item);
                              final subtitle = widget.subtitleBuilder?.call(
                                item,
                              );
                              return ListTile(
                                dense: true,
                                title: Text(label),
                                subtitle:
                                    subtitle != null && subtitle.isNotEmpty
                                    ? Text(subtitle)
                                    : null,
                                onTap: () => onSelected(item),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        onSubmitted: (_) {
                          if (_currentOptions.length == 1) {
                            final item = _currentOptions.first;
                            widget.onSelected(item);
                            _controller.text = widget.labelBuilder(item);
                            _focusNode.unfocus();
                          }
                        },
                        decoration: InputDecoration(
                          hintText: widget.hintText,
                          prefixIcon: const Icon(Icons.search),
                          border: const OutlineInputBorder(),
                          suffixIcon: controller.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: _clear,
                                )
                              : null,
                        ),
                      );
                    },
              );
            },
          ),
        ),
        if (widget.trailingAction != null) ...[
          const SizedBox(width: 8),
          widget.trailingAction!,
        ],
      ],
    );
  }
}
