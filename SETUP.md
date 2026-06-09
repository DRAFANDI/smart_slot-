# Smart Slots — Secure Setup Guide

## 1) Supabase

1. افتح Supabase → مشروعك.
2. من SQL Editor → New Query.
3. الصق محتوى `supabase-setup.sql`.
4. اضغط Run.

## 2) إنشاء مستخدم الأدمن

1. Supabase → Authentication → Users.
2. Add user → Create new user.
3. ضع إيميل وكلمة مرور لمسؤولة التسويق أو لك.
4. هذا هو تسجيل دخول `admin.html`.

## 3) config.js

من Supabase → Settings → API انسخ:

```js
export const SUPABASE_URL = 'https://YOUR_PROJECT_ID.supabase.co'
export const SUPABASE_ANON_KEY = 'YOUR_ANON_KEY'
```

مسموح وضع `anon key` في الواجهة.
ممنوع وضع `service_role key` في أي ملف Frontend.

## 4) Vercel

1. ارفع المجلد على GitHub أو ارفعه كـ Project.
2. Framework: Vite.
3. Deploy.

الروابط:
- صفحة العميل: `/`
- لوحة الأدمن: `/admin.html`

## 5) اختبار سريع

1. افتح صفحة العميل وسجل عرض وهمي.
2. افتح `/admin.html`.
3. سجّل دخول بإيميل الأدمن.
4. تأكد أن العرض ظهر.
5. جرّب Accept / Reject / Waitlist.

## ملاحظة مهمة

تم إلغاء قراءة بيانات العملاء من صفحة العميل. صفحة العميل تعمل Insert فقط.
لوحة الأدمن تعمل بعد تسجيل دخول Supabase Auth فقط.
