import SwiftUI

struct MapTypeButtons: View {
    @ObservedObject var vm: MapViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                vm.focusLocation()
            }, label: {
                Image(systemName: "location.fill")
                    .font(.title2)
                    .padding(10)
                    .background(Color.primary)
                    .clipShape(Circle())
            })
                .frame(maxWidth: .infinity, alignment: .trailing)
            
            Button(action: {
                vm.updateMapType()
            }, label: {
                Image(systemName: vm.mapType == .standard ? "network" : "map")
                    .font(.title2)
                    .padding(10)
                    .background(Color.primary)
                    .clipShape(Circle())
            })
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.trailing, 20)
    }
}

struct MapTypeButtons_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            MapTypeButtons(vm: MapViewModel())
        }
    }
}
