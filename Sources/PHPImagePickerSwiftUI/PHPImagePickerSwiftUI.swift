import PhotosUI
import SwiftUI

@available(iOS 14, *)
public struct PHPImagePickerSwiftUI: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    var configuration: PHPickerConfiguration

    public init(
        configuration: PHPickerConfiguration,
        selectedImag: Binding<UIImage?>
    ) {
        self.configuration = configuration
        self._selectedImage = selectedImag
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIViewController(context: Context) -> PHPickerViewController {
        let vc = PHPickerViewController(configuration: configuration)
        vc.delegate = context.coordinator
        return vc
    }

    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }

    public class Coordinator: PHPickerViewControllerDelegate {
        let parent: PHPImagePickerSwiftUI

        init(_ parent: PHPImagePickerSwiftUI) {
            self.parent = parent
        }

        public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            for result in results {
                let itemProvider = result.itemProvider

                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { item, error in
                        if let image = item as? UIImage {
                            self.parent.selectedImage = image
                        }

                        if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
}
