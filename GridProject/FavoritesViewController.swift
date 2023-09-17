import SwiftUI

struct FavoritesViewController: View {
    @State private var images: [UIImage] = []
    @State private var pictureInfo: [ImageInfo] = []
    private let api = "lgkyjtMJUDC18PPcrwYHZkTf7D1LKpp3QE6JVcKOABcwz2I7bB0hAbSD"
    @ObservedObject private var viewModel = ImageDownloader.shared
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 10)], spacing: 10) {
                ForEach(viewModel.imagesInfo.sorted(by: { $0.rating > $1.rating }), id: \.id) { imageInfo in
                    VStack(content: {
                        Image(uiImage: imageInfo.image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 100, maxHeight: 100)
                            .background(Color(.white))
                        ImageSlider(numberOfImages: imageInfo.rating)
                            .frame(width: 50)
                    })
                }
            }
            .padding()
            .background(Color(.gray))
        }
    }
    
}


