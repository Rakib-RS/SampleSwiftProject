////
////  FavoritesViewController.swift
////  GridProject
////
////  Created by macbook on 27/8/23.
////
//
//import SwiftUI
//
//struct FavoritesViewController: View {
//    var columns: [GridItem] = [
//        GridItem(.adaptive(minimum: 50, maximum: 300), spacing: 6, alignment: nil)
//    ]
//    var body: some View {
//        ScrollView {
//            LazyVGrid(
//                columns: columns,
//                alignment: .leading,
//                spacing: 10,
//                pinnedViews: [],
//                content: {
//                    Section(header: Text("Section 1")) {
//                        ForEach(0..<20) { index in
//                            Rectangle()
//                                .frame(height: 50)
//                        }
//                    }
//                }
//            )
//        }
//    }
//}
//
//struct FavoritesViewController_Previews: PreviewProvider {
//    static var previews: some View {
//        FavoritesViewController()
//    }
//}

import SwiftUI

struct FavoritesViewController: View {
    @State private var images: [UIImage] = []
    @State private var pictureInfo: [ImageInfo] = []
    private let api = "lgkyjtMJUDC18PPcrwYHZkTf7D1LKpp3QE6JVcKOABcwz2I7bB0hAbSD"
    @ObservedObject private var viewModel = ImageDownloader.shared
    @State private var imagesInfo: [ImageInfo] = []
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 10)], spacing: 10) {
                ForEach(viewModel.imagesInfo, id: \.self) { imageInfo in
                    Image(uiImage: imageInfo.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 100, maxHeight: 100)
                        .background(Color(.white))
                }
            }
            .padding()
            .background(Color(.gray))
            .onAppear {
                imagesInfo = viewModel.imagesInfo
            }
        }
    }

}


