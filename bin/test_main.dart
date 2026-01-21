import 'dart:math';
import 'package:dots_baas_flutter/dots_baas_flutter.dart';

void main() async {
  print("🚀 DOTS SYSTEM CHECK BAŞLIYOR...\n");

  // --- AYARLAR ---
  // 1. Project ID: Kafamızdan uydurduk, sistem bunu kabul eder ve izole eder.
  final projectId = 'demo_app_v1';

  // 2. API Key: "D7x9..." secret'ı ile üretilmiş ANONİM token.
  final apiKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlzcyI6ImRvdHMiLCJpYXQiOjE3MDAwMDAwMDAsImV4cCI6NDAwMDAwMDAwMH0.kLmLOBmD_MelnF-ROFg8ccq8hxMAUCk1fkZO03XlJJ4';

  // Rastgelelik (Hata almamak için)
  final randomId = Random().nextInt(9999);
  final email = 'user_$randomId@demo.com';
  final password = 'superSecretPassword123!';

  // SDK Başlat
  final dots = Dots(projectId, apiKey);

  try {
    // ---------------------------------------------------------
    // ADIM 1: KAYIT OL (Sign Up)
    // ---------------------------------------------------------
    print("⏳ [1/4] Kayıt olunuyor ($email)...");
    final signUpRes = await dots.auth.signUp(email: email, password: password);
    print("   ✅ Kayıt Başarılı! ID: ${signUpRes['id']}");

    // ---------------------------------------------------------
    // ADIM 2: GİRİŞ YAP (Sign In)
    // ---------------------------------------------------------
    print("\n⏳ [2/4] Giriş yapılıyor...");
    final signInRes = await dots.auth.signIn(email: email, password: password);
    print("   ✅ Giriş Başarılı! Token alındı.");
    print("   🔍 SignIn Response: $signInRes");
    // Not: SDK otomatik olarak token'ı hafızaya aldı.

    // --- DEBUG RLS ---
    // --- DEBUG RLS ---
    try {
      final claims = await dots.rpc('get_claims');
      print("   🕵️‍♀️ RLS DEBUG (Claims): $claims");
    } catch (e) {
      print("   ⚠️ DEBUG Warning: $e");
    }

    // ---------------------------------------------------------
    // ADIM 3: VERİ EKLE (Insert)
    // ---------------------------------------------------------
    final updateRes = await dots.from('profiles').update({
      'username': 'DemoUser_$randomId',
      'avatar_url': 'https://api.dots.net.tr/storage/avatar.png'
    }, idColumn: 'id', idValue: signInRes['user']['id']);

    if (updateRes is List && updateRes.isNotEmpty) {
      print("   ✅ Güncelleme Başarılı: ${updateRes[0]}");
    } else {
      print("   ⚠️ Güncelleme yapıldı ama dönüş formatı farklı: $updateRes");
    }

    // ---------------------------------------------------------
    // ADIM 4: VERİ ÇEK (Select & RLS Testi)
    // ---------------------------------------------------------
    print("\n⏳ [4/4] Veri çekiliyor...");
    final selectRes = await dots.from('profiles').select();

    print("\n📊 SUNUCUDAN GELEN YANIT:");
    print(selectRes);

    // Basit Doğrulama
    if (selectRes.toString().contains('DemoUser_$randomId')) {
      print("\n🎉🎉🎉 MÜKEMMEL! SİSTEM SORUNSUZ ÇALIŞIYOR.");
      print("    Auth, Veritabanı, RLS ve API Gateway aktif.");
    } else {
      print(
          "\n❌ HATA: Eklenen veri çekilemedi. RLS veya yetki sorunu olabilir.");
    }
  } catch (e) {
    print("\n🛑 KRİTİK HATA:");
    print(e);
  }
}
