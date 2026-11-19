import SwiftUI

struct ContentView: View {
    @StateObject private var vm = ContentViewModel()
    
    var body: some View {
        ZStack {
            Color(hex: "0A0A0E").ignoresSafeArea()
            
            VStack {
                // Heading
                VStack(alignment: .leading, spacing: 9) {
                    Text("Today")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(.gray)
                        .kerning(3)
                    Text(Date.now.dateToString())
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer().frame(maxHeight: 40)
                
                // Content
                if vm.isLoading {
                    Spacer()
                    ProgressView().tint(.white)
                    Spacer()
                } else if let error = vm.errorText {
                    Spacer()
                    Text(error)
                        .foregroundStyle(.red)
                        .padding()
                        .multilineTextAlignment(.center)
                    Spacer()
                } else if vm.events.isEmpty {
                    Spacer()
                    Text("Press the button to discover facts for this day")
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .padding(40)
                        .background(Color(hex: "151523"))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(vm.events) { event in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Year: \(event.year ?? "-")")
                                        .font(.system(size: 14, weight: .bold, design: .rounded))
                                        .foregroundStyle(Color(hex: "AD57CE"))
                                    Text(event.description ?? "")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 16, weight: .regular, design: .rounded))
                                        .lineSpacing(4)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(20)
                                .background(Color(hex: "151523"))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                        }
                    }
                }
                
                // Button
                Button {
                    Task { await vm.generate() }
                } label: {
                    Text("Learn a Fact")
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .background(
                            LinearGradient(
                                colors: [Color(hex: "7753F3"), Color(hex: "AD57CE")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding(.top, 10)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 40)
        }
    }
}

#Preview {
    ContentView()
}
