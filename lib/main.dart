import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

const String geminiApiKey = 'AQ.Ab8RN6I3n51SR5916_NS5xQ4HDPMb6q1tEiU9gSk9WVplh-yuQ'; // TODO: ใส่ Gemini API Key ที่นี่


void main() {
  runApp(const TrainTravelApp());
}

class TrainTravelApp extends StatelessWidget {
  const TrainTravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BKK Train Travel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

// === [โมเดลโครงสร้างข้อมูล] ===
class Station {
  final String id;
  final String name;
  final String lineName;
  final Color lineColor;

  const Station({
    required this.id,
    required this.name,
    required this.lineName,
    required this.lineColor,
  });
}

class UserReview {
  final String username;
  final double rating;
  final String comment;

  UserReview({
    required this.username,
    required this.rating,
    required this.comment,
  });
}

class Place {
  final String id; 
  final String name;
  final String category;
  final String description;
  final String exitNo;
  final String googleMapsUrl; 
  final String imageUrl; // พาธรูปภาพภายในเครื่อง เช่น assets/p1.jpg
  final Station station;
  final List<UserReview> reviews;
  final int baseFare; 
  bool isFavorite;    

  Place({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.exitNo,
    required this.googleMapsUrl,
    required this.imageUrl,
    required this.station,
    required this.reviews,
    this.baseFare = 20,
    this.isFavorite = false,
  });
}

// ==========================================
// 🔐 หน้า LOGIN SCREEN
// ==========================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent.withValues(alpha: 0.05),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '🚇 BKK Train Travel',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                      ),
                      const SizedBox(height: 8),
                      Text('กรุณาเข้าสู่ระบบเพื่อใช้งานแอพ', style: TextStyle(color: Colors.grey[600])),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'อีเมล / ชื่อผู้ใช้',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) => value == null || value.isEmpty ? 'กรุณากรอกอีเมล' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'รหัสผ่าน',
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) => value == null || value.isEmpty ? 'กรุณากรอกรหัสผ่าน' : null,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('เข้าสู่ระบบ', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterScreen()),
                          );
                        },
                        child: const Text('ยังไม่มีบัญชี? สมัครสมาชิกที่นี่', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 📝 หน้า REGISTER SCREEN
// ==========================================
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🎉 สมัครสมาชิกสำเร็จเรียบร้อย!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('สมัครสมาชิก'), backgroundColor: Colors.transparent, elevation: 0),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_add_alt_1_rounded, size: 70, color: Colors.blueAccent),
                const SizedBox(height: 16),
                const Text('สร้างบัญชีผู้ใช้ใหม่', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'อีเมล',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'กรุณากรอกอีเมล' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'รหัสผ่าน',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) => value == null || value.length < 6 ? 'รหัสผ่านต้องยาว 6 ตัวขึ้นไป' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'ยืนยันรหัสผ่าน',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'กรุณายืนยันรหัสผ่าน';
                    if (value != _passwordController.text) return 'รหัสผ่านไม่ตรงกัน';
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('ยืนยันการสมัครสมาชิก', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 🏠 หน้า HOME SCREEN
// ==========================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = "";
  bool _showOnlyFavorites = false; 
  List<Place>? _aiSearchResults;
  bool _isAILoading = false;

  
  final List<Station> _allStations = const [
    Station(id: 'mrt_blue', name: 'MRT สายสีน้ำเงิน', lineName: 'สายเฉลิมรัชมงคล', lineColor: Color(0xFF003399)),
    Station(id: 'bts_sukhumvit', name: 'BTS สายสุขุมวิท', lineName: 'สายสีเขียวอ่อน', lineColor: Color(0xFF52D017)),
    Station(id: 'bts_silom', name: 'BTS สายสีลม', lineName: 'สายสีเขียวเข้ม', lineColor: Color(0xFF006400)),
    Station(id: 'mrt_yellow', name: 'MRT สายสีเหลือง', lineName: 'รถไฟฟ้าโมโนเรล', lineColor: Color(0xFFFFCC00)),
    Station(id: 'mrt_purple', name: 'MRT สายสีม่วง', lineName: 'สายฉลองรัชธรรม', lineColor: Color(0xFF7F00FF)),
  ];

  late final List<Place> _allPlaces;

  @override
  void initState() {
    super.initState();
    
    final mrtBlue = _allStations[0];
    final btsSukhumvit = _allStations[1];
    final btsSilom = _allStations[2];
    final mrtYellow = _allStations[3];
    final mrtPurple = _allStations[4];

    _allPlaces = [
      // --- MRT สายสีน้ำเงิน ---
      Place(
        id: 'p1',
        name: 'วัดมังกรกมลาวาส (เล่งเน่ยยี่)',
        category: 'สายมู / วัด',
        description: 'วัดจีนเก่าแก่คู่ย่านเยาวราช นิยมมาทำบุญสะเดาะเคราะห์ แก้ชง และขอพรเพื่อความเป็นสิริมงคลให้ชีวิตราบรื่น',
        exitNo: 'MRT วัดมังกร - ทางออก 3',
        googleMapsUrl: 'https://www.google.com/maps/search/?api=1&query=%E0%B8%A7%E0%B8%B1%E0%B8%94%E0%B8%A1%E0%B8%B1%E0%B8%87%E0%B8%81%E0%B8%A3%E0%B8%81%E0%B8%A1%E0%B8%A5%E0%B8%B2%E0%B8%A7%E0%B8%B2%E0%B8%AA',
        imageUrl: 'assets/p1.jpg', 
        station: mrtBlue,
        baseFare: 24,
        reviews: [UserReview(username: 'สายมูตัวแม่', rating: 5, comment: 'มาแก้ชงทุกปี สบายใจมากค่ะ')],
      ),
      Place(
        id: 'p2',
        name: 'ถนนเยาวราช (Chinatown)',
        category: 'ของกิน / สตรีทฟู้ด',
        description: 'แหล่งรวมสตรีทฟู้ดระดับโลกที่มีอาหารคาวหวานให้เลือกละลานตา แสงสีป้ายไฟสวยงามมากในยามค่ำคืน',
        exitNo: 'MRT วัดมังกร - ทางออก 1',
        googleMapsUrl: 'https://www.google.com/maps/search/?api=1&query=%E0%B9%80%E0%B8%A2%E0%B8%B2%E0%B8%A7%E0%B8%A3%E0%B8%B2%E0%B8%8A',
        imageUrl: 'assets/p2.jpg', 
        station: mrtBlue,
        baseFare: 24,
        reviews: [UserReview(username: 'เด็กอ้วนชวนหิว', rating: 4, comment: 'ขนมปังอร่อยมาก แต่คนเยอะสุดๆ')],
      ),
      Place(
        id: 'p3',
        name: 'มิวเซียมสยาม (Museum Siam)',
        category: 'พิพิธภัณฑ์ / ถ่ายรูป',
        description: 'พิพิธภัณฑ์การเรียนรู้แนวใหม่ ตัวอาคารสไตล์โคโลเนียลสีเหลืองเด่นสง่า เหมาะแก่การเที่ยวชมและถ่ายภาพรูปชิค ๆ',
        exitNo: 'MRT สนามไชย - ทางออก 1',
        googleMapsUrl: 'https://www.google.com/maps/search/?api=1&query=Museum%20Siam',
        imageUrl: 'assets/p3.jpg', 
        station: mrtBlue,
        baseFare: 31,
        reviews: [],
      ),
      Place(
        id: 'p9',
        name: 'วัดพระเชตุพนวิมลมังคลาราม (วัดโพธิ์)',
        category: 'สายมู / วัด / ประวัติศาสตร์',
        description: 'วัดโบราณที่ขึ้นชื่อระดับโลก มีพระพุทธไสยาสน์ (พระนอน) องค์ใหญ่สวยงาม และเป็นแหล่งนวดแผนไทยต้นตำรับ',
        exitNo: 'MRT สนามไชย - ทางออก 2',
        googleMapsUrl: 'https://www.google.com/maps/search/?api=1&query=%E0%B8%A7%E0%B8%B1%E0%B8%94%E0%B9%82%E0%B8%9E%E0%B8%98%E0%B8%B4%E0%B9%8C',
        imageUrl: 'assets/p9.jpg',
        station: mrtBlue,
        baseFare: 31,
        reviews: [UserReview(username: 'TouristBKK', rating: 5, comment: 'Beautiful temple, highly recommended!')],
      ),
      Place(
        id: 'p10',
        name: 'ตลาดนัดจ๊อดแฟร์ (Jodd Fairs)',
        category: 'ของกิน / ตลาดนัดกลางคืน',
        description: 'ตลาดนัดกลางคืนสุดฮิตยอดนิยมของทั้งชาวไทยและต่างชาติ แหล่งรวมของกินแฟชั่น เสื้อผ้าวัยรุ่น บรรยากาศสุดคึกคัก',
        exitNo: 'MRT พระราม 9 - ทางออก 2',
        googleMapsUrl: 'https://www.google.com/maps/search/?api=1&query=Jodd%20Fairs%20Rama%209',
        imageUrl: 'assets/p10.jpg',
        station: mrtBlue,
        baseFare: 26,
        reviews: [],
      ),

      // --- BTS สายสุขุมวิท ---
      Place(
        id: 'p4',
        name: 'ตลาดนัดจตุจักร (Chatuchak Market)',
        category: 'ช้อปปิ้ง / เสื้อผ้า',
        description: 'ตลาดนัดขนาดใหญ่ระดับตำนาน แหล่งรวมแฟชั่น เสื้อผ้า ต้นไม้ ของตกแต่งบ้าน และของกินอร่อย ๆ ยามวันหยุดสุดสัปดาห์',
        exitNo: 'BTS หมอชิต - ทางออก 1',
        googleMapsUrl: 'https://www.google.com/maps/search/?api=1&query=Chatuchak%20Weekend%20Market',
        imageUrl: 'assets/p4.jpg', 
        station: btsSukhumvit,
        baseFare: 17,
        reviews: [UserReview(username: 'ช้อปเปอร์', rating: 5, comment: 'เดินตั้งแต่เช้ายันเย็น ของถูกใจเยอะมาก')],
      ),
      Place(
        id: 'p5',
        name: 'สยามพารากอน (Siam Paragon)',
        category: 'ช้อปปิ้ง / ห้างสรรพสินค้า',
        description: 'ศูนย์การค้าระดับโลกใจกลางกรุงเทพมหานคร แหล่งรวมแบรนด์เนมหรู โรงภาพยนตร์ และพิพิธภัณฑ์สัตว์น้ำใต้ดินขนาดใหญ่',
        exitNo: 'BTS สยาม - ทางออก 3',
        googleMapsUrl: 'https://www.google.com/maps/search/?api=1&query=Siam%20Paragon',
        imageUrl: 'assets/p5.jpg', 
        station: btsSukhumvit,
        baseFare: 43,
        reviews: [],
      ),
      Place(
        id: 'p11',
        name: 'หอศิลปวัฒนธรรมแห่งกรุงเทพมหานคร (BACC)',
        category: 'พิพิธภัณฑ์ / ศิลปะ / ถ่ายรูป',
        description: 'พื้นที่จัดแสดงงานศิลปะร่วมสมัย ใจกลางเมือง มีนิทรรศการหมุนเวียนให้เข้าชมฟรี เดินเสพงานศิลป์ถ่ายรูปมุมบันไดวนสุดฮิต',
        exitNo: 'BTS สนามกีฬาแห่งชาติ - ทางออก 3',
        googleMapsUrl: 'https://www.google.com/maps/search/?api=1&query=Bangkok%20Art%20and%20Culture%20Centre',
        imageUrl: 'assets/p11.jpg',
        station: btsSukhumvit,
        baseFare: 17,
        reviews: [UserReview(username: 'เสพศิลป์', rating: 4.8, comment: 'แอร์เย็น งานดี เดินเพลินมากครับ')],
      ),
      Place(
        id: 'p12',
        name: 'บ้านศิลปิน คลองบางหลวง',
        category: 'ชุมชนเก่า / ศิลปะ / คาเฟ่',
        description: 'ชุมชนริมคลองโบราณ มีกิจกรรมร้อยลูกปัด ระบายสีปูนปลาสเตอร์ และชมการแสดงโขนหุ่นละครเล็กฟรีในบรรยากาศฮีลใจ',
        exitNo: 'BTS บางหว้า - ต่อวินมอเตอร์ไซค์',
        googleMapsUrl: 'https://www.google.com/maps/search/?api=1&query=%E0%B8%9A%E0%B9%89%E0%B8%B2%E0%B8%99%E0%B8%A8%E0%B8%B4%E0%B8%A5%E0%B8%9B%E0%B8%B4%E0%B8%99%20%E0%B8%84%E0%B8%A5%E0%B8%AD%E0%B8%87%E0%B8%9A%E0%B8%B2%E0%B8%87%E0%B8%AB%E0%B8%A5%E0%B8%A7%E0%B8%87',
        imageUrl: 'assets/p12.jpg',
        station: btsSukhumvit,
        baseFare: 35,
        reviews: [],
      ),

      // --- BTS สายสีลม ---
      Place(
        id: 'p7',
        name: 'สวนลุมพินี (Lumpini Park)',
        category: 'สวนสาธารณะ / พักผ่อน',
        description: 'ปอดขนาดใหญ่ใจกลางกรุงเทพฯ สวนสาธารณะร่มรื่นมีทะเลสาบสำหรับปั่นเรือเป็ด บรรยากาศเงียบสงบเหมาะแก่การพักผ่อน',
        exitNo: 'BTS ศาลาแดง - ทางออก 6',
        googleMapsUrl: 'https://www.google.com/maps/search/?api=1&query=Lumpini%20Park',
        imageUrl: 'assets/p7.jpg', 
        station: btsSilom,
        baseFare: 28,
        reviews: [UserReview(username: 'คนชอบวิ่ง', rating: 4.5, comment: 'ร่มรื่น ลมเย็น เหมาะกับการมาออกกำลังกายตอนเย็น')],
      ),
      Place(
        id: 'p13',
        name: 'ไอคอนสยาม (ICONSIAM)',
        category: 'ช้อปปิ้ง / ห้างสรรพสินค้า / ริมแม่น้ำ',
        description: 'อภิมหาโครงการเมืองริมแม่น้ำเจ้าพระยา แหล่งรวมความหรูหรา มีโซนสุขสยามจำลองตลาดน้ำในร่ม และลานน้ำพุเต้นระบำสุดอลังการ',
        exitNo: 'BTS เจริญนคร / BTS สะพานตากสิน ต่อเรือรับส่ง',
        googleMapsUrl: 'https://www.google.com/maps/search/?api=1&query=ICONSIAM',
        imageUrl: 'assets/p13.jpg',
        station: btsSilom,
        baseFare: 45,
        reviews: [UserReview(username: 'LuxuryLife', rating: 5, comment: 'ห้างสวยมาก วิวริมแม่น้ำตอนกลางคืนคือเด็ด')],
      ),
      Place(
        id: 'p14',
        name: 'สะพานช่องนนทรี (Chong Nonsi Skywalk)',
        category: 'ถ่ายรูป / แสงสีเมือง',
        description: 'สะพานลอยฟ้าสถาปัตยกรรมโมเดิร์นทรงโครงเหล็ก แลนด์มาร์คถ่ายรูปยอดฮิตของตากล้องสาย Cityscape ท่ามกลางตึกสูงช่องนนทรี',
        exitNo: 'BTS ช่องนนทรี - ทางออก 3',
        googleMapsUrl: 'https://www.google.com/maps/search/?api=1&query=Chong%20Nonsi%20Skywalk',
        imageUrl: 'assets/p14.jpg',
        station: btsSilom,
        baseFare: 22,
        reviews: [],
      ),

      // --- MRT สายสีเหลือง ---
      Place(
        id: 'p6',
        name: 'ตลาดนัดรถไฟ ศรีนครินทร์',
        category: 'ตลาดนัดกลางคืน / ของกิน',
        description: 'ตลาดนัดกลางคืนสไตล์วินเทจสุดฮิต แหล่งรวมของสะสมโบราณ เสื้อผ้าแนว ๆ และร้านอาหารสตรีทฟู้ดมากมายหลังห้างซีคอนสแควร์',
        exitNo: 'MRT สวนหลวง ร.9 - ทางออก 1',
        googleMapsUrl: 'https://www.google.com/maps/search/?api=1&query=%E0%B8%95%E0%B8%A5%E0%B8%B2%E0%B8%94%E0%B8%99%E0%B8%B1%E0%B8%94%E0%B8%A3%E0%B8%96%E0%B9%84%E0%B8%9F%20%E0%B8%A8%E0%B8%A3%E0%B8%B5%E0%B8%99%E0%B8%84%E0%B8%A3%E0%B8%B4%E0%B8%99%E0%B8%97%E0%B8%A3%E0%B9%8C',
        imageUrl: 'assets/p6.jpg', 
        station: mrtYellow,
        baseFare: 35,
        reviews: [],
      ),
      Place(
        id: 'p15',
        name: 'สวนหลวง ร.9',
        category: 'สวนสาธารณะ / ดอกไม้ / พักผ่อน',
        description: 'สวนสาธารณะและสวนพฤกษศาสตร์ที่ใหญ่ที่สุดในกรุงเทพฯ มีหอรัชมงคลสถาปัตยกรรมเด่นตระหง่าน และสวนนานาชาติให้เดินชม',
        exitNo: 'MRT สวนหลวง ร.9 - ต่อรถรับส่งเข้าสวน',
        googleMapsUrl: 'https://www.google.com/maps/search/?api=1&query=%E0%B8%AA%E0%B8%A7%E0%B8%99%E0%B8%AB%E0%B8%A5%E0%B8%A7%E0%B8%87%20%E0%B8%A3.9',
        imageUrl: 'assets/p15.jpg',
        station: mrtYellow,
        baseFare: 20,
        reviews: [UserReview(username: 'คนรักต้นไม้', rating: 4.7, comment: 'ช่วงธันวาคมงานพรรณไม้งามสวยมากค่ะ')],
      ),

      // --- MRT สายสีม่วง ---
      Place(
        id: 'p8',
        name: 'Central Westgate บางใหญ่',
        category: 'ช้อปปิ้ง / ห้างสรรพสินค้า',
        description: 'ห้างสรรพสินค้าคอมเพล็กซ์ขนาดใหญ่ยักษ์ฝั่งนนทบุรี เดินเลือกซื้อสินค้าแบรนด์เนมและเลือกซื้อเฟอร์นิเจอร์ที่ Ikea ได้ครบถ้วน',
        exitNo: 'MRT ตลาดบางใหญ่ - ทางออก 4',
        googleMapsUrl: 'https://www.google.com/maps/search/?api=1&query=Central%20Westgate',
        imageUrl: 'assets/p8.jpg', 
        station: mrtPurple,
        baseFare: 45,
        reviews: [],
      ),
      Place(
        id: 'p16',
        name: 'วัดบรมราชากาญจนาภิเษกอนุสรณ์ (วัดเล่งเน่ยยี่ 2)',
        category: 'สายมู / วัด / ถ่ายรูป',
        description: 'วัดจีนนิกายรังสรรค์ขนาดมหึมาในนนทบุรี สถาปัตยกรรมแบบพระราชวังต้องห้ามของจีน สวยงาม อลังการ สายถ่ายรูปและแก้ชงต้องมา',
        exitNo: 'MRT คลองบางไผ่ - ต่อรถรับส่ง/แท็กซี่',
        googleMapsUrl: 'https://www.google.com/maps/search/?api=1&query=%E0%B8%A7%E0%B8%B1%E0%B8%94%E0%B9%80%E0%B8%A5%E0%B9%88%E0%B8%87%E0%B9%80%E0%B8%99%E0%B9%88%E0%B8%A2%E0%B8%A2%E0%B8%B5%E0%B9%88%202',
        imageUrl: 'assets/p16.jpg',
        station: mrtPurple,
        baseFare: 35,
        reviews: [UserReview(username: 'ตี๋ใหญ่', rating: 5, comment: 'อลังการเหมือนอยู่เมืองจีนเลยครับ')],
      ),
      Place(
        id: 'p17',
        name: 'อุทยานมกุฏรมยสราญ',
        category: 'สวนสาธารณะ / พักผ่อน',
        description: 'สวนสาธารณะร่มรื่นใจกลางเมืองนนทบุรี อยู่ติดศาลากลางจังหวัด มีสระน้ำขนาดใหญ่ ร่มรื่นด้วยต้นไม้ใหญ่ เหมาะสำหรับคนเมืองมาพักผ่อนและออกกำลังกาย',
        exitNo: 'MRT ศูนย์ราชการนนทบุรี - ทางออก 1',
        googleMapsUrl: 'https://www.google.com/maps/search/?api=1&query=%E0%B8%AD%E0%B8%B8%E0%B8%97%E0%B8%A2%E0%B8%B2%E0%B8%99%E0%B8%A1%E0%B8%81%E0%B8%B8%E0%B8%8F%E0%B8%A3%E0%B8%A1%E0%B8%A2%E0%B8%AA%E0%B8%A3%E0%B8%B2%E0%B8%8D',
        imageUrl: 'assets/p17.jpg',
        station: mrtPurple,
        baseFare: 21,
        reviews: [],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final filteredPlaces = _allPlaces.where((place) {
      final matchesSearch = place.name.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                            place.category.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFavorite = !_showOnlyFavorites || place.isFavorite;
      return matchesSearch && matchesFavorite;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('BKK Train Travel 🚇', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_showOnlyFavorites ? Icons.favorite : Icons.favorite_border, color: Colors.white),
            onPressed: () {
              setState(() {
                _showOnlyFavorites = !_showOnlyFavorites;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.white),
            tooltip: 'ค้นหาสถานที่ด้วยรูปภาพ (AI)',
            onPressed: _pickImageAndIdentify,
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.amber[100],
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.gpp_good_rounded, color: Colors.green[800], size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'สถานะวันนี้: รถไฟฟ้าทุกสายเปิดให้บริการตามปกติ 🟢 ไม่มีเหตุขัดข้อง',
                    style: TextStyle(fontSize: 12, color: Colors.green[900], fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                        _aiSearchResults = null; // Reset AI search when typing manually
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'พิมพ์ค้นหา หรือให้ AI ช่วยหา...',
                      prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.purpleAccent,
                  tooltip: '✨ ให้ AI ช่วยหา',
                  onPressed: () => _performAISearch(_searchQuery),
                  child: const Icon(Icons.auto_awesome, color: Colors.white),
                ),
              ],
            ),
          ),
          if (_isAILoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(),
            ),
          Expanded(
            child: filteredPlaces.isEmpty
              ? const Center(child: Text('❌ ไม่พบสถานที่ท่องเที่ยวที่คุณค้นหา หรือไม่มีรายการโปรด', style: TextStyle(fontSize: 14, color: Colors.grey)))
              : _searchQuery.isNotEmpty || _showOnlyFavorites
                  ? _buildSearchResults(filteredPlaces)
                  : _buildGroupedListView(filteredPlaces),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedListView(List<Place> displayList) {
    return ListView.builder(
      itemCount: _allStations.length,
      itemBuilder: (context, index) {
        final stationLine = _allStations[index];
        final placesInLine = displayList.where((p) => p.station.id == stationLine.id).toList();

        if (placesInLine.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              margin: const EdgeInsets.only(top: 12, bottom: 6),
              color: stationLine.lineColor.withValues(alpha: 0.15),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 24,
                    decoration: BoxDecoration(color: stationLine.lineColor, borderRadius: BorderRadius.circular(4)),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    stationLine.name,
                    style: TextStyle(
                      fontSize: 17, 
                      fontWeight: FontWeight.bold, 
                      color: stationLine.lineColor == const Color(0xFFFFCC00) ? Colors.orange[700] : stationLine.lineColor
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text('(${stationLine.lineName})', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: placesInLine.length,
              itemBuilder: (context, pIndex) {
                return _buildPlaceCard(placesInLine[pIndex]);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchResults(List<Place> results) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) => _buildPlaceCard(results[index]),
    );
  }

  Widget _buildPlaceCard(Place place) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailScreen(place: place)),
            );
            setState(() {}); 
          },
          child: Row(
            children: [
              Image.asset(
                place.imageUrl,
                width: 110,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 110,
                    height: 110,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported, color: Colors.grey),
                  );
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(place.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(place.category, style: const TextStyle(color: Colors.blueAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.directions_transit, size: 14, color: place.station.lineColor),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(place.exitNo, style: TextStyle(color: Colors.grey[600], fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: Icon(place.isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.redAccent),
                onPressed: () {
                  setState(() {
                    place.isFavorite = !place.isFavorite;
                  });
                },
              ),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }

  // --- AI Features ---
  Future<GenerateContentResponse> _generateContentWithFallback(List<Content> content, {bool isImage = false}) async {
    final models = isImage 
        ? ['gemini-1.5-flash', 'gemini-1.5-pro', 'gemini-pro-vision', 'gemini-1.0-pro-vision']
        : ['gemini-1.5-flash', 'gemini-1.5-pro', 'gemini-pro', 'gemini-1.0-pro'];
    
    String lastError = "";
    for (String modelName in models) {
      try {
        final model = GenerativeModel(model: modelName, apiKey: geminiApiKey);
        final response = await model.generateContent(content);
        return response; // ถ้าสำเร็จให้คืนค่าทันที
      } catch (e) {
        lastError = e.toString();
        print('ลองใช้ Model $modelName แล้วล้มเหลว: $e');
        continue; // ถ้าล้มเหลวให้ลองรุ่นถัดไป
      }
    }
    throw Exception('ไม่สามารถเชื่อมต่อได้ทุกรุ่น (กรุณาตรวจสอบว่า API Key ถูกต้องหรือไม่): $lastError');
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('✨ AI Assistant'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ตกลง'))
        ],
      ),
    );
  }

  Future<void> _performAISearch(String query) async {
    if (query.trim().isEmpty) {
      _showErrorDialog('กรุณาพิมพ์สิ่งที่คุณต้องการให้ AI ค้นหาก่อนครับ');
      return;
    }
    if (geminiApiKey == 'YOUR_API_KEY') {
      _showErrorDialog('กรุณาใส่ Gemini API Key ในโค้ดตัวแปร geminiApiKey ก่อนใช้งาน AI');
      return;
    }
    
    setState(() => _isAILoading = true);
    try {
      // สร้างข้อมูลสถานที่ฉบับย่อให้ AI ดู
      final placesData = _allPlaces.map((p) => '{id: "${p.id}", name: "${p.name}", category: "${p.category}", description: "${p.description}"}').join(',\n');
      
      final prompt = '''
คุณคือ AI แนะนำสถานที่ท่องเที่ยวในกรุงเทพตามแนวรถไฟฟ้า
ผู้ใช้พิมพ์ค้นหาว่า: "$query"
จงวิเคราะห์ความต้องการของผู้ใช้ และเลือก id ของสถานที่ที่เหมาะสมจากรายการต่อไปนี้:
[$placesData]

ให้ตอบกลับมาเฉพาะ id ของสถานที่ที่แนะนำ โดยคั่นด้วยเครื่องหมายจุลภาค (comma) เท่านั้น ห้ามมีข้อความอื่น
ถ้าไม่มีสถานที่ที่ตรงเลย ให้ตอบว่า NONE
''';

      final content = [Content.text(prompt)];
      final response = await _generateContentWithFallback(content, isImage: false);
      final text = response.text?.trim() ?? 'NONE';
      
      if (text == 'NONE' || text.isEmpty) {
        _showErrorDialog('AI ไม่พบสถานที่ที่ตรงกับความต้องการของคุณ ลองค้นหาด้วยคำอื่นดูนะครับ');
      } else {
        final ids = text.split(',').map((e) => e.trim()).toList();
        setState(() {
          _aiSearchResults = _allPlaces.where((p) => ids.contains(p.id)).toList();
        });
      }
    } catch (e) {
      _showErrorDialog('เกิดข้อผิดพลาดในการเชื่อมต่อ AI: $e');
    } finally {
      setState(() => _isAILoading = false);
    }
  }

  Future<void> _pickImageAndIdentify() async {
    if (geminiApiKey == 'YOUR_API_KEY') {
      _showErrorDialog('กรุณาใส่ Gemini API Key ในโค้ดตัวแปร geminiApiKey ก่อนใช้งาน AI');
      return;
    }
    
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile == null) return;
    
    setState(() => _isAILoading = true);
    
    try {
      final bytes = await pickedFile.readAsBytes();
      
      final placesData = _allPlaces.map((p) => '{id: "${p.id}", name: "${p.name}"}').join(',\n');
      
      final prompt = TextPart('''
วิเคราะห์รูปภาพสถานที่นี้ และตรวจสอบว่าตรงกับสถานที่ใดในรายการนี้หรือไม่
[$placesData]

ถ้าใช่ ให้ตอบกลับมาเป็น ID ของสถานที่นั้นเพียงอย่างเดียว (เช่น p1)
ถ้าไม่ใช่ หรือไม่แน่ใจ ให้ตอบว่า UNKNOWN
''');
      final imagePart = DataPart('image/jpeg', bytes);
      
      final response = await _generateContentWithFallback([
        Content.multi([prompt, imagePart])
      ], isImage: true);
      
      final resultId = response.text?.trim() ?? 'UNKNOWN';
      
      if (resultId == 'UNKNOWN' || resultId.isEmpty) {
        _showErrorDialog('AI ไม่สามารถระบุสถานที่นี้ได้ หรือไม่มีสถานที่นี้ในระบบของเรา');
      } else {
        final matchedPlaceList = _allPlaces.where((p) => p.id == resultId).toList();
        if (matchedPlaceList.isNotEmpty) {
          final matchedPlace = matchedPlaceList.first;
          // พาไปหน้า DetailScreen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailScreen(place: matchedPlace)),
          ).then((_) => setState(() {}));
        } else {
          _showErrorDialog('AI ค้นพบสถานที่แต่วิเคราะห์ ID ผิดพลาด ($resultId)');
        }
      }
    } catch (e) {
      _showErrorDialog('เกิดข้อผิดพลาดในการเชื่อมต่อ AI: $e');
    } finally {
      setState(() => _isAILoading = false);
    }
  }
}


// ==========================================
// 📄 หน้าแสดงรายละเอียดสถานที่ท่องเที่ยว (DETAIL SCREEN)
// ==========================================
class DetailScreen extends StatefulWidget {
  final Place place;
  const DetailScreen({super.key, required this.place});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _commentController = TextEditingController();
  double _userRating = 5.0;
  int _stationCount = 1; 

  void _showReviewDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('✍️ เขียนรีวิวสถานที่'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('ให้คะแนนสถานที่นี้:'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < _userRating ? Icons.star : Icons.star_border,
                        color: Colors.orange,
                        size: 32,
                      ),
                      onPressed: () {
                        setDialogState(() {
                          _userRating = index + 1.0;
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    hintText: 'พิมพ์ความคิดเห็นของคุณที่นี่...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ยกเลิก'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_commentController.text.isNotEmpty) {
                    setState(() {
                      widget.place.reviews.add(UserReview(
                        username: 'คุณ (ผู้ใช้ทั่วไป)',
                        rating: _userRating,
                        comment: _commentController.text,
                      ));
                    });
                    _commentController.clear();
                    _userRating = 5.0;
                    Navigator.pop(context);
                  }
                },
                child: const Text('บันทึกรีวิว'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _launchMaps(String urlString) async {
    final Uri url = Uri.parse(urlString);

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    int calculatedFare = widget.place.baseFare + (_stationCount * 2);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: widget.place.station.lineColor,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: Icon(widget.place.isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.white),
                onPressed: () {
                  setState(() {
                    widget.place.isFavorite = !widget.place.isFavorite;
                  });
                },
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero, // ลบ Padding เพื่อให้ Container แถบดำขยายเต็มหน้ากว้าง
              centerTitle: true,
              title: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                // 🖤 ใส่กรอบพื้นหลังสีดำโปร่งแสงตรงนี้ เพื่อผลักชื่อสถานที่ให้เห็นเด่นชัด 100%
                color: Colors.black.withValues(alpha: 0.4), 
                child: Text(
                  widget.place.name, 
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, 
                    color: Colors.white, 
                    fontSize: 16,
                  ),
                ),
              ),
              background: Image.asset(widget.place.imageUrl, fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 0,
                    color: Colors.blueAccent.withValues(alpha: 0.05), 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.train, color: widget.place.station.lineColor),
                              const SizedBox(width: 8),
                              Text(widget.place.station.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.exit_to_app, color: Colors.redAccent),
                              const SizedBox(width: 8),
                              Text(widget.place.exitNo, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('📝 รายละเอียด:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(widget.place.description, style: const TextStyle(fontSize: 14, height: 1.5)),
                  
                  const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider()),

                  const Text('🎫 คำนวณค่าเดินทางโดยประมาณ:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        const Text('จำนวนสถานีที่นั่งมา: ', style: TextStyle(fontSize: 14)),
                        DropdownButton<int>(
                          value: _stationCount,
                          items: List.generate(15, (index) => index + 1).map((val) {
                            return DropdownMenuItem<int>(value: val, child: Text('$val สถานี'));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _stationCount = value ?? 1;
                            });
                          },
                        ),
                        const Spacer(),
                        Text('$calculatedFare บาท', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                      ],
                    ),
                  ),

                  const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider()),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('💬 รีวิวจากผู้ใช้งาน', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ElevatedButton.icon(
                        onPressed: _showReviewDialog,
                        icon: const Icon(Icons.rate_review),
                        label: const Text('เขียนรีวิว'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  widget.place.reviews.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Text('ยังไม่มีรีวิวสำหรับสถานที่นี้ มารีวิวคนแรกกันมึง!', style: TextStyle(color: Colors.grey)),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.place.reviews.length,
                          itemBuilder: (context, index) {
                            final rev = widget.place.reviews[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                title: Row(
                                  children: [
                                    Text(rev.username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                    const Spacer(),
                                    Row(
                                      children: List.generate(5, (starIdx) {
                                        return Icon(
                                          starIdx < rev.rating ? Icons.star : Icons.star_border,
                                          color: Colors.orange,
                                          size: 16,
                                        );
                                      }),
                                    )
                                  ],
                                ),
                                subtitle: Text(rev.comment),
                              ),
                            );
                          },
                        ),
                  
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () => _launchMaps(widget.place.googleMapsUrl),
                      icon: const Icon(Icons.map, color: Colors.white),
                      label: const Text('เปิด Google Maps นำทาง', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}