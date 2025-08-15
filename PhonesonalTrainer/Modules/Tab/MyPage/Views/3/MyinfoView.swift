// MyInfoView.swift
import SwiftUI

struct MyInfoView: View {
    // ✅ 외부에서 바인딩으로 관리(부모의 단일 상태를 공유)
    @Binding var name: String

    // 편집 버튼 탭을 부모에게 알리는 콜백 (부모가 네비게이션 수행)
    let onTapEditName: () -> Void
    let onTapEditHeight: () -> Void

    // 더미 데이터 (API 붙이기 전)
    @State private var age: Int = 25
    @State private var gender: String = "여성"
    @State private var heightCm: Int = 165

    // "닉네임" 라벨 폭을 측정해서 모든 라벨에 공통 적용
    @State private var labelWidth: CGFloat = 0

    // Pretendard Medium 18 폰트 (라벨 측정 & 표시 통일)
    private let labelUIFont = UIFont(name: "Pretendard-Medium", size: 18) ?? .systemFont(ofSize: 18, weight: .medium)

    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            Text("내 정보")
                .font(.PretendardMedium20)
                .foregroundColor(.grey05)

            // 닉네임 (수정 버튼 O)
            row(label: "닉네임") {
                HStack(spacing: 10) {
                    Text(name.isEmpty ? "-" : name)
                        .font(.PretendardMedium18)
                        .foregroundColor(.grey05)

                    Button(action: { onTapEditName() }) {
                        Text("수정")
                            .font(.PretendardMedium12)
                            .foregroundStyle(.orange05)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.orange01)
                            .cornerRadius(30)
                    }
                }
            }

            // 나이
            row(label: "나이") {
                Text("\(age)세")
                    .font(.PretendardMedium18)
                    .foregroundColor(.grey05)
            }

            // 성별
            row(label: "성별") {
                Text(gender)
                    .font(.PretendardMedium18)
                    .foregroundColor(.grey05)
            }

            // 신장 (수정 버튼 O)
            row(label: "신장") {
                HStack(spacing: 10) {
                    Text("\(heightCm)cm")
                        .font(.PretendardMedium18)
                        .foregroundColor(.grey05)

                    Button(action: { onTapEditHeight() }) {
                        Text("수정")
                            .font(.PretendardMedium12)
                            .foregroundStyle(.orange05)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.orange01)
                            .cornerRadius(30)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        // 라벨 폭 측정 (PretendardMedium18 기준)
        .background(
            TextWidthReader(text: "닉네임", font: labelUIFont) { w in
                labelWidth = w
            }
            .frame(width: 0, height: 0)
            .hidden()
        )
    }

    // 공통 행: 라벨 고정폭(labelWidth) + 30 띄우고 값 영역
    @ViewBuilder
    private func row<L: View>(label: String, @ViewBuilder value: () -> L) -> some View {
        HStack(alignment: .center, spacing: 0) {
            Text(label)
                .font(.PretendardMedium18) // 표시도 18로 통일
                .foregroundColor(.grey03)
                .frame(width: labelWidth, alignment: .leading)

            Spacer().frame(width: 30) // 라벨 → 값 간격 30

            value()

            Spacer()
        }
    }
}

// 텍스트 실제 렌더 폭 측정 도우미
private struct TextWidthReader: UIViewRepresentable {
    let text: String
    let font: UIFont
    let onUpdate: (CGFloat) -> Void

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.font = font
        label.text = text
        label.sizeToFit()
        DispatchQueue.main.async { onUpdate(label.bounds.width) }
        return label
    }
    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.text = text
        uiView.font = font
        uiView.sizeToFit()
        DispatchQueue.main.async { onUpdate(uiView.bounds.width) }
    }
}

#Preview {
    NavigationStack {
        MyInfoView(
            name: .constant("서연"),
            onTapEditName: {},
            onTapEditHeight: {}
        )
    }
}
