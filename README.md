# 🗺️ TravelMuse
<div style="display: flex; flex-wrap: nowrap; overflow-x: auto; gap: 10px; margin-bottom: 20px;">
  <img src="https://github.com/user-attachments/assets/ede2370b-6541-4429-a74f-e4a318070d8a" width="1200" />
</div>

## 1.프로젝트 개요

TravelMuse는 사용자의 여행 성향을 분석하여 AI가 맞춤형 일정을 자동으로 추천하는 혁신적인 여행 앱입니다.
Flutter, Firebase, Gemini AI를 활용하여 개발되었으며,
트리플 앱의 기능을 벤치마킹하여 직관적인 지도 기반 일정 시각화를 구현했습니다.

**AI 기반 여행 일정 자동 추천 앱**

- Flutter + Firebase + Gemini AI를 활용한 혁신적인 여행 계획 플랫폼
- 트리플 앱 벤치마킹: 지도 기반 일정 시각화 지원
- 한국 특화 장소 탐색을 위한 Kakao API, 정밀 지도를 위한 Google Maps 활용


## 2.프로젝트 기간

- 시작일: 2025년 5월 29일

- 종료일: 2025년 7월 7일 (예정)






## 3.배포 및 테스트 정보
- 🔗 배포 URL: ''


## 4.팀 구성 및 역할

| 이름     | 역할         | 주요 담당 내용 |
|----------|--------------|----------------|
| **손진성** | 팀장 | 스플래시 화면 구현, 달력 및 지역 선택 기능, 마이페이지 개발, Git 설정 및 관리 |
| **김민지** | 팀원 | 구글 & 애플 로그인 기능 구현, Riverpod 상태 관리, 온보딩 프로세스, 사용자 프로필 설정 |
| **전진주** | 팀원 | 지도 페이지 개발, Kakao/Google 지도 API 연동, 검색 기능 구현, 일정 관리 시스템 구축 |
| **신성재** | 팀원 | 성향 테스트 기능, 홈 UI 구현, Gemini AI 연동, AI 추천받기 기능, 발표자료 작성 |
| **김민경** | 디자이너 | 전체 앱 디자인, 피그마 와이어프레임 설계, UI/UX 최적화 |



## 5.주요 기능

### 구글 & 애플 로그인 & 온보딩  
- 구글 계정 연동  
- 애플 계정 연동

### 성향 테스트  
- 여행 스타일 선호도 조사  
- AI 기반 분석으로 맞춤형 일정 추천

### 일정 등록 & 시각화  
- 날짜 설정 → 자동 일정 수립  
- 세부 일정 조정 시각화
- 지도 기반 일정 시각화

### 마이페이지 & 일정 관리  
- 단일/과거 일정 조회  
- 일정 저장기능  
- 장소 추가·삭제·커스터마이징


## 6.기술 스택

- **Flutter (MVVM + Riverpod)**: 구조화된 크로스플랫폼 앱, 효율적인 상태 관리  
- **Firebase**  
  - Auth: 사용자 인증  
  - Firestore: 실시간 DB  
  - Storage: 이미지/데이터 저장  
- **Google Maps API & Kakao 검색 API**: 최적화된 장소 검색 및 경로 제공  
- **Gemini AI**: 사용자 성향 분석, 자연어 요청 처리, 실시간 일정 최적화  

---

## 7.개발 환경

| 항목 | 내용 |
|------|------|
| **개발 언어** | Dart 3.8.0(Flutter 기반) |
| **프레임워크** | Flutter 3.32.0 (MVVM 구조 + Riverpod) |
| **백엔드 서비스** | Firebase (Auth, Firestore, Storage, Functions) |
| **AI 연동** | Gemini API (Google AI) |
| **지도 API** | Kakao Map API, Google Maps API |
| **디자인 툴** | [Figma](https://www.figma.com/design/t1huIotS4wJphGo76UObN1/2%EC%A1%B0---%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8%EB%AA%85---%ED%8C%80%EB%AA%85?node-id=31-207&p=f&t=LHQMN9OXTSoqIoQ1-0) |
| **패키지 관리** | pubspec.yaml, CocoaPods (iOS) |
| **IDE** | VS Code |
| **버전 관리** | Git + GitHub |

## 8.파일구조
```
assets/
lib/
├── constants/
│   ├── app_colors.dart
│   ├── app_other_styles.dart
│   └── app_text_styles.dart
│
├── core/
│   ├── widgets/
│   │   ├── bottom_bar.dart
│   │   ├── svg_icon.dart
│   │   ├── format_month_day.dart
│   │   ├── format_region.dart
│   │   ├── region_data.dart
│   │   └── validators.dart
│   └── models/
│       ├── app_user_model.dart
│       ├── calendar_model.dart
│       ├── home_place.dart
│       ├── home_state.dart
│       ├── map_state.dart
│       ├── place.dart
│       ├── plans.dart
│       ├── preference_test_model.dart
│       └── profile_state.dart
│
├── providers/
│   ├── bottom_bar_provider.dart
│   ├── calendar_location_provider.dart
│   ├── calendar_provider.dart
│   ├── home_view_model_provider.dart
│   ├── location_provider.dart
│   ├── map_provider.dart
│   ├── nearby_place_service_provider.dart
│   ├── place_search_service_provider.dart
│   ├── preference_test_provider.dart
│   ├── recent_search_provider.dart
│   ├── schedule_provider.dart
│   ├── search_provider.dart
│   └── selected_tag_provider.dart
│
├── repositories/
│   ├── app_user_repository.dart
│   ├── calendar_location_repository.dart
│   ├── location_repository.dart
│   ├── map_repository.dart
│   ├── plan_repository.dart
│   ├── preference_test_repository.dart
│   ├── schedule_repository.dart
│   └── search_history_repository.dart
│
├── services/
│   ├── ai_service.dart
│   ├── auth_service.dart
│   ├── nearby_place_service.dart
│   ├── place_search_service.dart
│   └── preference_test_service.dart
│
├── utils/
│   ├── ai_route_helper.dart
│   ├── date_utils.dart
│   ├── latlng_helper.dart
│   ├── map_utils.dart
│   └── marker_helper.dart
│
├── viewmodels/
│   ├── auth_view_model.dart
│   ├── calendar_location_view_model.dart
│   ├── calendar_view_model.dart
│   ├── home_view_model.dart
│   ├── map_view_model.dart
│   ├── preference_test_view_model.dart
│   ├── profile_view_model.dart
│   ├── schedule_view_model.dart
│   ├── search_view_model.dart
│   └── terms_agreement_view_model.dart
│
├── views/
│   ├── calendar/
│   │   ├── widgets/
│   │   │   ├── calendar_day_builder.dart
│   │   │   └── calendar_widget.dart
│   │   └── calendar_page.dart
│   ├── home/
│   │   ├── recommended_place/
│   │   │   ├── widgets/
│   │   │   │   ├── action_button_row.dart
│   │   │   │   ├── hashtag_selector.dart
│   │   │   │   ├── image_slider.dart
│   │   │   │   ├── location_row.dart
│   │   │   │   ├── place_description.dart
│   │   │   │   ├── place_direction_info.dart
│   │   │   │   ├── place_info_section.dart
│   │   │   │   ├── place_map_view.dart
│   │   │   │   ├── place_stats_row.dart
│   │   │   ├── recommended_carousel.dart
│   │   │   ├── recommended_place_list_card.dart
│   │   │   ├── recommended_restaurant_list_card.dart
│   │   │   ├── recommended_place_detail_page.dart
│   │   │   ├── recommended_places_list_page.dart
│   │   │   └── recommended_restaurant_list_page.dart
│   │   └── widgets/
│   │       ├── info_banner.dart
│   │       ├── popular_trips_list.dart
│   │       ├── recommended_places_list_card.dart
│   │       ├── recommended_restaurants_list.dart
│   │       ├── section_title.dart
│   │       └── travel_register_button.dart
│   └── home_page.dart
│
│   ├── location/
│   │   ├── widgets/
│   │   │   ├── day_tab_bar.dart
│   │   │   ├── map_display.dart
│   │   │   ├── map_page_app_bar.dart
│   │   │   ├── place_card.dart
│   │   │   ├── place_carousel.dart
│   │   │   └── map_page.dart
│
│   ├── login/
│   │   ├── widgets/
│   │   │   └── sns_login_bar.dart
│   │   └── login_page.dart
│
│   ├── my_page/
│   │   ├── sheet/
│   │   │   ├── widgets/
│   │   │   │   └── appbar_button.dart
│   │   │   └── edit_profile_page.dart
│   │   └── widgets/
│   │       ├── my_page_list_item.dart
│   │       ├── my_page_menu.dart
│   │       ├── my_profile_screen.dart
│   │       ├── my_page.dart
│   │       ├── plan_list_page.dart
│   │       └── preference_list_page.dart
│
│   ├── onboarding/
│   │   ├── widgets/
│   │   │   ├── check_duplicate_button.dart
│   │   │   ├── custom_check_toggle.dart
│   │   │   ├── duplicate_button_themes.dart
│   │   │   ├── edit_birth_date.dart
│   │   │   ├── select_gender.dart
│   │   │   ├── terms_agree_all.dart
│   │   │   ├── terms_agreement_title.dart
│   │   │   ├── terms_list.dart
│   │   │   └── terms_agreement_bottom_sheet.dart
│   │   └── onboarding_page.dart
│
│   ├── plan/
│   │   └── location_setting/
│   │       ├── widgets/
│   │       │   ├── district_box_item.dart
│   │       │   ├── district_box_list.dart
│   │       │   ├── province_box_item.dart
│   │       │   ├── province_box_list.dart
│   │       ├── district_setting_page.dart
│   │       └── province_setting_page.dart
│
│   ├── place_search/
│   │   ├── widgets/
│   │   │   ├── plan_place_card.dart
│   │   │   ├── recent_search_section.dart
│   │   │   ├── search_bar.dart
│   │   │   ├── search_result_list.dart
│   │   │   └── place_search_page.dart
│
│   ├── schedule/
│   │   ├── widgets/
│   │   │   ├── ai_button.dart
│   │   │   ├── ai_type_select_popup.dart
│   │   │   ├── bullet.dart
│   │   │   ├── day_schedule_section.dart
│   │   │   ├── dotted_line_vertical.dart
│   │   │   ├── ground_circle_icon.dart
│   │   │   ├── schedule_bottom_button.dart
│   │   │   ├── schedule_place_card.dart
│   │   │   └── type_select_item.dart
│   │   ├── schedule_page.dart
│   │   └── widgets/
│   │       └── schedule_app_bar.dart
│
│   ├── preference/
│   │   ├── widgets/
│   │   │   ├── intro_header.dart
│   │   │   ├── next_button.dart
│   │   │   ├── option_button.dart
│   │   │   ├── page_indicator_bar.dart
│   │   │   ├── preference_questions.dart
│   │   │   ├── question_card.dart
│   │   │   ├── question_list_view.dart
│   │   │   ├── result_action_buttons.dart
│   │   │   ├── result_view_detail.dart
│   │   │   ├── result_view.dart
│   │   │   ├── scroll_bar_indicator.dart
│   │   │   ├── start_button.dart
│   │   │   └── survey_preview_item.dart
│   │   ├── preference_intro_page_1.dart
│   │   ├── preference_intro_page_2.dart
│   │   ├── preference_loading_page.dart
│   │   └── preference_test_page.dart
│
│   ├── splash/
│   │   └── splash_page.dart
│
│   └── widgets/
│       ├── edit_nickname.dart
│       ├── edit_profile_image.dart
│       └── next_button.dart
│
├── firebase_options.dart
└── main.dart
```





## 9.Git 협업 전략 가이드

- [git 협업 전략 가이드](https://github.com/jinsung99123/travel_muse_app/wiki/Git-%ED%98%91%EC%97%85-%EC%A0%84%EB%9E%B5-%EA%B0%80%EC%9D%B4%EB%93%9C)


## 10.트러블슈팅 & 해결 사례
- [AI 추천 이후 Kakao API 연동 시 429 오류 발생 문제](https://github.com/jinsung99123/travel_muse_app/wiki/README-10.-AI-%EC%B6%94%EC%B2%9C-%EC%9D%B4%ED%9B%84-Kakao-API-%EC%97%B0%EB%8F%99-%EC%8B%9C-429-%EC%98%A4%EB%A5%98-%EB%B0%9C%EC%83%9D)
- [트러블 슈팅 MapPage 진입 시 앱 종료 및 TabController 오류 발생 문제](https://github.com/jinsung99123/travel_muse_app/wiki/README-10.-%ED%8A%B8%EB%9F%AC%EB%B8%94-%EC%8A%88%ED%8C%85-MapPage-%EC%A7%84%EC%9E%85-%EC%8B%9C-%EC%95%B1-%EC%A2%85%EB%A3%8C-%EB%B0%8F-TabController-%EC%98%A4%EB%A5%98-%ED%95%B4%EA%B2%B0)
- [바텀바 스택관리](https://github.com/jinsung99123/travel_muse_app/wiki/README-10.-%ED%8A%B8%EB%9F%AC%EB%B8%94-%EC%8A%88%ED%8C%85-%EB%B0%94%ED%85%80%EB%B0%94-%EC%8A%A4%ED%83%9D%EA%B4%80%EB%A6%AC)
- [이미지 업로드 지연 문제해결](https://github.com/jinsung99123/travel_muse_app/wiki/README-10.-%ED%8A%B8%EB%9F%AC%EB%B8%94-%EC%8A%88%ED%8C%85-%EC%9D%B4%EB%AF%B8%EC%A7%80-%EC%97%85%EB%A1%9C%EB%93%9C-%EC%A7%80%EC%97%B0-%EB%AC%B8%EC%A0%9C%ED%95%B4%EA%B2%B0)
- [캘린더 상태관리](https://github.com/jinsung99123/travel_muse_app/wiki/README-10.-%ED%8A%B8%EB%9F%AC%EB%B8%94-%EC%8A%88%ED%8C%85-%EC%BA%98%EB%A6%B0%EB%8D%94-%EC%83%81%ED%83%9C%EA%B4%80%EB%A6%AC)




## 11.앱 화면 미리보기

### 로그인 & 온보딩  

<div style="display: flex; flex-wrap: nowrap; overflow-x: auto; gap: 10px; margin-bottom: 20px;">
  <img src="https://github.com/user-attachments/assets/57c3199b-3f7d-4be2-97df-9b296e8c878f" width="200" />
  <img src="https://github.com/user-attachments/assets/3247135f-ff25-4748-8d08-7a6f44df4840" width="200" />
  <img src="https://github.com/user-attachments/assets/50f29303-c0e5-41e1-a36a-1ba132065ea8" width="200" />
  <img src="https://github.com/user-attachments/assets/e6a16cfc-b24d-488c-a692-9a01c29446ec" width="200" />
</div>
</br>

### 성향 테스트  
<div style="display: flex; flex-wrap: nowrap; overflow-x: auto; gap: 10px; margin-bottom: 20px;">
  <img src="https://github.com/user-attachments/assets/dc961921-05a0-4b67-8719-7d7a3696f186" width="200" />
  <img src="https://github.com/user-attachments/assets/fdd38469-7564-40c6-9aad-5a072e29344b" width="200" />
  <img src="https://github.com/user-attachments/assets/b7fb2e3f-7667-4d3d-b696-24145f340755" width="200" />
  <img src="https://github.com/user-attachments/assets/7374df4e-79be-4462-8eee-6efff86606bc" width="200" />
</div>
</br>

### 일정 등록 
<div style="display: flex; flex-wrap: nowrap; overflow-x: auto; gap: 10px; margin-bottom: 20px;">
  <img src="https://github.com/user-attachments/assets/7844b7cf-9422-447d-afba-6f1cdffb12e0" width="200" /> 
  <img src="https://github.com/user-attachments/assets/634286f7-c5b2-4adf-88e5-61278d6c8dcb" width="200" />
  <img src="https://github.com/user-attachments/assets/292d4a38-465e-4bf7-8536-00711b18a1d0" width="200" />
<img src="https://github.com/user-attachments/assets/ae16eccb-6300-45cc-8a5b-80ed3b24ba5d" width="200" />
  <img src="https://github.com/user-attachments/assets/56b9b68f-9efe-49de-93ea-d51396bdec35" width="200" />
</div>
</br>

### 명소 검색 & ai 일정 추천  
<div style="display: flex; flex-wrap: nowrap; overflow-x: auto; gap: 10px; margin-bottom: 20px;">
  <img src="https://github.com/user-attachments/assets/0c00ff31-b5a1-4ff8-b245-172fe22c9791" width="200" /> 
  <img src="https://github.com/user-attachments/assets/ef7ff989-08ec-4e42-86a5-953f0bd7c897" width="200" /> 
  <img src="https://github.com/user-attachments/assets/a808d484-4847-4ab1-8493-90f1e457455b" width="200" />
  <img src="https://github.com/user-attachments/assets/2415b5f1-cf5e-40ef-8b92-ae04a32d83ea" width="200" />
  <img src="https://github.com/user-attachments/assets/8553a2ad-716c-4479-b28c-d66f10f11d1d" width="200" />
</div>
</br>

### 지도 기반 시각화 & 마이페이지
<div style="display: flex; flex-wrap: nowrap; overflow-x: auto; gap: 10px; margin-bottom: 20px;">
  <img src="https://github.com/user-attachments/assets/1edc57da-ab62-487e-b78b-1a73c4b08ff1" width="200" /> 
  <img src="https://github.com/user-attachments/assets/e5e6cfbc-ea08-42da-be4f-4873a688a39a" width="200" /> 
  <img src="https://github.com/user-attachments/assets/beb1099e-2562-49cd-95e4-501e27dffb16" width="200" />
  <img src="https://github.com/user-attachments/assets/975a67ba-941c-48eb-81db-06a1d2db9ed2" width="200" />
  <img src="https://github.com/user-attachments/assets/6a0302e6-de70-4999-b142-d1890c3d9c31" width="200" />
</div>
</br>



## 12.후기 및 개선 계획
- 초기 버전 완성 후 사용자 피드백 수집 예정  
- 향후 기능: 여행 후기 게시판, ai 일정 자동 정렬, 관리자 페이지 추가 예정  



## 13.더 알아보기  
🎥 앱 데모 영상은 [TravleMuse](https://www.youtube.com/watch?v=npxDu1s38yM&t=1s)에서도 확인하실 수 있어요!



