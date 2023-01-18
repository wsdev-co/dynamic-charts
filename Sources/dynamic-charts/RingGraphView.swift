//
//  CircleGraphView.swift
//  T3zz
//
//  Created by Inagamjanov on 17/01/23.
//

import SwiftUI


// MARK: CIRCLE GRAPH SCHEME
public struct CircleChartScheme: Identifiable, Hashable {
    var id: UUID? = UUID()
    var value: CGFloat
    var color: Color
    var name: String
}


// MARK: VIEW
public struct CircleChartView: View {
    // MARK: View Swttings
    var symbol: Image = Image(systemName: "flame.fill")
    var title: String = ""
    var title_color: Color = Color(.systemGreen)
    var subtitle: Text = Text("Nutritions")
    var divider: Bool = false
    var background: Color = Color.white
    
    var data: Array<CircleChartScheme> = []
    
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
            }
            
            // MARK: SUBTITLE
            subtitle
            
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
                    .frame(maxWidth: UIScreen.main.bounds.width / 5, minHeight: UIScreen.main.bounds.height / 9, alignment: .center)
                    
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
