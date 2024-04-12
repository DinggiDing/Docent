//
//  View_per.swift
//  Docent_swift
//
//  Created by 성재 on 2022/09/02.
//

import SwiftUI
import Kingfisher
import FirebaseAnalytics
import UIKit

struct View_per: View {

    @State var changeView = true
    @EnvironmentObject var Top_kkk : ShopAPI
//    @EnvironmentObject var shopAPI_per : ShopAPI
    @State private var moveIn360 = false
    @State private var rotateIn3D = false
    @State private var isSelected : Bool = false
    @State private var sharebutton: Bool = false
//    @State var animationInProgress = false

    var body: some View {
        let data = Top_kkk.searchResult?.items[0].image ?? ""
//        let link = Top_kkk.searchResult?.items[0].link ?? ""
        
        GeometryReader { geo in
            let Emottion = getKKey_Emotion(callrand: changeView)
            let _ = print(Emottion)
            let main_sent : String = getSentModel(gr_sent: Top_kkk.Top_sent_gr!, Emotion: Emottion)
            VStack(alignment: .leading) {
                Spacer().frame(height: geo.size.height*0.02)
                VStack() {
                    HStack() {
                        Spacer().frame(width: geo.size.width*0.85-15)
                        Button(action: {
                            self.sharebutton = true
                        }, label: {
                            Image(systemName: "square.and.arrow.up")
                                .resizable()
                                .foregroundColor(Color("TabBut"))
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25, alignment: .center)
                        })
                    }
                }.sheet(isPresented: $sharebutton, content: {
                    ActivityView(text: main_sent)
                })
                Spacer().frame(height: geo.size.height*0.05)
                VStack() {
                    ZStack() {
                        if isSelected == false {
                            VStack() {
                                Spacer().frame(height:15)
                                VStack() {
                                    KFImage(URL(string: data))
                                        .cacheOriginalImage()
                                        .resizable()
                                        .foregroundColor(.gray)
                                        .scaleEffect(moveIn360 ? 1.2 : 1)
                                        .offset(x: moveIn360 ? -30 : 30)
                                        .opacity(moveIn360 ? 1 : 0)
                                        .animation(Animation.easeOut(duration: 60).speed(5).repeatForever(autoreverses: false), value: moveIn360)
                                        .onAppear() {
                                            moveIn360 = true
                                        }
                                    
                                        .frame(width: geo.size.width*0.85-15, height: geo.size.height*0.5, alignment:.bottom)
                                        .clipped()
                                        .cornerRadius(10)
                                }
                                .frame(width: geo.size.width*0.85-15, height: geo.size.height*0.5, alignment:.bottom)
                                .background(Color.white)
                                .cornerRadius(10)
                                Spacer().frame(height:15)
                                Text(main_sent).foregroundColor(.black)
                                    .font(.custom("Cafe24Oneprettynight", size: 20))
                                    .lineLimit(3)
                                    .padding(.leading, 10)
                                    .padding(.top, 5)
                                    .lineSpacing(8)
                                    .multilineTextAlignment(.leading)
                                    .frame(width: geo.size.width*0.85-15, alignment: .topLeading)
                                Spacer()
                            }.onTapGesture {
                                isSelected = true
                            }
                        }
                        else {
                            LottieView(isSelected: $isSelected)
                        }
                    }
                }
                .frame(width: geo.size.width*0.85, height: geo.size.height*0.65)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5, x: 6, y: 6)
                .onChange(of: isSelected, perform: { value in
                    if isSelected {
                        let iindex = EmotiontoIndex(emo: Emottion)
                        var Keyword : [Int] = UserDefaults.standard.array(forKey: "Emotion") as? [Int] ?? []
                        Keyword[iindex] += 1
                        
                        let Top_k_index = Top_kkk.Top_rand!
                        
                        // Emotion
                        Analytics.logEvent("EEE", parameters: [
                            "Emo" : IndextoEmotion(index: iindex) as NSObject,
                        ])
                        Analytics.logEvent("EEECO", parameters: [
                            "Emo" : "Hi" as NSObject,
                        ])
                        // Sixman
                        Analytics.logEvent("SSS", parameters: [
                            "Six" : "\(Top_k_index)" as NSObject,
                        ])
                        Analytics.logEvent("SSSCO", parameters: [
                            "Six" : "Hi" as NSObject,
                        ])
                        
                        var Keyword6 : [Int] = UserDefaults.standard.array(forKey: "Sixman") as? [Int] ?? []
                        Keyword6[Top_k_index - 1] += 1
                        
                        UserDefaults.standard.set(Keyword, forKey: "Emotion")
                        UserDefaults.standard.set(Keyword6, forKey: "Sixman")
                        print("+++")
                    }
                })
                
                
               
                Spacer().frame(height: geo.size.height*0.1)
            }.frame(width: geo.size.width,height: geo.size.height)
                
                .background {
                    KFImage(URL(string: data))
                        .cacheOriginalImage()
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                    Rectangle()
                        .fill(.thinMaterial)
                    
                    LinearGradient(colors: [.clear, Color("WB")], startPoint: .top, endPoint: .bottom)
                    }
                .onAppear {
                    print("View_per")
                    changeView.toggle()
                }
          
        }.edgesIgnoringSafeArea(.all)
    }
}

private func getSentModel(gr_sent: [SentModel], Emotion : String) -> String {
    let ee_sent : String
    let gg_Emotion : String = Emotion
    if let index = gr_sent.firstIndex(where: { $0.tone == gg_Emotion}) {
        ee_sent = gr_sent[index].sentence
    } else {
        ee_sent = ""
    }
    return ee_sent
}


private func EmotiontoIndex(emo : String) -> Int {
    let Emotion_Type : [String] = ["Assertive", "Cooperative", "Curious", "Encouraging", "Formal", "Friendly", "Informal", "Optimistic", "Surprised"]
    let EIndex : Int
    if let index = Emotion_Type.firstIndex(of: emo) {
        EIndex = index
    } else {
        EIndex = 0
    }
    
    return EIndex
}

private func IndextoEmotion(index : Int) -> String {
    let Emotion_Type : [String] = ["Assertive", "Cooperative", "Curious", "Encouraging", "Formal", "Friendly", "Informal", "Optimistic", "Surprised"]
    return Emotion_Type[index]
}

struct View_per_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


// MARK - :: Share
struct ActivityView: UIViewControllerRepresentable {
    let text: String
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: [text], applicationActivities: nil)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {}
}
