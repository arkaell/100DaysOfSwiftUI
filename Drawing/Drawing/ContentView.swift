//
//  ContentView.swift
//  Drawing
//
//  Created by David Liongson on 10/5/20.
//

import SwiftUI

struct ContentView: View {
    
//    @State private var amount: CGFloat = 0.0
    
    @State private var insetAmount: CGFloat = 50
    
    @State private var rows = 4
    @State private var columns = 4
    
    
    @State private var innerRadius = 125.0
    @State private var outerRadius = 75.0
    @State private var distance = 25.0
    @State private var amount: CGFloat = 0
    @State private var hue = 0.6
    
    @State private var thickness = 1
    private let thicknessLevels = ["Slim", "Regular", "Wide", "Ultra-wide"]
    
    @State private var colorCycle = 0.0
    
    
    private var arrowThickness: CGFloat {
        switch thickness {
        case 0:
            return 0.15
        case 1:
            return 0.38
        case 2:
            return 0.5
        case 3:
            return 0.7
        default:
            return 0.5
        }
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            Text("Arrow")
                .font(.title)
                .padding([.horizontal, .bottom])
            
            Arrow(thickness: arrowThickness)
                .frame(width: 150, height: 150)
                .foregroundColor(.green)
                .animation(.linear)
                .padding([.horizontal, .bottom])
            
            Picker(selection: $thickness, label: Text("Select the thickness")) {
                
                ForEach(0..<thicknessLevels.count) {
                    Text(thicknessLevels[$0])
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding([.horizontal, .bottom])
            
            Text("You selected \(thicknessLevels[thickness])")
                .padding([.horizontal, .bottom])
            
            Text("Color Cycling Rectangle")
                .font(.title)
                .padding([.horizontal, .bottom])
            
            ColorCyclingRectangle(amount: self.colorCycle, steps: 150)
                .frame(width: 250, height: 250)
                .padding([.horizontal, .bottom])
            
            Slider(value: $colorCycle)
            
//            Spacer()
//
//            Spirograph(innerRadius: Int(innerRadius), outerRadius: Int(outerRadius), distance: Int(distance), amount: amount)
//                .stroke(Color(hue: hue, saturation: 1, brightness: 1), lineWidth: 1)
//
//            Spacer()
//
//            Group {
//                Text("Inner radius: \(Int(innerRadius))")
//                Slider(value: $innerRadius, in: 10...150, step: 1)
//                    .padding([.horizontal, .bottom])
//
//                Text("Outer radius: \(Int(outerRadius))")
//                Slider(value: $outerRadius, in: 10...150, step: 1)
//                    .padding([.horizontal, .bottom])
//
//                Text("Distance: \(Int(distance))")
//                Slider(value: $distance, in: 1...150, step: 1)
//                    .padding([.horizontal, .bottom])
//
//                Text("Amount: \(amount, specifier: "%.2f")")
//                Slider(value: $amount)
//                    .padding([.horizontal, .bottom])
//
//                Text("Color")
//                Slider(value: $hue)
//                    .padding(.horizontal)
//
//            }
        }
        
//        Checkerboard(rows: rows, columns: columns)
//            .onTapGesture {
//                withAnimation(.linear(duration: 3)) {
//                    self.rows = 8
//                    self.columns = 16
//                }
//            }
        
//        Trapezoid(insetAmount: insetAmount)
//            .frame(width: 200, height: 100)
//            .onTapGesture {
//                withAnimation {
//                    self.insetAmount = CGFloat.random(in: 10...90)
//                }
//            }
        
//        VStack {
//            ZStack {
//                Circle()
//                    .fill(Color.red)
//                    .frame(width: 200 * amount)
//                    .offset(x: -50, y: -80)
//                    .blendMode(.screen)
//
//                Circle()
//                    .fill(Color.green)
//                    .frame(width: 200 * amount)
//                    .offset(x: 50, y: 80)
//                    .blendMode(.screen)
//
//                Circle()
//                    .fill(Color.blue)
//                    .frame(width: 200 * amount)
//                    .blendMode(.screen)
//            }
//            .frame(width: 300, height: 300)
//
//            Slider(value: $amount)
//                .padding()
//            Image("Germany")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 200, height: 200)
//                .saturation(Double(amount))
//                .blur(radius: (1 - amount) * 20)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.black)
//        .edgesIgnoringSafeArea(.all)
    }
}

struct Arrow: Shape {
    
    var thickness: CGFloat
    var animatableData: CGFloat {
        get { thickness }
        set { self.thickness = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        
        let bodyWidth: CGFloat = (rect.maxX - rect.midX) * (thickness)
        let arrowWidth: CGFloat = (1/3 * rect.width) * (thickness)
        print(rect.midX)
        print(bodyWidth)
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX + bodyWidth + arrowWidth, y: 0.5 * rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + bodyWidth, y: 0.5 * rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + bodyWidth, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX - bodyWidth, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX - bodyWidth, y: 0.5 * rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX - bodyWidth - arrowWidth, y: 0.5 * rect.maxY))
//        path.addLine(to: CGPoint(x: rect.midX - thickness, y: rect.maxY))
//        path.addLine(to: CGPoint(x: rect.midX - thickness, y: 0.5 * rect.maxY))
//        path.addLine(to: CGPoint(x: rect.minX, y: 0.5 * rect.maxY))
        
        return path
    }
}

struct ColorCyclingRectangle: View {
    
    var amount = 0.0
    var steps = 100
    
    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Rectangle()
                    .inset(by: CGFloat(value))
                    .strokeBorder(self.color(for: value, brightness: 1), lineWidth: 2)
            }
        }
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(self.steps) + Double(self.amount)
        
        if targetHue >= 1 {
            targetHue -= 1
        }
        
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct Checkerboard: Shape {
    var rows: Int
    var columns: Int
    
    public var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(Double(rows), Double(columns))
        }
        
        set {
            self.rows = Int(newValue.first)
            self.columns = Int(newValue.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let rowSize = rect.height / CGFloat(rows)
        let columnSize = rect.width / CGFloat(columns)
        
        for row in 0..<rows {
            for column in 0..<columns {
                if (row + column).isMultiple(of: 2) {
                    let startX = columnSize * CGFloat(column)
                    let startY = rowSize * CGFloat(row)
                    
                    let rect = CGRect(x: startX, y: startY, width: columnSize, height: rowSize)
                    path.addRect(rect)
                }
            }
        }
        
        return path
    }
}

struct Spirograph: Shape {
    let innerRadius: Int
    let outerRadius: Int
    let distance: Int
    let amount: CGFloat
    
    func gcd(_ a: Int, _ b: Int) -> Int {
        var a = a
        var b = b
        
        while b != 0 {
            let temp = b
            b = a % b
            a = temp
        }
        
        return a
    }
    
    func path(in rect: CGRect) -> Path {
        let divisor = gcd(innerRadius, outerRadius)
        let outerRadius = CGFloat(self.outerRadius)
        let innerRadius = CGFloat(self.innerRadius)
        let distance = CGFloat(self.distance)
        let difference = innerRadius - outerRadius
        let endPoint = ceil(2 * CGFloat.pi * outerRadius / CGFloat(divisor)) * amount
        
        var path = Path()
        
        for theta in stride(from: 0, through: endPoint, by: 0.01) {
            var x = difference * cos(theta) + distance * cos(difference / outerRadius * theta)
            var y = difference * sin(theta) - distance * sin(difference / outerRadius * theta)
            
            x += rect.width / 2
            y += rect.height / 2
            
            if theta == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        return path
    }
}

struct Trapezoid: Shape {
    var insetAmount: CGFloat
    var animatableData: CGFloat {
        get { insetAmount }
        set { self.insetAmount = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        
        return path
    }
}
struct ColorCyclingCircle: View {
    var amount = 0.0
    var steps = 100
    
    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Circle()
                    .inset(by: CGFloat(value))
//                    .strokeBorder(self.color(for: value, brightness: 1), lineWidth: 2)
                    .strokeBorder(
                        LinearGradient(gradient:
                                        Gradient(colors: [self.color(for: value, brightness: 1),
                                                          self.color(for: value, brightness: 0.5)]), startPoint: .top, endPoint: .bottom), lineWidth: 2)
            }
        }
        .drawingGroup()
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(self.steps) + Double(self.amount)
        
        if targetHue >= 1 {
            targetHue -= 1
        }
        
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct Flower: Shape {
//    How much to move this petal away from the center
    var petalOffset: Double = -20
    
//    How wide to make each petal
    var petalWidth: Double = 100
    
    func path(in rect: CGRect) -> Path {
//        the path that will hold all petals
        var path = Path()
        
//        Count from 0 up to pi * 2, moving up pi / 8 each time
        for number in stride(from: 0, to: CGFloat.pi * 2, by: CGFloat.pi / 8) {
//            rotate the petal by the current value of our loop
            let rotation = CGAffineTransform(rotationAngle: number)
            
//            move the petal to be at the center of our view
            let position = rotation.concatenating(CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2))
            
//            create a path for this petal using our properties plus a fixed Y and height
            let originalPetal = Path(ellipseIn: CGRect(x: CGFloat(petalOffset), y: 0, width: CGFloat(petalWidth), height: rect.width / 2))
            
//            apply our rotation/position transformation to the petal
            let rotatedPetal = originalPetal.applying(position)
            
//            add it to our main path
            path.addPath(rotatedPetal)
            
        }
        
        return path
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 200, y: 100))
        path.addLine(to: CGPoint(x: 100, y: 300))
        path.addLine(to: CGPoint(x: 300, y: 300))
        path.addLine(to: CGPoint(x: 200, y: 100))
        
        return path
    }
}

struct Arc: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                    radius: rect.width / 2,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: clockwise)
        
        return path
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
