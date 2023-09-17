//
//  DetailViewController.swift
//  GridProject
//
//  Created by macbook on 28/8/23.
//

import SwiftUI

struct DetailViewController: View {
    // @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var sliderValue: Double
    @State private var id: Int
    @Environment(\.presentationMode) var presentationMode
    
    init(id: Int) {
        _id = State(initialValue: id)
        _sliderValue = State(initialValue: Double(ImageDownloader.shared.getRating(with: id)))
        
        print("sliderValue: \(sliderValue)")
    }
    
    var body: some View {
        VStack(
            alignment: .center,
            spacing: 10,
            content: {
                ImageSlider(numberOfImages: Int(sliderValue))
                    .frame(height: 50)
                
                Slider(
                    value: $sliderValue,
                    in: 1...5,
                    step: 1
                ) {
                    Text("Speed")
                } minimumValueLabel: {
                    Text("1")
                } maximumValueLabel: {
                    Text("5")
                } onEditingChanged: { editing in
                }
                .padding()
                
                Button("Save") {
                    ImageDownloader.shared.updateRaing(with: id, newRating: Int(sliderValue))
                    presentationMode.wrappedValue.dismiss()
                    
                }
                
                .font(.headline)
                .padding()
                
            }
        )
    }
    
}

struct ImageSlider: View {
    let numberOfImages: Int
    
    var body: some View {
        HStack(
            alignment: .center,
            spacing: 0,
            content: {
                ForEach(0..<numberOfImages, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.yellow)
                }
            }
        )
    }
}

struct DetailViewController_Previews: PreviewProvider {
    static var previews: some View {
        DetailViewController(id: 1)
    }
}
