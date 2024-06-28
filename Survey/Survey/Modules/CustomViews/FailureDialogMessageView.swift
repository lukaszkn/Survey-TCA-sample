//
//  FailureDialogMessageView.swift
//  Survey
//
//  Created by Lukasz on 28/06/2024.
//

import SwiftUI

struct FailureDialogMessageView<Button>: View where Button: View  {
    @ViewBuilder let button: () -> Button
    
    var body: some View {
        VStack() {
            HStack {
                Image(systemName: "checkmark.circle.badge.xmark.fill")
                    .resizable()
                    .frame(width: 35, height: 30)
                    .foregroundColor(.white)
                    .padding(.trailing)
                
                Text("Failure....")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .padding(.trailing)
                
                button()
                    .padding(.leading, 20)
            }
        }
        .multilineTextAlignment(.center)
        .padding(30)
        .frame(maxWidth: .infinity)
        .background(.red)
        .mask {
            RoundedRectangle(cornerRadius: 15)
        }
        .padding(10)
    }
}

#Preview {
    FailureDialogMessageView() {
        Button("Retry") {
        }
        .buttonStyle(.borderedProminent)
    }
}
