import SwiftUI

struct ListViewController: View {
    @ObservedObject private var imageDownloader = ImageDownloader.shared
    @State private var selectedIndex: Int?
    @State private var isShowingDetail = false
    var body: some View {
        NavigationView {
            List {
                ForEach(imageDownloader.imagesInfo, id: \.self) { imageInfo in
                    NavigationLink(
                        destination: DetailViewController(id: imageInfo.id),
                        tag: imageInfo.id,
                        selection: $selectedIndex
                    ) {
                        HStack {
                            Image(uiImage: imageInfo.image)
                                .resizable()
                                .frame(width: 100, height: 100)
                            Spacer()
                            HStack {
                                ForEach(0..<imageInfo.rating, id: \.self) { index in
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                }
                            }
                            .frame(alignment: .center)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

//struct ListViewController_Previews: PreviewProvider {
//    static var previews: some View {
//        ListViewController()
//    }
//}
