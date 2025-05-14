import 'package:flutter/material.dart';
import 'package:tabler_icons/tabler_icons.dart';

PreferredSize getAppBar(BuildContext context) {
  final tab = 'All';
  return PreferredSize(
    preferredSize: const Size.fromHeight(148),
    child: SafeArea(
      maintainBottomViewPadding: true,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  const Icon(
                    TablerIcons.menu_2,
                    size: 28,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(top: 12),
                          hintText: 'Search...',
                          border: InputBorder.none,
                          suffixIcon: InkWell(
                            onTap: () => FocusScope.of(context).unfocus(),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: 6,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, index) {
                  final labels = [
                    'All',
                    'Beauty & Fashion',
                    'Football',
                    'Cricket',
                    'News',
                    'Politics',
                  ];
                  return FilterChip(
                    label: Text(
                      labels[index],
                      style: TextStyle(fontWeight: FontWeight.w600, color: tab == labels[index] ? Colors.white : Colors.black54),
                    ),
                    selected: index == 0,
                    showCheckmark: false,
                    backgroundColor: Colors.grey.shade100,
                    selectedColor: Colors.lightBlue,
                    onSelected: (_) {},
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
