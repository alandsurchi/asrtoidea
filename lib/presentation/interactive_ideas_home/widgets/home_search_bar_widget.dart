import 'package:flutter/material.dart';
import '../../../theme/text_style_helper.dart';
import '../../../core/utils/size_utils.dart';

class HomeSearchBarWidget extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;

  const HomeSearchBarWidget({Key? key, this.onChanged, this.onFilterTap})
    : super(key: key);

  @override
  State<HomeSearchBarWidget> createState() => _HomeSearchBarWidgetState();
}

class _HomeSearchBarWidgetState extends State<HomeSearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _showSuggestions = false;
  final List<String> _suggestions = [
    'Mobile app idea',
    'Landing page concept',
    'SaaS product',
    'E-commerce platform',
    'AI-powered tool',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5FF),
            borderRadius: BorderRadius.circular(14.0),
            border: Border.all(color: const Color(0xFFEBEBFF)),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.h),
                child: const Icon(
                  Icons.search,
                  color: Color(0xFF9999BB),
                  size: 20,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: (v) {
                    widget.onChanged?.call(v);
                    setState(() => _showSuggestions = v.isNotEmpty);
                  },
                  onTap: () => setState(() => _showSuggestions = true),
                  decoration: InputDecoration(
                    hintText: 'Search ideas...',
                    hintStyle: TextStyleHelper.instance.body14RegularPoppins
                        .copyWith(color: const Color(0xFFBBBBCC)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 13.h),
                  ),
                  style: TextStyleHelper.instance.body14RegularPoppins.copyWith(
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
              ),
              GestureDetector(
                onTap: widget.onFilterTap,
                child: Container(
                  margin: EdgeInsets.all(6.h),
                  padding: EdgeInsets.all(8.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D00FF),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_showSuggestions && _controller.text.isNotEmpty)
          Container(
            margin: EdgeInsets.only(top: 4.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(20),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: _suggestions
                  .where(
                    (s) => s.toLowerCase().contains(
                      _controller.text.toLowerCase(),
                    ),
                  )
                  .take(3)
                  .map(
                    (s) => ListTile(
                      dense: true,
                      leading: const Icon(
                        Icons.history,
                        size: 16,
                        color: Color(0xFFBBBBBB),
                      ),
                      title: Text(
                        s,
                        style: TextStyleHelper.instance.body14RegularPoppins
                            .copyWith(color: const Color(0xFF333333)),
                      ),
                      onTap: () {
                        _controller.text = s;
                        widget.onChanged?.call(s);
                        setState(() => _showSuggestions = false);
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }
}
