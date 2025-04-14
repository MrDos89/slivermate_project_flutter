import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';

// 가족 구성원  페이지
class UserInfoPage extends StatefulWidget {
  final UserVo? currentUser;

  const UserInfoPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  // API 관련
  static String ec2IpAddress = dotenv.get("EC2_IP_ADDRESS");
  static String ec2Port = dotenv.get("EC2_PORT");
  static final Dio dio = Dio();

  static String userGroupUrl = "http://$ec2IpAddress:$ec2Port/api/usergroup";

  late PersistCookieJar cookieJar;

  // 가족 구성원 목록
  List<UserVo> _familyMembers = [];
  bool _isLoading = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _initDio();
    _fetchFamilyMembers();
  }

  /// Dio + Cookie 초기화
  Future<void> _initDio() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    cookieJar = PersistCookieJar(
      storage: FileStorage("${appDocDir.path}/.cookies/"),
    );
    dio.interceptors.add(CookieManager(cookieJar));
  }

  /// 가족 구성원 목록 불러오기
  Future<void> _fetchFamilyMembers() async {
    if (widget.currentUser == null) {
      setState(() {
        _errorText = "현재 사용자 정보가 없습니다.";
      });
      return;
    }

    final int groupId = widget.currentUser!.groupId;
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final response = await dio.get("$userGroupUrl/$groupId");
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          // 전체 그룹 멤버 파싱
          List<UserVo> groupList =
              data
                  .map((e) => UserVo.fromJson(e as Map<String, dynamic>))
                  .toList();

          // 현재 로그인 사용자 타입
          final int myType = widget.currentUser!.userType;
          final int myUid = widget.currentUser!.uid;

          // 필터링 로직
          List<UserVo> filteredList = [];
          if (myType == 1) {
            // userType=1인 사람이 로그인한 경우 → userType=2인 사람들만 표시 (나 자신 제외)
            filteredList =
                groupList.where((member) {
                  // 1) 자신 제외
                  if (member.uid == myUid) return false;
                  // 2) userType=2 인 사람만
                  return member.userType == 2;
                }).toList();
          } else {
            // userType=2인 사람이 로그인 → 그룹 전체에서 자기 자신만 제외
            filteredList =
                groupList.where((member) {
                  // 자기 자신 제외
                  return member.uid != myUid;
                }).toList();
          }

          setState(() {
            _familyMembers = filteredList;
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            _errorText = "서버 응답 데이터가 리스트 형식이 아닙니다.";
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorText =
              "가족 구성원 정보를 가져오지 못했습니다. (status: ${response.statusCode})";
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorText = "오류 발생: $error";
      });
    }
  }

  /// "준비중" 다이얼로그 예시
  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("준비중"),
            content: const Text("해당 기능은 아직 준비중입니다."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("확인"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: HeaderPage(pageTitle: "가족 구성원"),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[100],
          child:
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorText != null
                  ? Center(child: Text(_errorText!))
                  : _buildFamilyList(),
        ),
      ),
    );
  }

  /// 가족 구성원 리스트를 빌드하는 위젯
  Widget _buildFamilyList() {
    if (_familyMembers.isEmpty) {
      return const Center(child: Text("가족 구성원 정보가 없습니다."));
    }

    return ListView.builder(
      itemCount: _familyMembers.length,
      itemBuilder: (context, index) {
        final member = _familyMembers[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage:
                  member.thumbnail.isNotEmpty
                      ? NetworkImage(member.thumbnail)
                      : null,
            ),
            title: Text(member.userName),
            subtitle: Text("아이디: ${member.userId}\n닉네임: ${member.nickname}"),
            isThreeLine: true,
            onTap: () {
              // TODO: 상세 페이지 혹은 다른 동작
              // 예: _showComingSoonDialog(context);
            },
          ),
        );
      },
    );
  }
}
