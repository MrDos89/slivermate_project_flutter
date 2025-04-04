import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/vo/announceVo.dart';

class AnnouncementListPage extends StatefulWidget {
  final List<AnnounceVo> announcements;

  const AnnouncementListPage({super.key, required this.announcements});

  @override
  State<AnnouncementListPage> createState() => _AnnouncementListPageState();
}

class _AnnouncementListPageState extends State<AnnouncementListPage> {
  int? expandedIndex;

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: const HeaderPage(
          pageTitle: "공지사항",
          showBackButton: true,
        ),
        body: ListView.builder(
          itemCount: widget.announcements.length,
          itemBuilder: (context, index) {
            final notice = widget.announcements[index];
            final isExpanded = expandedIndex == index;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    notice.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("${notice.date} • ${notice.time}"),
                  trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                  onTap: () {
                    setState(() {
                      expandedIndex = isExpanded ? null : index;
                    });
                  },
                ),
                if (isExpanded)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("장소: ${notice.location}"),
                        const SizedBox(height: 4),
                        Text("내용: ${notice.description}"),
                      ],
                    ),
                  ),
                const Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}