import 'package:flutter/material.dart';

class SearchableDropdown<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T) displayItem;
  final T? selectedItem;
  final bool Function(String query, T item)? filterFunction;
  final Function(T?)? onChanged;
  final String hintText;
  final String? errorText;

  const SearchableDropdown({
    Key? key,
    required this.items,
    required this.displayItem,
    this.filterFunction,
    required this.hintText,
    required this.onChanged,
    this.selectedItem,
    this.errorText,
  }) : super(key: key);

  @override
  State<SearchableDropdown> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  TextEditingController _controller = TextEditingController();
  List<T> _filteredItems = [];
  bool _isDropdownOpen = false;
  T? selectedItem;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    selectedItem = widget.selectedItem;
    if (widget.selectedItem != null) {
      _controller.text = widget.displayItem(widget.selectedItem!);
    }
  }

  @override
  void didUpdateWidget(covariant SearchableDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedItem != oldWidget.selectedItem && selectedItem == null) {
      if (widget.selectedItem != null) {
        _controller.text = widget.displayItem(widget.selectedItem!);
      }
    }
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items.where((item) {
          if (widget.filterFunction != null) {
            return widget.filterFunction!(query, item);
          }
          return widget
              .displayItem(item)
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
      }
    });
    _overlayEntry?.markNeedsBuild(); // Update the overlay when filtering
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context)?.insert(_overlayEntry!);
    setState(() {
      _isDropdownOpen = true;
    });
  }

  void _closeDropdown() {
    if (selectedItem == null) {
      _controller.clear();
    } else {
      _controller.text = widget.displayItem(selectedItem!);
    }
    _overlayEntry?.remove();
    setState(() {
      _isDropdownOpen = false;
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    double screenHeight = MediaQuery.of(context).size.height;
    double availableHeightBelow = screenHeight - offset.dy - size.height;
    double availableHeightAbove = offset.dy;

    // Determine whether to open upwards or downwards
    bool openUpwards = availableHeightBelow < 200 &&
        availableHeightAbove > availableHeightBelow;

    return OverlayEntry(builder: (context) {
      return GestureDetector(
        behavior:
            HitTestBehavior.translucent, // Detect taps outside of the overlay
        onTap: () {
          _closeDropdown();
        },
        child: Stack(
          children: [
            Positioned(
              width: size.width,
              // Open upwards or downwards based on available space
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: openUpwards
                    ? Offset(
                        0.0, -220) // Open upwards (adjust height as needed)
                    : Offset(0.0, size.height), // Open downwards
                child: Material(
                  elevation: 4.0,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 200.0, // Limit dropdown height
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        T item = _filteredItems[index];
                        return ListTile(
                          title: Text(widget.displayItem(item)),
                          onTap: () {
                            selectedItem = item;
                            _controller.text = widget.displayItem(item);
                            widget.onChanged?.call(item);
                            _closeDropdown();
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        controller: _controller,
        onChanged: (value) {
          _filterItems(value);
        },
        onTap: () {
          _toggleDropdown();
        },
        decoration: InputDecoration(
          labelText: widget.hintText,
          errorText: widget.errorText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          suffixIcon: Icon(Icons.arrow_drop_down),
        ),
      ),
    );
  }
}
