Nestmart adalah aplikasi mobile berbasis marketplace yang bertujuan untuk membantu pelaku Usaha Mikro, Kecil, dan Menengah (UMKM) dalam mempromosikan profil usaha serta menjual produk mereka secara digital dalam satu platform terintegrasi. Aplikasi ini memungkinkan pengguna untuk menemukan UMKM kategori usaha, melihat profil UMKM, katalog produk, serta melakukan pemesanan produk secara langsung.

Aplikasi ini mendukung SDG 8: Decent Work and Economic Growth dengan memberikan akses digital yang lebih luas bagi UMKM untuk meningkatkan visibilitas usaha, memperluas pasar, serta mendorong pertumbuhan ekonomi lokal secara berkelanjutan.

Project Objective:

- Membantu UMKM untuk mempromosikan produk dan profil usahanya secara digital.
- Menyediakan platform pemesanan produk UMKM yang sederhana dan terintegrasi.
- Memudahkan transaksi pelaku usaha UMKM kepada masyarakat.
- Mendukung pertumbuhan ekonomi lokal dan pemberdayaan UMKM sesuai SDG 8.

Aplikasi Nestmart memiliki berbagai fitur yaitu:
- Login dan Membuat Akun 
User dapat membuat akun baru terlebih dahulu dengan memasukkan username, email, dan password. Selanjutnya, user dapat melakukan login ke dalam aplikasinya.

- Search Product / Store
User dapat mencari produk UMKM yang diinginkan dengan menggunakan search bar. Selain itu, user juga dapat mencari nama toko UMKM yang diinginkan.

- Favorite
User dapat memilih dan menyimpan produk atau toko langganan mereka sehingga memudahkan user karena tidak perlu search ulang produk atau toko yang sama.

- Keranjang
User dapat menambahkan produk yang ingin dibeli ke dalam fitur keranjang. User dapat melihat kembali produk yang ingin dibeli, menambah atau mengurangi jumlah produk, serta melakukan pemesanan.

- Review dan Rating Produk
User dapat melihat review dan rating produk. Selain itu, user dapat melakukan rating produk yang telah dibeli sebelumnya.

Project fullstack menggunakan:

- Flutter (Frontend Mobile)
- NestJS (Backend API)
- MySQL (Database)

Requirements

Pastikan software berikut sudah terinstall:

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

Clone Repository
git clone https://github.com/USERNAME/Project-NestMart-MobileHybridSolution.git
Masuk ke folder project:
cd Project-NestMart-MobileHybridSolution

Setup Backend (NestJS)
1. Masuk ke folder backend - cd backend_app
2. Install dependency - npm install
3. Setup database MySQL
Buat database baru di MySQL: CREATE DATABASE nestmart_db;
4. Konfigurasi database
Buat file: .env
Isi:
DB_HOST=localhost
DB_PORT=3306
DB_USERNAME=root
DB_PASSWORD=YOUR_PASSWORD
DB_DATABASE=nestmart_db
5. Jalankan backend - npm run start:dev (Backend berjalan di: http://localhost:3000)

Setup Frontend (Flutter)
1. Masuk ke folder frontend - cd frontend
2. Install dependency Flutter - flutter pub get
3. Jalankan Flutter - flutter run -d chrome

Koneksi Flutter ke Backend
Web / Chrome - http://localhost:3000

Git Commands (Push perubahan ke GitHub)
git add .
git commit -m "update project"
git push



