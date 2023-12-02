import SwiftUI

struct PhotoSearchView: View {
  @StateObject var photoStore = PhotoStore()
  @State private var searchText = ""
  
  struct SearchBar: View {
    @Binding var text: String
    var onSearch: () -> Void
    
    var body: some View {
      HStack {
        TextField("Search", text: $text, onCommit: onSearch)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        Button("Search", action: onSearch)
      }
      .padding()
    }
  }
  
  var body: some View {
    NavigationView {
      VStack {
        SearchBar(text: $searchText, onSearch: performInitialSearch)
        
        if !photoStore.photos.isEmpty {
          List(photoStore.photos) { photo in
            NavigationLink(destination: PhotoDetailView(photo: photo, photoStore: photoStore)) {
              HStack {
                AsyncImage(url: photo.src.medium) { image in
                  image.resizable().scaledToFit()
                } placeholder: {
                  ProgressView()
                }
                .frame(width: 50, height: 50)
                
                Text(photo.photographer).padding()
              }
            }
          }
          
          paginationControls
        } else if let errorMessage = photoStore.errorMessage {
          Text(errorMessage)
            .foregroundColor(.red)
        } else {
          Text("No results found")
            .foregroundColor(.gray)
        }
      }
      .navigationBarTitle("My Favorite Photos")
    }
  }
  
  private var paginationControls: some View {
    HStack {
      Button("Previous", action: loadPreviousPage)
        .disabled(photoStore.prevPageURL == nil)
      
      Spacer()
      
      Button("Next", action: loadNextPage)
        .disabled(photoStore.nextPageURL == nil)
    }
    .padding()
  }
  
  private func performInitialSearch() {
    guard !searchText.isEmpty else { return }
    photoStore.fetchPhotos(query: searchText)
  }
  
  private func loadNextPage() {
    guard let nextPageURL = photoStore.nextPageURL else { return }
    photoStore.fetchPhotos(pageURL: nextPageURL)
  }
  
  private func loadPreviousPage() {
    guard let prevPageURL = photoStore.prevPageURL else { return }
    photoStore.fetchPhotos(pageURL: prevPageURL)
  }
}


struct PhotoSearchView_Previews: PreviewProvider {
  static var previews: some View {
    PhotoSearchView()
  }
}
