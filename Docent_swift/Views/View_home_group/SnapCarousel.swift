//
//  SnapCarousel.swift
//  Docent_swift
//
//  Created by 성재 on 2022/10/20.
//

import SwiftUI

struct SnapCarousel<Content: View, T: Identifiable>: View {
    
    var content: (T) -> Content
    var list: [T]
    
    // Properties
    var spacing : CGFloat
    var trailingSpace: CGFloat
    @Binding var index: Int
    
    init(spacing: CGFloat = 15, trailingSpace: CGFloat = 100, index: Binding<Int>, items: [T], @ViewBuilder content: @escaping (T)->Content) {
        
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
    }
    
    // Offset...
    @GestureState var offset: CGFloat = 0
    @State var currentIndex: Int = 0
    @State var curIdxChange : Int = 0       // 부드러운 전환 효과를 위해
    @State var nextIndex : Int = 0
    
    var body: some View {
        GeometryReader { proxy in
            
            // setting correct width for snap Carousel
            
            let width = proxy.size.width - (trailingSpace - spacing)
            let adjustMentWidth = (trailingSpace / 2) - spacing
            
            HStack(spacing: spacing) {
                ForEach(list) { item in
                    let getIndexx = getIndex(item: item)
                    content(item)
                        .frame(width: proxy.size.width - trailingSpace)
                        .scaleEffect((curIdxChange == 1) || (getIndexx == index) ? 1 : 0.85)
                        .opacity(getIndexx == index ? 1 : 0.5)
                }
            }
            // Spacing will be horizontal padding...
            .padding(.horizontal, spacing)
            // setting only after 0th index..
            .offset(x: (CGFloat(currentIndex) * -width) + offset)
            // 중앙 정렬
//            .offset(x: (CGFloat(currentIndex) * -width) + adjustMentWidth + offset)
            .gesture(
                DragGesture()
                    .updating($offset, body: { value, out, _ in
                        out = value.translation.width
                    })
                    .onEnded({ value in
                        // Updating Current Index
                        let offsetX = value.translation.width
                        
                        // were going to convert the translatino into progress(0-1)
                        // and round thre value
                        // based on the progress increasing or decreasing the currentIndex
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        // setting min
                        currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                        curIdxChange = 0
                        // updating index
                        currentIndex = index
                    })
                    .onChanged({ value in
                        // updatin only index
                        
                        // Updating Current Index
                        let offsetX = value.translation.width
                        
                        // were going to convert the translatino into progress(0-1)
                        // and round thre value
                        // based on the progress increasing or decreasing the currentIndex
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        // setting min
                        index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                        curIdxChange = 1
                    })
            )
        }
        // Animating when offset = 0
        .animation(.easeInOut, value: offset == 0)

       
    }
    
    func getIndex(item: T) -> Int {
        let index = list.firstIndex { currentItem in
            return currentItem.id == item.id
        } ?? 0
        
        return index
    }

}

struct SnapCarousel_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
