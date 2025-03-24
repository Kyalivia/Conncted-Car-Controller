

import SwiftUI

struct TabButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .fontWeight(isSelected ? .bold : .light)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .bold : .light)
            }
            .foregroundColor(isSelected ? .white : .gray)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.gray.opacity(0.8) : Color.clear)
            )
        }
    }
}
