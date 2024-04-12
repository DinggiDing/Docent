//
//  View_home.swift
//  Docent_swift
//
//  Created by 성재 on 2022/09/02.
//

import SwiftUI
import Kingfisher

struct View_home: View {
    @State var currentIndex: Int = 0
    @EnvironmentObject var SGRM : SelectGRM
    @State var opacity : Double = 1
    @EnvironmentObject var Top_kkk : ShopAPI
    @State var showDetailView = false
    @State var currentDetailItem: Item?
    @EnvironmentObject var baseData : BaseViewModel
    
    // Enviorment Values
    @Namespace var animation

    var body: some View {
        let data = Top_kkk.searchResult?.items ?? []

        GeometryReader { geo in

            VStack(alignment: .leading) {
                Text(SGRM.Gr_sent!).font(.custom("RIDIBatang", size:26, relativeTo: .title))
                    .lineSpacing(16)
                    .padding(.leading, 15)
                    .foregroundColor(Color("BW"))
                    .multilineTextAlignment(.leading)
                    .frame(width: geo.size.width, height: geo.size.height*0.3, alignment: .leading)
                    .padding(.bottom, 10)
                    .opacity(opacity)
                    .onAppear {
                        let baseAnimation = Animation.linear(duration: 1).delay(3)
                        let repeated =  baseAnimation.repeatForever(autoreverses: true)
                        withAnimation(repeated) {
                            opacity = 0.2
                        }
                    }
//                    .animation(.easeInOut(duration: 3.0), value: textanimating)
                SnapCarousel(spacing : 15, index: $currentIndex, items: data) { post in
                    ZStack {
                        VStack {
                            if currentDetailItem?.id == post.id && showDetailView {
                                Rectangle()
                                    .fill(.clear)
                            } else {

                                KFImage(URL(string: post.image))
                                //.retry(maxCount: 3, interval: .seconds(5))
                                    .cacheOriginalImage()
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(.gray)
                                    .frame(width: geo.size.width*0.7-15, height: geo.size.height*0.5, alignment:.bottom)
                                    .cornerRadius(25)
//                                    .clipped()
                                    .matchedGeometryEffect(id: post.id, in: animation)
                                    .onTapGesture {
                                        currentDetailItem = post
                                        withAnimation(.easeInOut) {
                                            showDetailView = true
                                            baseData.showDetail = true
                                        }
                                    }
                                    
                            }
                            
                        }
                        VStack() {
                            Spacer()
                            HStack(alignment: .center) {
                                VStack(alignment: .leading) {
                                    Text("\(post.title.removeHTMLTag())").foregroundColor(.white).padding(.leading, 15.0)
                                        .font(.custom("SUIT-Light", size: 16))
                                        .lineLimit(1)
                                    let price = Int(post.lprice) ?? 0
                                    Text("\(price) 원").foregroundColor(.white)
                                        .padding(.leading, 20.0)
                                        .font(.custom("SUIT-Bold", size: 22))
                                }
                                Spacer()
                                VStack {
                                    NavigationLink(destination: FirstView_Webview(urlToLoad: post.link)) {
                                        ZStack {
                                            HStack {
                                                Spacer()
                                                Image(systemName: "bag.fill")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .foregroundColor(Color.white)
                                                    .frame(width:35, height:22)
                                                Spacer()
                                            }
                                        }
                                        .frame(width: geo.size.width*0.2, height: 50)
                                        .background(LinearGradient(
                                            gradient: Gradient(stops: [
                                                .init(color: Color(#colorLiteral(red: 0.8000000119, green: 0.3372549117, blue: 0.850980401, alpha: 1)), location: 0),
                                                .init(color: Color(#colorLiteral(red: 0.5333333611488342, green: 0.3686274588108063, blue: 0.9490196108818054, alpha: 1)), location: 0.20000000298023224),
                                                .init(color: Color(#colorLiteral(red: 0.2705882489681244, green: 0.4313725531101227, blue: 0.9333333373069763, alpha: 1)), location: 0.4000000059604645),
                                                .init(color: Color(#colorLiteral(red: 0.38823530077934265, green: 0.6784313917160034, blue: 0.8196078538894653, alpha: 1)), location: 0.6000000238418579),
                                                .init(color: Color(#colorLiteral(red: 0.4941176474094391, green: 0.8901960849761963, blue: 0.7176470756530762, alpha: 1)), location: 0.800000011920929),
                                                .init(color: Color(#colorLiteral(red: 0.615686297416687, green: 0.8901960849761963, blue: 0.615686297416687, alpha: 1)), location: 1)]),
                                            startPoint: UnitPoint(x: 0.7313432830617212, y: 1.2228915545704548),
                                            endPoint: UnitPoint(x: 0.9440298289061873, y: -0.030120541945483303)))
                                        .cornerRadius(10)
                                    }
                                }
                                .padding(.trailing, 15.0)

                            }.frame(width: geo.size.width*0.7-15, height: 83)
                                .background(Color("MainColor"))
                                .cornerRadius(25)
                        }
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height*0.5)
                .shadow(radius: 5, x: 6, y: 6)
                

                // Indicator ...
                VStack(alignment: .center) {
                    Spacer().frame(height: 15)
                    HStack(spacing: 5) {
                        ForEach(data.indices, id: \.self) { index in
                            Circle()
                                .fill(Color("BW").opacity(currentIndex == index ? 1 : 0.1))
                                .frame(width: 7, height: 7)
                                .scaleEffect(currentIndex == index ? 1.4 : 1)
                                .animation(.spring(), value: currentIndex == index)
                        }
                    }
                }.frame(width: geo.size.width)
                Spacer().frame(height: geo.size.height*0.1)
            }.frame(height: geo.size.height)
                .background {
                    // No Internet exception
                    if data != [] {
                        TabView(selection: $currentIndex) {
                            
                                KFImage(URL(string: data[currentIndex].image))
                                //.retry(maxCount: 3, interval: .seconds(5))
                                    .cacheOriginalImage()
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geo.size.width, height: geo.size.height)
                                    .clipped()
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .animation(.easeInOut, value: currentIndex)
                    }
                    
                    Rectangle()
                        .fill(.ultraThinMaterial)
                    
                    LinearGradient(colors: [Color("WB"), Color("WB"), .clear, Color("WB")], startPoint: .top, endPoint: .bottom)
                }
                
                .overlay {
                    if let post = currentDetailItem, showDetailView {
                        DetailView(item: post, showDetailView: $showDetailView, detailItem: $currentDetailItem, animation: animation).environmentObject(baseData)
                    }
                }
//                .onAppear {
//                    textanimating = false
//                }
        
        }.edgesIgnoringSafeArea(.all)
    }
}



struct EdgeBorder: Shape {

    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }

            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }

            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width+40
                case .leading, .trailing: return self.width
                }
            }

            var h: CGFloat {
                switch edge {
                case .top, .bottom: return self.width
                case .leading, .trailing: return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        return path
    }
}

struct EdgeBorder_Basic: Shape {

    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }

            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }

            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return self.width
                }
            }

            var h: CGFloat {
                switch edge {
                case .top, .bottom: return self.width
                case .leading, .trailing: return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        return path
    }
}

extension View {
    func border(width: CGFloat, edges: [Edge], color: SwiftUI.Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
    
    func basicborder(width: CGFloat, edges: [Edge], color: SwiftUI.Color) -> some View {
        overlay(EdgeBorder_Basic(width: width, edges: edges).foregroundColor(color))
    }
}

struct View_home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

private func getScale(proxy: [Item], currentIndex: Int) -> CGFloat {
    
    //    ForEach(data.indices, id: \.self) { index in
    //        Circle()
    //            .fill(Color.black.opacity(currentIndex == index ? 1 : 0.1))
    //            .frame(width: 7, height: 7)
    //            .scaleEffect(currentIndex == index ? 1.4 : 1)
    //            .animation(.spring(), value: currentIndex == index)
    //    }
    var Index : CGFloat = 0.7
    for index in proxy.indices {
        if currentIndex == index {
            Index = 1
        }
    }
    
    return Index
}

