//
//  FirstView_Webview.swift
//  Docent_swift
//
//  Created by 성재 on 2022/09/11.
//

import SwiftUI
import WebKit

struct FirstView_Webview: UIViewRepresentable {
    
    var urlToLoad: String
    
    func makeUIView(context: Context) -> WKWebView {
            
            //unwrapping
            guard let url = URL(string: self.urlToLoad) else {
                return WKWebView()
            }
            //웹뷰 인스턴스 생성
            let webView = WKWebView()
            
            //웹뷰를 로드한다
            webView.load(URLRequest(url: url))
            return webView
        }
        
    //업데이트 ui view
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<FirstView_Webview>) {
        
    }
}

struct FirstView_Webview_Previews: PreviewProvider {
    static var previews: some View {
        FirstView_Webview(urlToLoad: "https://www.naver.com")
    }
}
