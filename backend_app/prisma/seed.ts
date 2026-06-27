import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Mulai seeding database NestMart...\n');

  // ─── BERSIHKAN DATA LAMA (urutan penting karena foreign key) ─────────────
  await prisma.review.deleteMany();
  await prisma.favorite.deleteMany();
  await prisma.orderItem.deleteMany();
  await prisma.order.deleteMany();
  await prisma.cartItem.deleteMany();
  await prisma.product.deleteMany();
  await prisma.user.deleteMany();
  console.log('🧹 Data lama berhasil dihapus');

  // ─── USERS ────────────────────────────────────────────────────────────────
  const hashedPassword = await bcrypt.hash('password123', 10);

  const [admin, andi, sari] = await Promise.all([
    prisma.user.create({
      data: {
        name: 'Admin NestMart',
        email: 'admin@nestmart.id',
        password: await bcrypt.hash('admin123', 10),
      },
    }),
    prisma.user.create({
      data: {
        name: 'Andi Pratama',
        email: 'andi@gmail.com',
        password: hashedPassword,
      },
    }),
    prisma.user.create({
      data: {
        name: 'Sari Dewi',
        email: 'sari@gmail.com',
        password: hashedPassword,
      },
    }),
  ]);
  console.log(`👤 Users: ${admin.name}, ${andi.name}, ${sari.name}`);

  // ─── PRODUCTS ─────────────────────────────────────────────────────────────
  // Produk disesuaikan dengan katalog Flutter frontend (favorites_state.dart)
  const products = await Promise.all([
    prisma.product.create({
      data: {
        id: 1,
        name: 'Action Figure',
        description:
          'Mainan figur pahlawan Superman berkualitas premium dengan detail kostum, jubah, dan anatomi yang sangat presisi. Sangat cocok sebagai koleksi atau pajangan meja para penggemar komik dan film pahlawan super.',
        price: 10.0,
        image:
          'https://images.unsplash.com/photo-1608889174637-3c44f6326f1a?w=400&auto=format&fit=crop',
        category: 'Hobi',
        storeName: 'NestMart Official Store',
        stock: 50,
      },
    }),
    prisma.product.create({
      data: {
        id: 2,
        name: 'Iphone 17 Pro Max',
        description:
          'Smartphone flagship masa depan dengan kamera telefoto beresolusi super tinggi, layar dinamis tajam, chipset mutakhir penunjang aktivitas multitasking harian Anda, serta baterai tahan lama sepanjang hari.',
        price: 1199.0,
        image:
          'https://images.unsplash.com/photo-1616348436168-de43ad0db179?w=400&auto=format&fit=crop',
        category: 'Elektronik',
        storeName: 'IndoTech Gadget',
        stock: 20,
      },
    }),
    prisma.product.create({
      data: {
        id: 3,
        name: 'Adidas Training Fullset',
        description:
          'Satu set lengkap jaket training dan celana olahraga Adidas berbahan serat premium yang breathable dan ringan. Cocok untuk gym, lari pagi, atau aktivitas outdoor lainnya dengan desain sporty modern.',
        price: 124.0,
        image:
          'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400&auto=format&fit=crop',
        category: 'Pakaian',
        storeName: 'SportyLife Outlet',
        stock: 35,
      },
    }),
    prisma.product.create({
      data: {
        id: 4,
        name: 'Nike Dunk Retro',
        description:
          'Sepatu kasual legendaris Nike Dunk Retro dengan kombinasi warna hitam dan putih yang kontras dan ikonik. Sol karet tebal memberikan kenyamanan ekstra dan grip kuat untuk berbagai medan.',
        price: 60.0,
        image:
          'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400&auto=format&fit=crop',
        category: 'Fashion',
        storeName: 'GayaKeren Fashion',
        stock: 40,
      },
    }),
    prisma.product.create({
      data: {
        id: 5,
        name: 'Retro Helmet',
        description:
          'Helm premium bergaya retro klasik matte dengan visor antik dan busa bagian dalam yang tebal serta empuk. Memenuhi standar keselamatan SNI dengan sertifikasi internasional untuk keamanan berkendara.',
        price: 40.0,
        image:
          'https://images.unsplash.com/photo-1558981806-ec527fa84c39?w=400',
        category: 'Otomotif',
        storeName: 'NestMart Official Store',
        stock: 25,
      },
    }),
    prisma.product.create({
      data: {
        id: 6,
        name: 'Superman Figure',
        description:
          'Action figure Superman berskala kolektor dalam pose aksi ikonik lengkap dengan jubah kain premium serta detail cat berkualitas tinggi. Dilengkapi display stand transparan eksklusif.',
        price: 35.0,
        image:
          'https://images.unsplash.com/photo-1608889174637-3c44f6326f1a?w=400&auto=format&fit=crop',
        category: 'Hobi',
        storeName: 'NestMart Official Store',
        stock: 30,
      },
    }),
    prisma.product.create({
      data: {
        id: 7,
        name: 'Logitech Keyboard',
        description:
          'Keyboard mekanikal gaming Logitech dengan respon pengetikan instan, lampu latar RGB yang dapat dikustomisasi, dan anti-ghosting penuh untuk performa gaming kompetitif tertinggi.',
        price: 50.0,
        image:
          'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=400&auto=format&fit=crop',
        category: 'Elektronik',
        storeName: 'IndoTech Gadget',
        stock: 45,
      },
    }),
    prisma.product.create({
      data: {
        id: 8,
        name: 'Luxury Leather Handbag',
        description:
          'Tas genggam wanita berbahan kulit sapi asli berkualitas tinggi dengan jahitan tangan yang rapi, komponen logam berlapis emas, dan lapisan dalam berbahan suede mewah.',
        price: 150.0,
        image:
          'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400&auto=format&fit=crop',
        category: 'Fashion',
        storeName: 'GayaKeren Fashion',
        stock: 15,
      },
    }),
    prisma.product.create({
      data: {
        id: 9,
        name: 'Sleek Black Duffle Bag',
        description:
          'Tas travel duffle olahraga modis tahan air dengan kapasitas penyimpanan besar dan tempat sepatu terpisah. Bahan polyester ripstop premium dengan resleting YKK berkualitas tinggi.',
        price: 85.0,
        image:
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400&auto=format&fit=crop',
        category: 'Fashion',
        storeName: 'SportyLife Outlet',
        stock: 28,
      },
    }),
    prisma.product.create({
      data: {
        id: 10,
        name: 'Esthetic Skincare Serum Set',
        description:
          'Paket serum wajah organik premium yang mengandung Hyaluronic Acid dan Niacinamide murni untuk hidrasi dan mencerahkan kulit secara intensif. Formula bebas paraben dan sudah teruji dermatologis.',
        price: 45.0,
        image:
          'https://images.unsplash.com/photo-1608248597481-496100c8c836?w=400&auto=format&fit=crop',
        category: 'Kecantikan',
        storeName: 'NestMart Official Store',
        stock: 60,
      },
    }),
    prisma.product.create({
      data: {
        id: 11,
        name: 'Organic Matte Lip Cream',
        description:
          'Lip cream matte dengan formula super ringan tidak lengket yang diperkaya dengan Vitamin E dan Jojoba Oil. Hadir dalam 12 pilihan warna nude hingga bold yang tahan lama hingga 12 jam.',
        price: 24.0,
        image:
          'https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?w=400&auto=format&fit=crop',
        category: 'Kecantikan',
        storeName: 'NestMart Official Store',
        stock: 75,
      },
    }),
    prisma.product.create({
      data: {
        id: 12,
        name: 'Premium Oat & Nut Salad Pack',
        description:
          'Camilan sehat kemasan kedap udara berisi campuran oat panggang renyah, kacang almond gurih, mete, kismis, dan cranberry kering pilihan. Bebas pengawet, tinggi serat dan protein.',
        price: 15.0,
        image:
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&auto=format&fit=crop',
        category: 'Makanan',
        storeName: 'NestMart Official Store',
        stock: 100,
      },
    }),
    prisma.product.create({
      data: {
        id: 13,
        name: 'Sleek Remote Car Key Fob',
        description:
          'Gantungan kunci mobil pintar premium berlapis kulit asli dan campuran logam zinc, dirancang eksklusif untuk berbagai merek kendaraan. Dilengkapi cover pelindung tombol anti-debu.',
        price: 28.0,
        image:
          'https://images.unsplash.com/photo-1542282088-fe8426682b8f?w=400&auto=format&fit=crop',
        category: 'Otomotif',
        storeName: 'NestMart Official Store',
        stock: 40,
      },
    }),
    prisma.product.create({
      data: {
        id: 14,
        name: 'Pro Mirrorless Leather Straps',
        description:
          'Tali bahu kamera mirrorless buatan pengrajin lokal berbahan kulit asli premium. Memberikan kenyamanan saat dibawa berjam-jam dan kompatibel dengan semua merek kamera mirrorless.',
        price: 39.0,
        image:
          'https://images.unsplash.com/photo-1511556532299-8f662fc26c06?w=400&auto=format&fit=crop',
        category: 'Hobi',
        storeName: 'NestMart Official Store',
        stock: 20,
      },
    }),
    prisma.product.create({
      data: {
        id: 15,
        name: 'Specialty Cold Brew Bottle',
        description:
          'Botol cold brew kopi premium berkapasitas 500ml berbahan borosilikat tahan panas dengan infuser saring ganda untuk hasil seduhan kopi terbaik. Cocok untuk dibawa ke kantor maupun bepergian.',
        price: 18.0,
        image:
          'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400&auto=format&fit=crop',
        category: 'Minuman',
        storeName: 'NestMart Official Store',
        stock: 55,
      },
    }),
    prisma.product.create({
      data: {
        id: 16,
        name: 'Samsung Galaxy S25 Ultra',
        description:
          'Flagship Android terbaru Samsung dengan chipset Snapdragon 8 Elite, kamera 200MP, layar Dynamic AMOLED 6.9 inci 120Hz, S-Pen terintegrasi, dan baterai 5000mAh dengan fast charging 45W.',
        price: 1299.0,
        image:
          'https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?w=400&auto=format&fit=crop',
        category: 'Elektronik',
        storeName: 'IndoTech Gadget',
        stock: 18,
      },
    }),
  ]);

  console.log(`📦 Products: ${products.length} produk berhasil ditambahkan`);

  // ─── REVIEWS ─────────────────────────────────────────────────────────────
  const reviews = await Promise.all([
    prisma.review.create({
      data: {
        userId: andi.id,
        productId: 2,
        rating: 5,
        comment:
          'iPhone 17 Pro Max luar biasa! Kamera bulan detail banget, layarnya smooth, dan baterainya awet seharian penuh bahkan dengan pemakaian berat.',
      },
    }),
    prisma.review.create({
      data: {
        userId: sari.id,
        productId: 2,
        rating: 4,
        comment:
          'Produk asli dan pengiriman cepat! Box tersegel rapat. Performa chipset-nya jauh lebih cepat dari generasi sebelumnya.',
      },
    }),
    prisma.review.create({
      data: {
        userId: andi.id,
        productId: 7,
        rating: 5,
        comment:
          'Keyboard Logitech terbaik yang pernah saya pakai! RGB-nya cantik, taktilnya enak, anti-ghosting-nya top untuk gaming.',
      },
    }),
    prisma.review.create({
      data: {
        userId: sari.id,
        productId: 10,
        rating: 5,
        comment:
          'Serum set-nya amazing! Kulit saya terasa lebih lembap dan cerah setelah 2 minggu rutin pakai. Bau-nya juga enak dan tidak iritasi.',
      },
    }),
    prisma.review.create({
      data: {
        userId: andi.id,
        productId: 4,
        rating: 4,
        comment:
          'Nike Dunk Retro-nya keren banget! Sol-nya nyaman untuk jalan seharian. Ukuran sesuai chart, packaging aman.',
      },
    }),
    prisma.review.create({
      data: {
        userId: sari.id,
        productId: 8,
        rating: 5,
        comment:
          'Tas kulit aslinya premium banget! Jahitannya rapi, baunya tidak menyengat, dan ukurannya pas untuk daily carry. Worth it!',
      },
    }),
  ]);

  console.log(`⭐ Reviews: ${reviews.length} ulasan berhasil ditambahkan`);

  // ─── FAVORITES ───────────────────────────────────────────────────────────
  const favorites = await Promise.all([
    prisma.favorite.create({ data: { userId: andi.id, productId: 4 } }),
    prisma.favorite.create({ data: { userId: andi.id, productId: 7 } }),
    prisma.favorite.create({ data: { userId: andi.id, productId: 2 } }),
    prisma.favorite.create({ data: { userId: sari.id, productId: 8 } }),
    prisma.favorite.create({ data: { userId: sari.id, productId: 10 } }),
    prisma.favorite.create({ data: { userId: sari.id, productId: 11 } }),
  ]);

  console.log(`❤️  Favorites: ${favorites.length} favorit berhasil ditambahkan`);

  // ─── SAMPLE ORDER ─────────────────────────────────────────────────────────
  const sampleOrder = await prisma.order.create({
    data: {
      userId: andi.id,
      total: 1249.0,
      status: 'Paid',
      items: {
        create: [
          { productId: 2, quantity: 1, price: 1199.0 },
          { productId: 7, quantity: 1, price: 50.0 },
        ],
      },
    },
  });

  console.log(`🛒 Sample order #${sampleOrder.id} berhasil dibuat untuk ${andi.name}`);

  // ─── SUMMARY ─────────────────────────────────────────────────────────────
  console.log('\n✅ Seeding selesai! Ringkasan database:');
  console.log(`   👤 Users    : ${await prisma.user.count()}`);
  console.log(`   📦 Products : ${await prisma.product.count()}`);
  console.log(`   ⭐ Reviews  : ${await prisma.review.count()}`);
  console.log(`   ❤️  Favorites: ${await prisma.favorite.count()}`);
  console.log(`   🛒 Orders   : ${await prisma.order.count()}`);
  console.log('\n📝 Akun untuk testing:');
  console.log('   Email: andi@gmail.com    | Password: password123');
  console.log('   Email: sari@gmail.com    | Password: password123');
  console.log('   Email: admin@nestmart.id | Password: admin123');
}

main()
  .catch((e) => {
    console.error('❌ Seed gagal:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
