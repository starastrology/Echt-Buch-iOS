//
//  CircleImage.swift
//  EchtBuch
//
//  Created by Daniel Frecka on 3/26/22.
//

import SwiftUI

struct CircleImage: View {
    var image: Image

        var body: some View {
            image
                .clipShape(Circle())
                .shadow(radius: 7)
        }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(image: Image("eb"))
            
            
    }
}
