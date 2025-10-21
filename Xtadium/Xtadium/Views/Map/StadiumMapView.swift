import SwiftUI
import MapKit

struct StadiumMapView: View {
    @StateObject private var vm = StadiumMapViewModel()

    var body: some View {
        VStack(spacing: 8) {
            // Selector de estadio
            if !vm.items.isEmpty {
                Picker("Estadio", selection: $vm.selectedIndex) {
                    ForEach(vm.items.indices, id: \.self) { idx in
                        Text(vm.items[idx].estadio.nombre).tag(idx)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .onChange(of: vm.selectedIndex) { _, newValue in
                    if let estadio = vm.selected?.estadio {
                        vm.center(on: estadio.coordinate)
                    }
                }
            }

            // Mapa
            Map(position: $vm.cameraPosition) {
                if let sel = vm.selected {
                    // Pin estadio
                    Annotation(sel.estadio.nombre, coordinate: sel.estadio.coordinate) {
                        markerView(system: "sportscourt.fill", title: sel.estadio.nombre)
                    }

                    // Pins restaurantes
                    ForEach(sel.restaurantes) { rest in
                        Annotation(rest.nombre, coordinate: rest.coordinate) {
                            markerView(system: "fork.knife", title: rest.nombre)
                        }
                    }
                }
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
            .mapStyle(.standard)
            .overlay(alignment: .bottomTrailing) {
                if let c = vm.selected?.estadio.coordinate {
                    Button {
                        vm.center(on: c)
                    } label: {
                        Image(systemName: "location.circle.fill")
                            .font(.title)
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .padding()
                    }
                }
            }
        }
        .task { vm.load() }
    }

    @ViewBuilder
    private func markerView(system: String, title: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: system)
                .font(.title2)
                .padding(8)
                .background(.thinMaterial)
                .clipShape(Circle())
            Text(title)
                .font(.caption)
                .multilineTextAlignment(.center)
                .padding(4)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

#Preview {
    StadiumMapView()
}
