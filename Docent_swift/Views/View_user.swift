//
//  View_user.swift
//  Docent_swift
//
//  Created by 성재 on 2022/09/02.
//

import SwiftUI
import UserNotifications
import AlertToast

struct View_user: View {
    
    @State private var someToggle = false
    @State private var showToast = false
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                Text("설정").font(.custom("SUIT-Bold", size:32))
                    .padding(.horizontal, 15)
                    .padding(.leading, 15)
                    .frame(width: geo.size.width, height: geo.size.height*0.3, alignment: .leading)
                
                VStack(alignment: .leading) {
                    Spacer()
                    HStack {

                        Toggle(isOn: $someToggle) {
                            Text("알림").font(.custom("SUIT-Regular", size: 20)).padding([.top, .leading, .bottom], 30.0)
                        }.tint(.black)
                            .frame(width: geo.size.width*0.75)
                            .basicborder(width: 0.5, edges: [.bottom], color: Color("BW"))
                            .disabled(true)
                            .onTapGesture {
                                showToast.toggle()
                            }
                    }
                    VStack {
                        HStack {
                            Text("버전").font(.custom("SUIT-Regular", size: 20)).padding([.top, .leading, .bottom], 30.0).frame(width: geo.size.width*0.65, alignment: .leading)
                            Text("\(currentAppVersion())").font(.custom("SUIT-Light", size: 16))
                        }.frame(width: geo.size.width*0.75, alignment: .leading).basicborder(width: 0.5, edges: [.bottom], color: Color("BW"))
                        
                    }
                    NavigationLink(destination: FirstView_Webview(urlToLoad: "https://nifty-death-746.notion.site/7fdc8231b11243f1a51385a4c0039468")) {
                        Text("정보").font(.custom("SUIT-Regular", size: 20)).padding([.top, .leading, .bottom], 30.0)
                            .foregroundColor(Color("BW"))
                            .frame(width: geo.size.width*0.75, alignment: .leading).foregroundColor(Color.black)
                    }
                    Spacer()
                }.frame(width: geo.size.width, height: geo.size.height*0.4)
                Spacer().frame(height: geo.size.height*0.2)
            }.frame(width: geo.size.width, height: geo.size.height, alignment: .topLeading)
                .background {
                    Rectangle()
                        .fill(.thinMaterial)
                    
                }
                .onAppear {
                    getpushnotiauth()
                    
                }.toast(isPresenting: $showToast) {
                    //https://github.com/elai950/AlertToast
                    
                    AlertToast(type: .regular, title: "설정 앱에서 알림을 바꿔주세요")
                }
        }.edgesIgnoringSafeArea(.all)
        
    }
    
    private func getpushnotiauth() {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: {
            setting in
            if setting.authorizationStatus == .authorized {
                self.someToggle = true
            } else {
                self.someToggle = false
            }
        })
    }
    
}




struct View_user_Previews: PreviewProvider {
    static var previews: some View {
        View_user()
    }
}

// MARK - : current version
private func currentAppVersion() -> String {
  if let info: [String: Any] = Bundle.main.infoDictionary,
      let currentVersion: String
        = info["CFBundleShortVersionString"] as? String {
        return currentVersion
  }
  return "nil"
}
