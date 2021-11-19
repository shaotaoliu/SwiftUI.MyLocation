import SwiftUI

struct PlaceSearchBar: View {
    @ObservedObject var vm: MapViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search", text: $vm.searchText)
                    .colorScheme(.light)
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(Color.white)
            
            if !vm.places.isEmpty && vm.searchText != "" {
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(vm.places) { place in
                            Text(place.placemark.name ?? "")
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                                .onTapGesture(perform: {
                                    vm.selectPlace(place: place)
                                })
                            
                            Divider()
                        }
                    }
                    .padding(.top)
                }
                .background(Color.white)
            }
        }
        .padding()
        .onChange(of: vm.searchText, perform: { value in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                if value == vm.searchText {
                    self.vm.searchQuery()
                }
            })
        })
    }
}

struct PlaceSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.blue
            
            VStack {
                PlaceSearchBar(vm: MapViewModel())
                Spacer()
            }
        }
    }
}
