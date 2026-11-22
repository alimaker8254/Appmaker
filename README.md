# مدیر فوتبال | Football Manager
نسخهٔ اولیهٔ بازی مدیریت فوتبال با Flutter، رابط فارسی راست‌چین و طراحی نئونی.

## امکانات
- انتخاب یکی از ۱۵ باشگاه
- داشبورد افقی با نمایش سطح، نوار پیشرفت و منابع
- کارت‌های مسابقات، جدول لیگ، ارتقای بازیکن، خرید بازیکن، تاکتیک و استخدام مربی
- رابط فارسی RTL و قفل جهت صفحه روی Landscape
- ساخت APK انتشار‌یافته با GitHub Actions

## اجرا
نیازمند Flutter 3.24.0 و Android SDK:
```bash
flutter pub get
flutter run
```

## ساخت APK
```bash
flutter build apk --release
```
با push به شاخهٔ main/master یا اجرای دستی workflow با نام **Build Android APK**، فایل APK در Actions → Artifacts در دسترس است.

شناسهٔ برنامه: `com.example.football_manager`
