//
//  MainView.swift
//  Docent_swift
//
//  Created by 성재 on 2022/09/02.
//

import SwiftUI

struct MainView: View {
    // Hold the state for which tab is active/selected
    @State var selection: Int = 0
    @EnvironmentObject var Top_kk : ShopAPI
    @StateObject var baseData = BaseViewModel()
//    @StateObject var shopAPI1 = ShopAPI()
    
    init() {
//        let transparentAppearence = UITabBarAppearance()
//        transparentAppearence.configureWithTransparentBackground()
//        UITabBar.appearance().standardAppearance = transparentAppearence
//
        UITabBar.appearance().isHidden = true
    }
        
    var body: some View {
        TabView(selection: $selection) {
            View_per()
                .tag(0)
            
            View_home()
                .environmentObject(baseData)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tag(1)
            
            View_my()
                .tag(2)
            
        }
        .overlay(
            HStack {
                Spacer()
                
                // First Tab Button
                Button(action: {
                    self.selection = 0
                }, label: {
                    Image(systemName: "bag.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25, alignment: .center)
                        .foregroundColor(Color("TabBut"))
                        .opacity(selection == 0 ? 1 : 0.4)
//                        .contentShape(Rectangle())
                })
                Spacer()
                
                // Second Tab Button
                Button(action: {
                    self.selection = 1
                }, label: {
                    Image(systemName: "house.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25, alignment: .center)
                        .foregroundColor(Color("TabBut"))
                        .opacity(selection == 1 ? 1 : 0.4)
                })
                
                Spacer()
                
                // Third Tab Button
                Button(action: {
                    self.selection = 2
                }, label: {
                    Image(systemName: "person.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25, alignment: .center)
                        .foregroundColor(Color("TabBut"))
                        .opacity(selection == 2 ? 1 : 0.4)
                })
                Spacer()
                
            }.frame(height: 40) // Match Height of native bar)
                .offset(y: baseData.showDetail ? 200 : 0)
            .onAppear {
                print("MainView")
//                shopAPI1.requestAPIToNaver(queryValue: Top_kk.Top_key!, completion: {
//                shopAPI1.getData(query: Top_kk.Top_key ?? "")
            }
                 
        ,alignment: .bottom)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
//        .environmentObject(shopAPI1)
        

    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension String {
    // html 태그 제거 + html entity들 디코딩.
    func removeHTMLTag() -> String {

       return self.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)

    }
}

