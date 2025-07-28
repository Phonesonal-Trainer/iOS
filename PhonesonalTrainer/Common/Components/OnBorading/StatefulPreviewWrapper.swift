//
//  StatefulPreviewWrapper.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/28/25.
//


import SwiftUI

struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State private var value: Value
    private let content: (Binding<Value>) -> Content

    init(_ initialValue: Value, @ViewBuilder content: @escaping (Binding<Value>) -> Content) {
        _value = State(wrappedValue: initialValue)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}
