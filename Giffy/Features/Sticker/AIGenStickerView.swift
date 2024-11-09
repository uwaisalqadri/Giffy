//
//  StickerView.swift
//  Giffy
//
//  Created by Uwais Alqadri on 10/11/24.
//

import SwiftUI
import PhotosUI
import CommonUI

struct AIGenStickerView: View {
  
//  let columns = [GridItem(.adaptive(minimum: 108, maximum: 108), spacing: 20)]
//  @State var vm = StickerMaker()
  
  var body: some View {
    Text("AI GEN")
//    List {
//      HStack(alignment: .top, spacing: 16) {
//        imagePickerMenu(badgeText: "IC", sticker: vm.trayIcon)
//        Toggle("Show background", isOn: $vm.showOriginalImage)
//      }
//      .listRowSeparator(.hidden)
//      
//      generateAISection
//      
//      LazyVGrid(columns: columns, spacing: 20) {
//        ForEach(vm.stickers) { sticker in
//          imagePickerMenu(badgeText: String(sticker.pos + 1), sticker: sticker)
//        }
//      }
//      .listRowSeparator(.hidden)
//    }
//    .listStyle(.plain)
//    .scrollDismissesKeyboard(.immediately)
//    .navigationTitle("XCA DALL·E 3 AI WA Sticker Maker")
//    .navigationBarTitleDisplayMode(.inline)
//    .toolbar {
//      ToolbarItem(placement: .primaryAction) {
//        Button("Export") {
//          vm.sendToWhatsApp()
//        }
//        .disabled(!vm.isAbleToExportAsStickers)
//      }
//    }
//    .photosPicker(isPresented: $vm.shouldPresentPhotoPicker, selection: $vm.selectedPhotoPickerItem, matching: .images)
//    .onChange(of: vm.selectedPhotoPickerItem) { loadInputImage(fromPhotosPickerItem: $1) }
  }
  
//  var generateAISection: some View {
//    Section {
//      DisclosureGroup("DALL·E 3 AI sticker generation ✨", isExpanded: $vm.isAISectionExpanded) {
//        VStack(alignment: .leading, spacing: 16) {
//          Picker("AI Generate Option", selection: $vm.selectedAIGenerateOption) {
//            ForEach(AIGenerateOption.allCases) {
//              Text($0.rawValue).id($0)
//            }
//          }.pickerStyle(.segmented)
//            .disabled(vm.isPromptingGPT4Vision)
//          
//          switch vm.selectedAIGenerateOption {
//          case .textPrompt:
//            TextField("Enter prompt", text: $vm.promptText, axis: .vertical)
//              .textFieldStyle(.roundedBorder)
//              .lineLimit(4, reservesSpace: true)
//          case .gpt4Vision:
//            HStack(alignment: .top, spacing: 8) {
//              
//              if case .prompting = vm.gpt4PromptPhase {
//                ProgressView("Prompting GPT4...")
//                
//              } else {
//                Text("Generate Image based on source image input")
//              }
//              
//              Spacer()
//              ImagePicker {
//                ZStack {
//                  if let image = vm.selectedGPT4VisionSourceImage {
//                    Image(uiImage: image)
//                      .resizable()
//                      .scaledToFit()
//                      .clipped()
//                      .frame(maxWidth: .infinity, maxHeight: .infinity)
//                  }
//                }
//                .frame(width: width, height: width)
//                .overlay {
//                  RoundedRectangle(cornerRadius: 10)
//                    .stroke(Color.pink, style: StrokeStyle(lineWidth: 3, dash: [8]))
//                }
//              } onSelectedImage: {
//                self.vm.selectedGPT4VisionSourceImage = UIImage(cgImage: vm.imageHelper.render(ciImage: $0))
//              }
//              .disabled(vm.isPromptingGPT4Vision)
//            }
//          }
//          
//          HStack(spacing: 32) {
//            Toggle("Vivid", isOn: $vm.isVivid)
//            Spacer()
//            Toggle("HD", isOn: $vm.isHD)
//          }
//          
//          HStack {
//            Text(String(vm.minImagesInBatch))
//            Slider(value: $vm.imagesInBatch, in: Double(vm.minImagesInBatch)...Double(vm.maxImagesInBatch), step: 1)
//              .frame(width: 128)
//            Text(String(vm.maxImagesInBatch))
//            Spacer()
//            Button("Generate \(Int(vm.imagesInBatch)) in Batch") {
//              vm.generateDallE3ImagesInBatch()
//            }
//            .disabled(!vm.isPromptValid || vm.isPromptingGPT4Vision)
//            .buttonStyle(.borderedProminent)
//          }
//        }
//      }
//    }
//  }
//  
//  func imagePickerMenu(badgeText: String, sticker: Sticker) -> some View {
//    Menu {
//      Button("Select from Photo Library") {
//        vm.selectedStickerForPhotoPicker = sticker
//        vm.shouldPresentPhotoPicker = true
//      }
//      
//      if vm.selectedAIGenerateOption == .textPrompt && vm.isPromptValid {
//        Button("Generate with OpenAI DALL·E 3") {
//          guard vm.isPromptValid else { return }
//          vm.generateDallE3Image(promptText: vm.promptText, sticker: sticker)
//        }
//      }
//      
//      if sticker.imageData != nil {
//        Button("Delete", role: .destructive) {
//          vm.deleteImage(sticker: sticker)
//        }
//      }
//      
//    } label: {
//      ImageContainerView(sticker: sticker, showOriginalImage: vm.showOriginalImage)
//    }
//    .disabled(sticker.isGeneratingImage)
//  }
//  
//  private func loadInputImage(fromPhotosPickerItem item: PhotosPickerItem?) {
//    vm.selectedPhotoPickerItem = nil
//    guard let item, let sticker = vm.selectedStickerForPhotoPicker else { return }
//    item.loadTransferable(type: Data.self) { result in
//      switch result {
//      case .failure(let error):
//        print("Failed to load: \(error)")
//        return
//        
//      case .success(let _data):
//        guard let data = _data else {
//          print("Failed to load image data")
//          return
//        }
//        
//        guard var image = CIImage(data: data) else {
//          print("Failed to create image from selected photo")
//          return
//        }
//        
//        if let orientation = image.properties["Orientation"] as? Int32, orientation != 1 {
//          image = image.oriented(forExifOrientation: orientation)
//        }
//        
//        DispatchQueue.main.async {
//          vm.onInputImageSelected(image, sticker: sticker)
//        }
//      }
//    }
//  }
}
