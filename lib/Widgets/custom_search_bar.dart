import 'package:flutter/material.dart';
import 'package:simulasi_ukk/models/model_warna.dart';

class CustomSearchBar extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmitted;

  const CustomSearchBar({
    Key? key,
    this.hintText = 'Cari...',
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: _focusNode,
      cursorColor: Warna().Ijo,
      style: TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: 'CircularStd',
      ),
      onChanged: widget.onChanged,
      onFieldSubmitted: (_) => widget.onSubmitted?.call(),
      decoration: InputDecoration(
        filled: true,
        fillColor: Warna().Putih,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Icon(
            Icons.search,
            color: _isFocused ? Warna().Ijo : Colors.grey,
            size: 20,
          ),
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: 'CircularStd',
        ),
        // Border saat TIDAK diklik (abu-abu)
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(300),
          borderSide: BorderSide(color: Colors.transparent, width: 1),
        ),
        // Border saat DIKLIK (hijau)
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(300),
          borderSide: BorderSide(color: Warna().Ijo, width: 2),
        ),
        // Padding di dalam field
        contentPadding: EdgeInsets.symmetric(horizontal: 17, vertical: 14),
      ),
    );
  }
}
