//
//  ContentView.swift
//  UniversalTextDemo
//
//  Created by Brian Masse on 12/28/23.
//

import SwiftUI

struct ContentView: View {

//    MARK: Body
    var body: some View {
        VStack(alignment: .leading) {
        
            UniversalText("UniversalText Demo",
                          size: Constants.UITitleTextSize,
                          case: .uppercase)
            .bold(true)
            .padding(.vertical)
            
//            overview
            UniversalText("Can be used as a basic text wrapper",
                          size: Constants.UIDefaultTextSize)
                .bold(true)
            
            UniversalText("hello world!", size: Constants.UIDefaultTextSize)
                .padding(.bottom)
            
            
            Divider()
            
//            wrapping, scaling, sizing demonstration
            UniversalText( "Trmmed with wrap=false",
                           size: Constants.UIDefaultTextSize)
            .bold(true)
            UniversalText("Hello World, I am a little longer!",
                          size: Constants.UIHeaderTextSize,
                          font: .syneHeavy,
                          wrap: false)
            .padding(.bottom)
        
            UniversalText( "fit text to space with wrap=false, scale=true",
                           size: Constants.UIDefaultTextSize)
            .bold(true)
            
            UniversalText( "Hello World, I am a little longer!",
                           size: Constants.UIHeaderTextSize,
                           font: .syneHeavy,
                           wrap: false,
                           scale: true)
            .padding(.bottom)
            
            UniversalText( "comofrtably fit spcae with wrap=true, scale=true",
                           size: Constants.UIDefaultTextSize)
            .bold(true)
            UniversalText( "Hello World, I am much longer than the other two examples, this text goes on and on!",
                           size: Constants.UIDefaultTextSize,
                           font: .renoMono,
                           scale: true)
            
            Divider()
            
//            line spacing
            UniversalText( "increase the default line spacing",
                           size: Constants.UIDefaultTextSize)
            .bold(true)
            
            UniversalText( "This is some longer text, that has increased line spacing!",
                           size: Constants.UIDefaultTextSize,
                           font: .madeTommyRegular,
                           lineSpacing: 20)
            .padding(.bottom)
            
            UniversalText( "decrease the default line spacing",
                           size: Constants.UIDefaultTextSize)
            .bold(true)
            UniversalText( "This is some longer text, that has \ndecreased line spacing!",
                           size: Constants.UIDefaultTextSize,
                           font: .madeTommyRegular,
                           lineSpacing: -10)
            Divider()
            
            Spacer()
            
            HStack {
                Spacer()
                UniversalText("Universal\nText!",
                              size: Constants.UITitleTextSize + 20,
                              font: .syneHeavy,
                              wrap: false,
                              scale: false,
                              textAlignment: .center,
                              lineSpacing: -30)
                .background( Color(red: 235 / 255,
                                        green: 64 / 255,
                                        blue: 52 / 255) )
                
                Spacer()
            }
            
            Spacer()
            
        }
        .padding(.horizontal)
    }
}

#Preview {
    ContentView()
}

//MARK: UniversalText

struct UniversalText: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    let text: String
    let size: CGFloat
    let font: String
    let textCase: Text.Case
    
    let wrap: Bool
    let fixed: Bool
    let scale: Bool
    
    let alignment: TextAlignment
    let lineSpacing: CGFloat
    let compensateForEmptySpace: Bool
    
    init(_ text: String,
         size: CGFloat,
         font: ProvidedFont = .helvetica,
         case textCase: Text.Case = .lowercase,
         wrap: Bool = true,
         fixed: Bool = false,
         scale: Bool = false,
         textAlignment: TextAlignment = .leading,
         lineSpacing: CGFloat = 0.5,
         compensateForEmptySpace: Bool = true
    ) {
        self.text = text
        self.size = size
        self.font = font.rawValue
        self.textCase = textCase
        
        self.wrap = wrap
        self.fixed = fixed
        self.scale = scale
        
        self.alignment = textAlignment
        self.lineSpacing = lineSpacing
        self.compensateForEmptySpace = compensateForEmptySpace
    }
    
    @ViewBuilder
    private func makeText(_ text: String) -> some View {
        
        Text(text)
            .dynamicTypeSize( ...DynamicTypeSize.accessibility1 )
            .lineSpacing(lineSpacing)
            .minimumScaleFactor(scale ? 0.1 : 1)
            .lineLimit(wrap ? 30 : 1)
            .multilineTextAlignment(alignment)
            .font( fixed ? Font.custom(font, fixedSize: size) : Font.custom(font, size: size).leading(.tight) )
            .textCase(textCase)
        
    }
    
    private func translateTextAlignment() -> HorizontalAlignment {
        switch alignment {
        case .leading:
            return .leading
        case .center:
            return .center
        case .trailing:
            return .trailing
        }
    }
    
    var body: some View {
        
        if lineSpacing < 0 {
            let texts = text.components(separatedBy: "\n")
            
            VStack(alignment: translateTextAlignment(), spacing: 0) {
                ForEach(0..<texts.count, id: \.self) { i in
                    makeText(texts[i])
                        .offset(y: CGFloat( i ) * lineSpacing )
                }
            }
            .padding(.bottom, (Double(texts.count - 1) * lineSpacing) )
        } else {
            makeText(text)
        }
    }
}


//MARK: Constants
class Constants {
    
    //    font sizes
    static let UILargeTextSize: CGFloat     = 90
    static let UITitleTextSize: CGFloat     = 40
    static let UIHeaderTextSize: CGFloat    = 30
    static let UISubHeaderTextSize: CGFloat = 20
    static let UIDefaultTextSize: CGFloat   = 15
    static let UISmallTextSize: CGFloat     = 11
    
    //    fonts
    static let titleFont: ProvidedFont = .madeTommyRegular
    static let mainFont: ProvidedFont = .madeTommyRegular

}

//MARK: ProvidedFont
enum ProvidedFont: String {
    case madeTommyRegular = "MadeTommy"
    case renoMono = "RenoMono-Regular"
    case helvetica = "helvetica"
    case syneHeavy = "Syne-Bold"
}

//MARK: Divider
struct Divider: View {
    
    let vertical: Bool
    let strokeWidth: CGFloat
    let color: Color
    
    init(vertical: Bool = false, strokeWidth: CGFloat = 1, color: Color = .black) {
        self.vertical = vertical
        self.strokeWidth = strokeWidth
        self.color = color
    }
    
    var body: some View {
        Rectangle()
            .if(vertical) { view in view.frame(width: strokeWidth) }
            .if(!vertical) { view in view.frame(height: strokeWidth) }
            .foregroundStyle(color)
    }
}

extension View {
    @ViewBuilder
    func `if`<Content: View>( _ condition: Bool, contentBuilder: (Self) -> Content ) -> some View {
        if condition {
            contentBuilder(self)
        } else { self }
    }
}
