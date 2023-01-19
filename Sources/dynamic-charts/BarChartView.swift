//
//  BarChartView.swift
//  T3zz
//
//  Created by Inagamjanov on 17/01/23.


import SwiftUI


// MARK: SCHEME
@available(macOS 12, *)
@available(iOS 15, *)
public struct BarChartScheme: Identifiable{
    public init(id: Int,
                header: String? = nil,
                subheader: String? = nil,
                box_text: String? = nil,
                value: CGFloat,
                color: Color? = nil) {
        self.id = id
        self.header = header
        self.subheader = subheader
        self.box_text = box_text
        self.value = value
        self.color = color
    }
    
    public var id: Int
    public var header: String?
    public var subheader: String?
    public var box_text: String?
    public var value: CGFloat
    public var color: Color?
}


// MARK: VIEW
@available(macOS 12, *)
@available(iOS 15, *)
public struct BarChartView: View {
    public init(destination: AnyView? = nil,
                symbol: Image = Image(systemName: "flame.fill"),
                title: String = "",
                title_color: Color = Color(.systemGreen),
                subtitle: String = "Nutritions",
                subtitle_color: Color = Color.black,
                divider: Bool = false,
                background: Color = Color.white,
                chart_data: Array<BarChartScheme> = [],
                chart_gradient: Array<Color> = [Color(.systemCyan),Color(.systemBlue)],
                default_chart_gradient: Array<Color> = [Color.gray.opacity(0.3), Color.gray.opacity(0.3)],
                is_selectable: Bool = false,
                selected: Int = 0,
                width_ratio: Int = 1) {
        self.destination = destination
        self.symbol = symbol
        self.title = title
        self.title_color = title_color
        self.subtitle = subtitle
        self.subtitle_color = subtitle_color
        self.divider = divider
        self.background = background
        self.chart_data = chart_data
        self.chart_gradient = chart_gradient
        self.default_chart_gradient = default_chart_gradient
        self.is_selectable = is_selectable
        self.selected = selected
        self.width_ratio = width_ratio
    }
    
    
    // MARK: View Swttings
    public var destination: AnyView
    public var symbol: Image
    public var title: String
    public var title_color: Color
    public var subtitle: String
    public var subtitle_color: Color
    public var divider: Bool
    public var background: Color
    
    // MARK: Graph Settings
    public var chart_data: Array<BarChartScheme>
    public var chart_gradient: Array<Color>
    public var default_chart_gradient: Array<Color>
    public var is_selectable: Bool
    
    // MARK: State
    @State public var selected: Int
    public var width_ratio: Int
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 5){
            // MARK: Title
            NavigationLink {
                if destination != nil {
                    destination!
                }
            } label: {
                VStack(alignment: .leading, spacing: 5){
                    // MARK: Title
                    HStack{
                        symbol
                            .foregroundColor(title_color)
                        
                        Text(title)
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundColor(title_color)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                    
                    // MARK: SUBTITLE
                    Text(subtitle)
                        .font(.system(.title2, design: .rounded))
                        .foregroundColor(subtitle_color)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                }
            }
            .disabled(destination == nil)
            
            // MARK: DIVIDER
            if divider {
                Divider()
                    .padding(.vertical, 5)
            }
            
            // MARK: Bar Graph
            VStack(alignment: .leading, spacing: 15){
                ForEach(Array(zip(chart_data.indices, chart_data)), id: \.0){ index, each_data in
                    VStack(alignment: .leading, spacing: 2){
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
                                                       is_selectable: is_selectable,
                                                       default_chart_gradient: default_chart_gradient)
                                .frame(width: each_data.value == 0 ? 0 : get_bar_width(bar_value: each_data.value), height: 30, alignment: .leading)
                            
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
        //        .frame(maxWidth: get_os_width() - 16)
        .padding(20)
        .background{
            Rectangle()
                .foregroundColor(background)
                .cornerRadius(10)
            
        }
    }
    
    // MARK: FUNCTIONS
    func get_bar_width(bar_value: CGFloat) -> CGFloat {
        // calculates the maximum height size of column.
        
        // max height of device screen.
        let max_width = get_os_width()
        
        // max value of data set.
        let max_value = get_max_value()
        
        // portion of screen that maximum value
        let max_value_width = (max_width / CGFloat(width_ratio))
        
        // current column's height according to maximum column height
        let bar_width = (bar_value / max_value) * (max_value_width - 70)
        return bar_width
    }
    
    // MARK: Getting Max value of data set
    func get_max_value() -> CGFloat {
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
    var default_chart_gradient: Array<Color>
    
    // MARK: LOCAL VARIABLES || STATES
    @State var showBar: Bool = false
    
    var body: some View{
        VStack(spacing: 1){
            //
            if each_graph_data.color != nil {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(each_graph_data.color)
                    .frame(width: showBar ? nil : 30, alignment: .leading)
            } else {
                let is_selected: Bool = (selected == each_graph_data.id || selected == 0)
                RoundedRectangle(cornerRadius: 5)
                    .fill(LinearGradient(gradient: .init(colors: is_selected ? graph_color : default_chart_gradient), startPoint: .leading, endPoint: .trailing))
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
#if os(iOS)
                    let impactMed =  UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
#endif
                    selected = (selected == each_graph_data.id) ? 0 : each_graph_data.id
                }
            }
        }
    }
}
