//
//  DialogMessageView.swift
//  Survey
//
//  Created by Lukasz on 28/06/2024.
//

import SwiftUI

struct SuccessDialogMessageView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
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
