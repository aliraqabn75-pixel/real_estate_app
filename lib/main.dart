import 'package:flutter/material.dart';

void main() {
  runApp(const RealEstateApp());
}

class RealEstateApp extends StatelessWidget {
  const RealEstateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق العقارات',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF6F6F6),
        useMaterial3: true,
      ),
      // البداية من الشاشة الترحيبية
      home: const WelcomeScreen(),
    );
  }
}

// ==========================================
// 1. الشاشة الترحيبية (Welcome Screen)
// ==========================================
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // خلفية بتدرج ألوان جذاب
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF004D40), Color(0xFF00897B)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // أيقونة الشعار
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.home_work_rounded,
                      size: 90,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'أهلاً بك في تطبيق العقارات',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'منصتك الأولى للبحث عن المنازل والعقارات، وإضافة إعلاناتك والتواصل المباشر في العراق.',
                    style: TextStyle(fontSize: 15, color: Colors.white70, height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  // زر البدء للدخول للرئيسية
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF004D40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const MainScreen()),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ابدأ التصفح الآن',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_back, size: 20),
                        ],
                      ),
             ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// نموذج بيانات العقار
class Property {
  final String id;
  final String title;
  final String category;
  final String city;
  final String price;
  final String description;
  final String ownerName;

  Property({
    required this.id,
    required this.title,
    required this.category,
    required this.city,
    required this.price,
    required this.description,
    required this.ownerName,
  });
}

// ==========================================
// 2. الشاشة الرئيسية للتطبيق
// ==========================================
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // إدارة الصلاحيات
  String userRole = 'user'; // 'user', 'leader', 'admin'
  String currentUserName = 'مستخدم زائر';

  final Map<String, Map<String, String>> _usersDatabase = {
    'admin': {'password': '123', 'role': 'admin', 'name': 'المدير العام'},
    'leader': {'password': '123', 'role': 'leader', 'name': 'الليدر أحمد'},
  };

  String selectedCategory = 'سكني';
  String selectedCity = 'الكل';

  final List<String> categories = ['سكني', 'أراضي / زراعي', 'تجاري', 'صناعي'];
  final List<String> cities = [
    'بغداد', 'النجف', 'ذي قار', 'صلاح الدين', 'أربيل', 'السليمانية',
    'كربلاء', 'الأنبار', 'واسط', 'ميسان', 'دهوك', 'المثنى',
    'البصرة', 'بابل', 'ديالى', 'القادسية', 'الموصل', 'كركوك'
  ];

  // قائمة العقارات الديناميكية
  List<Property> propertiesList = [
    Property(
      id: '1',
      title: 'منزل حديث للبيع في بغداد',
      category: 'سكني',
      city: 'بغداد',
      price: '\$180,000',
      description: 'منزل مساحة 200 متر مربع، طابقين، يحتوي على 4 غرف نوم وكراج ومجلس واسع.',
      ownerName: 'المدير العام',
    ),
    Property(
      id: '2',
      title: 'شقة فاخرة للبيع في النجف',
      category: 'سكني',
      city: 'النجف',
      price: '\$95,000',
      description: 'شقة حديثة البناء في مجمع سكني متكامل الخدمات قريبة من المطار.',
      ownerName: 'الليدر أحمد',
    ),
  ];

  void _resetToHome() {
    setState(() {
      _selectedIndex = 0;
      selectedCategory = 'سكني';
      selectedCity = 'الكل';
    });
  }

  // إضافة عقار جديد (متاحة للجميع مع ميزات إضافية للمدير/الليدر)
  void _showAddPropertyDialog() {
    final titleController = TextEditingController();
    final priceController = TextEditingController();
    final descController = TextEditingController();
    String dialogCategory = selectedCategory;
    String dialogCity = cities.first;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      userRole == 'admin' || userRole == 'leader'
                          ? 'إضافة عقار جديد ($currentUserName)'
                          : 'أضف إعلانك الخاص',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
     TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'عنوان الإعلان/المنزل',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: 'السعر (مثال: \$120,000)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: dialogCategory,
                        items: categories.map((cat) {
                          return DropdownMenuItem(value: cat, child: Text(cat));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) dialogCategory = val;
                        },
                        decoration: const InputDecoration(labelText: 'القسم', border: OutlineInputBorder()),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: dialogCity,
                        items: cities.map((c) {
                          return DropdownMenuItem(value: c, child: Text(c));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) dialogCity = val;
                        },
                        decoration: const InputDecoration(labelText: 'المحافظة', border: OutlineInputBorder()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'تفاصيل العقار والمواصفات',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (titleController.text.isNotEmpty && priceController.text.isNotEmpty) {
                        setState(() {
                          propertiesList.add(
                            Property(
                              id: DateTime.now().toString(),
                              title: titleController.text,
                              category: dialogCategory,
                              city: dialogCity,
                              price: priceController.text,
                              description: descController.text.isEmpty
                                  ? 'لا توجد تفاصيل إضافية.'
                                  : descController.text,
                              ownerName: currentUserName,
                            ),
                          );
                        });
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم نشر الإعلان بنجاح!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    child: const Text('نشر الإعلان الآن', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
              ),
          ),
        );
      },
    );
  }

  void _showLoginDialog() {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    String? errorMessage;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Row(
                children: [
                  Icon(Icons.lock_person, color: Colors.teal),
                  SizedBox(width: 10),
                  Text('تسجيل الدخول للمديرين', style: TextStyle(fontSize: 18)),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (errorMessage != null)
                    Text(errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 13)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(labelText: 'اسم المستخدم', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'كلمة السر', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 8),
                  const Text('* مدير: admin / 123  |  ليدر: leader / 123', style: TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('إلغاء'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                  onPressed: () {
                    String u = usernameController.text.trim();
                    String p = passwordController.text.trim();
                    if (_usersDatabase.containsKey(u) && _usersDatabase[u]!['password'] == p) {
                      setState(() {
                        userRole = _usersDatabase[u]!['role']!;
                        currentUserName = _usersDatabase[u]!['name']!;
                      });
                      Navigator.pop(dialogContext);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('تم الدخول بصلاحية: $currentUserName'), backgroundColor: Colors.green),
                      );
                    } else {
                      setDialogState(() {
                        errorMessage = 'بيانات الدخول غير صحيحة!';
                      });
                    }
                  },
                  child: const Text('دخول'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _logout() {
    setState(() {
      userRole = 'user';
      currentUserName = 'مستخدم زائر';
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تسجيل الخروج')));
  }

  @override
  Widget build(BuildContext context) {
    // تصفية العقارات حسب الفئة والمحافظة المختارة
    final filteredProperties = propertiesList.where((p) {
      bool matchesCategory = p.category == selectedCategory;
      bool matchesCity = selectedCity == 'الكل' || p.city == selectedCity;
      return matchesCategory && matchesCity;
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            // 0. الشاشة الرئيسية
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // شريط البحث والرجوع
                  Container(
                    color: const Color(0xFF00897B),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 22),
                          onPressed: _resetToHome,
                        ),
                        Expanded(
                          child: Container(
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const TextField(
                              decoration: InputDecoration(
                                hintText: 'ابحث في عقارات...',
                                hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                                prefixIcon: Icon(Icons.search, color: Colors.grey),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.notifications_none, color: Colors.white, size: 26),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'عقارات للبيع ($selectedCategory)',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Text(
                                  selectedCity == 'الكل' ? 'كل المدن' : selectedCity,
                                  style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                                ),
                                const Icon(Icons.location_on_outlined, color: Colors.grey),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // فلترة الفئات
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final cat = categories[index];
                              final isSelected = selectedCategory == cat;
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: FilterChip(
                                  label: Text(cat),
                                  selected: isSelected,
                                  selectedColor: Colors.teal.shade100,
                                  onSelected: (val) {
                                    setState(() {
                                      selectedCategory = cat;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),

                        // فلترة المحافظات
                        const Text('اختر المحافظة:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: cities.map((city) {
                            final isSelected = selectedCity == city;
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedCity = isSelected ? 'الكل' : city;
                                });
                              },
                              child: Container(
                                width: (MediaQuery.of(context).size.width - 56) / 3,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.teal : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  city,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.black87,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),

                        // كرت التحكم الإداري (للمدير والليدر)
                        if (userRole == 'admin' || userRole == 'leader')
                          Card(
                            color: Colors.teal.shade50,
                            margin: const EdgeInsets.only(bottom: 15),
                            child: ListTile(
                              leading: const Icon(Icons.admin_panel_settings, color: Colors.teal, size: 30),
                              title: Text('لوحة إضافة العقارات الإدارية ($currentUserName)'),
                              subtitle: const Text('إمكانية إضافة وإدارة بيوت وإعلانات في كافة المحافظات'),
                              trailing: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                                onPressed: _showAddPropertyDialog,
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text('إضافة عقار'),
                              ),
                            ),
                          ),

                        // قائمة العقارات مع فتح التفاصيل والمشاركة
                        const Text('قائمة العقارات المتاحة:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),

                        filteredProperties.isEmpty
                            ? Container(
                                padding: const EdgeInsets.all(30),
                                alignment: Alignment.center,
                                child: const Text('لا توجد عقارات مطابقة في هذا القسم حالياً.'),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filteredProperties.length,
                                itemBuilder: (context, index) {
                                  final prop = filteredProperties[index];
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 15),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PropertyDetailsScreen(property: prop),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 160,
                                            decoration: BoxDecoration(
                                              color: Colors.teal.shade100,
                                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                            ),
                                            child: const Center(
                                              child: Icon(Icons.home_outlined, size: 70, color: Colors.teal),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(prop.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                                    Text(prop.price, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
                                                  ],
                                                ),
                                                const SizedBox(height: 6),
                                                Row(
                                                  children: [
                                                    Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                                                    Text(' ${prop.city} • ${prop.category}', style: TextStyle(color: Colors.grey.shade600)),
                                                    const Spacer(),
                                                    const Text('اضغط للتفاصيل والمشاركة', style: TextStyle(color: Colors.teal, fontSize: 12, fontWeight: FontWeight.bold)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 1. شاشة الدردشات العامة (لكافة الأشخاص)
            const ChatScreen(),

            // 2. إضافة إعلان (لكافة الأشخاص)
            Center(
              child: Padding(
              padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_home_work_outlined, size: 80, color: Colors.teal),
                    const SizedBox(height: 15),
                    const Text('نشر عقار أو إعلان جديد', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    const Text('يمكن للجميع الآن نشر عقاراتهم وإعلاناتهم مباشرة ليراها كافّة المستخدِمين.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                      ),
                      onPressed: _showAddPropertyDialog,
                      icon: const Icon(Icons.add_circle_outline),
                      label: const Text('إضافة إعلان جديد الآن', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),

            // 3. إعلاناتي
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.assignment_outlined, size: 70, color: Colors.teal),
                  const SizedBox(height: 10),
                  Text('إعلاناتك المسجلة ($currentUserName)', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: _showAddPropertyDialog,
                    child: const Text('أضف إعلانك الأول'),
                  )
                ],
              ),
            ),

            // 4. حسابي / إدارة الصلاحيات
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(userRole == 'user' ? Icons.person_outline : Icons.admin_panel_settings, size: 80, color: Colors.teal),
                  const SizedBox(height: 10),
                  Text('الحساب الحالي: $currentUserName', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('نوع الصلاحية: $userRole', style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 25),
                  if (userRole == 'user')
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                      onPressed: _showLoginDialog,
                      icon: const Icon(Icons.login),
                      label: const Text('تسجيل دخول كـ (مدير / ليدر)'),
                    )
                  else
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                      onPressed: _logout,
                      icon: const Icon(Icons.logout),
                      label: const Text('تسجيل الخروج'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),

      // الشريط السفلي للتنقل
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          const BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'الدردشات'),
          const BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline, size: 35, color: Colors.orange), label: 'أضف إعلان'),
          const BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'إعلاناتي'),
          BottomNavigationBarItem(
            icon: Icon(userRole == 'user' ? Icons.person_outline : Icons.admin_panel_settings),
            label: userRole == 'user' ? 'حسابي' : currentUserName,
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 3. شاشة الدردشات العامة المفتوحة للجميع
// ==========================================
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> messages = [
    {'sender': 'علي', 'text': 'السلام عليكم، هل المنزل المتاح في النجف ما زال معروضاً؟'},
    {'sender': 'الليدر أحمد', 'text': 'وعليكم السلام، نعم الشقة والمنزل متوفران حالياً.'},
    {'sender': 'سارة', 'text': 'ما هي أسعار الأراضي في بغداد اليوم؟'},
  ];

  final TextEditingController messageController = TextEditingController();

  void _sendMessage() {
    if (messageController.text.trim().isNotEmpty) {
      setState(() {
        messages.add({
          'sender': 'أنت (زائر/مستخدم)',
          'text': messageController.text.trim(),
        });
        messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('غرفة الدردشة العامة للمستخدمين'),
        backgroundColor: const Color(0xFF00897B),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg['sender']!.contains('أنت');
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.teal.shade100 : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg['sender']!,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.teal.shade900),
                        ),
                        const SizedBox(height: 4),
                        Text(msg['text']!, style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'اكتب رسالتك للجميع هنا...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.teal),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// ==========================================
// 4. شاشة تفاصيل المنزل + مشاركة التطبيق
// ==========================================
class PropertyDetailsScreen extends StatelessWidget {
  final Property property;

  const PropertyDetailsScreen({super.key, required this.property});

  void _shareAppAndProperty(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('مشاركة العقار والتطبيق', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              ListTile(
                leading: const Icon(Icons.share, color: Colors.blue),
                title: const Text('نسخ رابط العقار والتطبيق'),
                subtitle: Text('https://realestate-app.com/property/${property.id}'),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم نسخ رابط المشاركة بنجاح!'), backgroundColor: Colors.teal),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.message, color: Colors.green),
                title: const Text('إرسال عبر الواتساب / الرسائل'),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم توجيه المشاركة للتطبيقات الخارجية')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(property.title),
        backgroundColor: const Color(0xFF00897B),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'مشاركة العقار والتطبيق',
            onPressed: () => _shareAppAndProperty(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 230,
              width: double.infinity,
              color: Colors.teal.shade200,
              child: const Center(
                child: Icon(Icons.home_work, size: 100, color: Colors.teal),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          property.title,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        property.price,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Chip(label: Text(property.city), backgroundColor: Colors.teal.shade50),
                      const SizedBox(width: 8),
                      Chip(label: Text(property.category), backgroundColor: Colors.grey.shade200),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text('تفاصيل المنزل والعقار:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    property.
                    description,
                    style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  Text('الناشر / صاحب الإعلان: ${property.ownerName}', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('جاري الاتصال بالمالك...')),
                            );
                          },
                          icon: const Icon(Icons.phone),
                          label: const Text('اتصال بمالك المنزل'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () => _shareAppAndProperty(context),
                          icon: const Icon(Icons.share),
                          label: const Text('مشاركة الإعلان'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
