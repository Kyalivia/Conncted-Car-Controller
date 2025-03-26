// SearchView.swift
import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: SearchViewModel
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        VStack(spacing: 20) {
                    if let message = viewModel.searchResultMessage {
                        Text(message)
                            .font(.callout)
                            .foregroundColor(message.contains("다시") ? .red : .white)
                            .bold()
                            .multilineTextAlignment(.center)
                    }

                    Button(action: {
                        withAnimation {
                            viewModel.startSearch()
                        }
                    }) {
                        Text("검색 시작")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.cyan)
                            .foregroundColor(.black)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
        .padding()
        .sheet(isPresented: $viewModel.isSearchSheetPresented) {
            VStack(spacing: 24) {
                Text("주소를 입력해주세요")
                    .font(.title2)
                    .bold()

                Text("대한민국 지명을 영어로 입력해주세요 (예: seoul)")
                    .font(.footnote)
                    .foregroundColor(.gray)

                TextField("예: seoul", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .focused($isTextFieldFocused)

                HStack(spacing: 16) {
                    Button(action: {
                        viewModel.sendSearchText()
                        isTextFieldFocused = false
                    }) {
                        Text("전송")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.cyan.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        viewModel.isSearchSheetPresented = false
                    }) {
                        Text("취소")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }
}
