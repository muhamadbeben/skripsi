import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/santri_model.dart';
import '../services/dashboard_service.dart';
import 'santri_screen.dart';
import 'nilai_screen.dart';
import 'rapor_screen.dart';
import 'prediksi_screen.dart';
import 'laporan_screen.dart';
import 'login_screen.dart';
import 'profil_santri_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardService _dashboardService = DashboardService();
  int _selectedIndex = 0;
  bool _isLoading = true;
  String _role = 'santri';
  String _nama = '';
  String _uid = '';
  late List<Widget> _adminScreens;
  late List<Widget> _santriScreens;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final userData = await _dashboardService.fetchUserProfile();
      if (userData != null && mounted) {
        setState(() {
          _role = userData['role'];
          _nama = userData['nama'];
          _uid = userData['uid'];

          _initScreens();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Gagal memuat data dashboard: $e");
      setState(() => _isLoading = false);
    }
  }

  void _initScreens() {
    _adminScreens = [
      _HomeTab(
          role: 'admin',
          nama: _nama,
          uid: _uid,
          dashboardService: _dashboardService),
      const SantriScreen(),
      const PrediksiScreen(),
      const LaporanScreen(),
      const Center(child: Text("Profil Admin")),
    ];

    _santriScreens = [
      _HomeTab(
          role: 'santri',
          nama: _nama,
          uid: _uid,
          dashboardService: _dashboardService),
      RaporScreen(userRole: _role, currentUserUid: _uid),
      _ProfilSantriWrapper(uid: _uid),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body:
            Center(child: CircularProgressIndicator(color: Color(0xFF1B5E20))),
      );
    }

    final isAdmin = _role == 'admin';
    final currentScreens = isAdmin ? _adminScreens : _santriScreens;
    if (_selectedIndex >= currentScreens.length) {
      _selectedIndex = 0;
    }
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: currentScreens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFF1B5E20).withOpacity(0.15),
        destinations: isAdmin ? _adminDestinations : _santriDestinations,
      ),
    );
  }

  final List<NavigationDestination> _adminDestinations = const [
    NavigationDestination(
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard, color: Color(0xFF1B5E20)),
      label: 'Dashboard',
    ),
    NavigationDestination(
      icon: Icon(Icons.people_outlined),
      selectedIcon: Icon(Icons.people, color: Color(0xFF1B5E20)),
      label: 'Santri',
    ),
    NavigationDestination(
      icon: Icon(Icons.psychology_outlined),
      selectedIcon: Icon(Icons.psychology, color: Color(0xFF1B5E20)),
      label: 'Prediksi',
    ),
    NavigationDestination(
      icon: Icon(Icons.bar_chart_outlined),
      selectedIcon: Icon(Icons.bar_chart, color: Color(0xFF1B5E20)),
      label: 'Laporan',
    ),
  ];
  final List<NavigationDestination> _santriDestinations = const [
    NavigationDestination(
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard, color: Color(0xFF1B5E20)),
      label: 'Dashboard',
    ),
    NavigationDestination(
      icon: Icon(Icons.description_outlined),
      selectedIcon: Icon(Icons.description, color: Color(0xFF1B5E20)),
      label: 'Rapor',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person, color: Color(0xFF1B5E20)),
      label: 'Profil Saya',
    ),
  ];
}

class _ProfilSantriWrapper extends StatelessWidget {
  final String uid;
  const _ProfilSantriWrapper({required this.uid});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Terjadi Kesalahan'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('Data profil tidak ditemukan'));
        }
        final santri =
            SantriModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);
        return ProfilSantriScreen(santri: santri);
      },
    );
  }
}

class _HomeTab extends StatelessWidget {
  final String role;
  final String nama;
  final String uid;
  final DashboardService dashboardService;
  const _HomeTab({
    required this.role,
    required this.nama,
    required this.uid,
    required this.dashboardService,
  });
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Assalamu'alaikum,";
    if (hour < 15) return 'Selamat Siang,';
    if (hour < 18) return 'Selamat Sore,';
    return 'Selamat Malam,';
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B5E20),
                foregroundColor: Colors.white),
            onPressed: () async {
              Navigator.pop(ctx);
              await dashboardService.logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = role == 'admin';
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1B5E20), Color(0xFF388E3C)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getGreeting(),
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 14),
                              ),
                              Text(
                                isAdmin ? 'Ustadz Admin' : 'Ananda $nama',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _logout(context),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.logout,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.mosque, color: Colors.white),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Pondok Pesantren Khoirul Huda',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  isAdmin
                                      ? 'Mode Administrator'
                                      : 'Portal Akademik Santri',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(title: 'Menu Utama'),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.9,
                      children: isAdmin
                          ? _buildAdminMenu(context)
                          : _buildSantriMenu(context),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAdminMenu(BuildContext context) {
    return [
      _MenuCard(
        icon: Icons.people,
        label: 'Kelola Santri',
        color: const Color(0xFF1B5E20),
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const SantriScreen())),
      ),
      _MenuCard(
        icon: Icons.grade,
        label: 'Input Nilai',
        color: const Color(0xFF1565C0),
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const NilaiScreen())),
      ),
      _MenuCard(
        icon: Icons.description,
        label: 'Cetak Rapor',
        color: const Color(0xFF6A1B9A),
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const RaporScreen())),
      ),
      _MenuCard(
        icon: Icons.psychology,
        label: 'Prediksi AI',
        color: const Color(0xFF00838F),
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const PrediksiScreen())),
      ),
      _MenuCard(
        icon: Icons.bar_chart,
        label: 'Laporan',
        color: const Color(0xFF558B2F),
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const LaporanScreen())),
      ),
    ];
  }

  List<Widget> _buildSantriMenu(BuildContext context) {
    return [
      _MenuCard(
        icon: Icons.description_outlined,
        label: 'Rapor Saya',
        color: const Color(0xFF1B5E20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RaporScreen(
                userRole: role,
                currentUserUid: uid,
              ),
            ),
          );
        },
      ),
      _MenuCard(
        icon: Icons.trending_up,
        label: 'Prediksi Kelulusan',
        color: const Color(0xFF1565C0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PrediksiScreen(
                userRole: role, // Kirim role
                uid: uid, // Kirim UID
              ),
            ),
          );
        },
      ),
      _MenuCard(
        icon: Icons.person_outline,
        label: 'Profil Saya',
        color: const Color(0xFFF57F17),
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => _ProfilSantriWrapper(uid: uid))),
      ),
    ];
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1B5E20),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _MenuCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
