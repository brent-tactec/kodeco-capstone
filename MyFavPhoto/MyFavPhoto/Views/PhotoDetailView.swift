import SwiftUI

struct PhotoDetailView: View {
  let photo: Photo
  @EnvironmentObject var photoFavModel: PhotoFavModel
  @ObservedObject var photoStore: PhotoStore
  @State private var isFavorite: Bool = false
  @State private var downloadedImage: UIImage?
  @StateObject private var downloadProgress = PhotoNetwork.DownloadProgress()
  @State private var isDownloading: Bool = true
  @State private var errorMessage: String?
  @State private var heartScale: CGFloat = 1.0 // For heart animation
  @State private var showPhotoDetails = false // State to control photo details visibility
  
  var body: some View {
    VStack {
      Group {
        if let downloadedImage = downloadedImage {
          Image(uiImage: downloadedImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onTapGesture {
              showPhotoDetails.toggle() // Toggle photo details visibility
            }
          
          if showPhotoDetails {
            PhotoInfoView(photo: photo) // Show details when tapped
          }
        } else if isDownloading {
          
          ProgressView(value: downloadProgress.value)
          
        } else if let errorMessage = errorMessage {
          Text(errorMessage)
            .foregroundColor(.red)
        }
      }
      
      // Heart button for favorites
      Text("Tab the picture for more info.")
      
      Button(action: toggleFavorite) {
        Image(systemName: isFavorite ? "heart.fill" : "heart")
          .resizable()
          .frame(width: 30, height: 30)
          .foregroundColor(isFavorite ? .red : .gray)
      }
      .scaleEffect(heartScale)
      .padding()
    }
    .onAppear {
      isFavorite = photoFavModel.isFavorite(photo: photo)
      if downloadedImage == nil {
        loadAndDisplayImage()
      }
    }
    .navigationBarTitle("Photographer: \(photo.photographer)", displayMode: .inline)
    .navigationBarBackButtonHidden(false)
  }
  
  private func loadAndDisplayImage() {
    isDownloading = true
    
    Task {
      do {
        let image = try await photoStore.network.downloadImage(
          url: photo.src.large2x,
          progress: downloadProgress  // Pass the DownloadProgress object
        )
        await MainActor.run {
          self.downloadedImage = image
          self.isDownloading = false
        }
      } catch let error as PhotoNetwork.NetworkError {
        await MainActor.run {
          self.errorMessage = "Network error: \(error.localizedDescription)"
          self.isDownloading = false
        }
      } catch {
        await MainActor.run {
          self.errorMessage = "Failed to load image: \(error.localizedDescription)"
          self.isDownloading = false
        }
      }
    }
    
  }
  
  private func toggleFavorite() {
    isFavorite.toggle()
    withAnimation(.easeInOut(duration: 0.2)) {
      heartScale = 1.3
    }
    withAnimation(.easeInOut(duration: 0.2).delay(0.2)) {
      heartScale = 1.0
    }
    if isFavorite {
      photoFavModel.addFavorite(photo: photo)
    } else {
      photoFavModel.removeFavorite(photo: photo)
    }
  }
}

struct PhotoInfoView: View {
  let photo: Photo
  
  var body: some View {
    VStack {
      Text("Photographer: \(photo.photographer)")
        .bold()
      if let photographerId = photo.photographerId {
        Text("Photographer ID: \(photographerId)")
      }
      if let photographerURL = photo.photographerURL {
        Link("Photographer URL", destination: photographerURL)
      }
      Text("Photo URL: \(photo.url.absoluteString)")
        .border(Color.gray, width: 1)
    }
    .padding()
  }
}

// Preview with Mock Data removed
