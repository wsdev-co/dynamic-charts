
//
//  BarGraphView.swift
//  T3zz
//
//  Created by Inagamjanov on 16/01/23.
//

import SwiftUI


// MARK: SCHEME
@available(macOS 12, *)
@available(iOS 15, *)
public struct ColumnChartScheme: Identifiable{
    public init(id: Int,
                name: String,
                value: CGFloat,
                color: Color? = nil) {
        self.id = id
        self.name = name
        self.value = value
        self.color = color
    }
    
    public var id: Int
    public var name: String
    public var value: CGFloat
    public var color: Color?
}


// MARK: VIEW
@available(macOS 12, *)
@available(iOS 15, *)
public struct ColumnChartView: View {
    public init(symbol: Image = Image(systemName: "flame.fill"),
                title: String = "",
                title_color: Color = Color(.systemGreen),
                subtitle: String = "Nutritions",
                subtitle_color: Color = Color.black,
                divider: Bool = false,
                background: Color = Color.white,
                chart_data: Array<ColumnChartScheme> = [],
                x_axis_color: Color? = Color.gray.opacity(0.2),
                x_name_color: Color? = Color.gray,
                chart_gradient: Array<Color> = [Color(.systemCyan),Color(.systemBlue)],
                default_chart_gradient: Array<Color> = [Color.gray.opacity(0.3), Color.gray.opacity(0.3)],
                is_selectable: Bool = false,
                show_median: Bool = false,
                selected_median_color: Color = Color("orange_color"),
                unselect_median_color: Color = Color("graph_color"),
                selected: Int = 0,
                height_ratio: Int = 4) {
        self.symbol = symbol
        self.title = title
        self.title_color = title_color
        self.subtitle = subtitle
        self.subtitle_color = subtitle_color
        self.divider = divider
        self.background = background
        self.chart_data = chart_data
        self.x_axis_color = x_axis_color
        self.x_name_color = x_name_color
        self.chart_gradient = chart_gradient
        self.default_chart_gradient = default_chart_gradient
        self.is_selectable = is_selectable
        self.show_median = show_median
        self.selected_median_color = selected_median_color
        self.unselect_median_color = unselect_median_color
        self.selected = selected
        self.height_ratio = height_ratio
    }
    
    // MARK: View Swttings
    public var symbol: Image
    public var title: String
    public var title_color: Color
    public var subtitle: String
    public var subtitle_color: Color
    public var divider: Bool
    public var background: Color
    
    // MARK: Graph Settings
    public var chart_data: Array<ColumnChartScheme>
    public var x_axis_color: Color?
    public var x_name_color: Color?
    public var chart_gradient: Array<Color>
    public var default_chart_gradient: Array<Color>
    public var is_selectable: Bool
    public var show_median: Bool
    public var selected_median_color: Color
    public var unselect_median_color: Color
    
    
    // MARK: State
    @State public var selected: Int
    public var height_ratio: Int
    
    public var body: some View {
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
            Text(subtitle)
                .font(.system(.title2, design: .rounded))
                .foregroundColor(subtitle_color)
                .fontWeight(.semibold)
            
            // MARK: DIVIDER
            if divider {
                Divider()
                    .padding(.vertical, 5)
            }
            
            // MARK: Bar Graph
            BarGraph(graph_data: chart_data,
                     x_axis_color: x_axis_color,
                     x_name_color: x_name_color,
                     graph_gradient: chart_gradient,
                     default_chart_gradient: default_chart_gradient,
                     is_selectable: is_selectable,
                     show_median: show_median,
                     selected_median_color: selected_median_color,
                     unselect_median_color: unselect_median_color,
                     selected: selected
            )
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


// MARK: GRAPH CHARTS
@available(macOS 12, *)
@available(iOS 15, *)
struct BarGraph: View {
    var graph_data: Array<ColumnChartScheme>
    var x_axis_color: Color?
    var x_name_color: Color?
    var graph_gradient: Array<Color>
    var default_chart_gradient: Array<Color>
    var is_selectable: Bool
    var show_median: Bool
    var selected_median_color: Color
    var unselect_median_color: Color
    @State var selected: Int = 0
    var height_ratio: Int = 4
    
    // MARK: VIEW
    var body: some View{
        ZStack(alignment: .center){
            // MARK: Lines appear when show lines equal to true
            if x_axis_color != nil {
                VStack(spacing: 0){
                    ForEach(get_chart_lines(),id: \.self){line in
                        HStack {
                            Text("\(Int(line))")
                                .font(.system(.caption, design: .rounded))
                                .foregroundColor(x_name_color)
                            
                            Rectangle()
                                .fill(x_axis_color!)
                                .frame(height: 1)
                        }
                        .padding(.bottom, 18)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                }
            }
            
            // MARK: Bar Graph
            HStack {
                ForEach(Array(zip(graph_data.indices, graph_data)), id: \.0){ index, each_data in
                    VStack(spacing: 0){
                        VStack(spacing: 5){
                            AnimatedBarGraph(selected: $selected,
                                             each_graph_data: each_data,
                                             index: index,
                                             graph_color: graph_gradient,
                                             is_selectable: is_selectable,
                                             show_values: (x_name_color != nil),
                                             default_chart_gradient: default_chart_gradient)
                        }
                        .frame(height: each_data.value == 0 ? 0 : get_column_height(column_value: each_data.value))
                        
                        // MARK: Bottom Text
                        Text(each_data.name)
                            .font(.system(.caption2, design: .rounded))
                            .foregroundColor(x_name_color ?? Color(.white).opacity(0))
                            .frame(height: 25,alignment: .bottom)
                    }
                    .frame(maxWidth: 30, maxHeight: .infinity, alignment: .bottom)
                    
                    // Spacer arguments
                    if graph_data.count != index+1 {
                        Spacer(minLength: 3)
                    }
                }
            }
            .padding(.leading, (x_axis_color != nil) ? 30 : 0)
            
            // MARK: MEDIAN DATA
            if show_median {
                let median = get_max_value()/2
                VStack (alignment: .leading, spacing: 0){
                    Text(String(format: "%.0f", median))
                        .font(.system(.callout, design: .rounded))
                        .foregroundColor(selected == 0 ? unselect_median_color : selected_median_color.opacity(0.8))
                        .fontWeight(.semibold)
                    
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(selected == 0 ? unselect_median_color : selected_median_color.opacity(0.8))
                        .frame(height: 5)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.leading, (x_axis_color != nil) ? 30 : 0)
                .padding(.bottom, 30)
            }
        }
        
    }
    
    // MARK: FUNCTIONS
    func get_column_height(column_value: CGFloat) -> CGFloat {
        // calculates the maximum height size of column.
        
        // max height of device screen.
        let max_height = get_os_height()
        
        // max value of data set.
        let max_value = get_max_value()
        
        // portion of screen that maximum value
        let max_value_height = (max_height / CGFloat(height_ratio))
        
        // current column's height according to maximum column height
        let column_height = (column_value / max_value) * max_value_height
        return column_height
    }
    
    // MARK: Getting Sample Graph Lines based on max Value...
    func get_chart_lines() -> [CGFloat] {
        
        // max value of data set.
        let max_value = get_max_value()
        
        var lines: [CGFloat] = []
        
        lines.append(max_value)
        
        for index in 1...5 {
            
            // dividing the max by 4 and iterating as index for graph lines...
            let progress = (max_value / 5)
            
            lines.append(max_value - (progress * CGFloat(index)))
        }
        
        return lines
    }
    
    // MARK: Getting Max value of data set
    func get_max_value() -> CGFloat {
        let max = graph_data.max { first, scnd in
            return scnd.value > first.value
        }?.value ?? 0
        return max
    }
}


// MARK: FOR ANIMATION
@available(macOS 12, *)
@available(iOS 15, *)
struct AnimatedBarGraph: View{
    // MARK: STATES
    @Binding var selected: Int
    var each_graph_data: ColumnChartScheme
    var index: Int
    var graph_color: Array<Color>
    var is_selectable: Bool
    var show_values: Bool
    
    // MARK: LOCAL VARIABLES || STATES
    @State var showBar: Bool = false
    var default_chart_gradient: Array<Color>
    
    var body: some View{
        VStack(spacing: 0){
            Spacer(minLength: 0)
            if (selected == each_graph_data.id && show_values){
                Text(String(format: "%.0f", each_graph_data.value))
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(Color.black)
                    .padding(.bottom,2)
            }
            
            if each_graph_data.color != nil {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(each_graph_data.color)
                    .frame(height: showBar ? nil : 0, alignment: .bottom)
            } else {
                let is_selected: Bool = (selected == each_graph_data.id || selected == 0)
                RoundedRectangle(cornerRadius: 5)
                    .fill(LinearGradient(gradient: .init(colors: is_selected ? graph_color : default_chart_gradient), startPoint: .top, endPoint: .bottom))
                    .frame(height: showBar ? nil : 0, alignment: .bottom)
            }
            
            
        }
        .onAppear {
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8).delay(Double(index) * 0.12)){
                showBar = true
            }
        }
        .onTapGesture {
            if is_selectable {
                withAnimation(.easeInOut.delay(0.06)){
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
