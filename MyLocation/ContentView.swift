import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject var vm = MapViewModel()
    
    var body: some View {
        ZStack {
            vm.mapView
                .ignoresSafeArea(.all, edges: .all)
            
            VStack {
                PlaceSearchBar(vm: vm)
                
                Spacer()
                
                MapTypeButtons(vm: vm)
            }
        }
        .onAppear(perform: {
            vm.requestAuthorization()
        })
        .alert(isPresented: $vm.permissionDenied, content: {
            Alert(title: Text("Permission Denied"),
                  message: Text("Please enable permission in settings"),
                  dismissButton: .default(Text("Goto Settings"),
                                          action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
