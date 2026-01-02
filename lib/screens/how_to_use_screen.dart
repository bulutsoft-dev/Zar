import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../utils/app_colors.dart';

/// How to use guide screen with detailed instructions
class HowToUseScreen extends StatelessWidget {
  const HowToUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    AppColors.primaryDark,
                    AppColors.secondaryDark,
                    AppColors.accentDark,
                  ]
                : [
                    AppColors.primaryLight,
                    AppColors.accentLight,
                    AppColors.secondaryLight,
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App bar
              _buildAppBar(context, isDark),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome section
                      _buildWelcomeCard(isDark),
                      const SizedBox(height: 24),

                      // Quick Start
                      _buildSectionTitle('Hızlı Başlangıç', Icons.rocket_launch, isDark),
                      const SizedBox(height: 12),
                      _buildStep(
                        number: 1,
                        title: 'Zar Sayısını Seçin',
                        description: 'Ana ekranda 1-6 arasında kaç zar atacağınızı seçin.',
                        icon: Icons.tune,
                        isDark: isDark,
                      ),
                      _buildStep(
                        number: 2,
                        title: 'Zar Atın',
                        description: '"ZAR AT" butonuna basarak zarları atın ve sonuçları görün.',
                        icon: Icons.casino,
                        isDark: isDark,
                      ),
                      _buildStep(
                        number: 3,
                        title: 'Sonuçları Takip Edin',
                        description: 'Toplam değerinizi ekranda anlık olarak görün.',
                        icon: Icons.star,
                        isDark: isDark,
                      ),

                      const SizedBox(height: 24),

                      // Multiplayer Mode
                      _buildSectionTitle('Çok Oyunculu Mod', Icons.group, isDark),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        title: 'Oyuncu Seçimi',
                        content: 'Menü > Yeni Oyun Başlat bölümünden oyuncu sayısını seçebilirsiniz. 0-8 arası oyuncu ekleyebilirsiniz.',
                        icon: Icons.people,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoCard(
                        title: 'Oyuncu İsimleri',
                        content: 'Her oyuncu için özel isim girebilirsiniz. Boş bırakırsanız "Oyuncu 1, Oyuncu 2..." şeklinde varsayılan isimler kullanılır.',
                        icon: Icons.person,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoCard(
                        title: 'Sıra Takibi',
                        content: 'Oyun sırasında sıra kimdeyse ekranda o oyuncunun adı görünür. Her atıştan sonra sıra otomatik olarak sonraki oyuncuya geçer.',
                        icon: Icons.swap_horiz,
                        isDark: isDark,
                      ),

                      const SizedBox(height: 24),

                      // Game Session
                      _buildSectionTitle('Oyun Oturumu', Icons.play_circle, isDark),
                      const SizedBox(height: 12),
                      _buildStep(
                        number: 1,
                        title: 'Yeni Oyun Başlatın',
                        description: 'Menü ikonuna (☰) basın ve "Yeni Oyun Başlat" seçeneğini seçin.',
                        icon: Icons.play_circle_outline,
                        isDark: isDark,
                      ),
                      _buildStep(
                        number: 2,
                        title: 'Oyuncu Ayarlayın',
                        description: 'Oyuncu sayısını ve isimlerini ayarlayın, sonra "OYUNU BAŞLAT" butonuna basın.',
                        icon: Icons.group_add,
                        isDark: isDark,
                      ),
                      _buildStep(
                        number: 3,
                        title: 'Oynayın',
                        description: 'Sırayla zar atın. Her atış kaydedilir ve oyuncu bazlı istatistikler tutulur.',
                        icon: Icons.casino,
                        isDark: isDark,
                      ),
                      _buildStep(
                        number: 4,
                        title: 'Oyunu Bitirin',
                        description: 'Menüden "Oyunu Bitir" seçeneği ile oyunu kaydedin veya silin.',
                        icon: Icons.stop_circle_outlined,
                        isDark: isDark,
                      ),

                      const SizedBox(height: 24),

                      // History
                      _buildSectionTitle('Geçmiş ve Kayıtlar', Icons.history, isDark),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        title: 'Anlık Geçmiş',
                        content: 'Aktif oyun sırasında "Geçmiş" butonuna basarak tüm atışları görebilirsiniz.',
                        icon: Icons.history,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoCard(
                        title: 'Kayıtlı Oyunlar',
                        content: 'Menü > Kayıtlı Oyunlar bölümünden daha önce kaydettiğiniz tüm oyunlara erişebilirsiniz.',
                        icon: Icons.folder_outlined,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoCard(
                        title: 'Oyuncu Logları',
                        content: 'Kayıtlı oyunların detay sayfasında her oyuncunun ayrı ayrı atışlarını ve toplam puanlarını görebilirsiniz.',
                        icon: Icons.person_search,
                        isDark: isDark,
                      ),

                      const SizedBox(height: 24),

                      // Settings
                      _buildSectionTitle('Ayarlar', Icons.settings, isDark),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        title: 'Tema Değiştirme',
                        content: 'Menüden açık ve koyu tema arasında geçiş yapabilirsiniz. Tercihleriniz otomatik olarak kaydedilir.',
                        icon: Icons.palette,
                        isDark: isDark,
                      ),

                      const SizedBox(height: 24),

                      // Tips
                      _buildSectionTitle('İpuçları', Icons.lightbulb, isDark),
                      const SizedBox(height: 12),
                      _buildTip(
                        tip: 'Tek kişi oynayacaksanız oyuncu sayısını 0 olarak bırakın.',
                        isDark: isDark,
                      ),
                      _buildTip(
                        tip: 'Oyunu bitirmeden kapatsanız bile aktif oyununuz kaybolmaz.',
                        isDark: isDark,
                      ),
                      _buildTip(
                        tip: 'Kayıtlı oyunları silmek için listedeki silme ikonuna basın.',
                        isDark: isDark,
                      ),
                      _buildTip(
                        tip: 'Titreşim geri bildirimi ile zarları atarken gerçekçi bir deneyim yaşayın.',
                        isDark: isDark,
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.secondaryDark.withOpacity(0.5)
            : AppColors.secondaryLight,
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? Colors.white : AppColors.textDark,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.highlightColor, AppColors.neonPurple],
              ),
              borderRadius: BorderRadius.circular(0),
            ),
            child: const Icon(
              Icons.menu_book,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Nasıl Kullanılır?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.highlightColor,
            AppColors.neonPurple,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.highlightColor.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: const Icon(
                  Icons.casino,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Zar Pro\'ya Hoş Geldiniz!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Profesyonel zar atma deneyimi',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(0),
            ),
            child: const Text(
              'Bu kılavuz, uygulamayı en verimli şekilde kullanmanız için hazırlanmıştır. Aşağıdaki bölümleri inceleyerek tüm özellikleri keşfedin!',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.highlightColor,
          size: 22,
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textDark,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildStep({
    required int number,
    required String title,
    required String description,
    required IconData icon,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  Colors.white.withOpacity(0.08),
                  Colors.white.withOpacity(0.04),
                ]
              : [
                  Colors.black.withOpacity(0.04),
                  Colors.black.withOpacity(0.02),
                ],
        ),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.highlightColor, AppColors.neonPurple],
              ),
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: AppColors.highlightColor,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? Colors.white.withOpacity(0.7)
                        : AppColors.textDark.withOpacity(0.7),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  Colors.white.withOpacity(0.08),
                  Colors.white.withOpacity(0.04),
                ]
              : [
                  Colors.black.withOpacity(0.04),
                  Colors.black.withOpacity(0.02),
                ],
        ),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.highlightColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(0),
            ),
            child: Icon(
              icon,
              color: AppColors.highlightColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? Colors.white.withOpacity(0.7)
                        : AppColors.textDark.withOpacity(0.7),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip({required String tip, required bool isDark}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.goldColor.withOpacity(0.1),
        border: Border.all(
          color: AppColors.goldColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.tips_and_updates,
            color: AppColors.goldColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white.withOpacity(0.8) : AppColors.textDark,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
