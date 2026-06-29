Nestmart adalah aplikasi berbasis mobile yang bertujuan untuk membantu pelaku usaha mikro, kecil, dan menengah (UMKM) dalam mempromosikan profil bisnis mereka dan menjual produk mereka melalui saluran digital dalam satu platform terintegrasi. Aplikasi ini memungkinkan pengguna untuk menemukan kategori bisnis UMKM, profil, katalog produk, dan memesan produk mereka secara langsung.

Aplikasi ini akan mendukung SDG 8: Pekerjaan Layak dan Pertumbuhan Ekonomi dengan menyediakan akses digital yang lebih luas bagi UMKM untuk meningkatkan visibilitas bisnis mereka, memperluas pasar mereka, dan mendorong pertumbuhan ekonomi berkelanjutan.

Tujuan proyek:

- Membantu UMKM mempromosikan produk dan profil bisnis mereka melalui sarana digital.

- Menyediakan platform pemesanan terintegrasi untuk produk UMKM.

- Mempermudah transaksi bagi UMKM kepada masyarakat.

- Mendukung pertumbuhan ekonomi lokal dan pemberdayaan UMKM berdasarkan SDG 8.

Fitur aplikasi Nestmart meliputi:

- Login dan Pembuatan Akun
Pengguna dapat membuat akun baru terlebih dahulu dengan memasukkan nama pengguna, alamat email, dan kata sandi. Kemudian, pengguna dapat masuk ke aplikasi ini.

- Pencarian Produk/Toko
Pengguna dapat mencari produk UMKM yang diinginkan menggunakan kolom pencarian. Selain itu, pengguna juga dapat mencari nama toko UMKM yang diinginkan.

- Favorit
Pengguna dapat memilih dan menyimpan produk dan toko favorit agar lebih mudah karena pengguna tidak perlu mencari produk dan toko yang sama lagi.

- Keranjang Belanja
Pengguna dapat menambahkan produk yang ingin dibeli ke fitur keranjang belanja. Pengguna dapat memeriksa kembali produk yang ingin dibeli, mengubah atau mengurangi jumlah produk, dan melakukan pemesanan.

- Ulasan dan Peringkat Produk
Pengguna dapat melihat ulasan dan peringkat produk. Selain itu, pengguna dapat memberikan peringkat pada produk yang telah dibeli sebelumnya.

Stack Full-Stack yang digunakan dalam proyek ini:

- Flutter (Frontend Mobile)
- NestJS (Backend API)
- MySQL (Database)

Persyaratan

Pastikan perangkat lunak berikut telah diinstal:

- Frontend (Flutter)
Flutter SDK
Dart SDK
Android Studio
VS Code
Git

- Backend (NestJS)
Node.js
npm
NestJS CLI
MySQL Server

Kloning Repositori
git clone https://github.com/USERNAME/Project-NestMart-MobileHybridSolution.git
Masuk ke folder proyek:
cd Project-NestMart-MobileHybridSolution

Pengaturan Backend (NestJS)
1. Masuk ke folder backend - cd backend_app
2. Instal dependensi - npm install
3. Siapkan database MySQL
Buat database baru di MySQL: CREATE DATABASE nestmart_db;

4. Konfigurasi basis data
Buat file baru: .env
Masukkan konfigurasi:
DB_HOST=localhost
DB_PORT=3306
DB_USERNAME=root
DB_PASSWORD=KATA_SANDI_ANDA
DB_DATABASE=nestmart_db
5. Jalankan backend - npm run start:dev (Backend berjalan di http://localhost:3000)

Siapkan Frontend (Flutter)
1. Navigasi ke folder frontend - cd frontend
2. Instal dependensi Flutter - flutter pub get
3. Jalankan Flutter - flutter run -d chrome

Hubungkan Flutter ke Backend
Web / Chrome - http://localhost:3000

Perintah Git (Dorong perubahan ke GitHub)
git add .

git commit -m "update project"
git push
