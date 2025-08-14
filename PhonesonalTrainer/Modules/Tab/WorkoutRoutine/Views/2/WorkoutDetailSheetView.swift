//
//  WorkoutDetailSheetView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/6/25.
//

import SwiftUI

// MARK: - Helper
enum YouTubeHelper {
    /// videoId 추출
    static func extractVideoID(from url: URL) -> String? {
        let host = (url.host ?? "").replacingOccurrences(of: "www.", with: "")
        let path = url.path

        // 1) https://youtu.be/VIDEOID?...
        if host == "youtu.be" {
            return path.split(separator: "/").first.map(String.init)
        }

        // 2) https://youtube.com/watch?v=VIDEOID
        if host.contains("youtube.com") && path.starts(with: "/watch") {
            let items = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
            return items?.first(where: { $0.name == "v" })?.value
        }

        return nil
    }

    /// 고화질 썸네일 URL
    static func thumbnailURL(for videoId: String) -> URL? {
        URL(string: "https://img.youtube.com/vi/\(videoId)/hqdefault.jpg")
    }
}

struct WorkoutDetailSheetView: View {
    // MARK: - Property
    let detail: WorkoutDetailModel
    
    @State private var isExpanded = false
    @State private var showYouTube = false
    @Environment(\.dismiss) private var dismiss  // ← 시트 닫기용
    
    // MARK: - Constants
    fileprivate enum SheetConstants {
        static let HPadding: CGFloat = 25
        static let xButtonSize: CGFloat = 20
        /// 운동 방법
        static let chevronSize: CGFloat = 16
        static let VHPadding: CGFloat = 20
        static let stepCircleSize: CGFloat = 20
        static let stepMainSpacing: CGFloat = 10
        static let VSpacing: CGFloat = 15  // 본문 vspacing
        /// 유의사항
        static let alertIconSize: CGFloat = 18  // 유의사항 아이콘
        static let cautionTextSpacing: CGFloat = 10
        /// 유튜브 썸네일
        static let thumbHeight: CGFloat = 180
        static let iconWidth: CGFloat = 50
        static let iconHeight: CGFloat = 37
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                /// 상단
                VStack(alignment: .leading) {
                    /// 운동 이름  + 'x'
                    HStack {
                        Text(detail.name)
                            .font(.PretendardSemiBold22)
                            .foregroundStyle(Color.grey06)
                        
                        Spacer()
                        
                        // X 닫기 버튼
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .foregroundStyle(.grey06)
                                .frame(width: SheetConstants.xButtonSize, height: SheetConstants.xButtonSize)
                        }
                    }
                    /// 부위 + 사용 근육들
                    Text("\(detail.bodyCategory.displayName) (\(detail.bodyParts.joined(separator: ", ")))")
                        .font(.PretendardMedium16)
                        .foregroundStyle(Color.grey03)
                }
                /// 운동 이미지
                workoutImage
                /// 운동 방법 토글
                workoutInstructions
                /// 운동 유의사항
                workoutCaution
                
                /// 유튜브 썸네일만,  클릭하면 서버 URL로 WebView
                youtubeThumbnail
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal, SheetConstants.HPadding)
        }
        .sheet(isPresented: $showYouTube) {
            if let url = detail.youtubeURL {
                YouTubeWebView(url: url).ignoresSafeArea()
            }
        }
    }
    
    // MARK: - 운동 이미지
    private var workoutImage: some View {
        Group {
            if let url = detail.imageURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Rectangle().fill(Color.grey01)
                            ProgressView()
                        }
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        ZStack {
                            Rectangle().fill(Color.grey01)
                            Text("이미지를 불러올 수 없어요")
                                .font(.PretendardRegular12)
                                .foregroundStyle(Color.grey03)
                        }
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                ZStack {
                    Rectangle().fill(Color.grey01)
                    Text("이미지 없음")
                        .font(.PretendardRegular12)
                        .foregroundStyle(Color.grey03)
                }
            }
        }
        .frame(height: 180)
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
    
    // MARK: - 운동 방법
    private var workoutInstructions: some View {
        VStack(spacing: 0) {
            // 헤더 (토근 버튼)
            Button {
                withAnimation(.easeInOut) { isExpanded.toggle() } // 애니메이션 넣을지 말지 고민...
            } label: {
                HStack {
                    Text("운동 방법")
                        .font(.PretendardSemiBold18)
                        .foregroundStyle(Color.grey06)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .frame(width: SheetConstants.chevronSize)
                        .foregroundStyle(Color.grey03)
                }
            }
            .padding(.horizontal, SheetConstants.VHPadding)
            .padding(.vertical, SheetConstants.VHPadding)
            .contentShape(Rectangle())
            
            // 본문
            if isExpanded {
                VStack(alignment: .leading, spacing: SheetConstants.VSpacing) {
                    let steps = detail.descriptions
                    ForEach(steps) { step in
                        HStack(alignment: .top, spacing: SheetConstants.stepMainSpacing) {
                            ZStack {
                                Circle()
                                    .fill(Color.orange02)
                                    .frame(width: SheetConstants.stepCircleSize, height: SheetConstants.stepCircleSize)
                                Text("\(step.step)")
                                    .font(.PretendardMedium12)
                                    .foregroundStyle(Color.orange05)
                            }
                            VStack(alignment: .leading, spacing: 5) {
                                Text(step.main)
                                    .font(.PretendardMedium16)
                                    .foregroundStyle(Color.grey06)
                                
                                Text(step.sub)
                                    .font(.PretendardRegular14)
                                    .foregroundStyle(Color.grey03)
                            }
                        }
                    }
                }
                .padding(.horizontal, SheetConstants.VHPadding)
                .padding(.bottom, SheetConstants.VHPadding)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.grey00)
                .shadow(color: .black.opacity(0.1), radius: 2)
        )
        .padding(.top, SheetConstants.VSpacing)
    }
    
    // MARK: - 운동 유의사항
    private var workoutCaution: some View {
        let cautionItems: [String] = detail.caution
            .split(separator: ".")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .map { "\($0)." } // 마침표 복원
        
        return VStack(alignment: .leading, spacing: SheetConstants.VSpacing) {
            HStack(spacing: 0) {
                Image("AlertIcon2")
                    .resizable()
                    .frame(width: SheetConstants.alertIconSize, height: SheetConstants.alertIconSize)
                    .padding(.trailing, 5)
                
                Text("유의사항")
                    .font(.PretendardSemiBold14)
                    .foregroundStyle(Color.grey03)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: SheetConstants.cautionTextSpacing) {
                ForEach(cautionItems, id: \.self) { item in
                    HStack {
                        Text("•")
                            .foregroundStyle(Color.grey02)
                        Text(item)
                            .foregroundStyle(Color.grey03)
                            .multilineTextAlignment(.leading)
                    }
                    .font(.PretendardMedium12)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, SheetConstants.VHPadding)
        .padding(.vertical, SheetConstants.VHPadding)
        .background(Color.orange01)
        .cornerRadius(5)
    }
    
    // MARK: - 유튜브 썸네일
    private var youtubeThumbnail: some View {
        Group {
            if let url = detail.youtubeURL,
                let id = YouTubeHelper.extractVideoID(from: url),
                let thumb = YouTubeHelper.thumbnailURL(for: id) {
                ZStack {
                    AsyncImage(url: thumb) { phase in
                        switch phase {
                        case .empty:
                            ZStack {
                                RoundedRectangle(cornerRadius: 5).fill(Color.grey01)
                                ProgressView()
                            }
                        case .success(let image):
                            image.resizable().scaledToFill()
                                .overlay(
                                    Image("youtubeIcon")
                                        .resizable()
                                        .frame(width: SheetConstants.iconWidth, height: SheetConstants.iconHeight)
                                )
                        case .failure:
                            ZStack {
                                RoundedRectangle(cornerRadius: 8).fill(Color.grey01)
                                HStack(spacing: 8) {
                                    Image(systemName: "play.rectangle.fill")
                                        .foregroundStyle(.red)
                                    Text("동영상 보기")
                                        .font(.PretendardMedium12)
                                        .foregroundStyle(Color.grey05)
                                }
                                
                            }
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                .frame(height: SheetConstants.thumbHeight)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .onTapGesture { showYouTube = true }
                .accessibilityAddTraits(.isButton)
                .accessibilityLabel("유튜브 동영상 재생")
            }
        }
    }
}

// #Preview {
//     WorkoutDetailSheetView()
// }
