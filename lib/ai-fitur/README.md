# Fitur AI Quranify

Fitur AI Quranify adalah asisten cerdas yang menggunakan Google Gemini AI untuk membantu pengguna dengan pertanyaan seputar Al-Quran, Hadist, dan Islam.

## 🌟 Fitur Utama

### 1. Chat AI Interaktif
- Tanya jawab real-time dengan AI
- Dukungan voice input (speech-to-text)
- Riwayat chat tersimpan otomatis
- Copy-paste jawaban mudah

### 2. Rekomendasi Ayat
- Rekomendasi ayat Al-Quran berdasarkan perasaan/mood
- Terjemahan dan penjelasan kontekstual
- Format yang mudah dibaca dan dipahami

### 3. Hadist dan Sunnah
- Pencarian hadist berdasarkan topik
- Verifikasi keaslian hadist
- Penjelasan aplikasi praktis

### 4. Panduan Islami
- Solusi masalah sehari-hari menurut Islam
- Dalil dari Al-Quran dan Hadist
- Panduan praktis implementasi

## 📁 Struktur Folder

```
ai-fitur/
├── config/
│   └── ai_config.dart          # Konfigurasi API dan pengaturan
├── models/
│   └── chat_message.dart       # Model untuk pesan chat
├── services/
│   ├── ai_service.dart         # Service untuk Google Gemini AI
│   └── chat_service.dart       # Service untuk penyimpanan chat
├── widgets/
│   ├── ai_feature_button.dart  # Tombol AI di home page
│   ├── chat_input_widget.dart  # Widget input chat dengan voice
│   └── chat_message_widget.dart # Widget untuk menampilkan pesan
├── screens/
│   └── ai_chat_screen.dart     # Screen utama chat AI
└── ai_fitur.dart               # File export utama
```

## 🔧 Setup & Konfigurasi

### 1. Google AI API Key
1. Kunjungi [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Buat API Key baru
3. Ganti `YOUR_GOOGLE_AI_API_KEY_HERE` di `ai-fitur/config/ai_config.dart`

### 2. Dependencies
Dependencies yang dibutuhkan sudah ditambahkan di `pubspec.yaml`:
- `google_generative_ai: ^0.4.3`
- `speech_to_text: ^6.6.0`
- `flutter_markdown: ^0.6.18`

### 3. Permissions
Permissions Android sudah ditambahkan di `AndroidManifest.xml`:
- `RECORD_AUDIO` - untuk voice input
- `INTERNET` - untuk API calls
- `MICROPHONE` - untuk speech recognition

## 🚀 Cara Menggunakan

### 1. Akses Fitur AI
- Buka aplikasi Quranify
- Tap tombol "Asisten AI Quranify" di home page
- Mulai chat dengan AI

### 2. Fitur Voice Input
- Tap ikon mikrofon di chat input
- Bicara dengan jelas
- AI akan memproses suara menjadi teks

### 3. Quick Suggestions
- Gunakan tombol saran cepat untuk pertanyaan umum
- Tap untuk langsung mengirim pertanyaan

### 4. Copy & Share
- Tap ikon copy pada pesan AI
- Bagikan jawaban dengan mudah

## 💡 Tips Penggunaan

### Pertanyaan yang Efektif:
1. **Spesifik**: "Ayat tentang kesabaran dalam menghadapi cobaan"
2. **Kontekstual**: "Saya sedang sedih, berikan ayat yang menenangkan"
3. **Praktis**: "Bagaimana Islam mengatur hubungan dengan tetangga?"

### Kategori Pertanyaan:
- **Mood/Perasaan**: Otomatis memberikan rekomendasi ayat
- **Hadist**: Pencarian hadist berdasarkan topik
- **Panduan**: Solusi praktis kehidupan Islami
- **Umum**: Pertanyaan tentang Al-Quran dan Islam

## 🔒 Keamanan & Privasi

- Riwayat chat disimpan lokal di device
- API key tidak disimpan di server
- Tidak ada data pribadi yang dikirim ke server
- Dapat menghapus riwayat chat kapan saja

## 🎨 Customization

### Mengubah Pesan Selamat Datang
Edit `AIConfig.welcomeMessage` di `ai-fitur/config/ai_config.dart`

### Mengubah Model AI
Edit `AIConfig.modelName` untuk menggunakan model Gemini yang berbeda

### Mengubah Tema
Edit warna dan styling di widget components

## 🚨 Troubleshooting

### API Key Error
- Pastikan API key valid dan aktif
- Periksa quota API di Google Cloud Console
- Pastikan billing account terhubung

### Voice Input Tidak Bekerja
- Pastikan permission mikrofon diberikan
- Periksa koneksi internet
- Restart aplikasi

### Chat Tidak Tersimpan
- Periksa permission storage
- Clear app cache jika perlu
- Reinstall aplikasi

## 📱 Kompatibilitas

- **Android**: API Level 21+ (Android 5.0+)
- **iOS**: iOS 12.0+
- **Flutter**: 3.8.1+

## 🤝 Kontribusi

Untuk menambahkan fitur atau memperbaiki bug:
1. Fork repository
2. Buat branch baru
3. Implementasi perubahan
4. Submit pull request

## 📄 Lisensi

Fitur AI Quranify menggunakan:
- Google Gemini AI (Google Terms of Service)
- Flutter (BSD 3-Clause License)
- Dependencies lainnya sesuai lisensi masing-masing
