//
//  CircleGraphView.swift
//  T3zz
//
//  Created by Inagamjanov on 17/01/23.
//

import SwiftUI


// MARK: CIRCLE GRAPH SCHEME
@available(macOS 12, *)
@available(iOS 15, *)
public struct CircleChartScheme: Identifiable, Hashable {
    public init(id: UUID? = UUID(),
                value: CGFloat,
                color: Color,
                name: String) {
        self.id = id
        self.value = value
        self.color = color
        self.name = name
    }
    
    public var id: UUID?
    public var value: CGFloat
    public var color: Color
    public var name: String
}


// MARK: VIEW
@available(macOS 12, *)
@available(iOS 15, *)
public struct CircleChartView: View {
    public init(destination: AnyView? = nil,
                symbol: Image = Image(systemName: "flame.fill"),
                title: String = "",
                title_color: Color = Color(.systemGreen),
                subtitle: String = "Nutritions",
                subtitle_color: Color = Color.black,
                divider: Bool = false,
                background: Color = Color.white,
                data: Array<CircleChartScheme> = [],
                width_ratio: Int = 3) {
        self.destination = destination
        self.symbol = symbol
        self.title = title
        self.title_color = title_color
        self.subtitle = subtitle
        self.subtitle_color = subtitle_color
        self.divider = divider
        self.background = background
        self.data = data
        self.width_ratio = width_ratio
    }
    
    // MARK: View Swttings
    public var destination: AnyView?
    public var symbol: Image
    public var title: String
    public var title_color: Color
    public var subtitle: String
    public var subtitle_color: Color
    public var divider: Bool
    public var background: Color
    public var data: Array<CircleChartScheme>
    public var width_ratio: Int
    
    public var body: some View {
        let circle_size: CGFloat = (get_os_width() / CGFloat(width_ratio) - 50)
        VStack(alignment: .leading, spacing: 5){
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
                            .font(.system(.footnote, design: .rounded))
                            .foregroundColor(title_color)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                        
                        
                        Spacer()
                        
                        if destination != nil {
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color(.lightGray))
                            .font(.system(.body))
                        }
                    }
                    
                    // MARK: SUBTITLE
                    Text(subtitle)
                        .font(.system(.body, design: .rounded))
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
            HStack{
                ForEach(Array(zip(data.indices, data)), id: \.0){ index, each_data in
                    ZStack(alignment: .center){
                        AnimatedCircleGraphView(data: each_data,
                                                index: index)
                        Text(each_data.name)
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundColor(Color("median_gray_color"))
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: circle_size, minHeight: circle_size, alignment: .center)
                    
                    
                    if data.count != index+1 {
                        Spacer(minLength: 5)
                    }
                }
            }
            .padding(.top, 10)
        }
        .padding(20)
        .background{
            Rectangle()
                .foregroundColor(background)
                .cornerRadius(10)
            
        }
    }
}


// MARK: ANIMATED CIRCLE GRAPH
@available(macOS 12, *)
@available(iOS 15, *)
struct AnimatedCircleGraphView: View{
    @State var show_chart: Bool = false
    var data: CircleChartScheme
    var index: Int
    
    var body: some View{
        ZStack{
            Circle()
                .stroke(.gray.opacity(0.3),lineWidth: 15)
            Circle()
                .trim(from: 0, to: show_chart ? data.value / 100 : 0)
                .stroke(data.color, style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                .rotationEffect(.init(degrees: -90))
        }
        .onAppear {
            // Show After Intial Animation Finished
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 1.4, blendDuration: 1.4).delay(Double(index) * 0.1)){
                show_chart = true
            }
        }
    }
}
