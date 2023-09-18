import SwiftUI

struct FavoritesViewController: View {
    @State private var images: [UIImage] = []
    @State private var pictureInfo: [ImageInfo] = []
    private let api = "lgkyjtMJUDC18PPcrwYHZkTf7D1LKpp3QE6JVcKOABcwz2I7bB0hAbSD"
    @ObservedObject private var viewModel = ImageDownloader.shared
    var colums: [GridItem] = [
        GridItem(.fixed(100), spacing: 15, alignment: .leading),
        GridItem(.fixed(100), spacing: 15, alignment: .center),
        GridItem(.fixed(100), spacing: 15, alignment: .center)
    ]
    
    var body: some View {
        ScrollView {
            Text("Favorites")
                .font(.title)
                .frame(maxWidth: .infinity ,alignment: .leading)
                .padding(.leading, 10)
            LazyVGrid(columns: colums, spacing: 10) {
                ForEach(viewModel.imagesInfo.sorted(by: { $0.rating > $1.rating }), id: \.id) { imageInfo in
                    VStack(content: {
                        Image(uiImage: imageInfo.image)
                            .resizable()
                            .frame(height: 100)
                            //.background(Color(.white))
                        ImageSlider(numberOfImages: imageInfo.rating)
                            .frame(width: 50)
                    })
                }
            }
            .padding(.top, 20)
            .background(.gray)
        }
    }
    
}


