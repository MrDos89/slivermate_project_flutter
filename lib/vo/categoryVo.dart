import 'package:dio/dio.dart';

class CategoryVo {
  final int categoryId;
  final String categoryName;
  final int subCategoryId;
  final String subCategoryName;
  final String image;
  final String updDate;

  CategoryVo({
    required this.categoryId,
    required this.categoryName,
    required this.subCategoryId,
    required this.subCategoryName,
    required this.image,
    required this.updDate,
  });

  //  JSON → 객체 변환
  factory CategoryVo.fromJson(Map<String, dynamic> json) {
    return CategoryVo(
      categoryId: json['category_id'] ?? 0,
      categoryName: json['category_name'] ?? "없음",
      subCategoryId: json['sub_category_id'] ?? 0,
      subCategoryName: json['sub_category_name'] ?? "없음",
      image: json['image'] ?? "",
      updDate: json['upd_date'] ?? "없음",
    );
  }
}

class CategoryService {
  static const String apiEndpoint =
      "http://13.125.197.66:18090/api/category"; // 서버 URL
  static final Dio dio = Dio();

  //  전체 카테고리 리스트 가져오기
  static Future<List<CategoryVo>> fetchCategories() async {
    try {
      final response = await dio.get(apiEndpoint);
      print(' [API 응답 성공] 상태 코드: ${response.statusCode}');
      print(' [API 응답 데이터]: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> data = response.data;

        //  JSON 리스트를 CategoryVo 객체 리스트로 변환
        return data.map((json) => CategoryVo.fromJson(json)).toList();
      } else {
        print('⚠ [서버 응답 이상] 코드: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('🚨 [API 요청 실패] 오류 발생: $e');
      return [];
    }
  }

  //  특정 카테고리 ID와 서브카테고리에 해당하는 데이터만 가져오기
  static Future<CategoryVo?> fetchCategoryData(
    int categoryId,
    int subCategoryId,
  ) async {
    final String url =
        "$apiEndpoint/sc/$categoryId/$subCategoryId"; //  URL 구조 변경

    print(' [API 요청 시작] 요청 URL: $url');

    try {
      final response = await dio.get(url);

      print(' [API 응답 성공] 상태 코드: ${response.statusCode}');
      print(' [API 응답 데이터]: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is List && response.data.isNotEmpty) {
          final parsedCategory = CategoryVo.fromJson(
            response.data[0],
          ); //  JSON을 CategoryVo로 변환
          print(' [JSON 파싱 성공]');
          return parsedCategory;
        } else {
          print('⚠ [서버 응답 데이터 없음]');
          return null;
        }
      } else {
        print('⚠ [서버 응답 이상] 코드: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print(' [API 요청 실패] 오류 발생: $e');
      return null;
    }
  }
}
