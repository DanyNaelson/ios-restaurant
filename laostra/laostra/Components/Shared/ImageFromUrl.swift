//
//  ImageFromUrl.swift
//  laostra
//
//  Created by Daniel Mejia on 06/08/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI

struct ImageFromUrl: View {
    @ObservedObject var imageLoader: ImageLoader
    
    init(imageUrl: String) {
        imageLoader = ImageLoader(imageUrl: imageUrl)
    }
    
    var body: some View {
        Image(uiImage: ((imageLoader.data.count == 0) ? UIImage(systemName: "photo") : UIImage(data: imageLoader.data))!)
    }
}
