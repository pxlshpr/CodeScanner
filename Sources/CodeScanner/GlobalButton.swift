import SwiftUI

func global_button(action: (() -> Void)? = nil, image: String, alwaysDarkShadow: Bool = false) -> some View {
    Group {
        if image.contains("circle.fill") {
            Button(action: { action?() }) {
                Image(systemName: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 55, height: 55)
                    .foregroundColor(Color.accentColor)
                    .background(Color(.systemBackground))
                    .clipShape(Circle())
                    .shadow(color: alwaysDarkShadow ? Color.red : Color.blue, radius: 2, x: 0, y: 1)
//                    .shadow(color: alwaysDarkShadow ? Color("ShadowDark") : Color("ShadowColor"), radius: 2, x: 0, y: 1)
            }
        } else {
            Button(action: { action?() }) {
                ZStack {
                    Circle()
                        .frame(width: 55, height: 55)
                        .foregroundColor(Color.accentColor)
                        .clipShape(Circle())
                        .shadow(color: alwaysDarkShadow ? Color.red : Color.blue, radius: 2, x: 0, y: 1)
//                        .shadow(color: alwaysDarkShadow ? Color("ShadowDark") : Color("ShadowColor"), radius: 2, x: 0, y: 1)
                    Image(systemName: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28, height: 28)
                        .foregroundColor(Color(.systemBackground))
                }
            }
            
        }
    }
}
