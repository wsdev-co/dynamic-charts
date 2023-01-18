//
//  BarGraphView.swift
//  T3zz
//
//  Created by Inagamjanov on 16/01/23.
//

import SwiftUI


// MARK: SCHEME
public struct ColumnChartScheme: Identifiable{
    var id: Int
    var name: String
    var value: CGFloat
    var color: Color?
}


// MARK: VIEW
public struct ColumnChartView: View {
    // MARK: View Swttings
    var symbol: Image = Image(systemName: "flame.fill")
    var title: String = ""
    var title_color: Color = Color(.systemGreen)
    var subtitle: Text = Text("Nutritions")
    var divider: Bool = false
    var background: Color = Color.white
    
    // MARK: Graph Settings
    var chart_data: Array<ColumnChartScheme> = []
    var x_axis_color: Color? = Color.gray.opacity(0.2)
    var x_name_color: Color? = Color.gray
    var chart_gradient: Array<Color> = [Color(.systemCyan),Color(.systemBlue)]
    var is_selectable: Bool = false
    var show_median: Bool = false
    var selected_median_color: Color = Color("orange_color")
    var unselect_median_color: Color = Color("graph_color")
    
    // MARK: State
    @State var selected: Int = 0
    
    var body: some View {
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
                //
                //                Image(systemName: "chevron.right")
                //                    .foregroundColor(Color(.systemGray2))
                //                    .font(.system(size: 15))
            }
            
            // MARK: SUBTITLE
            subtitle
            
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
struct BarGraph: View {
    var graph_data: Array<ColumnChartScheme>
    var x_axis_color: Color?
    var x_name_color: Color?
    var graph_gradient: Array<Color>
    var is_selectable: Bool
    var show_median: Bool
    var selected_median_color: Color
    var unselect_median_color: Color
    @State var selected: Int = 0
    
    // MARK: VIEW
    var body: some View{
        GeometryReader{proxy in
            ZStack(alignment: .center){
                // MARK: Lines appear when show lines equal to true
                if x_axis_color != nil {
                    VStack(spacing: 0){
                        ForEach(getGraphLines(),id: \.self){line in
                            HStack {
                                Text("\(Int(line))")
                                    .font(.system(.caption, design: .rounded))
                                    .foregroundColor(x_name_color)
                                    .frame(height: 20)
                                
                                Rectangle()
                                    .fill(x_axis_color!)
                                    .frame(height: 1)
                            }
                            .frame(maxHeight: .infinity,alignment: .bottom)
                            .offset(y: -15)
                        }
                    }
                }
                
                // MARK: Bar Graph
                HStack{
                    ForEach(Array(zip(graph_data.indices, graph_data)), id: \.0){ index, each_data in
                        VStack(spacing: 0){
                            VStack(spacing: 5){
                                AnimatedBarGraph(selected: $selected,
                                                 each_graph_data: each_data,
                                                 index: index,
                                                 graph_color: graph_gradient,
                                                 is_selectable: is_selectable,
                                                 show_values: (x_name_color != nil))
                            }
                            .frame(height: each_data.value == 0 ? 0 : getBarHeight(point: each_data.value, size: proxy.size))
                            
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
                    let median = getMax()/2
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        // Fixed Height
        .frame(height: UIScreen.main.bounds.height / 4)
    }
    
    // MARK: FUNCTIONS
    func getBarHeight(point: CGFloat,size: CGSize)->CGFloat{
        
        let max = getMax()
        
        let height = (point / max) * (size.height - 37)
        
        return height
    }
    
    // MARK: Getting Sample Graph Lines based on max Value...
    func getGraphLines()->[CGFloat]{
        
        let max = getMax()
        
        var lines: [CGFloat] = []
        
        lines.append(max)
        
        for index in 1...5{
            
            // dividing the max by 4 and iterating as index for graph lines...
            let progress = max / 5
            
            lines.append(max - (progress * CGFloat(index)))
        }
        
        return lines
    }
    
    // MARK: Getting Max....
    func getMax()->CGFloat{
        let max = graph_data.max { first, scnd in
            return scnd.value > first.value
        }?.value ?? 0
        return max
    }
}


// MARK: FOR ANIMATION
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
    let generator = UINotificationFeedbackGenerator()
    let default_color: Array<Color> = [Color("graph_color"), Color("graph_color")]
    let impactMed = UIImpactFeedbackGenerator(style: .medium)
    
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
                RoundedShape()
                    .foregroundColor(each_graph_data.color)
                    .frame(height: showBar ? nil : 0, alignment: .bottom)
            } else {
                //                let is_selected: Bool = (selected == each_graph_data.id) //|| selected == 0
                let is_selected: Bool = (selected == each_graph_data.id || selected == 0)
                RoundedShape()
                    .fill(LinearGradient(gradient: .init(colors: is_selected ? graph_color : default_color), startPoint: .top, endPoint: .bottom))
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
                    impactMed.impactOccurred()
                    //                    selected = each_graph_data.id //(selected == each_graph_data.id) ? 0 :
                    selected = (selected == each_graph_data.id) ? 0 : each_graph_data.id
                }
            }
        }
    }
}


// MARK: Custom Rounded Rectangle (5,5,0,0)
struct RoundedShape : Shape {
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 5, height: 5))
        return Path(path.cgPath)
    }
}
