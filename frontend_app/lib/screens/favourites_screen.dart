import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../favorites_state.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Elektronik', 'Fashion', 'Hobi'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEAE6), // Warm beige cream backdrop
      body: SafeArea(
        child: ValueListenableBuilder<Set<String>>(
          valueListenable: FavoritesState.favoriteIds,
          builder: (context, favIds, child) {
            // Get current list of actual favorited products
            final allFavs = FavoritesState.getFavoriteProducts();

            // Filter by search query & category
            final filteredFavs = allFavs.where((p) {
              final matchesQuery = p.name.toLowerCase().contains(_searchQuery.toLowerCase());
              
              if (_selectedCategory == 'All') {
                return matchesQuery;
              }
              // Normalizing category names (e.g. "Elektronik" vs "Elekronik")
              final normalCategory = p.category.replaceAll('k', '').replaceAll('c', '').toLowerCase();
              final normalSelected = _selectedCategory.replaceAll('k', '').replaceAll('c', '').toLowerCase();
              return matchesQuery && (normalCategory == normalSelected);
            }).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Customized top header matching screenshots
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 18.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Goes back to main/menu screen
                          Navigator.pushReplacementNamed(context, '/menu');
                        },
                        behavior: HitTestBehavior.opaque,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.black,
                            size: 26,
                          ),
                        ),
                      ),
                      Text(
                        'FAVOURITES',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          color: const Color(0xFF7E4D2B), // Rich brown
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 42), // Visual spacer to center the title
                    ],
                  ),
                ),

                // 2. Search container matching screenshot styling
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E2DE), // Soft gray background matching mockup
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black12,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (val) {
                              setState(() {
                                _searchQuery = val;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'What do you mostly like?',
                              hintStyle: GoogleFonts.inter(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.search_rounded,
                          color: Colors.black54,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),

                // 3. Category filters horizontal scrollbar-hide container
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: _categories.map((cat) {
                        final isSelected = _selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = cat;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF864F1F) : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFF864F1F),
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                cat,
                                style: GoogleFonts.inter(
                                  color: isSelected ? Colors.white : const Color(0xFF864F1F),
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // 4. Favourite Items Grid
                Expanded(
                  child: filteredFavs.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.favorite_border_rounded,
                                size: 54,
                                color: const Color(0xFF864F1F).withOpacity(0.4),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Belum ada produk favorit',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFF864F1F),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Tambahkan dengan menekan logo hati',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.76, // Matches "Just for you" format
                            ),
                            itemCount: filteredFavs.length,
                            itemBuilder: (context, idx) {
                              final item = filteredFavs[idx];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/product', arguments: item.toMap());
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE2DFDC), // Light grey matching screenshots
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Top cell image and favorite heart
                                      Expanded(
                                        flex: 6,
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                                              child: Image.network(
                                                item.image,
                                                width: double.infinity,
                                                height: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Positioned(
                                              top: 10,
                                              right: 10,
                                              child: GestureDetector(
                                                onTap: () {
                                                  FavoritesState.toggleFavorite(item.id);
                                                },
                                                child: const Icon(
                                                  Icons.favorite,
                                                  color: Color(0xFF7E4D2B), // Brown filled heart
                                                  size: 21,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Bottom details with overlapping look
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          width: double.infinity,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                              bottomLeft: Radius.circular(24),
                                              bottomRight: Radius.circular(24),
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.name,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.inter(
                                                      fontWeight: FontWeight.w800,
                                                      fontSize: 11,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 1),
                                                  Row(
                                                    children: List.generate(5, (starIdx) {
                                                      return const Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                        size: 11,
                                                      );
                                                    }),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    item.price,
                                                    style: GoogleFonts.inter(
                                                      fontWeight: FontWeight.w900,
                                                      fontSize: 13,
                                                      color: const Color(0xFF7E4D2B),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 24,
                                                    height: 24,
                                                    decoration: const BoxDecoration(
                                                      color: Color(0xFF864F1F), // Brown button with white plus inside
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                      size: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
      // 5. Bottom Navigation Bar matching screenshot with Favourites selected (active color)
      bottomNavigationBar: Container(
        height: 72,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavTab(Icons.storefront_outlined, 'Shop', false, () {
              Navigator.pushReplacementNamed(context, '/menu');
            }),
            _buildNavTab(Icons.manage_search, 'Kategori', false, () {
              Navigator.pushReplacementNamed(context, '/category');
            }),
            _buildNavTab(Icons.shopping_cart_outlined, 'Cart', false, () {
              Navigator.pushReplacementNamed(context, '/cart');
            }),
            _buildNavTab(Icons.favorite, 'Favourite', true, () {}), // Set to active with filled heart
            _buildNavTab(Icons.person_outline, 'Account', false, () {
              Navigator.pushReplacementNamed(context, '/account');
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildNavTab(IconData icon, String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: active ? const Color(0xFF7E4D2B) : Colors.black45,
            size: 23,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: active ? FontWeight.w900 : FontWeight.w700,
              color: active ? const Color(0xFF7E4D2B) : Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
}
