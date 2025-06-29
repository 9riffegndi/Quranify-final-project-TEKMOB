import 'package:flutter/material.dart';
import 'juz_model.dart';
import 'juz_service.dart';

class JuzScreen extends StatefulWidget {
  const JuzScreen({super.key});

  @override
  State<JuzScreen> createState() => _JuzScreenState();
}

class _JuzScreenState extends State<JuzScreen> {
  late Future<List<Juz>> _juzList;

  @override
  void initState() {
    super.initState();
    _juzList = JuzService.fetchJuzList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Juz'),
        backgroundColor: const Color(0xFF219EBC),
      ),
      body: FutureBuilder<List<Juz>>(
        future: _juzList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Gagal: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Tidak ada data'));
          }

          final juzList = snapshot.data!;
          return ListView.builder(
            itemCount: juzList.length,
            itemBuilder: (context, index) {
              final juz = juzList[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                color: const Color(0xFFDFF5F3),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF219EBC),
                    child: Text('${juz.juzNumber}', style: const TextStyle(color: Colors.white)),
                  ),
                  title: Text('Juz ${juz.juzNumber}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    'Dari: ${juz.startSurah} ayat ${juz.startAyah} \n'
                    'Sampai: ${juz.endSurah} ayat ${juz.endAyah}',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF219EBC), size: 18),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Kamu memilih Juz ${juz.juzNumber}')),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
