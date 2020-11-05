//
//  CustomTextField.swift
//  laostra
//
//  Created by Daniel Mejia on 29/09/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//
import Combine
import SwiftUI

struct CustomTextField: UIViewRepresentable {

    class Coordinator: NSObject, UITextFieldDelegate {

        @Binding var text: String
        @Binding var codePosition: Int
        var didBecomeFirstResponder = false

        init(text: Binding<String>, codePosition: Binding<Int>) {
            _text = text
            _codePosition = codePosition
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.text = textField.text ?? ""
                
                if self.text != "" {
                    self.codePosition += 1
                }
            }
        }

    }

    @Binding var text: String
    @Binding var codePosition: Int
    var isFirstResponder: Bool = false

    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.keyboardType = .decimalPad
        textField.font = UIFont.systemFont(ofSize: 35.0)
        textField.textColor = UIColor(named: "primary")
        textField.textAlignment = .center
        return textField
    }

    func makeCoordinator() -> CustomTextField.Coordinator {
        return Coordinator(text: $text, codePosition: $codePosition)
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomTextField>) {
        uiView.text = text
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }
}
