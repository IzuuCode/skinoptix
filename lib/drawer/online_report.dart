import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OnlineReportScreen extends StatelessWidget {
  const OnlineReportScreen({super.key});

  // Helper method to safely launch a PDF URL
  Future<void> _launchPDF(String url, BuildContext context) async {
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("PDF URL is missing.")),
      );
      return;
    }

    try {
      final Uri uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not launch the PDF URL.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to launch PDF: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Online Report"),
        backgroundColor: Colors.lightBlue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('reports').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading reports'));
          }

          final reports = snapshot.data?.docs ?? [];
          if (reports.isEmpty) {
            return const Center(child: Text("No reports available."));
          }

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final data = reports[index].data() as Map<String, dynamic>?;

              if (data == null || !data.containsKey('url')) {
                return const SizedBox.shrink();
              }

              final String title = data['title'] ?? 'Untitled Report';
              final String url = data['url'] ?? '';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(title),
                  trailing: IconButton(
                    icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                    onPressed: () => _launchPDF(url, context),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
