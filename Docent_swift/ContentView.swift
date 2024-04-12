//
//  ContentView.swift
//  Docent_swift
//
//  Created by 성재 on 2022/09/02.
//

import SwiftUI
import Firebase
import FirebaseAnalytics

struct ContentView: View {
    @StateObject var SGRM1 = SelectGRM()
    @StateObject var Top_k = ShopAPI()
    @State var splash = false
    let manager = NotificationManager.instance
    var body: some View {

        NavigationView {
            GeometryReader {
                geo in
                    NavigationLink(isActive: $splash, destination: {
                        MainView()
                    }, label: {
                        VStack {
                            Text("개인화된 경험을\n\n제공하다").font(.headline)
                                .multilineTextAlignment(.leading).padding(.leading, 60.0).padding(.top, 90.0).frame(width: geo.size.width, alignment: .leading).foregroundColor(Color.black)
                            Text("Docent").font(.largeTitle)
                                .foregroundColor(Color.black)
                                .multilineTextAlignment(.trailing).padding(.trailing, 60.0).padding(.top, 30.0).frame(width: geo.size.width, alignment: .trailing)
                            
                            Spacer()
                            Image("splash").resizable().scaledToFill().frame(height:geo.size.height*0.6,  alignment: .bottom).clipped()
                        }.background(Color.white)
                    })
                    
            }.ignoresSafeArea(.all, edges: .bottom)
                .onAppear {
                    print("once")
                    UIApplication.shared.applicationIconBadgeNumber = 0
                    DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
                        splash = true
                    }
                    print("------BirthDay------")
                    print("HH".stringFromDate())
                    print("d".stringFromDate())
                    print("\((Int("d".stringFromDate()) ?? 0)+1)")
                    Top_k.getTop_key(id: "\((Int("d".stringFromDate()) ?? 0)%10+1)")
                    // 아침, 오후, 저녁 별 인사말
                    if (6...11 ~= Int("HH".stringFromDate())!) {
                        print("아침")
                        SGRM1.LoadGRjson(jsonname: "morning_greeting", Tone_id: getKKey_Emotion(callrand: false), Time_id: 9)

                    } else if (12...18 ~= Int("HH".stringFromDate())!) {
                        print("점심")

                        SGRM1.LoadGRjson(jsonname: "after_greeting", Tone_id: getKKey_Emotion(callrand: false), Time_id: 6)

                    } else {
                        print("저녁")

                        SGRM1.LoadGRjson(jsonname: "dinner_greeting", Tone_id: getKKey_Emotion(callrand: false), Time_id: 9)

                    }
                    printUserDefault()
                    manager.requestAuthorization()
                    manager.scheduleNotification()
                    
                }
        }
        .accentColor(.blue)
        .environmentObject(Top_k)
        .environmentObject(SGRM1)
    }
}

func getKKey_Emotion(callrand : Bool) -> String {
    
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    let arr : [Int] = UserDefaults.standard.array(forKey: "Emotion") as? [Int] ?? []
    let Emotion_Type : [String] = ["Assertive", "Cooperative", "Curious", "Encouraging", "Formal", "Friendly", "Informal", "Optimistic", "Surprised"]
    let Max_Index : Int
    
    if launchedBefore == false {
        print("First LOAD")
        let Keyword = Array(repeating: 0, count: 9)
        UserDefaults.standard.set(Keyword, forKey: "Emotion")
        UserDefaults.standard.set(true, forKey: "launchedBefore")
        let Keyword2 = Array(repeating: 0, count: 6)
        UserDefaults.standard.set(Keyword2, forKey: "Sixman")
    }
    
    if arr == Array(repeating: 0, count: 9) || callrand {
        Max_Index = Int.random(in: 0...8)
    } else {
        let Maxx = arr.max() ?? 0
        Max_Index = arr.firstIndex(of: Maxx) ?? 0
    }
    
    return Emotion_Type[Max_Index]
}

func printUserDefault() {
    let arr : [Int] = UserDefaults.standard.array(forKey: "Emotion") as? [Int] ?? []
    let brr : [Int] = UserDefaults.standard.array(forKey: "Sixman") as? [Int] ?? []

    let stringarr = arr.map { String($0) }
    let stringlog = stringarr.joined(separator: ",")
    Analytics.logEvent("Emotion", parameters: [
        "Emo" : stringlog as NSObject,
    ])
    print(arr)
    print(brr)
}

func getLocalDate() -> String {
    let date = Date()
    let timeFor = DateFormatter()
    timeFor.dateFormat = "dd"
    let local_dd = timeFor.string(from: date)
    return local_dd
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct HiddenNavigationBar: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
    }
}

extension View {
    func hiddenNavigationBarStyle() -> some View {
        modifier( HiddenNavigationBar() )
    }
}

extension String {
    func stringFromDate() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: now)
    }
}


class SelectGRM: ObservableObject {
    @Published var Gr_sent: String?
    
    func LoadGRjson(jsonname: String, Tone_id: String, Time_id: Int) {
        guard let path = Bundle.main.path(forResource: jsonname, ofType: "json") else {
            return
        }
        guard let jsonString = try? String(contentsOfFile: path) else {
            return
        }
        
        let decoder = JSONDecoder()
        let data = jsonString.data(using: .utf8)
        if let data = data,
           let person = try? decoder.decode([GreetingModel].self, from: data) {
            let ft_person = person.filter {
                ($0.tone) == Tone_id
            }
            let rand = Int.random(in: 0...Time_id)
            self.Gr_sent = ft_person[rand].sent
        }
    }
    
}
