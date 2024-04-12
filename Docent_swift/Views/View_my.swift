//
//  View_my.swift
//  Docent_swift
//
//  Created by 성재 on 2023/01/28.
//

import SwiftUI

struct View_my: View {
    @State private var userbutton = false
    @State private var showToast = false
    
    var body: some View {
        GeometryReader { geo in
            let emotion = get_Emotion()
            VStack(alignment: .leading) {
                VStack() {
                    HStack() {
                        Text("My").font(.custom("SUIT-Bold", size:32))
                            .padding(.horizontal, 15)
                            .padding(.leading, 15)
                            .frame(width: geo.size.width*0.85-15, height: geo.size.height*0.15, alignment: .leading)
                        
                        //                    Spacer()
                        VStack(alignment: .leading) {
                            NavigationLink(destination: View_user(), isActive: $userbutton, label: {
                                Image(systemName: "person")
                                    .resizable()
                                    .foregroundColor(Color("TabBut"))
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25, alignment: .center)
                                    .onTapGesture {
                                        userbutton = true
                                    }
                            })
                        }
                    }                   
                    Text("나에게 어울리는 문장은...").font(.custom("SUIT-Regular", size:24))
                        .padding(.leading, 15)
                        .frame(width: geo.size.width*0.85-15, height: .infinity, alignment: .leading)
                }.frame(width: geo.size.width, height: geo.size.height*0.3, alignment: .leading)
                VStack(alignment: .leading) {
                    Spacer()
                    VStack() {
                        Image(emotion.first).resizable().scaledToFit()
                            .frame(width: geo.size.width*0.7, height: geo.size.height*0.5, alignment: .bottom).clipped()
                    }
                    VStack() {
                        Text(emotion.first).font(.custom("SUIT-Bold", size:32))
                            .padding([.top, .leading, .bottom], 15.0)
                            .frame(width: geo.size.width*0.75, alignment: .leading)
                        
                        Text(emotion.second).font(.custom("SUIT-Thin", size:22))
                            .padding([.leading, .bottom], 15.0)
                            .frame(width: geo.size.width*0.75, height: .infinity, alignment: .leading)
                    }
                    Spacer()
                }.frame(width: geo.size.width, height: geo.size.height*0.4)
                Spacer().frame(height: geo.size.height*0.2)
            }.frame(width: geo.size.width, height: geo.size.height, alignment: .topLeading)
                .background {
                    Rectangle()
                        .fill(.thinMaterial)
                    
                }
                
        }.edgesIgnoringSafeArea(.all)
        
    }
    
}

struct View_my_Previews: PreviewProvider {
    static var previews: some View {
        View_my()
    }
}

private func get_Emotion() -> (first: String, second: String) {
    
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    let arr : [Int] = UserDefaults.standard.array(forKey: "Emotion") as? [Int] ?? []
    let Emotion_Type0 : [String] = ["Assertive", "Cooperative", "Curious", "Encouraging", "Formal", "Friendly", "Informal", "Optimistic", "Surprised", "None"]
    let Emotion_script0 : [String] = ["자신감과 권위있는 문장", "긍정과 협력적인 문장", "호기심있는 문장", "지지와 이해가 있는 문장", "직접적이고 정중한 문장", "가볍고 친절한 문장", "대화적이고 표현력이 있는 문장", "희망과 미래적인 문장", "놀라움을 불러 일으키는 문장", "소개 문장이 마음에 들면 터치!"]
    let Max_Index : Int
    
    if arr == Array(repeating: 0, count: 9) {
        Max_Index = 9
    } else {
        let Maxx = arr.max() ?? 0
        Max_Index = arr.firstIndex(of: Maxx) ?? 0
    }
    
    print("MAX __ INDEX : \(Max_Index)")
    return (first: Emotion_Type0[Max_Index], second: Emotion_script0[Max_Index])
}
