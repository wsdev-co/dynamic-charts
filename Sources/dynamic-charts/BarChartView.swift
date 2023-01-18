//
//  BarChartView.swift
//  T3zz
//
//  Created by Inagamjanov on 17/01/23.
//

import SwiftUI


// MARK: SCHEME
@available(macOS 12, *)
@available(iOS 15, *)
public struct BarChartScheme: Identifiable{
    internal init(id: Int, header: String? = nil, subheader: String? = nil, box_text: String? = nil, value: CGFloat, color: Color? = nil) {
        self.id = id
        self.header = header
        self.subheader = subheader
        self.box_text = box_text
        self.value = value
        self.color = color
    }
    
    public var id: Int
    public var header: String? = nil
    public var subheader: String? = nil
    public var box_text: String? = nil
    public var value: CGFloat
    public var color: Color? = nil
}


// MARK: VIEW
@available(macOS 12, *)
@available(iOS 15, *)
public struct BarChartView: View {
    internal init(symbol: AnyView = AnyView(Image(systemName: "flame.fill")), title: String = "", title_color: Color = Color(.systemGreen), subtitle: Text = Text("Nutritions"), divider: Bool = false, background: Color = Color.white, chart_data: Array<BarChartScheme> = [], chart_gradient: Array<Color> = [Color(.systemCyan),Color(.systemBlue)], is_selectable: Bool = false, selected: Int = 0) {
        self.symbol = symbol
        self.title = title
        self.title_color = title_color
        self.subtitle = subtitle
        self.divider = divider
        self.background = background
        self.chart_data = chart_data
        self.chart_gradient = chart_gradient
        self.is_selectable = is_selectable
        self.selected = selected
    }
    
    
    // MARK: View Swttings
    public var symbol: AnyView
    public var title: String
    public var title_color: Color
    public var subtitle: Text
    public var divider: Bool
    public var background: Color
    
    // MARK: Graph Settings
    public var chart_data: Array<BarChartScheme>
    public var chart_gradient: Array<Color>
    public var is_selectable: Bool
    
    // MARK: State
    @State public var selected: Int
    
    public var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 5){
                // MARK: Title
                HStack{
                    symbol
                        .foregroundColor(title_color)
                    
                    Text(title)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(title_color)
                        .fontWeight(.semibold)
                    
                    Spacer()
                }
                
                // MARK: SUBTITLE
                subtitle
                
                // MARK: DIVIDER
                if divider {
                    Divider()
                        .padding(.vertical, 5)
                }
                
                // MARK: Bar Graph
                VStack(alignment: .leading, spacing: 15){
                    ForEach(Array(zip(chart_data.indices, chart_data)), id: \.0){ index, each_data in
                        LazyVStack(alignment: .leading, spacing: 2){
                            HStack(alignment: .bottom, spacing: 5){
                                if each_data.header != nil {
                                    Text(each_data.header!)
                                        .font(.system(.title, design: .rounded))
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color.black)
                                }
                                if each_data.subheader != nil {
                                    Text(each_data.subheader!)
                                        .font(.system(.body, design: .rounded))
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color.gray)
                                }
                            }
                            ZStack(alignment: .leading){
                                HorizontalAnimatedBarGraph(selected: $selected,
                                                           each_graph_data: each_data,
                                                           index: index,
                                                           graph_color: chart_gradient,
                                                           is_selectable: is_selectable)
                                    .frame(width: each_data.value == 0 ? 0 : GetBarWidth(point: each_data.value, size: proxy.size), height: 25, alignment: .leading)
                                
                                if each_data.box_text != nil {
                                    Text(each_data.box_text!)
                                        .font(.system(.subheadline, design: .rounded))
                                        .fontWeight(.semibold)
                                        .foregroundColor((selected == each_data.id || selected == 0) ? Color.white : Color(.lightGray))
                                        .padding(10)
                                }
                            }
                        }
                    }
                }
                .padding(.top, 5)
            }
            .padding(20)
            .background{
                Rectangle()
                    .foregroundColor(background)
                    .cornerRadius(10)
                
            }
        }
    }
    
    // MARK: FUNCTIONS
    func GetBarWidth(point: CGFloat,size: CGSize)->CGFloat{
        
        let max = GetMax()
        
        let width = (point / max) * (size.width - 70)
        
        return width + 1
    }
    
    // MARK: Getting Max....
    func GetMax()->CGFloat{
        let max = chart_data.max { first, scnd in
            return scnd.value > first.value
        }?.value ?? 0
        return max
    }
}


// MARK: FOR ANIMATION
@available(macOS 12, *)
@available(iOS 15, *)
struct HorizontalAnimatedBarGraph: View {
    // MARK: STATES
    @Binding var selected: Int
    var each_graph_data: BarChartScheme
    var index: Int
    var graph_color: Array<Color>
    var is_selectable: Bool
    
    // MARK: LOCAL VARIABLES || STATES
    @State var showBar: Bool = false
    let default_color: Array<Color> = [Color("graph_color"), Color("graph_color")]
//    let impactMed = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View{
        VStack(spacing: 1){
            //
            if each_graph_data.color != nil {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(each_graph_data.color)
                    .frame(width: showBar ? nil : 30, alignment: .leading)
            } else {
                //                let is_selected: Bool = (selected == each_graph_data.id) //|| selected == 0
                let is_selected: Bool = (selected == each_graph_data.id || selected == 0)
                RoundedRectangle(cornerRadius: 5)
                    .fill(LinearGradient(gradient: .init(colors: is_selected ? graph_color : default_color), startPoint: .leading, endPoint: .trailing))
                    .frame(width: showBar ? nil : 30, alignment: .leading)
            }
            
        }
        .onAppear {
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8).delay(Double(index) * 0.1)){
                showBar = true
            }
        }
        .onTapGesture {
            if is_selectable {
                withAnimation(.easeInOut){
//                    impactMed.impactOccurred()
                    //                    selected = each_graph_data.id //(selected == each_graph_data.id) ? 0 :
                    selected = (selected == each_graph_data.id) ? 0 : each_graph_data.id
                }
            }
        }
    }
}
