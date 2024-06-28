//
//  DialogMessageView.swift
//  Survey
//
//  Created by Lukasz on 28/06/2024.
//
//  This is success dialog which shown after answer submission

import SwiftUI

struct SuccessDialogMessageView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                /// Indicate success also with image
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .padding(.trailing)
                
                Text("Success!")
                    .font(.title2)
                    .foregroundStyle(.white)
            }
        }
        .multilineTextAlignment(.leading)
        .padding(30)
        .frame(maxWidth: .infinity)
        .background(.green)
        .mask {
            RoundedRectangle(cornerRadius: 15)
        }
        .padding(10)
    }
}

#Preview {
    SuccessDialogMessageView()
}
