import SwiftUI
import Charts

struct Graph: View {
    @Environment(AppState.self) private var app: AppState
    @Environment(History.self) private var history: History
    @Environment(Settings.self) private var settings: Settings
    
    private let yesterday = Date().addingTimeInterval(-86400)
    
    private var last24Glucose: [Glucose] {
        history.glucose.filter { glucose in
            glucose.date > yesterday
        }
    }
    
    private var last24Carbs: [Carbohydrates] {
        combineCarbsObjectsIfNeeded(
            history.carbs.filter { carbs in
                carbs.date > yesterday
            }
        )
    }
    
    private var last24Insulin: [InsulinDelivery] {
        history.insulin.filter { insulin in
            insulin.date > yesterday
        }
    }
    
    private var maxGlucose: Glucose? {
        last24Glucose.max(by: {
            $0.value < $1.value
        })
    }
    
    private var minGlucose: Glucose? {
        last24Glucose.min(by: {
            $0.value < $1.value
        })
    }
    
    var body: some View {
        VStack {
            Chart {
                if let maxGlucose {
                    PointMark(
                        x: .value("Date", maxGlucose.date),
                        y: .value("Glucose", Double(maxGlucose.value.units)!)
                    )
                    .foregroundStyle(.red)
                    .annotation {
                        Text(maxGlucose.value.units)
                    }
                }
                
                if let minGlucose {
                    PointMark(
                        x: .value("Date", minGlucose.date),
                        y: .value("Glucose", Double(minGlucose.value.units)!)
                    )
                    .foregroundStyle(.red)
                    .annotation(position: .bottom) {
                        Text(minGlucose.value.units)
                    }
                }
                
                ForEach(last24Glucose, id: \.self) { glucose in
                    if let value = Double(glucose.value.units) {
                        LineMark(
                            x: .value("Time", glucose.date),
                            y: .value("Glucose", value)
                        )
                        .foregroundStyle(.pink)
                    }
                }
                
                ForEach(last24Carbs, id: \.self) { carbs in
                    PointMark(
                        x: .value("Date", carbs.date),
                        y: .value("Carbs", 0)
                    )
                    .foregroundStyle(.green)
                    .annotation(overflowResolution: .automatic) {
                        Text(carbs.value)
                            .fontSize(8)
                    }
                    .symbol {
                        Image(systemName: "fork.knife")
                            .foregroundStyle(.green)
                            .footnote()
                    }
                }
                
                ForEach(history.factoryTrend, id: \.self) { value in
                    LineMark(
                        x: .value("Time", value.date),
                        y: .value("Glucose", value.value.units)
                    )
                    .foregroundStyle(.orange)
                }
                
                ForEach(last24Insulin, id: \.self) { insulin in
                    PointMark(
                        x: .value("Date", insulin.date),
                        y: .value("Insulin", -2)
                    )
                    .foregroundStyle(insulin.type == .basal ? .purple : .yellow)
                    .annotation {
                        Text(insulin.value)
                            .fontSize(8)
                    }
                    .symbol {
                        Image(systemName: insulin.type == .basal ? "syringe.fill" : "syringe")
                            .foregroundStyle(insulin.type == .basal ? .purple : .yellow)
                            .footnote()
                    }
                    
                    // BarMark(
                    //     x: .value("Time", insulin.date),
                    //     y: .value("Insulin", insulin.value)
                    // )
                    // .foregroundStyle(insulin.type == .basal ? .purple : .yellow)
                    
                    // RuleMark(
                    //     x: .value("Time", value.date)
                    // )
                    // .foregroundStyle(.yellow)
                }
                
                //  ForEach(history.rawValues, id: \.self) { value in
                //      LineMark(
                //          x: .value("Time", value.date),
                //          y: .value("Glucose", value.value.units)
                //      )
                //      .foregroundStyle(.orange)
                //  }
                //
                //  ForEach(history.glucose, id: \.self) { value in
                //      LineMark(
                //          x: .value("Time", value.date),
                //          y: .value("Glucose", value.value.units)
                //      )
                //      .foregroundStyle(.red)
                //  }
                //
                //  if let last = history.glucose.last?.date,
                //     let first = history.glucose.first?.date,
                //     let targetLow = Int(settings.targetLow.units),
                //     let targetHigh = Int(settings.targetHigh.units) {
                //      RectangleMark(
                //          xStart: .value("Start", first),
                //          xEnd: .value("End", last),
                //          yStart: .value("Low", targetLow),
                //          yEnd: .value("High", targetHigh)
                //          //                        yEnd: .value("High", 15 * 18.0182)
                //      )
                //      .foregroundStyle(.green.opacity(0.15))
                //  }
                
                RuleMark(y: .value("Alarm Low", Double(settings.alarmLow.units)!))
                    .foregroundStyle(.red.opacity(0.5))
                
                RuleMark(y: .value("Alarm High", Double(settings.alarmHigh.units)!))
                    .foregroundStyle(.red.opacity(0.5))
                
                RectangleMark(
                    yStart: .value("Min", Double(settings.targetLow.units)!),
                    yEnd: .value("Max", Double(settings.targetHigh.units)!)
                )
                .foregroundStyle(.green.opacity(0.15))
            }
            .chartYScale(domain: -2...20)
            .chartXAxis {
                AxisMarks(values: .stride(by: .hour, count: 2)) { value in
                    if let date = value.as(Date.self) {
                        let hour = Calendar.current.component(.hour, from: date)
                        
                        AxisValueLabel {
                            Text(hour)
                            // Text(date, style: .time)
                            //     .rotate(-90)
                        }
                        
                        AxisGridLine()
                    }
                }
            }
            .task {
                app.main.healthKit?.readGlucose(limit: 1000)
                app.main.healthKit?.readCarbs()
                app.main.healthKit?.readInsulin()
            }
        }
    }
}

#Preview {
    HomeView()
        .glucosyPreview(.monitor)
}
