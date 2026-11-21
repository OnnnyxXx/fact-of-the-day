import SwiftUI

struct ContentView: View {
    @StateObject private var vm = ContentViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "0A0A0E"), Color(hex: "12101C"), Color(hex: "0A0A0E")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            Circle()
                .fill(Color(hex: "7753F3").opacity(0.15))
                .frame(width: 300, height: 300)
                .blur(radius: 60)
                .offset(x: 150, y: -250)
            
            VStack(spacing: 24) {
                
                Picker("Mode", selection: $vm.isToday) {
                    Text("Today").tag(true)
                    Text("Select Date").tag(false)
                }
                .pickerStyle(.segmented)
                .padding(4)
                .background(Color.white.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack(alignment: .leading, spacing: 12) {
                    if vm.isToday {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("TODAY IS")
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color(hex: "AD57CE"))
                                    .kerning(2)
                                Text(Date.now.dateToString())
                                    .font(.system(size: 34, weight: .bold, design: .rounded))
                                    .foregroundStyle(.white)
                            }
                            Spacer()
                            Image(systemName: "calendar")
                                .font(.system(size: 28))
                                .foregroundStyle(Color(hex: "7753F3").opacity(0.8))
                        }
                    } else {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("SELECTED DATE")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .foregroundStyle(Color(hex: "AD57CE"))
                                .kerning(2)
                            
                            DatePicker(
                                "Pick Date",
                                selection: $vm.selectedDate,
                                displayedComponents: .date
                            )
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .colorScheme(.dark)
                            .scaleEffect(1.2, anchor: .leading)
                            .padding(.top, 4)
                        }
                    }
                }
                .padding(24)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                
                ZStack {
                    if vm.isLoading {
                        VStack(spacing: 16) {
                            ProgressView().tint(Color(hex: "7753F3")).scaleEffect(1.5)
                            Text("Searching history...")
                                .font(.system(size: 14, design: .rounded))
                                .foregroundStyle(.gray)
                        }
                    } else if let error = vm.errorText {
                        VStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.largeTitle)
                                .foregroundStyle(.orange)
                            Text(error)
                                .foregroundStyle(.red)
                                .multilineTextAlignment(.center)
                                .font(.system(size: 15, design: .rounded))
                        }
                        .padding()
                    } else if vm.events.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 40))
                                .foregroundStyle(Color(hex: "AD57CE").opacity(0.5))
                            Text("Tap the button below\nto discover historical facts")
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.center)
                                .font(.system(size: 16, design: .rounded))
                                .lineSpacing(4)
                        }
                    } else {
                        ScrollView(showsIndicators: false) {
                            LazyVStack(spacing: 16) {
                                ForEach(vm.events) { event in
                                    FactCard(event: event)
                                }
                            }
                            .padding(.bottom, 20)
                        }
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
                .frame(maxHeight: .infinity)
                .animation(.easeInOut(duration: 0.3), value: vm.isLoading)
                .animation(.easeInOut(duration: 0.3), value: vm.events.count)
                
                Button {
                    Task { await vm.generate() }
                } label: {
                    HStack(spacing: 12) {
                        Text("Learn a Fact")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                        Image(systemName: "wand.and.stars")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "7753F3"), Color(hex: "AD57CE")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(color: Color(hex: "7753F3").opacity(0.4), radius: 15, x: 0, y: 8)
                }
                .disabled(vm.isLoading)
                .opacity(vm.isLoading ? 0.6 : 1.0)
                .scaleEffect(vm.isLoading ? 0.98 : 1.0)
                .animation(.spring(), value: vm.isLoading)
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            .padding(.bottom, 30)
        }
        .onChange(of: vm.isToday) {
            withAnimation {
                vm.events = []
                vm.errorText = nil
            }
        }
        .onChange(of: vm.selectedDate) {
            withAnimation {
                vm.events = []
                vm.errorText = nil
            }
        }
    }
}

struct FactCard: View {
    let event: FactEvent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(event.year ?? "—")
                    .font(.system(size: 13, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color(hex: "7753F3"))
                    .clipShape(Capsule())
                
                Spacer()
                
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.white.opacity(0.3))
            }
            
            Text(event.description ?? "")
                .foregroundStyle(.white)
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .lineSpacing(5)
                .multilineTextAlignment(.leading)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "151523"))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.1), Color.clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }
}

#Preview {
    ContentView()
}
