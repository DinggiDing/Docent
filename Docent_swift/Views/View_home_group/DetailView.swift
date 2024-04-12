//
//  DetailView.swift
//  Docent_swift
//
//  Created by 성재 on 2023/01/28.
//

import SwiftUI
import Kingfisher

struct DetailView: View {
    var item: Item

    @Binding var showDetailView: Bool
    @Binding var detailItem: Item?
    @EnvironmentObject var baseData : BaseViewModel
    
    @State var showDetailContent: Bool = false
    @State var offset: CGFloat = 0
    var animation: Namespace.ID
    
    var body: some View {
        
        GeometryReader {
            let size = $0.size
            ZStack(alignment: .topTrailing) {
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        KFImage(URL(string: item.image))
                        //.retry(maxCount: 3, interval: .seconds(5))
                            .cacheOriginalImage()
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(.gray)
                            .frame(width: size.width, height: size.height/1.9)
                            .cornerRadius(5)
                            .clipped()
                            .matchedGeometryEffect(id: item.id, in: animation)
                            .padding(.leading, -16)
                        
                        VStack() {
                            VStack(alignment: .leading, spacing: 15) {
                                Text(item.title.removeHTMLTag()).foregroundColor(Color("BW"))
                                    .font(.custom("SUIT-Bold", size: 24))
                                    .frame(width: size.width/1.5, alignment: .topLeading)
                                    .padding(.top, 20)
                                    .padding(.leading, -20)
                            }
                            
                            VStack() {
                                Text("쇼핑몰 : \(item.mallName)")
                                    .foregroundColor(Color("BW"))
                                    .font(.custom("SUIT-Regular", size: 20))
                                    .frame(width: .infinity, alignment: .topLeading)
                                    .padding(.top, 50)
                                Text("브랜드 : \(item.brand)")
                                    .foregroundColor(Color("BW"))
                                    .font(.custom("SUIT-Regular", size: 20))
                                    .frame(width: .infinity, alignment: .topLeading)
                                    .padding(.top, 20)
                                Text("카테고리 : \(item.category1) | \(item.category2) | \(item.category3) | \(item.category4)")
                                    .foregroundColor(Color("BW"))
                                    .font(.custom("SUIT-Regular", size: 20))
                                    .frame(width: .infinity, alignment: .topLeading)
                                    .padding(.top, 20)
                                
                                Spacer().frame(height: 147)
                            }
                        }
                        
                        .opacity(showDetailContent ? 1 : 0)
                        .offset(y: showDetailContent ? 0 : 200)
                    }
                    .padding(.horizontal)
                    .modifier(OffsetModifier(offset: $offset))
                }
                .coordinateSpace(name: "SCROLL")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                }
                .onAppear {
                    withAnimation(.easeInOut) {
                        showDetailContent = true
                    }
                }
                .onChange(of: offset) { newValue in
                    if newValue > 120 {
                        withAnimation(.easeInOut) {
                            baseData.showDetail = false
                            showDetailContent = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            withAnimation(.easeInOut) {
                                showDetailView = false
                            }
                        }
                    }
                }
                Image(systemName: "multiply.circle.fill")
                    .resizable().foregroundColor(Color("TabBut"))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25, alignment: .leading)
                    .padding()
                    .padding([.trailing, .top], 30)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            baseData.showDetail = false
                            showDetailContent = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            withAnimation(.easeInOut) {
                                showDetailView = false
                            }
                        }
                    }
                
                GeometryReader { geo in
                    HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            HStack(alignment: .center) {
                                VStack(alignment: .leading) {
                                    let price = Int(item.lprice) ?? 0
                                    Text("\(price) 원").foregroundColor(.white)
                                        .padding(.leading, 20.0)
                                        .font(.custom("SUIT-Bold", size: 22))
                                }
                                Spacer()
                                VStack {
                                    NavigationLink(destination: FirstView_Webview(urlToLoad: item.link)) {
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
                                
                            }.frame(width: geo.size.width*0.9-15, height: 83)
                                .background(Color("MainColor"))
                                .cornerRadius(25)
                        }
                        .padding(.bottom, 25)
                        .padding(.leading, -16)
                        Spacer()
                    }
                }
            }
        }
        
    }
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView()
//    }
//}
